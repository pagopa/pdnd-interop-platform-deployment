#!/bin/bash

REGION_SUFFIX="-es1"

STAGE="UAT"

DOMAIN_NAME="uat.interop.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-south-1.amazonaws.com"
POSTGRES_HOST=""
POSTGRES_PORT="5432"
POSTGRES_DB_NAME="persistence_management"
READ_MODEL_DB_HOST="interop-read-model-test.cluster-ciwztfqful5r.eu-south-1.docdb.amazonaws.com"
READ_MODEL_DB_PORT="27017"
READ_MODEL_DB_NAME="read-model"
READ_MODEL_REPLICA_SET="rs0"
READ_MODEL_READ_PREFERENCE="secondaryPreferred"
REPLICAS=1
BACKEND_SERVICE_PORT="8088"
KAFKA_BROKERS="b-2.interopplatformevents.9r48hf.c3.kafka.eu-south-1.amazonaws.com:9098,b-1.interopplatformevents.9r48hf.c3.kafka.eu-south-1.amazonaws.com:9098,b-3.interopplatformevents.9r48hf.c3.kafka.eu-south-1.amazonaws.com:9098"

AGREEMENT_TOPIC="event-store.test_agreement.events"
ATTRIBUTE_TOPIC="event-store.test_attribute_registry.events"
AUTHORIZATION_TOPIC="event-store.test_authorization.events"
CATALOG_TOPIC="event-store.test_catalog.events"
PURPOSE_TOPIC="event-store.test_purpose.events"

AWS_REGION="eu-south-1"
PERSISTENCE_QUEUE_NAME="persistence-events.fifo"
CERTIFIED_MAIL_QUEUE_NAME="certified-mail.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

NOTIFICATION_QUEUE_URL="https://sqs.eu-south-1.amazonaws.com/895646477129/persistence-events.fifo"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://uat.interop.pagopa.it/.well-known/jwks.json"
DEV_ENDPOINTS_ENABLED="true"

UI_JWT_AUDIENCE="uat.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="uat.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="uat.interop.pagopa.it/internal"

RSA_KEYS_IDENTIFIERS="cdb52532-dd94-40ef-824d-9c55b10e6bc9"

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
PRIVACY_NOTICES_CONTAINER="interop-privacy-notices-content-test-es1"

PAGOPA_TENANT_ID="84871fd4-2fd7-46ab-9d22-f6b452f4b3c5"

REPORT_SENDER_MAIL="noreply@reports.uat.interop.pagopa.it"
REPORT_SENDER_LABEL="noreply-test"

NOTIFICATION_SENDER_MAIL="noreply@notifiche.uat.interop.pagopa.it"
NOTIFICATION_SENDER_LABEL="noreply-test"

SES_ENDPOINT="http://ses-mock.test.svc.cluster.local:8005"

PEC_SMTP_ADDRESS="smtp-mock.test.svc.cluster.local"
PEC_SMTP_PORT=5025
PEC_SMTP_SECURE=false

SMTP_SECURE=false
SMTP_ADDRESS="smtp-mock.test.svc.cluster.local"
SMTP_PORT=5025

AUTHORIZATION_MANAGEMENT_URL="http://interop-be-authorization-management.test.svc.cluster.local:8088/authorization-management/1.0"
