#!/bin/bash

TENANTS_COLLECTION_NAME="tenants"
PURPOSES_COLLECTION_NAME="purposes"
ESERVICES_COLLECTION_NAME="eservices"
ATTRIBUTES_COLLECTION_NAME="attributes"
AGREEMENTS_COLLECTION_NAME="agreements"
STORAGE_BUCKET="interop-public-dashboards-test"
FILENAME="test-metrics.json"

ATHENA_TOKENS_TABLE_NAME="generated_jwt_test"
ATHENA_OUTPUT_BUCKET="interop-athena-query-results-test"

JOB_DTD_METRICS_RESOURCE_CPU="500m"
JOB_DTD_METRICS_RESOURCE_MEM="1Gi"

DTD_PDND_OPENDATA_REPOSITORY="interop-metrics-deploy-test"
DTD_REPOSITORY_OWNER="pagopa"