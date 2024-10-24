#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh

. $(pwd)/kubernetes/configs/prod/versions.sh
. $(pwd)/kubernetes/configs/prod/commons.sh

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

. $(pwd)/kubernetes/configs/prod/redis.sh

. $(pwd)/kubernetes/configs/prod/agreement_email_sender.sh
. $(pwd)/kubernetes/configs/prod/agreement_readmodel_writer.sh
. $(pwd)/kubernetes/configs/prod/agreement_process.sh
. $(pwd)/kubernetes/configs/prod/api_gateway.sh
. $(pwd)/kubernetes/configs/prod/authorization_management.sh
. $(pwd)/kubernetes/configs/prod/authorization_process.sh
. $(pwd)/kubernetes/configs/prod/authorization_server.sh
. $(pwd)/kubernetes/configs/prod/authorization_updater.sh
. $(pwd)/kubernetes/configs/prod/attribute_registry_readmodel_writer.sh
. $(pwd)/kubernetes/configs/prod/attribute_registry_process.sh
. $(pwd)/kubernetes/configs/prod/attributes_loader.sh
. $(pwd)/kubernetes/configs/prod/backend_for_frontend.sh
. $(pwd)/kubernetes/configs/prod/catalog_readmodel_writer.sh
. $(pwd)/kubernetes/configs/prod/catalog_process.sh
. $(pwd)/kubernetes/configs/prod/compute_agreements_consumer.sh
. $(pwd)/kubernetes/configs/prod/client_readmodel_writer.sh
. $(pwd)/kubernetes/configs/prod/key_readmodel_writer.sh
. $(pwd)/kubernetes/configs/prod/frontend.sh
. $(pwd)/kubernetes/configs/prod/party_registry_proxy.sh
. $(pwd)/kubernetes/configs/prod/purpose_process.sh
. $(pwd)/kubernetes/configs/prod/purpose_readmodel_writer.sh
. $(pwd)/kubernetes/configs/prod/tenant_process.sh
. $(pwd)/kubernetes/configs/prod/tenant_readmodel_writer.sh
. $(pwd)/kubernetes/configs/prod/tenants-certified-attributes-updater.sh
. $(pwd)/kubernetes/configs/prod/notifier.sh
. $(pwd)/kubernetes/configs/prod/notifier_seeder.sh
. $(pwd)/kubernetes/configs/prod/token_details_persister.sh
. $(pwd)/kubernetes/configs/prod/party_registry_proxy_refresher.sh
. $(pwd)/kubernetes/configs/prod/eservices_monitoring_exporter.sh
. $(pwd)/kubernetes/configs/prod/anac_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/prod/ivass_certified_attributes_importer.sh
. $(pwd)/kubernetes/configs/prod/pn_consumers.sh
. $(pwd)/kubernetes/configs/prod/padigitale_report_generator.sh
. $(pwd)/kubernetes/configs/prod/dtd_catalog_exporter.sh
. $(pwd)/kubernetes/configs/prod/one_trust_notices.sh
. $(pwd)/kubernetes/configs/prod/selfcare_onboarding_consumer.sh
. $(pwd)/kubernetes/configs/prod/eservice_descriptors_archiver.sh
. $(pwd)/kubernetes/configs/prod/datalake_data_export.sh
