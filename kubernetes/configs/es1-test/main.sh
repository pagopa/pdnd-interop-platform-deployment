#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh

. $(pwd)/kubernetes/configs/es1-test/versions.sh
. $(pwd)/kubernetes/configs/es1-test/commons.sh

# Calculated
NAMESPACE=$NAMESPACE
EXTERNAL_APPLICATION_HOST="$UI_SUBDOMAIN.$DOMAIN_NAME"
AUTHORIZATION_SERVER_HOST="$AUTH_SUBDOMAIN.$DOMAIN_NAME"
API_GATEWAY_HOST="$API_SUBDOMAIN.$DOMAIN_NAME"

AUTHORIZATION_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AUTHORIZATION_MANAGEMENT_IMAGE_VERSION)
PARTY_REGISTRY_PROXY_INTERFACE_VERSION=$(shortVersion $PARTY_REGISTRY_PROXY_IMAGE_VERSION)

API_GATEWAY_INTERFACE_VERSION="1.0"
BACKEND_FOR_FRONTEND_INTERFACE_VERSION=$(shortVersion $BACKEND_FOR_FRONTEND_IMAGE_VERSION)
NOTIFIER_INTERFACE_VERSION=$(shortVersion $NOTIFIER_IMAGE_VERSION)

. $(pwd)/kubernetes/configs/es1-test/redis.sh
. $(pwd)/kubernetes/configs/es1-test/smtp_mock.sh
. $(pwd)/kubernetes/configs/es1-test/ses_mock.sh

. $(pwd)/kubernetes/configs/es1-test/agreement_email_sender.sh
. $(pwd)/kubernetes/configs/es1-test/agreement_outbound_writer.sh
. $(pwd)/kubernetes/configs/es1-test/agreement_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-test/agreement_process.sh
. $(pwd)/kubernetes/configs/es1-test/api_gateway.sh
. $(pwd)/kubernetes/configs/es1-test/authorization_management.sh
. $(pwd)/kubernetes/configs/es1-test/authorization_process.sh
. $(pwd)/kubernetes/configs/es1-test/authorization_server.sh
. $(pwd)/kubernetes/configs/es1-test/authorization_updater.sh
. $(pwd)/kubernetes/configs/es1-test/attribute_registry_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-test/attribute_registry_process.sh
. $(pwd)/kubernetes/configs/es1-test/attributes_loader.sh
. $(pwd)/kubernetes/configs/es1-test/backend_for_frontend.sh
. $(pwd)/kubernetes/configs/es1-test/catalog_outbound_writer.sh
. $(pwd)/kubernetes/configs/es1-test/catalog_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-test/catalog_process.sh
. $(pwd)/kubernetes/configs/es1-test/compute_agreements_consumer.sh
. $(pwd)/kubernetes/configs/es1-test/client_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-test/key_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-test/frontend.sh
. $(pwd)/kubernetes/configs/es1-test/party_registry_proxy.sh
. $(pwd)/kubernetes/configs/es1-test/purpose_outbound_writer.sh
. $(pwd)/kubernetes/configs/es1-test/purpose_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-test/purpose_process.sh
. $(pwd)/kubernetes/configs/es1-test/tenant_process.sh
. $(pwd)/kubernetes/configs/es1-test/tenant_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-test/tenants-certified-attributes-updater.sh
. $(pwd)/kubernetes/configs/es1-test/notifier.sh
. $(pwd)/kubernetes/configs/es1-test/notifier_seeder.sh
. $(pwd)/kubernetes/configs/es1-test/token_details_persister.sh
. $(pwd)/kubernetes/configs/es1-test/party_registry_proxy_refresher.sh
. $(pwd)/kubernetes/configs/es1-test/eservices_monitoring_exporter.sh
. $(pwd)/kubernetes/configs/es1-test/metrics_report_generator.sh
. $(pwd)/kubernetes/configs/es1-test/anac_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/es1-test/ivass_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/es1-test/pn_consumers.sh
. $(pwd)/kubernetes/configs/es1-test/padigitale_report_generator.sh
. $(pwd)/kubernetes/configs/es1-test/dtd_catalog_exporter.sh
. $(pwd)/kubernetes/configs/es1-test/one_trust_notices.sh
. $(pwd)/kubernetes/configs/es1-test/selfcare_onboarding_consumer.sh
. $(pwd)/kubernetes/configs/es1-test/eservice_descriptors_archiver.sh
. $(pwd)/kubernetes/configs/es1-test/datalake_data_export.sh
. $(pwd)/kubernetes/configs/es1-test/producer-key-readmodel-writer.sh
. $(pwd)/kubernetes/configs/es1-test/producer-keychain-readmodel-writer.sh