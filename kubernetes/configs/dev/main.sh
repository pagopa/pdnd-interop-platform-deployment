#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh

. $(pwd)/kubernetes/configs/dev/versions.sh
. $(pwd)/kubernetes/configs/dev/commons.sh
. $(pwd)/kubernetes/configs/dev/spid.sh
. $(pwd)/kubernetes/configs/dev/party_management.sh
. $(pwd)/kubernetes/configs/dev/catalog_process.sh

# Calculated
NAMESPACE=$NAMESPACE
INTERNAL_APPLICATION_HOST=$NAMESPACE.$INTERNAL_INGRESS_HOST
EXTERNAL_APPLICATION_HOST=$NAMESPACE.$EXTERNAL_INGRESS_HOST

USER_REGISTRY_MANAGEMENT_URL="$USER_REGISTRY_MANAGEMENT_SERVICE_NAME/$USER_REGISTRY_MANAGEMENT_INTERFACE_VERSION"

AGREEMENT_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AGREEMENT_MANAGEMENT_IMAGE_VERSION)
ATTRIBUTE_REGISTRY_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $ATTRIBUTE_REGISTRY_MANAGEMENT_IMAGE_VERSION)
CATALOG_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $CATALOG_MANAGEMENT_IMAGE_VERSION)
PARTY_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $PARTY_MANAGEMENT_IMAGE_VERSION)
USER_REGISTRY_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $USER_REGISTRY_MANAGEMENT_IMAGE_VERSION)
