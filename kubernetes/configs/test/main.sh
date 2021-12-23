#!/bin/bash

. $(pwd)/kubernetes/configs/shared.sh

. $(pwd)/kubernetes/configs/test/versions.sh
. $(pwd)/kubernetes/configs/test/commons.sh
. $(pwd)/kubernetes/configs/test/spid.sh
. $(pwd)/kubernetes/configs/test/party_management.sh
. $(pwd)/kubernetes/configs/test/catalog_process.sh

# Calculated
NAMESPACE=$NAMESPACE
INTERNAL_APPLICATION_HOST=$NAMESPACE.$INTERNAL_INGRESS_HOST
EXTERNAL_APPLICATION_HOST=$NAMESPACE.$EXTERNAL_INGRESS_HOST

USER_REGISTRY_MANAGEMENT_URL="https://$INTERNAL_APPLICATION_HOST/$USER_REGISTRY_MANAGEMENT_SERVICE_NAME/$USER_REGISTRY_MANAGEMENT_INTERFACE_VERSION"
