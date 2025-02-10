#!/bin/bash
TOKENS_JOB_BUCKET="interop-generated-jwt-details-prod-es1"
TOKENS_JOB_BASE_DOCS_PATH="token-details"
TOKEN_JOB_QUEUE_VISIBILITY_TIMEOUT_IN_SECONDS="60"
TOKEN_JOB_MAX_NUMBER_OF_MESSAGES_PER_FILE="1000"

JOB_DETAILS_PERSISTER_RESOURCE_CPU="2"
JOB_DETAILS_PERSISTER_RESOURCE_MEM="4Gi"


################################################
# Configurations for Node version
# Remove configs above when dismissing the old service
################################################
S3_BUCKET="interop-generated-jwt-details-prod-es1"
# Note: this is the size of the payload
#   It is not clear if Kafka includes also headers and metadata.
#   If it does, we need to increase this value properly
AUDIT_AVERAGE_KAFKA_MESSAGE_SIZE_IN_BYTES="1110"
AUDIT_MESSAGES_TO_READ_PER_BATCH="1000"
AUDIT_MAX_WAIT_KAFKA_BATCH_MILLIS="25000" # 25 seconds
TOKEN_DETAILS_PERSISTER_RESOURCE_CPU="1"
TOKEN_DETAILS_PERSISTER_RESOURCE_MEM="2Gi"