#!/bin/bash

STAGE="UAT"

DOMAIN_NAME="uat.interop.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="interop-rds-test-auroradbcluster-u2a45bkp2iqr.cluster-cfx5ud7lsyvt.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
READ_MODEL_DB_HOST="read-model.cluster-cfx5ud7lsyvt.eu-central-1.docdb.amazonaws.com"
READ_MODEL_DB_PORT="27017"
READ_MODEL_DB_NAME="read-model"
REPLICAS=1
BACKEND_SERVICE_PORT="8088"

AWS_REGION="eu-central-1"
PERSISTENCE_QUEUE_NAME="persistence-events.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://uat.interop.pagopa.it/.well-known/jwks.json"
DEV_ENDPOINTS_ENABLED="true"

UI_JWT_AUDIENCE="uat.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="uat.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="uat.interop.pagopa.it/internal"

RSA_KEYS_IDENTIFIERS="32d8a321-1568-44f5-9558-a9072f519d2d"

PARTY_PROCESS_URL="https://api.selfcare.pagopa.it/external/party-process/v1"
PARTY_MANAGEMENT_URL="https://api.selfcare.pagopa.it/external/party-management/v1"
USER_REGISTRY_URL="https://api.pdv.pagopa.it/user-registry/v1"

SELFCARE_PRODUCT_ID="prod-interop-coll"

INTERNAL_JWT_ISSUER="uat.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="uat.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600