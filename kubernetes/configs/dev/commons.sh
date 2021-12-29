#!/bin/bash

INTERNAL_INGRESS_HOST="gateway.interop.pdnd.dev"
EXTERNAL_INGRESS_HOST="gateway.interop.pdnd.dev"
INTERNAL_INGRESS_CLASS="nginx"
EXTERNAL_INGRESS_CLASS="nginx"

REPOSITORY="gateway.interop.pdnd.dev"
POSTGRES_HOST="pdnd-interop-dev-rds.c9zr6t2swdpb.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
REPLICAS=1
WELL_KNOWN_URL="https://pdnd-interop-dev-public.s3.eu-central-1.amazonaws.com/.well-known/jwks.json"

AGREEMENT_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-agreement-management"
AGREEMENT_PROCESS_SERVICE_NAME="pdnd-interop-uservice-agreement-process"
ATTRIBUTE_REGISTRY_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-attribute-registry-management"
AUTHORIZATION_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-key-management"
AUTHORIZATION_PROCESS_SERVICE_NAME="pdnd-interop-uservice-key-process"
CATALOG_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-catalog-management"
PARTY_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-party-management"
PARTY_MOCK_REGISTRY_SERVICE_NAME="pdnd-interop-uservice-party-mock-registry"
PARTY_REGISTRY_PROXY_SERVICE_NAME="pdnd-interop-uservice-party-registry-proxy"
CATALOG_PROCESS_SERVICE_NAME="pdnd-interop-uservice-catalog-process"
USER_REGISTRY_MANAGEMENT_SERVICE_NAME="pdnd-interop-uservice-user-registry-management"

FRONTEND_SERVICE_NAME="pdnd-interop-frontend"
