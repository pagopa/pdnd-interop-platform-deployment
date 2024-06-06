#!/bin/bash

STAGE="UAT"

DOMAIN_NAME="uat.interop.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="interop-persistence-management-test.cluster-cfx5ud7lsyvt.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
POSTGRES_DB_NAME="persistence_management"
READ_MODEL_DB_HOST="interop-read-model-test.cluster-cfx5ud7lsyvt.eu-central-1.docdb.amazonaws.com"
READ_MODEL_DB_PORT="27017"
READ_MODEL_DB_NAME="read-model"
READ_MODEL_REPLICA_SET="rs0"
READ_MODEL_READ_PREFERENCE="secondaryPreferred"
REPLICAS=1
BACKEND_SERVICE_PORT="8088"
KAFKA_BROKERS="boot-9sxt6jl9.c2.kafka-serverless.eu-central-1.amazonaws.com:9098"

AGREEMENT_TOPIC="event-store.test_agreement.events"
ATTRIBUTE_TOPIC="event-store.test_attribute_registry.events"
CATALOG_TOPIC="event-store.test_catalog.events"
PURPOSE_TOPIC="event-store.test_purpose.events"

AWS_REGION="eu-central-1"
PERSISTENCE_QUEUE_NAME="persistence-events.fifo"
CERTIFIED_MAIL_QUEUE_NAME="certified-mail.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

NOTIFICATION_QUEUE_URL="https://sqs.eu-central-1.amazonaws.com/895646477129/persistence-events.fifo"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://uat.interop.pagopa.it/.well-known/jwks.json"
DEV_ENDPOINTS_ENABLED="true"

UI_JWT_AUDIENCE="uat.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="uat.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="uat.interop.pagopa.it/internal"

RSA_KEYS_IDENTIFIERS="32d8a321-1568-44f5-9558-a9072f519d2d"

SELFCARE_V2_URL="https://api.selfcare.pagopa.it/external/v2"

INTEROP_SELFCARE_PRODUCT_NAME="prod-interop-coll"
TENANT_ALLOWED_ORIGINS="IPA,ANAC,IVASS"
PRODUCER_ALLOWED_ORIGINS="IPA"

INTERNAL_JWT_ISSUER="uat.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="uat.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

PRIVACY_NOTICES_DYNAMO_TABLE_NAME="interop-privacy-notices-test"
PRIVACY_NOTICES_ACCEPTANCE_DYNAMO_TABLE_NAME="interop-privacy-notices-acceptances-test"
PRIVACY_NOTICES_UPDATER_PRIVACY_POLICY_UUID="0df21ff6-3e8f-4320-af8f-23dea9135d57"
PRIVACY_NOTICES_UPDATER_TERMS_OF_SERVICE_UUID="6bf8412a-41a7-41a0-82dc-26286ce61b1a"
PRIVACY_NOTICES_CONTAINER="interop-privacy-notices-content-test"

PAGOPA_TENANT_ID="84871fd4-2fd7-46ab-9d22-f6b452f4b3c5"

SMTP_ADDRESS="smtp.gmail.com"
SMTP_PORT=465

AUTHORIZATION_MANAGEMENT_URL="http://interop-be-authorization-management.test.svc.cluster.local:8088/authorization-management/1.0"
