#!/bin/bash

TENANTS_COLLECTION_NAME="tenants"
PURPOSES_COLLECTION_NAME="purposes"
AGREEMENTS_COLLECTION_NAME="agreements"
ESERVICES_COLLECTION_NAME="eservices"

TOKENS_BUCKET="interop-generated-jwt-details-test"
TOKEN_BUCKET_PATH="/"
METRIC_STORAGE_BUCKET="interop-metrics-reports-test"
METRIC_STORAGE_PATH="/"

SMTP_ADDRESS="smtp.gmail.com"
SMTP_PORT=465

JOB_METRICS_REPORT_GENERATOR_RESOURCE_CPU="500m"
JOB_METRICS_REPORT_GENERATOR_RESOURCE_MEM="1Gi"
