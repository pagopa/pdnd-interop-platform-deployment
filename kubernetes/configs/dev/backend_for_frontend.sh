#!/bin/bash

INTEROP_SESSION_TOKEN_DURATION_SECONDS=86400
INTEROP_SESSION_TOKEN_ISSUER="dev.interop.pagopa.it"

SELFCARE_AUDIENCE="selfcare.dev.interop.pagopa.it"
SELFCARE_WELL_KNOWN_URL="https://uat.selfcare.pagopa.it/.well-known/jwks.json"

BACKEND_FOR_FRONTEND_RESOURCE_CPU="500m"
BACKEND_FOR_FRONTEND_RESOURCE_MEM="2Gi"

CONSUMER_DOCS_CONTAINER="interop-application-documents-dev"
ESERVICE_DOCS_CONTAINER="interop-application-documents-dev"
ALLOW_LIST_CONTAINER="interop-allow-list-dev"
RISK_ANALYSIS_DOCS_CONTAINER="interop-application-documents-dev"

BFF_RATE_LIMITER_MAX_REQUESTS="10"
BFF_RATE_LIMITER_BURST_PERCENTAGE="1.0"
BFF_RATE_LIMITER_RATE_INTERVAL="1.second"
BFF_RATE_LIMITER_TIMEOUT="300.milliseconds"

SUPPORT_SAML_CALLBACK_URL="https://selfcare.dev.interop.pagopa.it/ui/it/assistenza/scelta-ente#id="
SUPPORT_SAML_CALLBACK_ERROR_URL="https://selfcare.dev.interop.pagopa.it/ui/it/assistenza/errore"