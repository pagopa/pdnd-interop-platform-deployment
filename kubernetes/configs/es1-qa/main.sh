#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh

. $(pwd)/kubernetes/configs/es1-qa/versions.sh
. $(pwd)/kubernetes/configs/es1-qa/commons.sh

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

. $(pwd)/kubernetes/configs/es1-qa/redis.sh
. $(pwd)/kubernetes/configs/es1-qa/smtp_mock.sh
. $(pwd)/kubernetes/configs/es1-qa/ses_mock.sh

. $(pwd)/kubernetes/configs/es1-qa/agreement_email_sender.sh
. $(pwd)/kubernetes/configs/es1-qa/agreement_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-qa/agreement_platformstate_writer.sh
. $(pwd)/kubernetes/configs/es1-qa/agreement_process.sh
. $(pwd)/kubernetes/configs/es1-qa/api_gateway.sh
. $(pwd)/kubernetes/configs/es1-qa/authorization_platformstate_writer.sh
. $(pwd)/kubernetes/configs/es1-qa/authorization_management.sh
. $(pwd)/kubernetes/configs/es1-qa/authorization_process.sh
. $(pwd)/kubernetes/configs/es1-qa/authorization_server.sh
. $(pwd)/kubernetes/configs/es1-qa/authorization_updater.sh
. $(pwd)/kubernetes/configs/es1-qa/attribute_registry_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-qa/attribute_registry_process.sh
. $(pwd)/kubernetes/configs/es1-qa/attributes_loader.sh
. $(pwd)/kubernetes/configs/es1-qa/backend_for_frontend.sh
. $(pwd)/kubernetes/configs/es1-qa/catalog_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-qa/catalog_platformstate_writer.sh
. $(pwd)/kubernetes/configs/es1-qa/catalog_process.sh
. $(pwd)/kubernetes/configs/es1-qa/compute_agreements_consumer.sh
. $(pwd)/kubernetes/configs/es1-qa/client_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-qa/delegation_items_archiver.sh
. $(pwd)/kubernetes/configs/es1-qa/delegation_process.sh
. $(pwd)/kubernetes/configs/es1-qa/delegation_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-qa/key_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-qa/frontend.sh
. $(pwd)/kubernetes/configs/es1-qa/party_registry_proxy.sh
. $(pwd)/kubernetes/configs/es1-qa/purpose_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-qa/purpose_platformstate_writer.sh
. $(pwd)/kubernetes/configs/es1-qa/purpose_process.sh
. $(pwd)/kubernetes/configs/es1-qa/tenant_process.sh
. $(pwd)/kubernetes/configs/es1-qa/tenant_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-qa/tenants-certified-attributes-updater.sh
. $(pwd)/kubernetes/configs/es1-qa/notifier.sh
. $(pwd)/kubernetes/configs/es1-qa/notifier_seeder.sh
. $(pwd)/kubernetes/configs/es1-qa/token_details_persister.sh
. $(pwd)/kubernetes/configs/es1-qa/party_registry_proxy_refresher.sh
. $(pwd)/kubernetes/configs/es1-qa/eservices_monitoring_exporter.sh
. $(pwd)/kubernetes/configs/es1-qa/anac_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/es1-qa/ivass_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/es1-qa/pn_consumers.sh
. $(pwd)/kubernetes/configs/es1-qa/padigitale_report_generator.sh
. $(pwd)/kubernetes/configs/es1-qa/dtd_catalog_exporter.sh
. $(pwd)/kubernetes/configs/es1-qa/one_trust_notices.sh
. $(pwd)/kubernetes/configs/es1-qa/selfcare_onboarding_consumer.sh
. $(pwd)/kubernetes/configs/es1-qa/eservice_descriptors_archiver.sh
. $(pwd)/kubernetes/configs/es1-qa/datalake_data_export.sh
. $(pwd)/kubernetes/configs/es1-qa/producer-key-readmodel-writer.sh
. $(pwd)/kubernetes/configs/es1-qa/producer-keychain-readmodel-writer.sh