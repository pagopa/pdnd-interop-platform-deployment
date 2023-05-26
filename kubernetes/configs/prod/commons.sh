#!/bin/bash

STAGE="PROD"

DOMAIN_NAME="interop.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="interop-persistence-management-prod.cluster-clwq8rah1dfz.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
READ_MODEL_DB_HOST="interop-read-model-prod.cluster-clwq8rah1dfz.eu-central-1.docdb.amazonaws.com"
READ_MODEL_DB_PORT="27017"
READ_MODEL_DB_NAME="read-model"
REPLICAS=2
BACKEND_SERVICE_PORT="8088"

AWS_REGION="eu-central-1"
PERSISTENCE_QUEUE_NAME="persistence-events.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://interop.pagopa.it/.well-known/jwks.json"
DEV_ENDPOINTS_ENABLED="false"

INTERNAL_JWT_ISSUER="interop.pagopa.it"
INTERNAL_JWT_SUBJECT="interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

UI_JWT_AUDIENCE="interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="interop.pagopa.it/internal"
RSA_KEYS_IDENTIFIERS="199d08d2-9971-4979-a78d-e6f7a544f296"

PARTY_PROCESS_URL="https://api.selfcare.pagopa.it/external/party-process/v1"
PARTY_MANAGEMENT_URL="https://api.selfcare.pagopa.it/external/party-management/v1"
USER_REGISTRY_URL="https://api.pdv.pagopa.it/user-registry/v1"
SELFCARE_V2_URL="https://api.selfcare.pagopa.it/external/v2"

SELFCARE_PRODUCT_ID="prod-interop"

PRIVACY_NOTICES_UPDATER_DYNAMO_TABLE_NAME="interop-privacy-notices-prod"
PRIVACY_NOTICES_UPDATER_PRIVACY_POLICY_UUID="0df21ff6-3e8f-4320-af8f-23dea9135d57"
PRIVACY_NOTICES_UPDATER_TERMS_OF_SERVICE_UUID="6bf8412a-41a7-41a0-82dc-26286ce61b1a"
