#!/bin/bash

IPA_CATEGORIES_URL="https://indicepa.gov.it/ipa-dati/datastore/dump/84ebb2e7-0e61-427b-a1dd-ab8bb2a84f07?format=json"
IPA_INSTITUTIONS_URL="https://indicepa.gov.it/ipa-dati/datastore/dump/d09adf99-dc10-4349-8c53-27b1e5aa97b6?format=json"
IPA_AOO_URL="https://indicepa.gov.it/ipa-dati/datastore/dump/cdaded04-f84e-4193-a720-47d6d5f422aa?format=json"
IPA_UO_URL="https://indicepa.gov.it/ipa-dati/datastore/dump/b0aa1f6c-f135-4c8a-b416-396fed4e1a5d?format=json"

IPA_CERTIFIED_ATTRIBUTES_IMPORTER_ATTRIBUTE_CREATION_WAIT_MS="5000"
IPA_CERTIFIED_ATTRIBUTES_IMPORTER_JWT_DURATION_SECONDS="1800"

JOB_IPA_CERTIFIED_ATTRIBUTES_IMPORTER_RESOURCE_CPU="1"
JOB_IPA_CERTIFIED_ATTRIBUTES_IMPORTER_RESOURCE_MEM="4Gi"

ECONOMIC_ACCOUNT_COMPANIES_ALLOWLIST=""