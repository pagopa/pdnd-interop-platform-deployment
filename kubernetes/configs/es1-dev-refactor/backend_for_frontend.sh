#!/bin/bash

INTEROP_SESSION_TOKEN_DURATION_SECONDS=86400
INTEROP_SESSION_TOKEN_ISSUER="refactor.dev.interop.pagopa.it"

SELFCARE_AUDIENCE="selfcare.refactor.dev.interop.pagopa.it"
SELFCARE_WELL_KNOWN_URL="https://uat.selfcare.pagopa.it/.well-known/jwks.json"

BACKEND_FOR_FRONTEND_RESOURCE_CPU="500m"
BACKEND_FOR_FRONTEND_RESOURCE_MEM="2Gi"

CONSUMER_DOCS_CONTAINER="interop-application-documents-refactor-dev-es1"
ESERVICE_DOCS_CONTAINER="interop-application-documents-refactor-dev-es1"
ESERVICE_DOCUMENTS_PATH="eservices/docs"
ALLOW_LIST_CONTAINER="interop-allow-list-dev-es1"
RISK_ANALYSIS_DOCS_CONTAINER="interop-application-documents-refactor-dev-es1"

BFF_RATE_LIMITER_MAX_REQUESTS="9999999"
BFF_RATE_LIMITER_BURST_PERCENTAGE="1.0"
BFF_RATE_LIMITER_RATE_INTERVAL=1000
BFF_RATE_LIMITER_TIMEOUT=300

SUPPORT_SAML_AUDIENCE="selfcare.refactor.dev.interop.pagopa.it"
SUPPORT_SAML_CALLBACK_URL="https://selfcare.refactor.dev.interop.pagopa.it/ui/it/assistenza/scelta-ente"
SUPPORT_SAML_CALLBACK_ERROR_URL="https://selfcare.refactor.dev.interop.pagopa.it/ui/it/assistenza/errore"

IMPORT_ESERVICE_CONTAINER="interop-application-import-export-dev-es1"
EXPORT_ESERVICE_CONTAINER="interop-application-import-export-dev-es1"
PRESIGNED_URL_GET_DURATION_MINUTES=2
PRESIGNED_URL_PUT_DURATION_MINUTES=2

PRIVACY_NOTICES_PATH="consent"
PRIVACY_NOTICES_FILE_NAME="pp.json"
