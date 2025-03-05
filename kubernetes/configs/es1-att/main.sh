#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh

. $(pwd)/kubernetes/configs/es1-att/versions.sh
. $(pwd)/kubernetes/configs/es1-att/commons.sh

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

. $(pwd)/kubernetes/configs/es1-att/redis.sh
. $(pwd)/kubernetes/configs/es1-att/smtp_mock.sh
. $(pwd)/kubernetes/configs/es1-att/ses_mock.sh

. $(pwd)/kubernetes/configs/es1-att/agreement_outbound_writer.sh
. $(pwd)/kubernetes/configs/es1-att/agreement_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-att/agreement_process.sh
. $(pwd)/kubernetes/configs/es1-att/api_gateway.sh
. $(pwd)/kubernetes/configs/es1-att/authorization_management.sh
. $(pwd)/kubernetes/configs/es1-att/authorization_process.sh
. $(pwd)/kubernetes/configs/es1-att/authorization_server.sh
. $(pwd)/kubernetes/configs/es1-att/authorization_updater.sh
. $(pwd)/kubernetes/configs/es1-att/attribute_registry_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-att/attribute_registry_process.sh
. $(pwd)/kubernetes/configs/es1-att/attributes_loader.sh
. $(pwd)/kubernetes/configs/es1-att/backend_for_frontend.sh
. $(pwd)/kubernetes/configs/es1-att/catalog_outbound_writer.sh
. $(pwd)/kubernetes/configs/es1-att/catalog_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-att/catalog_process.sh
. $(pwd)/kubernetes/configs/es1-att/certified_email_sender.sh
. $(pwd)/kubernetes/configs/es1-att/compute_agreements_consumer.sh
. $(pwd)/kubernetes/configs/es1-att/client_purpose_updater.sh
. $(pwd)/kubernetes/configs/es1-att/client_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-att/datalake_interface_exporter.sh
. $(pwd)/kubernetes/configs/es1-att/delegation_items_archiver.sh
. $(pwd)/kubernetes/configs/es1-att/delegation_outbound_writer.sh
. $(pwd)/kubernetes/configs/es1-att/delegation_process.sh 
. $(pwd)/kubernetes/configs/es1-att/delegation_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-att/key_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-att/frontend.sh
. $(pwd)/kubernetes/configs/es1-att/party_registry_proxy.sh
. $(pwd)/kubernetes/configs/es1-att/purpose_outbound_writer.sh
. $(pwd)/kubernetes/configs/es1-att/purpose_process.sh
. $(pwd)/kubernetes/configs/es1-att/purpose_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-att/tenant_outbound_writer.sh
. $(pwd)/kubernetes/configs/es1-att/tenant_process.sh
. $(pwd)/kubernetes/configs/es1-att/tenant_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-att/tenants-certified-attributes-updater.sh
. $(pwd)/kubernetes/configs/es1-att/notification_email_sender.sh
. $(pwd)/kubernetes/configs/es1-att/notifier.sh
. $(pwd)/kubernetes/configs/es1-att/notifier_seeder.sh
. $(pwd)/kubernetes/configs/es1-att/token_details_persister.sh
. $(pwd)/kubernetes/configs/es1-att/party_registry_proxy_refresher.sh
. $(pwd)/kubernetes/configs/es1-att/anac_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/es1-att/ivass_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/es1-att/pn_consumers.sh
. $(pwd)/kubernetes/configs/es1-att/padigitale_report_generator.sh
. $(pwd)/kubernetes/configs/es1-att/dtd_catalog_exporter.sh
. $(pwd)/kubernetes/configs/es1-att/one_trust_notices.sh
. $(pwd)/kubernetes/configs/es1-att/selfcare_onboarding_consumer.sh
. $(pwd)/kubernetes/configs/es1-att/eservice_descriptors_archiver.sh
. $(pwd)/kubernetes/configs/es1-att/datalake_data_export.sh
. $(pwd)/kubernetes/configs/es1-att/producer-key-readmodel-writer.sh
. $(pwd)/kubernetes/configs/es1-att/producer-keychain-readmodel-writer.sh
