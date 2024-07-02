#!/bin/bash

STAGE="PROD"

DOMAIN_NAME="interop.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="interop-persistence-management-prod.cluster-clwq8rah1dfz.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
POSTGRES_DB_NAME="persistence_management"
READ_MODEL_DB_HOST="interop-read-model-prod.cluster-clwq8rah1dfz.eu-central-1.docdb.amazonaws.com"
READ_MODEL_DB_PORT="27017"
READ_MODEL_DB_NAME="read-model"
READ_MODEL_REPLICA_SET="rs0"
READ_MODEL_READ_PREFERENCE="secondaryPreferred"
REPLICAS=2
BACKEND_SERVICE_PORT="8088"
KAFKA_BROKERS="boot-g41hzx46.c2.kafka-serverless.eu-central-1.amazonaws.com:9098"

AGREEMENT_TOPIC="event-store.prod_agreement.events"
ATTRIBUTE_TOPIC="event-store.prod_attribute_registry.events"
AUTHORIZATION_TOPIC="event-store.prod_authz.events"
CATALOG_TOPIC="event-store.prod_catalog.events"
PURPOSE_TOPIC="event-store.prod_purpose.events"

AWS_REGION="eu-central-1"
PERSISTENCE_QUEUE_NAME="persistence-events.fifo"
CERTIFIED_MAIL_QUEUE_NAME="certified-mail.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

NOTIFICATION_QUEUE_URL="https://sqs.eu-central-1.amazonaws.com/697818730278/persistence-events.fifo"

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

SELFCARE_V2_URL="https://api.selfcare.pagopa.it/external/v2"

INTEROP_SELFCARE_PRODUCT_NAME="prod-interop"
TENANT_ALLOWED_ORIGINS="IPA,ANAC,IVASS"
PRODUCER_ALLOWED_ORIGINS="IPA"

PRIVACY_NOTICES_DYNAMO_TABLE_NAME="interop-privacy-notices-prod"
PRIVACY_NOTICES_ACCEPTANCE_DYNAMO_TABLE_NAME="interop-privacy-notices-acceptances-prod"
PRIVACY_NOTICES_UPDATER_PRIVACY_POLICY_UUID="0df21ff6-3e8f-4320-af8f-23dea9135d57"
PRIVACY_NOTICES_UPDATER_TERMS_OF_SERVICE_UUID="6bf8412a-41a7-41a0-82dc-26286ce61b1a"
PRIVACY_NOTICES_CONTAINER="interop-privacy-notices-content-prod"

PAGOPA_TENANT_ID="4a4149af-172e-4950-9cc8-63ccc9a6d865"

REPORT_SENDER_MAIL="noreply@reports.interop.pagopa.it"
REPORT_SENDER_LABEL="noreply-prod"

NOTIFICATION_SENDER_MAIL="noreply@notifiche.interop.pagopa.it"
NOTIFICATION_SENDER_LABEL="PDND Interop no-reply"

PEC_SMTP_SECURE=true

SMTP_SECURE=true
SMTP_ADDRESS="email-smtp.eu-central-1.amazonaws.com"
SMTP_PORT=465

AUTHORIZATION_MANAGEMENT_URL="http://interop-be-authorization-management.prod.svc.cluster.local:8088/authorization-management/1.0"
