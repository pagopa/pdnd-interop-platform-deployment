import kafkajs from 'kafkajs';
const { ConfigResourceTypes, Kafka, logLevel } = kafkajs;
import { generateAuthToken } from "aws-msk-iam-sasl-signer-js";
import * as fs from "fs";
import path from 'path';

const quietModeOn = typeof process.env.QUIET_MODE != 'undefined' && process.env.QUIET_MODE == '1';
const logInfo = (message) => {
    if (!quietModeOn) {
        console.log(`${message}`);
    }
}

async function oauthBearerTokenProvider(region) {
   // Uses AWS Default Credentials Provider Chain to fetch credentials
   const authTokenResponse = await generateAuthToken({ region });
   return {
       value: authTokenResponse.token
   }
}

const parsingUtility = {
    sanitizePropsKey: function (propsKey) {
        let sanitized = propsKey.replaceAll("\"", '');
        sanitized = sanitized.replaceAll("'", '');

        return sanitized;
    },
    sanitizePropsValue: function (propsValue) {
        let sanitized = propsValue.replaceAll("\"", '');
        sanitized = sanitized.replaceAll("'", '');
        
        return sanitized;
    },
    sanitizePropsLine: function (propKey, propValue) {
        let sanitizedKey = parsingUtility.sanitizePropsKey(propKey);
        let sanitizedValue = parsingUtility.sanitizePropsValue(propValue);
        
        if (kafkaConfigUtility.isTopicOption(sanitizedKey)) {
            sanitizedValue = JSON.parse(sanitizedValue);
        }

        return {
            key: sanitizedKey,
            value: sanitizedValue
        }
    },
    parsePropsLine: function (propsEntry) {
        let currentLine = propsEntry.split("=");
        if (currentLine.length != 2) {
            throw new Error(`Topic configuration file ${topicConfigurationFile} is not properly formatted.`);
        }

        return parsingUtility.sanitizePropsLine(currentLine[0], currentLine[1]);
    },
    isCommentLine: function (line) {
        return line && (line.startsWith("#") || line.startsWith("/"));
    },
    shouldIgnoreLine: function (line) {
        return !line || parsingUtility.isCommentLine(line);
    },
    buildJsonFromPropertiesFile: function (filePath) {
        let topicConfigurationContent = fs.readFileSync(filePath).toString().split("\n");
        let propsToJson = {}
        
        if (!topicConfigurationContent.length) {
            return propsToJson;
        }
        
        for (let topicConfigurationContentEntry of topicConfigurationContent) {
            //Allow comments in props file but skip parsing
            if (parsingUtility.shouldIgnoreLine(topicConfigurationContentEntry)) {
                continue;
            }
            
            let currentLineParsed = parsingUtility.parsePropsLine(topicConfigurationContentEntry);
            if (!currentLineParsed["key"] || !currentLineParsed["value"]) {
                throw new Error(`Cannot parse key/value pair for line ${topicConfigurationContentEntry}`);
            }
            
            propsToJson[currentLineParsed["key"].toLowerCase()] = currentLineParsed["value"];
        }
    
        return propsToJson;
    }
}

const kafkaConfigUtility = {
    namePropertyKey: "name",
    getTopicDefaultConfiguration: function() {
        return [
            { name: "cleanup.policy", value: "delete" }, 
            { name: "retention.ms", value: "-1" }, 
            { name: "compression.type", value: "producer" }
        ];
    },
    getTopicOptions: function () {
        return [{
            targetLabel: "numPartitions",
            expectedLabel: "partitions",
            required: true
        },{
            targetLabel: "replicationFactor",
            expectedLabel: "replication.factor",
            required: true
        }];
    },
    getTopicRequiredOptions: function () {
        return kafkaConfigUtility.getTopicOptions().filter(option => option.required);
    },
    isTopicNameProperty: function (propKey) {
        return propKey === kafkaConfigUtility.namePropertyKey;
    },
    isTopicOption: function (optionKey) {
        return kafkaConfigUtility.getTopicOptions().map(opt => opt.expectedLabel).indexOf(optionKey) >= 0;
    },
    isTopicRequiredOption: function (optionKey) {
        return kafkaConfigUtility.getTopicRequiredOptions().map(opt => opt.expectedLabel).indexOf(optionKey) >= 0;
    },
    getTopicRequiredOptionKey: function (optionKey) {
        return kafkaConfigUtility.getTopicRequiredOptions().find(ro => ro.expectedLabel == optionKey).targetLabel;
    },
    isTopicDefaultConfig: function (configKey) {
        let defaultTopicConfiguration = kafkaConfigUtility.getTopicDefaultConfiguration();

        return defaultTopicConfiguration.findIndex(ce => ce.name === configKey) >= 0;
    },
    isValidTopicConfiguration: function (topicConfig) {
        if (!topicConfig["topic"]) {
            return {
                valid: false,
                error: `Topic name cannot be null`
            };
        }

        const requiredOptions = kafkaConfigUtility.getTopicRequiredOptions();
        for ( let requiredOption of requiredOptions) {
            if (typeof topicConfig[requiredOption.targetLabel]  == "undefined" || topicConfig[requiredOption.targetLabel] == null) {
                return {
                    valid: false,
                    error: `Topic configuration is missing required option ${requiredOption.expectedLabel}`
                }
            }
        }
        
        return {
            valid: true,
            error: null
        };
    }
}

