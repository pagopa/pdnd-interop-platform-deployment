#!/bin/bash

INTEROP_SESSION_TOKEN_DURATION_SECONDS=3600
INTEROP_SESSION_TOKEN_ISSUER="att.interop.pagopa.it"

SELFCARE_AUDIENCE="selfcare.att.interop.pagopa.it"
SELFCARE_WELL_KNOWN_URL="https://selfcare.pagopa.it/.well-known/jwks.json"

BACKEND_FOR_FRONTEND_RESOURCE_CPU="500m"
BACKEND_FOR_FRONTEND_RESOURCE_MEM="2Gi"

CONSUMER_DOCS_CONTAINER="interop-application-documents-att-es1"
ESERVICE_DOCS_CONTAINER="interop-application-documents-att-es1"
ALLOW_LIST_CONTAINER="interop-allow-list-att-es1"
RISK_ANALYSIS_DOCS_CONTAINER="interop-application-documents-att-es1"

BFF_RATE_LIMITER_MAX_REQUESTS="10"
BFF_RATE_LIMITER_BURST_PERCENTAGE="1.0"
BFF_RATE_LIMITER_RATE_INTERVAL="1.second"
BFF_RATE_LIMITER_TIMEOUT="300.milliseconds"

SUPPORT_SAML_AUDIENCE="selfcare.att.interop.pagopa.it"
SUPPORT_SAML_CALLBACK_URL="https://selfcare.att.interop.pagopa.it/ui/it/assistenza/scelta-ente"
SUPPORT_SAML_CALLBACK_ERROR_URL="https://selfcare.att.interop.pagopa.it/ui/it/assistenza/errore"

IMPORT_ESERVICE_CONTAINER="interop-application-import-export-att-es1"
EXPORT_ESERVICE_CONTAINER="interop-application-import-export-att-es1"
PRESIGNED_URL_GET_DURATION_MINUTES=2
PRESIGNED_URL_PUT_DURATION_MINUTES=2