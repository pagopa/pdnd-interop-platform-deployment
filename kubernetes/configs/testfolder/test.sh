#!/bin/bash

. $(pwd)/kubernetes/configs/testfolder/versions.sh

# Functions
# TODO Take version from image label
shortVersion() {
  echo $1 | grep -oE '[0-9]+\.[0-9]+'
}

# Common
NAMESPACE=$NAMESPACE
INTERNAL_INGRESS_HOST="gateway-private.test.pdnd-interop.pagopa.it"
INTERNAL_INGRESS_CLASS="nginx-internal"
INTERNAL_APPLICATION_HOST=$NAMESPACE.$INTERNAL_INGRESS_HOST

# TODO Enable this when ready
# EXTERNAL_INGRESS_HOST="gateway.test.pdnd-interop.pagopa.it"
# EXTERNAL_INGRESS_CLASS="nginx"
# EXTERNAL_APPLICATION_HOST=$NAMESPACE.$EXTERNAL_INGRESS_HOST
EXTERNAL_INGRESS_HOST="gateway-private.test.pdnd-interop.pagopa.it"
EXTERNAL_INGRESS_CLASS="nginx-internal"
EXTERNAL_APPLICATION_HOST=$NAMESPACE.$INTERNAL_INGRESS_HOST
### End TODO

REPOSITORY="gateway-private.test.pdnd-interop.pagopa.it"
POSTGRES_HOST="pdnd-interop-test-rds.cfx5ud7lsyvt.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
REPLICAS=1
WELL_KNOWN_URL="https://pdnd-interop-test-public.s3.eu-central-1.amazonaws.com/.well-known/jwks.json"

AGREEMENT_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $AGREEMENT_MANAGEMENT_IMAGE_VERSION)
ATTRIBUTE_REGISTRY_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $ATTRIBUTE_REGISTRY_MANAGEMENT_IMAGE_VERSION)
CATALOG_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $CATALOG_MANAGEMENT_IMAGE_VERSION)
PARTY_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $PARTY_MANAGEMENT_IMAGE_VERSION)
USER_REGISTRY_MANAGEMENT_INTERFACE_VERSION=$(shortVersion $USER_REGISTRY_MANAGEMENT_IMAGE_VERSION)

AGREEMENT_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-agreement-management"
ATTRIBUTE_REGISTRY_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-attribute-registry-management"
CATALOG_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-catalog-management"
PARTY_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-party-management"
CATALOG_PROCESS_SERVICE_NAME="pdnd-interop-uservice-catalog-process"
USER_REGISTRY_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-user-registry-management"

FRONTEND_SERVICE_NAME="pdnd-interop-frontend"

# Party Management
PARTY_MANAGEMENT_STORAGE_TYPE="S3"
PARTY_MANAGEMENT_STORAGE_CONTAINER="interop-pdnd-test-support"
PARTY_MANAGEMENT_STORAGE_ENDPOINT=""

# Catalog Process
CATALOG_PROCESS_STORAGE_TYPE="S3"
CATALOG_PROCESS_STORAGE_CONTAINER="interop-pdnd-test-support"
CATALOG_PROCESS_STORAGE_ENDPOINT=""


USER_REGISTRY_MANAGEMENT_URL="https://$INTERNAL_APPLICATION_HOST/$USER_REGISTRY_MANAGEMENT_SERVICE_NAME/$USER_REGISTRY_MANAGEMENT_INTERFACE_VERSION"

# SPID
IDP_SERVICE_URL=$NAMESPACE-idp.$EXTERNAL_INGRESS_HOST
SPID_LOGIN_SERVICE_NAME="hub-spid-login-ms"
REDIS_SERVICE_NAME="redis"