function buildTopicsConfig(topicsConfigurationPath) {
    let configurationsFound = fs.readdirSync(topicsConfigurationPath);
    let outputConfigurations = [];

    const topicConfigurationTemplate = {
        topic: null,
        configEntries: kafkaConfigUtility.getTopicDefaultConfiguration()
    };
    
    for(let topicConfigurationFile of configurationsFound) {
        let builtConfig = structuredClone(topicConfigurationTemplate);
        let topicConfigurationJson = parsingUtility.buildJsonFromPropertiesFile(path.join(topicsConfigurationPath, topicConfigurationFile));
        
        if (topicConfigurationJson && Object.keys(topicConfigurationJson).length) {
            
            for (let configurationKey of Object.keys(topicConfigurationJson)) {
                let configurationValue = topicConfigurationJson[configurationKey];

                if (kafkaConfigUtility.isTopicNameProperty(configurationKey)) {
                    builtConfig["topic"] = configurationValue;
                } else if (kafkaConfigUtility.isTopicRequiredOption(configurationKey)) {
                    let optionToOverride = kafkaConfigUtility.getTopicRequiredOptionKey(configurationKey);
                    if (optionToOverride) {
                        builtConfig[optionToOverride] = configurationValue;
                    }
                } else {
                    let overrideIndex = -1;
                    if (kafkaConfigUtility.isTopicDefaultConfig(configurationKey)) {
                        overrideIndex = builtConfig["configEntries"].findIndex(ce => ce.name === configurationKey);
                    }

                    if (overrideIndex != -1) {
                        builtConfig["configEntries"][overrideIndex].value = configurationValue;
                    } else {
                        builtConfig["configEntries"].push({
                            name: configurationKey,
                            value: configurationValue
                        });
                    }
                }
            }

            const validationResult = kafkaConfigUtility.isValidTopicConfiguration(builtConfig);            
            if (!validationResult.valid) {
                throw new Error(validationResult.error);
            }

            outputConfigurations.push(builtConfig);
        }
    }
    
    return outputConfigurations;
}

const run = async () => {
    if (!process.env.TOPICS_PROPERTIES_PATH) {
        throw new Error(`Missing TOPICS_PROPERTIES_PATH environment variable is required.`);
    }
    
    logInfo("Setup Kafka connection.");
    const kafka = new Kafka({
        clientId: 'kafka-scripts',
        brokers: [process.env.KAFKA_BROKERS],
        logLevel: logLevel.NOTHING,
        ssl: true,
        sasl: {
            mechanism: 'oauthbearer',
            oauthBearerProvider: () => oauthBearerTokenProvider(process.env.AWS_REGION)
        }
    });

    logInfo("Connect to Kafka with admin client.");
    const admin = kafka.admin();
    try {
        await admin.connect();
    } catch (ex) {
        throw new Error(`Cannot connect to Kafka with admin client.`);
    }

    const topicsConfigurationPath = process.env.TOPICS_PROPERTIES_PATH;
    const topicConfigurations = buildTopicsConfig(topicsConfigurationPath);
    let escalateDiff = false;
    let errors = [];
    
    try {
        for(let topicConfiguration of topicConfigurations) {
            logInfo(`Create topic ${topicConfiguration["topic"]} with configuration ${JSON.stringify(topicConfiguration)}`);
            let result = await admin.createTopics({
                validateOnly: false,
                waitForLeaders: false,
                topics: [topicConfiguration]
            });

            if (!result) { // result == false => implies cannot create topic
                let remoteConfigs = await admin.describeConfigs({
                    includeSynonyms: false,
                    resources: [{
                        type: ConfigResourceTypes.TOPIC,
                        name: topicConfiguration["topic"],
                        configNames: topicConfiguration["configEntries"].map(entry => entry.name)
                    }]
                });
                
                // Get properties configuration for current topic 
                if (remoteConfigs && remoteConfigs.resources.length) {
                    remoteConfigs = remoteConfigs.resources[0].configEntries;
                }

                // Check diff between remote topic configuration and provided topic configuration
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
                    let mismatches = configDiffFound.map(cd => `[${cd.name}: remote value ${cd.remoteValue}, local value ${cd.localValue}]`);
                    let errorMsg = `Topic ${topicConfiguration.topic} already exists, following properties do not match: ${mismatches}`
                    errors.push({
                        type: "TOPIC_CREATION_ERROR",
                        message: errorMsg
                    })
                    // Errore (topic esiste e properties non matchano)
                    //Do not print library error message - console.error(errorMsg);
                } else {
                    // Info (topic esiste e properties matchano)
                    logInfo(`Topic ${topicConfiguration.topic} already exists, all the specified properties match with remote ones.`);
                }
            }
        }

        if (escalateDiff) {
            throw new Error(`${errors.map(anError => `\n  [${anError.type ? anError.type : "GENERIC_ERROR" }: ${anError.message}]`)}`);
        }
    } catch (ex) {
        let invalidConfiguration = ex.errors && ex.errors.filter(e => e.type == "INVALID_CONFIG");
        if (invalidConfiguration.length) {
            throw new Error(`[TOPIC INVALID CONFIGURATION] Found invalid configuration for ${invalidConfiguration.map(ic => ic.topic)}`);
        } else {
            throw ex;
        }
    } finally {
        if (admin) {
            logInfo("Disconnect Kafka admin client.");
            await admin.disconnect();
        }
    }
}

run();
