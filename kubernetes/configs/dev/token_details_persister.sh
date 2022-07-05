#!/bin/bash
TOKENS_JOB_BUCKET="interop-generated-jwt-details-dev"
TOKENS_JOB_BASE_DOCS_PATH="token-details"
TOKEN_JOB_QUEUE_VISIBILITY_TIMEOUT_IN_SECONDS="60"
TOKEN_JOB_MAX_NUMBER_OF_MESSAGES_PER_FILE="1000"

JOB_DETAILS_PERSISTER_RESOURCE_CPU="1"
JOB_DETAILS_PERSISTER_RESOURCE_MEM="2Gi"
