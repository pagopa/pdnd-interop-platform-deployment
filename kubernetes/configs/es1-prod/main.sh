#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh

. $(pwd)/kubernetes/configs/es1-prod/versions.sh
. $(pwd)/kubernetes/configs/es1-prod/commons.sh

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

. $(pwd)/kubernetes/configs/es1-prod/redis.sh

. $(pwd)/kubernetes/configs/es1-prod/agreement_email_sender.sh
. $(pwd)/kubernetes/configs/es1-prod/agreement_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-prod/agreement_process.sh
. $(pwd)/kubernetes/configs/es1-prod/api_gateway.sh
. $(pwd)/kubernetes/configs/es1-prod/authorization_management.sh
. $(pwd)/kubernetes/configs/es1-prod/authorization_process.sh
. $(pwd)/kubernetes/configs/es1-prod/authorization_server.sh
. $(pwd)/kubernetes/configs/es1-prod/authorization_updater.sh
. $(pwd)/kubernetes/configs/es1-prod/attribute_registry_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-prod/attribute_registry_process.sh
. $(pwd)/kubernetes/configs/es1-prod/attributes_loader.sh
. $(pwd)/kubernetes/configs/es1-prod/backend_for_frontend.sh
. $(pwd)/kubernetes/configs/es1-prod/catalog_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-prod/catalog_process.sh
. $(pwd)/kubernetes/configs/es1-prod/compute_agreements_consumer.sh
. $(pwd)/kubernetes/configs/es1-prod/client_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-prod/key_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-prod/frontend.sh
. $(pwd)/kubernetes/configs/es1-prod/party_registry_proxy.sh
. $(pwd)/kubernetes/configs/es1-prod/purpose_process.sh
. $(pwd)/kubernetes/configs/es1-prod/purpose_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-prod/tenant_process.sh
. $(pwd)/kubernetes/configs/es1-prod/tenant_readmodel_writer.sh
. $(pwd)/kubernetes/configs/es1-prod/tenants-certified-attributes-updater.sh
. $(pwd)/kubernetes/configs/es1-prod/notifier.sh
. $(pwd)/kubernetes/configs/es1-prod/notifier_seeder.sh
. $(pwd)/kubernetes/configs/es1-prod/token_details_persister.sh
. $(pwd)/kubernetes/configs/es1-prod/party_registry_proxy_refresher.sh
. $(pwd)/kubernetes/configs/es1-prod/eservices_monitoring_exporter.sh
. $(pwd)/kubernetes/configs/es1-prod/anac_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/es1-prod/ivass_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/es1-prod/pn_consumers.sh
. $(pwd)/kubernetes/configs/es1-prod/padigitale_report_generator.sh
. $(pwd)/kubernetes/configs/es1-prod/dtd_catalog_exporter.sh
. $(pwd)/kubernetes/configs/es1-prod/one_trust_notices.sh
. $(pwd)/kubernetes/configs/es1-prod/selfcare_onboarding_consumer.sh
. $(pwd)/kubernetes/configs/es1-prod/eservice_descriptors_archiver.sh
. $(pwd)/kubernetes/configs/es1-prod/datalake_data_export.sh
