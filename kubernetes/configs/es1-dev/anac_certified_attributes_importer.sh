#!/bin/bash

TENANTS_COLLECTION_NAME="tenants"
ATTRIBUTES_COLLECTION_NAME="attributes"

ANAC_SFTP_PORT="22"
ANAC_SFTP_PATH="dev"
ANAC_SFTP_FILENAME_PREFIX="dev"
ANAC_CERTIFIED_ATTRIBUTES_IMPORTER_JWT_DURATION_SECONDS="1800"
ANAC_TENANT_ID="e99c1081-8fcb-4701-a461-ac2725b18fe7"
ANAC_CERTIFIED_ATTRIBUTES_RECORDS_PROCESS_BATCH_SIZE="100"

JOB_ANAC_CERTIFIED_ATTRIBUTES_IMPORTER_RESOURCE_CPU="500m"
JOB_ANAC_CERTIFIED_ATTRIBUTES_IMPORTER_RESOURCE_MEM="1Gi"