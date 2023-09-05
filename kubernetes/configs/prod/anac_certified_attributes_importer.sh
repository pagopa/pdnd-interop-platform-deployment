#!/bin/bash

TENANTS_COLLECTION_NAME="tenants"
ATTRIBUTES_COLLECTION_NAME="attributes"

ANAC_SFTP_PORT="22"
ANAC_SFTP_PATH="esercizio"
ANAC_CERTIFIED_ATTRIBUTES_IMPORTER_JWT_DURATION_SECONDS="1800"
ANAC_TENANT_ID="54b3b7a1-28fc-4078-b006-bfa53bb79927"
ANAC_CERTIFIED_ATTRIBUTES_RECORDS_PROCESS_BATCH_SIZE="100"

JOB_ANAC_CERTIFIED_ATTRIBUTES_IMPORTER_RESOURCE_CPU="500m"
JOB_ANAC_CERTIFIED_ATTRIBUTES_IMPORTER_RESOURCE_MEM="1Gi"