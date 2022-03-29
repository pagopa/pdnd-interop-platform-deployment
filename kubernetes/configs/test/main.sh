#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh
. $(pwd)/kubernetes/configs/versions.sh

. $(pwd)/kubernetes/configs/test/commons.sh


# Calculated
NAMESPACE=$NAMESPACE
INTERNAL_APPLICATION_HOST=$NAMESPACE.$INTERNAL_INGRESS_HOST
EXTERNAL_APPLICATION_HOST=$NAMESPACE.$EXTERNAL_INGRESS_HOST

AGREEMENT_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AGREEMENT_MANAGEMENT_IMAGE_VERSION)
ATTRIBUTE_REGISTRY_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $ATTRIBUTE_REGISTRY_MANAGEMENT_IMAGE_VERSION)
AUTHORIZATION_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AUTHORIZATION_MANAGEMENT_IMAGE_VERSION)
CATALOG_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $CATALOG_MANAGEMENT_IMAGE_VERSION)
PARTY_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $PARTY_MANAGEMENT_IMAGE_VERSION)
PARTY_REGISTRY_PROXY_INTERFACE_VERSION=$(shortVersion $PARTY_REGISTRY_PROXY_IMAGE_VERSION)
PARTY_MOCK_REGISTRY_INTERFACE_VERSION=$(shortVersion $PARTY_MOCK_REGISTRY_IMAGE_VERSION)
PURPOSE_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $PURPOSE_MANAGEMENT_IMAGE_VERSION)
USER_REGISTRY_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $USER_REGISTRY_MANAGEMENT_IMAGE_VERSION)

USER_REGISTRY_MANAGEMENT_URL="https://$INTERNAL_APPLICATION_HOST/$USER_REGISTRY_MANAGEMENT_SERVICE_NAME/$USER_REGISTRY_MANAGEMENT_INTERFACE_VERSION"

. $(pwd)/kubernetes/configs/test/spid.sh
. $(pwd)/kubernetes/configs/test/api_gateway.sh
. $(pwd)/kubernetes/configs/test/attributes_loader.sh
. $(pwd)/kubernetes/configs/test/catalog_management.sh
. $(pwd)/kubernetes/configs/test/catalog_process.sh
. $(pwd)/kubernetes/configs/test/party_management.sh
. $(pwd)/kubernetes/configs/test/party_process.sh
. $(pwd)/kubernetes/configs/test/party_registry_proxy.sh
. $(pwd)/kubernetes/configs/test/purpose_process.sh