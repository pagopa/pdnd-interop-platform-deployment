#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh

. $(pwd)/kubernetes/configs/es1-dev/versions.sh
. $(pwd)/kubernetes/configs/es1-dev/commons.sh

# Calculated
NAMESPACE=$NAMESPACE
EXTERNAL_APPLICATION_HOST="$UI_SUBDOMAIN.$DOMAIN_NAME"
AUTHORIZATION_SERVER_HOST="$AUTH_SUBDOMAIN.$DOMAIN_NAME"
API_GATEWAY_HOST="$API_SUBDOMAIN.$DOMAIN_NAME"

AUTHORIZATION_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AUTHORIZATION_MANAGEMENT_IMAGE_VERSION)
PARTY_REGISTRY_PROXY_INTERFACE_VERSION=$(shortVersion $PARTY_REGISTRY_PROXY_IMAGE_VERSION)
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

. $(pwd)/kubernetes/configs/es1-dev/redis.sh
. $(pwd)/kubernetes/configs/es1-dev/smtp_mock.sh


. $(pwd)/kubernetes/configs/es1-dev/agreement_email_sender.sh
. $(pwd)/kubernetes/configs/es1-dev/agreement_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-dev/agreement_process.sh
. $(pwd)/kubernetes/configs/es1-dev/api_gateway.sh
. $(pwd)/kubernetes/configs/es1-dev/authorization_management.sh
. $(pwd)/kubernetes/configs/es1-dev/authorization_process.sh
. $(pwd)/kubernetes/configs/es1-dev/authorization_server.sh
. $(pwd)/kubernetes/configs/es1-dev/authorization_updater.sh
. $(pwd)/kubernetes/configs/es1-dev/attribute_registry_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-dev/attribute_registry_process.sh
. $(pwd)/kubernetes/configs/es1-dev/attributes_loader.sh
. $(pwd)/kubernetes/configs/es1-dev/backend_for_frontend.sh
. $(pwd)/kubernetes/configs/es1-dev/catalog_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-dev/catalog_process.sh
. $(pwd)/kubernetes/configs/es1-dev/frontend.sh
. $(pwd)/kubernetes/configs/es1-dev/party_registry_proxy.sh
. $(pwd)/kubernetes/configs/es1-dev/purpose_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-dev/purpose_process.sh
. $(pwd)/kubernetes/configs/es1-dev/tenant_management.sh
. $(pwd)/kubernetes/configs/es1-dev/tenant_process.sh
. $(pwd)/kubernetes/configs/es1-dev/tenants-certified-attributes-updater.sh
. $(pwd)/kubernetes/configs/es1-dev/notifier.sh
. $(pwd)/kubernetes/configs/es1-dev/notifier_seeder.sh
. $(pwd)/kubernetes/configs/es1-dev/token_details_persister.sh
. $(pwd)/kubernetes/configs/es1-dev/party_registry_proxy_refresher.sh
. $(pwd)/kubernetes/configs/es1-dev/eservices_monitoring_exporter.sh
. $(pwd)/kubernetes/configs/es1-dev/metrics_report_generator.sh
. $(pwd)/kubernetes/configs/es1-dev/anac_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/es1-dev/ivass_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/es1-dev/pn_consumers.sh
. $(pwd)/kubernetes/configs/es1-dev/padigitale_report_generator.sh
. $(pwd)/kubernetes/configs/es1-dev/dashboard_metrics_report_generator.sh
. $(pwd)/kubernetes/configs/es1-dev/dtd_catalog_exporter.sh
. $(pwd)/kubernetes/configs/es1-dev/one_trust_notices.sh
. $(pwd)/kubernetes/configs/es1-dev/selfcare_onboarding_consumer.sh
. $(pwd)/kubernetes/configs/es1-dev/eservice_descriptors_archiver.sh
. $(pwd)/kubernetes/configs/es1-dev/dtd_metrics.sh
. $(pwd)/kubernetes/configs/es1-dev/datalake_data_export.sh
