#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh
. $(pwd)/kubernetes/configs/versions.sh

. $(pwd)/kubernetes/configs/dev/commons.sh

# Calculated
NAMESPACE=$NAMESPACE
EXTERNAL_APPLICATION_HOST=$DOMAIN_NAME

AGREEMENT_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AGREEMENT_MANAGEMENT_IMAGE_VERSION)
ATTRIBUTE_REGISTRY_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $ATTRIBUTE_REGISTRY_MANAGEMENT_IMAGE_VERSION)
AUTHORIZATION_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AUTHORIZATION_MANAGEMENT_IMAGE_VERSION)
CATALOG_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $CATALOG_MANAGEMENT_IMAGE_VERSION)
PARTY_REGISTRY_PROXY_INTERFACE_VERSION=$(shortVersion $PARTY_REGISTRY_PROXY_IMAGE_VERSION)
PARTY_MOCK_REGISTRY_INTERFACE_VERSION=$(shortVersion $PARTY_MOCK_REGISTRY_IMAGE_VERSION)
PURPOSE_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $PURPOSE_MANAGEMENT_IMAGE_VERSION)

API_GATEWAY_INTERFACE_VERSION=$(shortVersion $API_GATEWAY_IMAGE_VERSION)
AGREEMENT_PROCESS_INTERFACE_VERSION=$(shortVersion $AGREEMENT_PROCESS_IMAGE_VERSION)
AUTHORIZATION_PROCESS_INTERFACE_VERSION=$(shortVersion $AUTHORIZATION_PROCESS_IMAGE_VERSION)
CATALOG_PROCESS_INTERFACE_VERSION=$(shortVersion $CATALOG_PROCESS_IMAGE_VERSION)
PURPOSE_PROCESS_INTERFACE_VERSION=$(shortVersion $PURPOSE_PROCESS_IMAGE_VERSION)
NOTIFIER_INTERFACE_VERSION=$(shortVersion $NOTIFIER_IMAGE_VERSION)
BACKEND_FOR_FRONTEND_INTERFACE_VERSION=$(shortVersion $BACKEND_FOR_FRONTEND_IMAGE_VERSION)

. $(pwd)/kubernetes/configs/dev/agreement_management.sh
. $(pwd)/kubernetes/configs/dev/agreement_process.sh
. $(pwd)/kubernetes/configs/dev/api_gateway.sh
. $(pwd)/kubernetes/configs/dev/authorization_management.sh
. $(pwd)/kubernetes/configs/dev/authorization_process.sh
. $(pwd)/kubernetes/configs/dev/authorization_server.sh
. $(pwd)/kubernetes/configs/dev/attributes_loader.sh
. $(pwd)/kubernetes/configs/dev/backend_for_frontend.sh
. $(pwd)/kubernetes/configs/dev/catalog_management.sh
. $(pwd)/kubernetes/configs/dev/catalog_process.sh
. $(pwd)/kubernetes/configs/dev/frontend.sh
. $(pwd)/kubernetes/configs/dev/party_registry_proxy.sh
. $(pwd)/kubernetes/configs/dev/purpose_management.sh
. $(pwd)/kubernetes/configs/dev/purpose_process.sh
. $(pwd)/kubernetes/configs/dev/notifier.sh