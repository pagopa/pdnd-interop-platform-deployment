#!/bin/bash

INTERNAL_INGRESS_HOST="gateway-private.test.pdnd-interop.pagopa.it"
INTERNAL_INGRESS_CLASS="nginx-internal"
# TODO Enable this when ready
# EXTERNAL_INGRESS_HOST="gateway.test.pdnd-interop.pagopa.it"
# EXTERNAL_INGRESS_CLASS="nginx"
EXTERNAL_INGRESS_HOST="gateway-private.test.pdnd-interop.pagopa.it"
EXTERNAL_INGRESS_CLASS="nginx-internal"
### End TODO

REPOSITORY="gateway-private.test.pdnd-interop.pagopa.it"
POSTGRES_HOST="pdnd-interop-test-rds.cfx5ud7lsyvt.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
REPLICAS=1
WELL_KNOWN_URL="https://pdnd-interop-test-public.s3.eu-central-1.amazonaws.com/.well-known/jwks.json"

AGREEMENT_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-agreement-management"
AGREEMENT_PROCESS_SERVICE_NAME="pdnd-interop-uservice-agreement-process"
ATTRIBUTE_REGISTRY_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-attribute-registry-management"
AUTHORIZATION_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-key-management"
AUTHORIZATION_PROCESS_SERVICE_NAME="pdnd-interop-uservice-authorization-process"
CATALOG_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-catalog-management"
PARTY_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-party-management"
PARTY_MOCK_REGISTRY_SERVICE_NAME="pdnd-interop-uservice-party-mock-registry"
PARTY_PROCESS_SERVICE_NAME="pdnd-interop-uservice-party-process"
PARTY_REGISTRY_PROXY_SERVICE_NAME="pdnd-interop-uservice-party-registry-proxy"
CATALOG_PROCESS_SERVICE_NAME="pdnd-interop-uservice-catalog-process"
USER_REGISTRY_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-user-registry-management"

FRONTEND_SERVICE_NAME="pdnd-interop-frontend"
