#!/bin/bash
#
REGION_SUFFIX="-es1"

STAGE="ATT"

DOMAIN_NAME="att.interop.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-south-1.amazonaws.com"
POSTGRES_HOST="interop-platform-data-att.cluster-c5mm6mwy4v3q.eu-south-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
POSTGRES_DB_NAME="persistence_management"
READ_MODEL_DB_HOST="interop-read-model-att.cluster-c5mm6mwy4v3q.eu-south-1.docdb.amazonaws.com"
READ_MODEL_DB_PORT="27017"
READ_MODEL_DB_NAME="read-model"
READ_MODEL_REPLICA_SET="rs0"
READ_MODEL_READ_PREFERENCE="secondaryPreferred"
REPLICAS=1
BACKEND_SERVICE_PORT="8088"

KAFKA_BROKERS="b-3.interopplatformevents.1e4dzm.c3.kafka.eu-south-1.amazonaws.com:9098,b-1.interopplatformevents.1e4dzm.c3.kafka.eu-south-1.amazonaws.com:9098,b-2.interopplatformevents.1e4dzm.c3.kafka.eu-south-1.amazonaws.com:9098"

AGREEMENT_TOPIC="event-store.att_agreement.events"
ATTRIBUTE_TOPIC="event-store.att_attribute_registry.events"
AUTHORIZATION_TOPIC="event-store.att_authorization.events"
CATALOG_TOPIC="event-store.att_catalog.events"
PURPOSE_TOPIC="event-store.att_purpose.events"
TENANT_TOPIC="event-store.att_tenant.events"
DELEGATION_TOPIC="event-store.att_delegation.events"
ESERVICE_TEMPLATE_TOPIC="event-store.att_eservice_template.events"

AGREEMENT_OUTBOUND_TOPIC="outbound.att_agreement.events"
CATALOG_OUTBOUND_TOPIC="outbound.att_catalog.events"
PURPOSE_OUTBOUND_TOPIC="outbound.att_purpose.events"
TENANT_OUTBOUND_TOPIC="outbound.att_tenant.events"
DELEGATION_OUTBOUND_TOPIC="outbound.att_delegation.events"
ESERVICE_TEMPLATE_OUTBOUND_TOPIC="outbound.att_eservice_template.events"

APPLICATION_AUDIT_TOPIC="att_application.audit"

AWS_REGION="eu-south-1"
PERSISTENCE_QUEUE_NAME="persistence-events.fifo"
CERTIFIED_MAIL_QUEUE_NAME="certified-mail.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

NOTIFICATION_QUEUE_URL="https://sqs.eu-south-1.amazonaws.com/533267098416/persistence-events.fifo"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://att.interop.pagopa.it/.well-known/jwks.json"
DEV_ENDPOINTS_ENABLED="false"

INTERNAL_JWT_ISSUER="att.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="att.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

UI_JWT_AUDIENCE="att.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="att.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="att.interop.pagopa.it/internal"
RSA_KEYS_IDENTIFIERS="490baa58-8d24-4adf-bfb3-f19a9e505b9a"

SELFCARE_V2_URL="https://api.selfcare.pagopa.it/external/v2"
INTEROP_FE_BASE_URL="selfcare.att.interop.pagopa.it"

INTEROP_SELFCARE_PRODUCT_NAME="prod-interop-atst"
TENANT_ALLOWED_ORIGINS="IPA,ANAC,IVASS,INFOCAMERE,SELC,PDND_INFOCAMERE-SCP,PDND_INFOCAMERE-PRV,INFOCAMERE-PT"
PRODUCER_ALLOWED_ORIGINS="IPA,ANAC,IVASS,INFOCAMERE,SELC,PDND_INFOCAMERE-SCP,PDND_INFOCAMERE-PRV,INFOCAMERE-PT"
DELEGATIONS_ALLOWED_ORIGINS="IPA,ANAC,IVASS,INFOCAMERE,SELC,PDND_INFOCAMERE-SCP,PDND_INFOCAMERE-PRV,INFOCAMERE-PT"

ESERVICE_TEMPLATE_PROCESS_STORAGE_CONTAINER="interop-application-documents-att-es1"
ESERVICE_TEMPLATE_PROCESS_DOCUMENTS_PATH="eservice-template/docs"

PRIVACY_NOTICES_DYNAMO_TABLE_NAME="interop-privacy-notices-att"
PRIVACY_NOTICES_ACCEPTANCE_DYNAMO_TABLE_NAME="interop-privacy-notices-acceptances-att"
PRIVACY_NOTICES_UPDATER_PRIVACY_POLICY_UUID="0df21ff6-3e8f-4320-af8f-23dea9135d57"
PRIVACY_NOTICES_UPDATER_TERMS_OF_SERVICE_UUID="6bf8412a-41a7-41a0-82dc-26286ce61b1a"
PRIVACY_NOTICES_CONTAINER="interop-privacy-notices-content-att-es1"

PAGOPA_TENANT_ID="1013dbf7-1124-4daa-8e85-ac9313d5dc61"

REPORT_SENDER_MAIL="noreply@reports.att.interop.pagopa.it"
REPORT_SENDER_LABEL="noreply-att"

NOTIFICATION_SENDER_MAIL="noreply@notifiche.att.interop.pagopa.it"
NOTIFICATION_SENDER_LABEL="noreply-att"

SES_ENDPOINT="http://ses-mock.att.svc.cluster.local:8005"

PEC_SMTP_ADDRESS="smtp-mock.att.svc.cluster.local"
PEC_SMTP_PORT=5025
PEC_SMTP_SECURE=false

SMTP_SECURE=false
SMTP_ADDRESS="smtp-mock.att.svc.cluster.local"
SMTP_PORT=5025

AUTHORIZATION_MANAGEMENT_URL="http://interop-be-authorization-management.att.svc.cluster.local:8088/authorization-management/1.0"
DELEGATION_PROCESS_URL="http://interop-be-delegation-process.att.svc.cluster.local:8088"
AGREEMENT_PROCESS_URL="http://interop-be-agreement-process.att.svc.cluster.local:8088"
PURPOSE_PROCESS_URL="http://interop-be-purpose-process.att.svc.cluster.local:8088"
TENANT_PROCESS_URL="http://interop-be-tenant-process.att.svc.cluster.local:8088"
ATTRIBUTE_REGISTRY_PROCESS_URL="http://interop-be-attribute-registry-process.att.svc.cluster.local:8088"

CLIENT_ASSERTION_JWT_AUDIENCE="auth.att.interop.pagopa.it/client-assertion"

FEATURE_FLAG_SIGNALHUB_WHITELIST=false
SIGNALHUB_WHITELIST_PRODUCER=""
SIGNALHUB_WHITELIST_CONSUMER=""
