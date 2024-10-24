#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh

. $(pwd)/kubernetes/configs/es1-dev-refactor/versions.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/commons.sh

# Calculated
NAMESPACE=$NAMESPACE
EXTERNAL_APPLICATION_HOST="$UI_SUBDOMAIN.$DOMAIN_NAME"
AUTHORIZATION_SERVER_HOST="$AUTH_SUBDOMAIN.$DOMAIN_NAME"
API_GATEWAY_HOST="$API_SUBDOMAIN.$DOMAIN_NAME"

AUTHORIZATION_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AUTHORIZATION_MANAGEMENT_IMAGE_VERSION)
PARTY_REGISTRY_PROXY_INTERFACE_VERSION=$(shortVersion $PARTY_REGISTRY_PROXY_IMAGE_VERSION)

API_GATEWAY_INTERFACE_VERSION=$(shortVersion $API_GATEWAY_IMAGE_VERSION)
BACKEND_FOR_FRONTEND_INTERFACE_VERSION=$(shortVersion $BACKEND_FOR_FRONTEND_IMAGE_VERSION)
NOTIFIER_INTERFACE_VERSION=$(shortVersion $NOTIFIER_IMAGE_VERSION)

. $(pwd)/kubernetes/configs/es1-dev-refactor/redis.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/smtp_mock.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/ses_mock.sh

. $(pwd)/kubernetes/configs/es1-dev-refactor/agreement_email_sender.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/agreement_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/agreement_process.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/api_gateway.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/authorization_management.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/authorization_process.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/authorization_server.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/authorization_updater.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/attribute_registry_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/attribute_registry_process.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/attributes_loader.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/backend_for_frontend.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/catalog_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/client_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/catalog_process.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/compute_agreements_consumer.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/frontend.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/key_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/party_registry_proxy.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/purpose_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/purpose_process.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/tenant_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/tenant_process.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/tenants-certified-attributes-updater.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/notifier.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/notifier_seeder.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/token_details_persister.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/party_registry_proxy_refresher.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/eservices_monitoring_exporter.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/metrics_report_generator.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/anac_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/ivass_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/pn_consumers.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/padigitale_report_generator.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/dashboard_metrics_report_generator.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/dtd_catalog_exporter.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/one_trust_notices.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/selfcare_onboarding_consumer.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/eservice_descriptors_archiver.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/dtd_metrics.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/datalake_data_export.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/producer-key-readmodel-writer.sh
. $(pwd)/kubernetes/configs/es1-dev-refactor/producer-keychain-readmodel-writer.sh
