#!/bin/bash

# Functions
# TODO Take version from image label
shortVersion() {
  echo $1 | grep -oE '[0-9]+\.[0-9]+'
}

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
