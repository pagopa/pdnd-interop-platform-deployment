#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh

. $(pwd)/kubernetes/configs/test/versions.sh
. $(pwd)/kubernetes/configs/test/commons.sh

# Calculated
NAMESPACE=$NAMESPACE
EXTERNAL_APPLICATION_HOST="$UI_SUBDOMAIN.$DOMAIN_NAME"
AUTHORIZATION_SERVER_HOST="$AUTH_SUBDOMAIN.$DOMAIN_NAME"

AGREEMENT_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AGREEMENT_MANAGEMENT_IMAGE_VERSION)
ATTRIBUTE_REGISTRY_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $ATTRIBUTE_REGISTRY_MANAGEMENT_IMAGE_VERSION)
AUTHORIZATION_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AUTHORIZATION_MANAGEMENT_IMAGE_VERSION)
CATALOG_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $CATALOG_MANAGEMENT_IMAGE_VERSION)
PARTY_REGISTRY_PROXY_INTERFACE_VERSION=$(shortVersion $PARTY_REGISTRY_PROXY_IMAGE_VERSION)
PARTY_MOCK_REGISTRY_INTERFACE_VERSION=$(shortVersion $PARTY_MOCK_REGISTRY_IMAGE_VERSION)
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

. $(pwd)/kubernetes/configs/test/redis.sh

. $(pwd)/kubernetes/configs/test/agreement_management.sh
. $(pwd)/kubernetes/configs/test/agreement_process.sh
. $(pwd)/kubernetes/configs/test/api_gateway.sh
. $(pwd)/kubernetes/configs/test/authorization_management.sh
. $(pwd)/kubernetes/configs/test/authorization_process.sh
. $(pwd)/kubernetes/configs/test/authorization_server.sh
. $(pwd)/kubernetes/configs/test/attribute_registry_management.sh
. $(pwd)/kubernetes/configs/test/attributes_loader.sh
. $(pwd)/kubernetes/configs/test/backend_for_frontend.sh
. $(pwd)/kubernetes/configs/test/catalog_management.sh
. $(pwd)/kubernetes/configs/test/catalog_process.sh
. $(pwd)/kubernetes/configs/test/frontend.sh
. $(pwd)/kubernetes/configs/test/party_registry_proxy.sh
. $(pwd)/kubernetes/configs/test/party_mock_registry.sh
. $(pwd)/kubernetes/configs/test/purpose_management.sh
. $(pwd)/kubernetes/configs/test/purpose_process.sh
. $(pwd)/kubernetes/configs/test/tenant_management.sh
. $(pwd)/kubernetes/configs/test/tenant_process.sh
. $(pwd)/kubernetes/configs/test/tenants-certified-attributes-updater.sh
. $(pwd)/kubernetes/configs/test/notifier.sh
. $(pwd)/kubernetes/configs/test/token_details_persister.sh
