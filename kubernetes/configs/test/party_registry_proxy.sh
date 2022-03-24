#!/bin/bash

PARTY_REGISTRY_CATEGORIES_URL="https://indicepa.gov.it/ipa-dati/datastore/dump/84ebb2e7-0e61-427b-a1dd-ab8bb2a84f07?format=json"
PARTY_REGISTRY_INSTITUTIONS_URL="https://indicepa.gov.it/ipa-dati/datastore/dump/d09adf99-dc10-4349-8c53-27b1e5aa97b6?format=json"
MOCK_ORIGIN="INTEROP"
PARTY_MOCK_REGISTRY_INSTITUTIONS_URL="http://{{PARTY_MOCK_REGISTRY_SERVICE_NAME}}:8088/{{PARTY_MOCK_REGISTRY_APPLICATION_PATH}}/{{PARTY_MOCK_REGISTRY_INTERFACE_VERSION}}/opendata/parties"
PARTY_MOCK_REGISTRY_CATEGORIES_URL="http://{{PARTY_MOCK_REGISTRY_SERVICE_NAME}}:8088/{{PARTY_MOCK_REGISTRY_APPLICATION_PATH}}/{{PARTY_MOCK_REGISTRY_INTERFACE_VERSION}}/opendata/categories"