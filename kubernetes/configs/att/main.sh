#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh

. $(pwd)/kubernetes/configs/att/versions.sh
. $(pwd)/kubernetes/configs/att/commons.sh

# Calculated
NAMESPACE=$NAMESPACE
EXTERNAL_APPLICATION_HOST="$UI_SUBDOMAIN.$DOMAIN_NAME"
AUTHORIZATION_SERVER_HOST="$AUTH_SUBDOMAIN.$DOMAIN_NAME"
API_GATEWAY_HOST="$API_SUBDOMAIN.$DOMAIN_NAME"

AGREEMENT_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AGREEMENT_MANAGEMENT_IMAGE_VERSION)
ATTRIBUTE_REGISTRY_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $ATTRIBUTE_REGISTRY_MANAGEMENT_IMAGE_VERSION)
AUTHORIZATION_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AUTHORIZATION_MANAGEMENT_IMAGE_VERSION)
CATALOG_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $CATALOG_MANAGEMENT_IMAGE_VERSION)
PARTY_REGISTRY_PROXY_INTERFACE_VERSION=$(shortVersion $PARTY_REGISTRY_PROXY_IMAGE_VERSION)
PURPOSE_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $PURPOSE_MANAGEMENT_IMAGE_VERSION)
TENANT_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $TENANT_MANAGEMENT_IMAGE_VERSION)

ATTRIBUTE_REGISTRY_PROCESS_INTERFACE_VERSION=$(shortVersion $ATTRIBUTE_REGISTRY_PROCESS_IMAGE_VERSION)
AGREEMENT_PROCESS_INTERFACE_VERSION=$(shortVersion $AGREEMENT_PROCESS_IMAGE_VERSION)
AUTHORIZATION_PROCESS_INTERFACE_VERSION=$(shortVersion $AUTHORIZATION_PROCESS_IMAGE_VERSION)
CATALOG_PROCESS_INTERFACE_VERSION=$(shortVersion $CATALOG_PROCESS_IMAGE_VERSION)
PURPOSE_PROCESS_INTERFACE_VERSION=$(shortVersion $PURPOSE_PROCESS_IMAGE_VERSION)
TENANT_PROCESS_INTERFACE_VERSION=$(shortVersion $TENANT_PROCESS_IMAGE_VERSION)

API_GATEWAY_INTERFACE_VERSION=$(shortVersion $API_GATEWAY_IMAGE_VERSION)
BACKEND_FOR_FRONTEND_INTERFACE_VERSION=$(shortVersion $BACKEND_FOR_FRONTEND_IMAGE_VERSION)
NOTIFIER_INTERFACE_VERSION=$(shortVersion $NOTIFIER_IMAGE_VERSION)

. $(pwd)/kubernetes/configs/att/redis.sh
. $(pwd)/kubernetes/configs/att/smtp_mock.sh

. $(pwd)/kubernetes/configs/att/agreement_management.sh
. $(pwd)/kubernetes/configs/att/agreement_process.sh
. $(pwd)/kubernetes/configs/att/api_gateway.sh
. $(pwd)/kubernetes/configs/att/authorization_management.sh
. $(pwd)/kubernetes/configs/att/authorization_process.sh
. $(pwd)/kubernetes/configs/att/authorization_server.sh
. $(pwd)/kubernetes/configs/att/attribute_registry_management.sh
. $(pwd)/kubernetes/configs/att/attribute_registry_process.sh
. $(pwd)/kubernetes/configs/att/attributes_loader.sh
. $(pwd)/kubernetes/configs/att/backend_for_frontend.sh
. $(pwd)/kubernetes/configs/att/catalog_management.sh
. $(pwd)/kubernetes/configs/att/catalog_process.sh
. $(pwd)/kubernetes/configs/att/frontend.sh
. $(pwd)/kubernetes/configs/att/party_registry_proxy.sh
. $(pwd)/kubernetes/configs/att/purpose_management.sh
. $(pwd)/kubernetes/configs/att/purpose_process.sh
. $(pwd)/kubernetes/configs/att/tenant_management.sh
. $(pwd)/kubernetes/configs/att/tenant_process.sh
. $(pwd)/kubernetes/configs/att/tenants-certified-attributes-updater.sh
. $(pwd)/kubernetes/configs/att/notifier.sh
. $(pwd)/kubernetes/configs/att/token_details_persister.sh
. $(pwd)/kubernetes/configs/att/party_registry_proxy_refresher.sh
. $(pwd)/kubernetes/configs/att/eservices_monitoring_exporter.sh
. $(pwd)/kubernetes/configs/att/metrics_report_generator.sh
. $(pwd)/kubernetes/configs/att/anac_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/att/ivass_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/att/pn_consumers.sh
. $(pwd)/kubernetes/configs/att/padigitale_report_generator.sh
. $(pwd)/kubernetes/configs/att/dashboard_metrics_report_generator.sh
. $(pwd)/kubernetes/configs/att/dtd_catalog_exporter.sh
. $(pwd)/kubernetes/configs/att/one_trust_notices.sh
. $(pwd)/kubernetes/configs/att/selfcare_onboarding_consumer.sh
. $(pwd)/kubernetes/configs/att/eservice_descriptors_archiver.sh
. $(pwd)/kubernetes/configs/att/datalake_data_export.sh
