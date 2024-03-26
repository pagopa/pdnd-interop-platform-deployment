import kafkajs from 'kafkajs';
const { ConfigResourceTypes, Kafka } = kafkajs;
import { generateAuthToken } from "aws-msk-iam-sasl-signer-js";
import * as fs from "fs";
import path from 'path';

const quietModeOn = typeof process.env.QUIET_MODE != 'undefined' && process.env.QUIET_MODE == '1';

async function oauthBearerTokenProvider(region) {
   // Uses AWS Default Credentials Provider Chain to fetch credentials
   const authTokenResponse = await generateAuthToken({ region });
   return {
       value: authTokenResponse.token
   }
}
function getTopicRequiredOptions() {
    return [{
        targetLabel: "numPartitions",
        expectedLabel: "partitions"
    },{
        targetLabel: "replicationFactor",
        expectedLabel: "replication.factor"
    }];
}

function getTopicDefaultConfiguration() {
    return [
        { name: "cleanup.policy", value: "delete" }, 
        { name: "retention.ms", value: "-1" }, 
        { name: "compression.type", value: "producer" }
    ];
}

function readTopicsProperties(topicsConfigurationPath) {
    let configurationsFound = fs.readdirSync(topicsConfigurationPath);
    let outputConfigurations = [];
    const namePropertyKey = "name";
    const topicConfigurationTemplate = {
        topic: null,
        configEntries: getTopicDefaultConfiguration()
    };
    
    const requiredOptions = getTopicRequiredOptions();
    const requiredOptionsKeys = requiredOptions.map(opt => opt.expectedLabel);

    for(let topicConfigurationFile of configurationsFound) {
        let topicConfigurationContent = fs.readFileSync(path.join(topicsConfigurationPath, topicConfigurationFile)).toString().split("\n");
        
        if (topicConfigurationContent.length) {
            let builtConfig = structuredClone(topicConfigurationTemplate);
            for (let topicConfigurationContentEntry of topicConfigurationContent) {
                if (!topicConfigurationContentEntry || topicConfigurationContentEntry == "" || topicConfigurationContentEntry.startsWith("#") || topicConfigurationContentEntry.startsWith("/")) {
                    continue;
                }
                
                let currentLine = topicConfigurationContentEntry.split("=");
                if (currentLine.length != 2) {
                    console.error(`Topic configuration file ${topicConfigurationFile} error: please use KEY=VALUE format for properties definition.`);
                    throw new Error(`Topic configuration file ${topicConfigurationFile} is not properly formatted.`);
                }

                let lowercaseCurrentKey = currentLine[0].toLowerCase();
                if (lowercaseCurrentKey == namePropertyKey) {
                    builtConfig["topic"] = JSON.parse(currentLine[1]);
                } else if (requiredOptionsKeys.indexOf(lowercaseCurrentKey) >= 0) {
                    builtConfig[requiredOptions.find(ro => ro.expectedLabel == lowercaseCurrentKey).targetLabel] = JSON.parse(currentLine[1]);
                } else {
                    let overrideIndex = builtConfig["configEntries"].findIndex(ce => ce.name === lowercaseCurrentKey);
                    if (overrideIndex != -1) {
                        builtConfig["configEntries"][overrideIndex].value = JSON.parse(currentLine[1]);
                    } else {
                        builtConfig["configEntries"].push({
                            name: lowercaseCurrentKey,
                            value: JSON.parse(currentLine[1])
                        });
                    }
                }
                
            }

            console.log(builtConfig);
            
            if (builtConfig["topic"]) {
                
                for ( let requiredOption of requiredOptions) {
                    if (typeof builtConfig[requiredOption.targetLabel]  == "undefined" || builtConfig[requiredOption.targetLabel] == null) {
                        console.error(`Topic configuration ${topicConfigurationFile} is missing required option ${requiredOption.expectedLabel}`);
                        throw new Error(`Topic configuration ${topicConfigurationFile} is missing required option ${requiredOption.expectedLabel}`);
                    }
                }
                outputConfigurations.push(builtConfig);
            }
        }
    }
    
    return outputConfigurations;
}

const run = async () => {
    let admin = null;

    try {
        if (!process.env.TOPICS_PROPERTIES_PATH) {
            console.error(`Missing TOPICS_PROPERTIES_PATH environment variable is required.`);
            throw new Error(`Missing TOPICS_PROPERTIES_PATH environment variable is required.`);
        }
        
        logInfo("Setup Kafka connection.");
        const kafka = new Kafka({
            clientId: 'kafka-scripts',
            brokers: [process.env.KAFKA_BROKERS],
            ssl: true,
            sasl: {
                mechanism: 'oauthbearer',
                oauthBearerProvider: () => oauthBearerTokenProvider(process.env.AWS_REGION)
            }
        });

        logInfo("Connect to Kafka with admin client.");
        admin = kafka.admin();
        await admin.connect();
        
        const topicsConfigurationPath = process.env.TOPICS_PROPERTIES_PATH;
        const topicConfigurations = readTopicsProperties(topicsConfigurationPath);
        let escalateDiff = false;
        let errors = [];

        for(let topicConfiguration of topicConfigurations) {
            try {
                logInfo(`Create topic ${topicConfiguration["topic"]}`);
                let result = await admin.createTopics({
                    validateOnly: false,
                    waitForLeaders: false,
                    topics: [topicConfiguration]
                });
                if (!result) {
                    let remoteConfigs = await admin.describeConfigs({
                        includeSynonyms: false,
                        resources: [{
                            type: ConfigResourceTypes.TOPIC,
                            name: topicConfiguration["topic"],
                            configNames: topicConfiguration["configEntries"].map(entry => entry.name)
                        }]
                    });
                    
                    if (remoteConfigs && remoteConfigs.resources.length) {
                        remoteConfigs = remoteConfigs.resources[0].configEntries;
                    }

                    let configDiffFound = [];
                    topicConfiguration["configEntries"].forEach(localConfig => {
                        let remoteConfig = remoteConfigs.find(c => c.configName == localConfig.name);
                        if (remoteConfig && remoteConfig.configValue != localConfig.value) {
                            configDiffFound.push({
                                name: localConfig.name,
                                localValue: localConfig.value,
                                remoteValue: remoteConfig.configValue
                            });
                        }
                    });

                    if (configDiffFound.length) {
                        escalateDiff = true;
                        let mismatches = configDiffFound.map(cd => cd.name);
                        let errorMsg = `Topic ${topicConfiguration.topic} already exists, following properties do not match: ${mismatches}`
                        errors.push({
                            type: "TOPIC_CREATION_ERROR",
                            message: errorMsg
                        })
                        // Errore (topic esiste e properties non matchano)
                        console.error(errorMsg);
                    } else {
                        // Info (topic esiste e properties matchano)
                        logInfo(`Topic ${topicConfiguration.topic} already exists, all the specified properties match with remote ones.`);
                    }
                }
            } catch( ex ) {
                console.error(`Topic ${topicConfiguration.topic} creation error ${ex}`);
            }
        }

        if (escalateDiff) {
            throw new Error(`Topic creation error:${errors.map(anError => `\n\t[${anError.type}:${anError.message}]`)}`);
        }
    } catch (ex) {
        console.error(ex);
        throw ex;
    } finally {
        if (admin) {
            await admin.disconnect();
        }
    }
}

const logInfo = (message) => {
    if (!quietModeOn) {
        console.log(message);
    }
}

run();
