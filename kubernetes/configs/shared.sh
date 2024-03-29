#!/bin/bash

# Functions
# TODO Take version from image label
shortVersion() {
  echo $1 | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+$' | grep -oE '[0-9]+\.[0-9]+' || echo "0.0"
}

AGREEMENT_MANAGEMENT_SERVICE_NAME="interop-be-agreement-management"
AGREEMENT_READMODEL_WRITER_SERVICE_NAME="interop-be-agreement-readmodel-writer"
AGREEMENT_PROCESS_SERVICE_NAME="interop-be-agreement-process"
ATTRIBUTE_REGISTRY_MANAGEMENT_SERVICE_NAME="interop-be-attribute-registry-management"
ATTRIBUTE_REGISTRY_PROCESS_SERVICE_NAME="interop-be-attribute-registry-process"
AUTHORIZATION_MANAGEMENT_SERVICE_NAME="interop-be-authorization-management"
AUTHORIZATION_PROCESS_SERVICE_NAME="interop-be-authorization-process"
AUTHORIZATION_SERVER_SERVICE_NAME="interop-be-authorization-server"
AUTHORIZATION_UPDATER_SERVICE_NAME="interop-be-authorization-updater"
CATALOG_MANAGEMENT_SERVICE_NAME="interop-be-catalog-management"
CATALOG_READMODEL_WRITER_SERVICE_NAME="interop-be-catalog-readmodel-writer"
PARTY_REGISTRY_PROXY_SERVICE_NAME="interop-be-party-registry-proxy"
CATALOG_PROCESS_SERVICE_NAME="interop-be-catalog-process"
PURPOSE_MANAGEMENT_SERVICE_NAME="interop-be-purpose-management"
PURPOSE_PROCESS_SERVICE_NAME="interop-be-purpose-process"
API_GATEWAY_SERVICE_NAME="interop-be-api-gateway"
BACKEND_FOR_FRONTEND_SERVICE_NAME="interop-be-backend-for-frontend"
NOTIFIER_SERVICE_NAME="interop-be-notifier"
TENANT_MANAGEMENT_SERVICE_NAME="interop-be-tenant-management"
TENANT_PROCESS_SERVICE_NAME="interop-be-tenant-process"
CERTIFIED_MAIL_SENDER_SERVICE_NAME="interop-be-certified-mail-sender"
ESERVICE_DESCRIPTORS_ARCHIVER_SERVICE_NAME="interop-be-eservice-descriptors-archiver"

FRONTEND_SERVICE_NAME="interop-frontend"

SELFCARE_ONBOARDING_CONSUMER_SERVICE_NAME="interop-be-selfcare-onboarding-consumer"

JOB_ATTRIBUTES_LOADER_SERVICE_NAME="interop-be-attributes-loader"
JOB_DETAILS_PERSISTER_SERVICE_NAME="interop-be-token-details-persister"
JOB_TENANTS_CERTIFIED_ATTRIBUTES_UPDATER_SERVICE_NAME="interop-be-tenants-cert-attr-updater"
JOB_PARTY_REGISTRY_PROXY_REFRESHER_SERVICE_NAME="interop-be-party-registry-proxy-refresher"
JOB_METRICS_REPORT_GENERATOR_SERVICE_NAME="interop-be-metrics-report-generator"
JOB_PADIGITALE_REPORT_GENERATOR_SERVICE_NAME="interop-be-padigitale-report-generator"
JOB_DASHBOARD_METRICS_REPORT_GENERATOR_SERVICE_NAME="interop-be-dashboard-metrics-report-generator"
JOB_ESERVICES_MONITORING_EXPORTER_SERVICE_NAME="interop-be-eservices-monitoring-exporter"
JOB_DTD_CATALOG_EXPORTER_SERVICE_NAME="interop-be-dtd-catalog-exporter"
JOB_ONE_TRUST_NOTICES_SERVICE_NAME="interop-be-one-trust-notices"
JOB_ANAC_CERTIFIED_ATTRIBUTES_IMPORTER_SERVICE_NAME="interop-be-anac-certified-attributes-importer"
JOB_IVASS_CERTIFIED_ATTRIBUTES_IMPORTER_SERVICE_NAME="interop-be-ivass-certified-attributes-importer"
JOB_PN_CONSUMERS_SERVICE_NAME="interop-be-pn-consumers"
JOB_DTD_METRICS_SERVICE_NAME="interop-be-dtd-metrics"
JOB_DATALAKE_DATA_EXPORT_SERVICE_NAME="interop-be-datalake-data-export"

REDIS_SERVICE_NAME="redis"

SMTP_MOCK_SERVICE_NAME="smtp-mock"

AGREEMENT_MANAGEMENT_APPLICATION_PATH="agreement-management"
AGREEMENT_PROCESS_APPLICATION_PATH="agreement-process"
ATTRIBUTE_REGISTRY_MANAGEMENT_APPLICATION_PATH="attribute-registry-management"
ATTRIBUTE_REGISTRY_PROCESS_APPLICATION_PATH="attribute-registry-process"
AUTHORIZATION_MANAGEMENT_APPLICATION_PATH="authorization-management"
AUTHORIZATION_PROCESS_APPLICATION_PATH="authorization-process"
AUTHORIZATION_SERVER_APPLICATION_PATH="authorization-server"
CATALOG_MANAGEMENT_APPLICATION_PATH="catalog-management"
PARTY_REGISTRY_PROXY_APPLICATION_PATH="party-registry-proxy"
CATALOG_PROCESS_APPLICATION_PATH="catalog-process"
PURPOSE_MANAGEMENT_APPLICATION_PATH="purpose-management"
PURPOSE_PROCESS_APPLICATION_PATH="purpose-process"
TENANT_MANAGEMENT_APPLICATION_PATH="tenant-management"
TENANT_PROCESS_APPLICATION_PATH="tenant-process"

API_GATEWAY_APPLICATION_PATH="api-gateway"
BACKEND_FOR_FRONTEND_APPLICATION_PATH="backend-for-frontend"
NOTIFIER_APPLICATION_PATH="notifier"
FRONTEND_SERVICE_APPLICATION_PATH="ui"

UI_SUBDOMAIN="selfcare"
AUTH_SUBDOMAIN="auth"
API_SUBDOMAIN="api"
