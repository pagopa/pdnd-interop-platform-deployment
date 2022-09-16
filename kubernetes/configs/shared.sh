#!/bin/bash

# Functions
# TODO Take version from image label
shortVersion() {
  echo $1 | grep  -oE '^[0-9]+\.[0-9]+\.[0-9]+$' | grep -oE '[0-9]+\.[0-9]+' || echo "0.0"
}

AGREEMENT_MANAGEMENT_SERVICE_NAME="interop-be-agreement-management"
AGREEMENT_PROCESS_SERVICE_NAME="interop-be-agreement-process"
ATTRIBUTE_REGISTRY_MANAGEMENT_SERVICE_NAME="interop-be-attribute-registry-management"
AUTHORIZATION_MANAGEMENT_SERVICE_NAME="interop-be-authorization-management"
AUTHORIZATION_PROCESS_SERVICE_NAME="interop-be-authorization-process"
AUTHORIZATION_SERVER_SERVICE_NAME="interop-be-authorization-server"
CATALOG_MANAGEMENT_SERVICE_NAME="interop-be-catalog-management"
PARTY_MOCK_REGISTRY_SERVICE_NAME="interop-be-party-mock-registry"
PARTY_REGISTRY_PROXY_SERVICE_NAME="interop-be-party-registry-proxy"
CATALOG_PROCESS_SERVICE_NAME="interop-be-catalog-process"
PURPOSE_MANAGEMENT_SERVICE_NAME="interop-be-purpose-management"
PURPOSE_PROCESS_SERVICE_NAME="interop-be-purpose-process"
API_GATEWAY_SERVICE_NAME="interop-be-api-gateway"
BACKEND_FOR_FRONTEND_SERVICE_NAME="interop-be-backend-for-frontend"
NOTIFIER_SERVICE_NAME="interop-be-notifier"
TENANT_MANAGEMENT_SERVICE_NAME="interop-be-tenant-management"
TENANT_PROCESS_SERVICE_NAME="interop-be-tenant-process"

FRONTEND_SERVICE_NAME="interop-frontend"

JOB_ATTRIBUTES_LOADER_SERVICE_NAME="interop-be-attributes-loader"
JOB_DETAILS_PERSISTER_SERVICE_NAME="interop-be-token-details-persister"
JOB_TENANTS_CERTIFIED_ATTRIBUTES_UPDATER_SERVICE_NAME="interop-be-tenants-cert-attr-updater"

AGREEMENT_MANAGEMENT_APPLICATION_PATH="agreement-management"
AGREEMENT_PROCESS_APPLICATION_PATH="agreement-process"
ATTRIBUTE_REGISTRY_MANAGEMENT_APPLICATION_PATH="attribute-registry-management"
AUTHORIZATION_MANAGEMENT_APPLICATION_PATH="authorization-management"
AUTHORIZATION_PROCESS_APPLICATION_PATH="authorization-process"
AUTHORIZATION_SERVER_APPLICATION_PATH="authorization-server"
CATALOG_MANAGEMENT_APPLICATION_PATH="catalog-management"
PARTY_MOCK_REGISTRY_APPLICATION_PATH="party-mock-registry"
PARTY_REGISTRY_PROXY_APPLICATION_PATH="party-registry-proxy"
CATALOG_PROCESS_APPLICATION_PATH="catalog-process"
PURPOSE_MANAGEMENT_APPLICATION_PATH="purpose-management"
PURPOSE_PROCESS_APPLICATION_PATH="purpose-process"
TENANT_MANAGEMENT_APPLICATION_PATH="tenant-management"
TENANT_PROCESS_APPLICATION_PATH="tenant-process"

API_GATEWAY_APPLICATION_PATH="api-gateway"
BACKEND_FOR_FRONTEND_APPLICATION_PATH="backend-for-frontend"
NOTIFIER_APPLICATION_PATH="notifier"
FRONTEND_SERVICE_APPLICATION_PATH="ui"

