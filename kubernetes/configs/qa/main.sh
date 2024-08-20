#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh

. $(pwd)/kubernetes/configs/qa/versions.sh
. $(pwd)/kubernetes/configs/qa/commons.sh

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

. $(pwd)/kubernetes/configs/qa/redis.sh
. $(pwd)/kubernetes/configs/qa/smtp_mock.sh

. $(pwd)/kubernetes/configs/qa/agreement_management.sh
. $(pwd)/kubernetes/configs/qa/agreement_process.sh
. $(pwd)/kubernetes/configs/qa/api_gateway.sh
. $(pwd)/kubernetes/configs/qa/authorization_management.sh
. $(pwd)/kubernetes/configs/qa/authorization_process.sh
. $(pwd)/kubernetes/configs/qa/authorization_server.sh
. $(pwd)/kubernetes/configs/qa/authorization_updater.sh
. $(pwd)/kubernetes/configs/qa/attribute_registry_readmodel_writer.sh
. $(pwd)/kubernetes/configs/qa/attribute_registry_process.sh
. $(pwd)/kubernetes/configs/qa/attributes_loader.sh
. $(pwd)/kubernetes/configs/qa/backend_for_frontend.sh
. $(pwd)/kubernetes/configs/qa/catalog_readmodel_writer.sh
. $(pwd)/kubernetes/configs/qa/catalog_process.sh
. $(pwd)/kubernetes/configs/qa/frontend.sh
. $(pwd)/kubernetes/configs/qa/party_registry_proxy.sh
. $(pwd)/kubernetes/configs/qa/purpose_management.sh
. $(pwd)/kubernetes/configs/qa/purpose_process.sh
. $(pwd)/kubernetes/configs/qa/tenant_management.sh
. $(pwd)/kubernetes/configs/qa/tenant_process.sh
. $(pwd)/kubernetes/configs/qa/tenants-certified-attributes-updater.sh
. $(pwd)/kubernetes/configs/qa/notifier.sh
. $(pwd)/kubernetes/configs/qa/notifier_seeder.sh
. $(pwd)/kubernetes/configs/qa/token_details_persister.sh
. $(pwd)/kubernetes/configs/qa/party_registry_proxy_refresher.sh
. $(pwd)/kubernetes/configs/qa/eservices_monitoring_exporter.sh
. $(pwd)/kubernetes/configs/qa/metrics_report_generator.sh
. $(pwd)/kubernetes/configs/qa/anac_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/qa/ivass_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/qa/pn_consumers.sh
. $(pwd)/kubernetes/configs/qa/padigitale_report_generator.sh
. $(pwd)/kubernetes/configs/qa/dashboard_metrics_report_generator.sh
. $(pwd)/kubernetes/configs/qa/dtd_catalog_exporter.sh
. $(pwd)/kubernetes/configs/qa/one_trust_notices.sh
. $(pwd)/kubernetes/configs/qa/selfcare_onboarding_consumer.sh
. $(pwd)/kubernetes/configs/qa/eservice_descriptors_archiver.sh
. $(pwd)/kubernetes/configs/qa/datalake_data_export.sh
