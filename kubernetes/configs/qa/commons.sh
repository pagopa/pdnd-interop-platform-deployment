#!/bin/bash

STAGE="QA"

DOMAIN_NAME="qa.interop.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="interop-persistence-management-qa.cluster-cafe9jumfoc9.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
POSTGRES_DB_NAME="persistence_management"
READ_MODEL_DB_HOST="interop-read-model-qa.cluster-cafe9jumfoc9.eu-central-1.docdb.amazonaws.com"
READ_MODEL_DB_PORT="27017"
READ_MODEL_DB_NAME="read-model"
READ_MODEL_REPLICA_SET="rs0"
READ_MODEL_READ_PREFERENCE="secondaryPreferred"
REPLICAS=1
BACKEND_SERVICE_PORT="8088"
KAFKA_BROKERS="boot-5g5alzwn.c2.kafka-serverless.eu-central-1.amazonaws.com:9098"

AGREEMENT_TOPIC="event-store.qa_agreement.events"
ATTRIBUTE_TOPIC="event-store.qa_attribute_registry.events"
AUTHORIZATION_TOPIC="event-store.qa_authorization.events"
CATALOG_TOPIC="event-store.qa_catalog.events"
PURPOSE_TOPIC="event-store.qa_purpose.events"
TENANT_TOPIC="event-store.qa_tenant.events"

AWS_REGION="eu-central-1"
PERSISTENCE_QUEUE_NAME="persistence-events.fifo"
CERTIFIED_MAIL_QUEUE_NAME="certified-mail.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

NOTIFICATION_QUEUE_URL="https://sqs.eu-central-1.amazonaws.com/755649575658/persistence-events.fifo"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://qa.interop.pagopa.it/.well-known/jwks.json"
DEV_ENDPOINTS_ENABLED="false"

INTERNAL_JWT_ISSUER="qa.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="qa.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

UI_JWT_AUDIENCE="qa.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="qa.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="qa.interop.pagopa.it/internal"
RSA_KEYS_IDENTIFIERS="a1721903-0fc9-4744-96ea-00a4332c452f"

SELFCARE_V2_URL="https://api.uat.selfcare.pagopa.it/external/v2"

INTEROP_SELFCARE_PRODUCT_NAME="prod-interop-coll"
TENANT_ALLOWED_ORIGINS="IPA,ANAC,IVASS"
PRODUCER_ALLOWED_ORIGINS="IPA"

PRIVACY_NOTICES_DYNAMO_TABLE_NAME="interop-privacy-notices-qa"
PRIVACY_NOTICES_ACCEPTANCE_DYNAMO_TABLE_NAME="interop-privacy-notices-acceptances-qa"
PRIVACY_NOTICES_UPDATER_PRIVACY_POLICY_UUID="0df21ff6-3e8f-4320-af8f-23dea9135d57"
PRIVACY_NOTICES_UPDATER_TERMS_OF_SERVICE_UUID="6bf8412a-41a7-41a0-82dc-26286ce61b1a"
PRIVACY_NOTICES_CONTAINER="interop-privacy-notices-content-qa"

PAGOPA_TENANT_ID="69e2865e-65ab-4e48-a638-2037a9ee2ee7"

REPORT_SENDER_MAIL="noreply@reports.qa.interop.pagopa.it"
REPORT_SENDER_LABEL="noreply-qa"

SMTP_ADDRESS="email-smtp.eu-central-1.amazonaws.com"
SMTP_PORT=465

AUTHORIZATION_MANAGEMENT_URL="http://interop-be-authorization-management.qa.svc.cluster.local:8088/authorization-management/1.0"
