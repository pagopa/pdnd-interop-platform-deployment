#!/bin/bash

STAGE="DEV"

DOMAIN_NAME="dev.interop.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="interop-persistence-management-dev.cluster-c9zr6t2swdpb.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
READ_MODEL_DB_HOST="interop-read-model-dev.cluster-c9zr6t2swdpb.eu-central-1.docdb.amazonaws.com"
READ_MODEL_DB_PORT="27017"
READ_MODEL_DB_NAME="read-model"
REPLICAS=1
BACKEND_SERVICE_PORT="8088"

AWS_REGION="eu-central-1"
PERSISTENCE_QUEUE_NAME="persistence-events.fifo"
CERTIFIED_MAIL_QUEUE_NAME="certified-mail.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://dev.interop.pagopa.it/.well-known/jwks.json"
DEV_ENDPOINTS_ENABLED="true"

INTERNAL_JWT_ISSUER="dev.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="dev.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

UI_JWT_AUDIENCE="dev.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="dev.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="dev.interop.pagopa.it/internal"
RSA_KEYS_IDENTIFIERS="17c1177f-d7dc-4181-9f54-6fd416bf229b"

PARTY_PROCESS_URL="https://api.uat.selfcare.pagopa.it/external/party-process/v1"
PARTY_MANAGEMENT_URL="https://api.uat.selfcare.pagopa.it/external/party-management/v1"
USER_REGISTRY_URL="https://api.uat.pdv.pagopa.it/user-registry/v1"
SELFCARE_V2_URL="https://api.uat.selfcare.pagopa.it/external/v2"

SELFCARE_PRODUCT_ID="prod-interop"
