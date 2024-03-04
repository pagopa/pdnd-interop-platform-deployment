#!/bin/bash

TENANTS_COLLECTION_NAME="tenants"
PURPOSES_COLLECTION_NAME="purposes"
AGREEMENTS_COLLECTION_NAME="agreements"
ESERVICES_COLLECTION_NAME="eservices"

ATHENA_TOKENS_DB_NAME="generated_jwt_dev"
ATHENA_OUTPUT_BUCKET="interop-athena-query-results-dev"

SMTP_SECURE=false

JOB_METRICS_REPORT_GENERATOR_RESOURCE_CPU="2"
JOB_METRICS_REPORT_GENERATOR_RESOURCE_MEM="4Gi"
