#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh

. $(pwd)/kubernetes/configs/prod/versions.sh
. $(pwd)/kubernetes/configs/prod/commons.sh

# Calculated
NAMESPACE=$NAMESPACE
EXTERNAL_APPLICATION_HOST="$UI_SUBDOMAIN.$DOMAIN_NAME"
AUTHORIZATION_SERVER_HOST="$AUTH_SUBDOMAIN.$DOMAIN_NAME"

AGREEMENT_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AGREEMENT_MANAGEMENT_IMAGE_VERSION)
ATTRIBUTE_REGISTRY_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $ATTRIBUTE_REGISTRY_MANAGEMENT_IMAGE_VERSION)
AUTHORIZATION_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AUTHORIZATION_MANAGEMENT_IMAGE_VERSION)
CATALOG_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $CATALOG_MANAGEMENT_IMAGE_VERSION)
PARTY_REGISTRY_PROXY_INTERFACE_VERSION=$(shortVersion $PARTY_REGISTRY_PROXY_IMAGE_VERSION)
PURPOSE_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $PURPOSE_MANAGEMENT_IMAGE_VERSION)
TENANT_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $TENANT_MANAGEMENT_IMAGE_VERSION)

AGREEMENT_PROCESS_INTERFACE_VERSION=$(shortVersion $AGREEMENT_PROCESS_IMAGE_VERSION)
AUTHORIZATION_PROCESS_INTERFACE_VERSION=$(shortVersion $AUTHORIZATION_PROCESS_IMAGE_VERSION)
CATALOG_PROCESS_INTERFACE_VERSION=$(shortVersion $CATALOG_PROCESS_IMAGE_VERSION)
PURPOSE_PROCESS_INTERFACE_VERSION=$(shortVersion $PURPOSE_PROCESS_IMAGE_VERSION)
TENANT_PROCESS_INTERFACE_VERSION=$(shortVersion $TENANT_PROCESS_IMAGE_VERSION)

API_GATEWAY_INTERFACE_VERSION=$(shortVersion $API_GATEWAY_IMAGE_VERSION)
BACKEND_FOR_FRONTEND_INTERFACE_VERSION=$(shortVersion $BACKEND_FOR_FRONTEND_IMAGE_VERSION)
NOTIFIER_INTERFACE_VERSION=$(shortVersion $NOTIFIER_IMAGE_VERSION)

. $(pwd)/kubernetes/configs/prod/redis.sh

. $(pwd)/kubernetes/configs/prod/agreement_management.sh
. $(pwd)/kubernetes/configs/prod/agreement_process.sh
. $(pwd)/kubernetes/configs/prod/api_gateway.sh
. $(pwd)/kubernetes/configs/prod/authorization_management.sh
. $(pwd)/kubernetes/configs/prod/authorization_process.sh
. $(pwd)/kubernetes/configs/prod/authorization_server.sh
. $(pwd)/kubernetes/configs/prod/attribute_registry_management.sh
. $(pwd)/kubernetes/configs/prod/attributes_loader.sh
. $(pwd)/kubernetes/configs/prod/backend_for_frontend.sh
. $(pwd)/kubernetes/configs/prod/catalog_management.sh
. $(pwd)/kubernetes/configs/prod/catalog_process.sh
. $(pwd)/kubernetes/configs/prod/frontend.sh
. $(pwd)/kubernetes/configs/prod/party_registry_proxy.sh
. $(pwd)/kubernetes/configs/prod/purpose_management.sh
. $(pwd)/kubernetes/configs/prod/purpose_process.sh
. $(pwd)/kubernetes/configs/prod/tenant_management.sh
. $(pwd)/kubernetes/configs/prod/tenant_process.sh
. $(pwd)/kubernetes/configs/prod/tenants-certified-attributes-updater.sh
. $(pwd)/kubernetes/configs/prod/notifier.sh
. $(pwd)/kubernetes/configs/prod/token_details_persister.sh
. $(pwd)/kubernetes/configs/prod/metrics_report_generator.sh
. $(pwd)/kubernetes/configs/prod/padigitale_report_generator.sh
. $(pwd)/kubernetes/configs/prod/dashboard_metrics_report_generator.sh
