#!/bin/bash

STAGE="DEV"

DOMAIN_NAME="refactor.dev.interop.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="interop-persistence-management-dev.cluster-c9zr6t2swdpb.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
POSTGRES_DB_NAME="persistence_management_refactor"
READ_MODEL_DB_HOST="interop-read-model-dev.cluster-c9zr6t2swdpb.eu-central-1.docdb.amazonaws.com"
READ_MODEL_DB_PORT="27017"
READ_MODEL_DB_NAME="read-model-refactor"
READ_MODEL_REPLICA_SET="rs0"
READ_MODEL_READ_PREFERENCE="secondaryPreferred"
REPLICAS=1
BACKEND_SERVICE_PORT="8088"
KAFKA_BROKERS="boot-yqksbq44.c3.kafka-serverless.eu-central-1.amazonaws.com:9098"

AGREEMENT_TOPIC="event-store.dev-refactor_agreement.events"
ATTRIBUTE_TOPIC="event-store.dev-refactor_attribute_registry.events"
AUTHORIZATION_TOPIC="event-store.dev-refactor_authz.events"
CATALOG_TOPIC="event-store.dev-refactor_catalog.events"
PURPOSE_TOPIC="event-store.dev-refactor_purpose.events"

AWS_REGION="eu-central-1"
PERSISTENCE_QUEUE_NAME="persistence-events-refactor.fifo"
CERTIFIED_MAIL_QUEUE_NAME="certified-mail.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

NOTIFICATION_QUEUE_URL="https://sqs.eu-central-1.amazonaws.com/505630707203/persistence-events-refactor.fifo"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://dev.interop.pagopa.it/.well-known/jwks.json"
DEV_ENDPOINTS_ENABLED="true"

INTERNAL_JWT_ISSUER="refactor.dev.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="refactor.dev.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

UI_JWT_AUDIENCE="refactor.dev.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="refactor.dev.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="refactor.dev.interop.pagopa.it/internal"
RSA_KEYS_IDENTIFIERS="17c1177f-d7dc-4181-9f54-6fd416bf229b"

SELFCARE_V2_URL="https://api.uat.selfcare.pagopa.it/external/v2"

INTEROP_SELFCARE_PRODUCT_NAME="prod-interop-atst"
TENANT_ALLOWED_ORIGINS="IPA,ANAC,IVASS"
PRODUCER_ALLOWED_ORIGINS="IPA"

PRIVACY_NOTICES_DYNAMO_TABLE_NAME="interop-privacy-notices-dev"
PRIVACY_NOTICES_ACCEPTANCE_DYNAMO_TABLE_NAME="interop-privacy-notices-acceptances-dev"
PRIVACY_NOTICES_UPDATER_PRIVACY_POLICY_UUID="0df21ff6-3e8f-4320-af8f-23dea9135d57"
PRIVACY_NOTICES_UPDATER_TERMS_OF_SERVICE_UUID="6bf8412a-41a7-41a0-82dc-26286ce61b1a"
PRIVACY_NOTICES_CONTAINER="interop-privacy-notices-content-dev"

PAGOPA_TENANT_ID="69e2865e-65ab-4e48-a638-2037a9ee2ee7"

SMTP_ADDRESS="smtp.gmail.com"
SMTP_PORT=465

AUTHORIZATION_MANAGEMENT_URL="http://interop-be-authorization-management.dev-refactor.svc.cluster.local:8088/authorization-management/0.0"
