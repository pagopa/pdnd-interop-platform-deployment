#!/bin/bash

REGION_SUFFIX="-es1"

STAGE="DEV"

DOMAIN_NAME="dev.interop.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-south-1.amazonaws.com"
POSTGRES_HOST="interop-platform-data-dev.cluster-cevisn7oellx.eu-south-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
POSTGRES_DB_NAME="persistence_management"
READ_MODEL_DB_HOST="interop-read-model-dev.cluster-cevisn7oellx.eu-south-1.docdb.amazonaws.com"
READ_MODEL_DB_PORT="27017"
READ_MODEL_DB_NAME="read-model"
READ_MODEL_REPLICA_SET="rs0"
READ_MODEL_READ_PREFERENCE="secondaryPreferred"
REPLICAS=1
BACKEND_SERVICE_PORT="8088"
KAFKA_BROKERS="b-1.interopplatformevents.2doelu.c2.kafka.eu-south-1.amazonaws.com:9098,b-3.interopplatformevents.2doelu.c2.kafka.eu-south-1.amazonaws.com:9098,b-2.interopplatformevents.2doelu.c2.kafka.eu-south-1.amazonaws.com:9098"

AGREEMENT_TOPIC="event-store.dev_agreement.events"
ATTRIBUTE_TOPIC="event-store.dev_attribute_registry.events"
AUTHORIZATION_TOPIC="event-store.dev_authorization.events"
CATALOG_TOPIC="event-store.dev_catalog.events"
PURPOSE_TOPIC="event-store.dev_purpose.events"
TENANT_TOPIC="event-store.dev_tenant.events"

AGREEMENT_OUTBOUND_TOPIC="outbound.dev_agreement.events"
CATALOG_OUTBOUND_TOPIC="outbound.dev_catalog.events"
PURPOSE_OUTBOUND_TOPIC="outbound.dev_purpose.events"
TENANT_OUTBOUND_TOPIC="outbound.dev_tenant.events"

AWS_REGION="eu-south-1"
PERSISTENCE_QUEUE_NAME="persistence-events.fifo"
CERTIFIED_MAIL_QUEUE_NAME="certified-mail.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

NOTIFICATION_QUEUE_URL="https://sqs.eu-south-1.amazonaws.com/505630707203/persistence-events.fifo"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://dev.interop.pagopa.it/.well-known/jwks.json"
DEV_ENDPOINTS_ENABLED="true"

INTERNAL_JWT_ISSUER="dev.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="dev.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

UI_JWT_AUDIENCE="dev.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="dev.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="dev.interop.pagopa.it/internal"
RSA_KEYS_IDENTIFIERS="fcd1bab9-ae4d-49ce-9252-262db866e327"

SELFCARE_V2_URL="https://api.uat.selfcare.pagopa.it/external/v2"

INTEROP_SELFCARE_PRODUCT_NAME="prod-interop"
TENANT_ALLOWED_ORIGINS="IPA,ANAC,IVASS,PDND_INFOCAMERE-SCP,PDND_INFOCAMERE-PRV"
PRODUCER_ALLOWED_ORIGINS="IPA"

PRIVACY_NOTICES_DYNAMO_TABLE_NAME="interop-privacy-notices-dev"
PRIVACY_NOTICES_ACCEPTANCE_DYNAMO_TABLE_NAME="interop-privacy-notices-acceptances-dev"
PRIVACY_NOTICES_UPDATER_PRIVACY_POLICY_UUID="0df21ff6-3e8f-4320-af8f-23dea9135d57"
PRIVACY_NOTICES_UPDATER_TERMS_OF_SERVICE_UUID="6bf8412a-41a7-41a0-82dc-26286ce61b1a"
PRIVACY_NOTICES_CONTAINER="interop-privacy-notices-content-dev"

PAGOPA_TENANT_ID="69e2865e-65ab-4e48-a638-2037a9ee2ee7"

REPORT_SENDER_MAIL="noreply@reports.dev.interop.pagopa.it"
REPORT_SENDER_LABEL="noreply-dev"

NOTIFICATION_SENDER_MAIL="noreply@notifiche.dev.interop.pagopa.it"
NOTIFICATION_SENDER_LABEL="noreply-dev"

SES_ENDPOINT="http://ses-mock.dev.svc.cluster.local:8005"

PEC_SMTP_ADDRESS="smtp-mock.dev.svc.cluster.local"
PEC_SMTP_PORT=5025
PEC_SMTP_SECURE=false

SMTP_SECURE=false
SMTP_ADDRESS="smtp-mock.dev.svc.cluster.local"
SMTP_PORT=5025

AUTHORIZATION_MANAGEMENT_URL="http://interop-be-authorization-management.dev.svc.cluster.local:8088/authorization-management/1.0"
