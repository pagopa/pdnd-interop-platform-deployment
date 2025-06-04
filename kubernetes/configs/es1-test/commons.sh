#!/bin/bash

REGION_SUFFIX="-es1"

STAGE="UAT"

DOMAIN_NAME="uat.interop.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-south-1.amazonaws.com"
POSTGRES_HOST="interop-platform-data-test.cluster-ciwztfqful5r.eu-south-1.rds.amazonaws.com"
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

TOKEN_READMODEL_PLATFORM_STATES_TABLE_NAME="interop-platform-states-test"
TOKEN_READMODEL_TOKEN_STATES_TABLE_NAME="interop-token-generation-states-test"

AGREEMENT_TOPIC="event-store.test_agreement.events"
ATTRIBUTE_TOPIC="event-store.test_attribute_registry.events"
AUTHORIZATION_TOPIC="event-store.test_authorization.events"
CATALOG_TOPIC="event-store.test_catalog.events"
PURPOSE_TOPIC="event-store.test_purpose.events"
TENANT_TOPIC="event-store.test_tenant.events"
DELEGATION_TOPIC="event-store.test_delegation.events"
ESERVICE_TEMPLATE_TOPIC="event-store.test_eservice_template.events"

AGREEMENT_OUTBOUND_TOPIC="outbound.test_agreement.events"
CATALOG_OUTBOUND_TOPIC="outbound.test_catalog.events"
PURPOSE_OUTBOUND_TOPIC="outbound.test_purpose.events"
TENANT_OUTBOUND_TOPIC="outbound.test_tenant.events"
DELEGATION_OUTBOUND_TOPIC="outbound.test_delegation.events"
ESERVICE_TEMPLATE_OUTBOUND_TOPIC="outbound.test_eservice_template.events"

APPLICATION_AUDIT_TOPIC="test_application.audit"
TOKEN_AUDITING_TOPIC="test_authorization-server.generated-jwt"
APPLICATION_AUDIT_FALLBACK_SQS_URL="https://sqs.eu-south-1.amazonaws.com/895646477129/interop-analytics-application-audit-fallback-test"
FEATURE_FLAG_APPLICATION_AUDIT_STRICT="false"

AWS_REGION="eu-south-1"
PERSISTENCE_QUEUE_NAME="persistence-events.fifo"
CERTIFIED_MAIL_QUEUE_NAME="certified-mail.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

NOTIFICATION_QUEUE_URL="https://sqs.eu-south-1.amazonaws.com/895646477129/persistence-events.fifo"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://uat.interop.pagopa.it/.well-known/jwks.json"
DEV_ENDPOINTS_ENABLED="true"

INTERNAL_JWT_ISSUER="uat.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="uat.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

UI_JWT_AUDIENCE="uat.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="uat.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="uat.interop.pagopa.it/internal"

RSA_KEYS_IDENTIFIERS="cdb52532-dd94-40ef-824d-9c55b10e6bc9"

SELFCARE_V2_URL="https://api.selfcare.pagopa.it/external/v2"
INTEROP_FE_BASE_URL="selfcare.uat.interop.pagopa.it"

INTEROP_SELFCARE_PRODUCT_NAME="prod-interop-coll"
TENANT_ALLOWED_ORIGINS="IPA,ANAC,IVASS,PDND_INFOCAMERE-SCP"
PRODUCER_ALLOWED_ORIGINS="IPA"

ESERVICE_TEMPLATE_PROCESS_STORAGE_CONTAINER="interop-application-documents-test-es1"
ESERVICE_TEMPLATE_PROCESS_DOCUMENTS_PATH="eservice-template/docs"

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
DELEGATION_PROCESS_URL="http://interop-be-delegation-process.test.svc.cluster.local:8088"
AGREEMENT_PROCESS_URL="http://interop-be-agreement-process.test.svc.cluster.local:8088"
PURPOSE_PROCESS_URL="http://interop-be-purpose-process.test.svc.cluster.local:8088"
TENANT_PROCESS_URL="http://interop-be-tenant-process.test.svc.cluster.local:8088"
ATTRIBUTE_REGISTRY_PROCESS_URL="http://interop-be-attribute-registry-process.test.svc.cluster.local:8088"
CATALOG_PROCESS_URL="http://interop-be-catalog-process.test.svc.cluster.local:8088"
ESERVICE_TEMPLATE_PROCESS_URL="http://interop-be-eservice-template-process.test.svc.cluster.local:8088"

CLIENT_ASSERTION_JWT_AUDIENCE="auth.uat.interop.pagopa.it/client-assertion"

FEATURE_FLAG_SIGNALHUB_WHITELIST=false
FEATURE_FLAG_AGREEMENT_APPROVAL_POLICY_UPDATE=true
FEATURE_FLAG_ADMIN_CLIENT=true
SIGNALHUB_WHITELIST_PRODUCER=""
SIGNALHUB_WHITELIST_CONSUMER=""

API_GATEWAY_V1_INTERFACE_URL="https://selfcare.uat.interop.pagopa.it/m2m/v1-interface-specification.yaml"
API_GATEWAY_V2_INTERFACE_URL="https://selfcare.uat.interop.pagopa.it/m2m/v2-interface-specification.yaml"