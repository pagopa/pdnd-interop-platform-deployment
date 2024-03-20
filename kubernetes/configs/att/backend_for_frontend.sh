#!/bin/bash

INTEROP_SESSION_TOKEN_DURATION_SECONDS=86400
INTEROP_SESSION_TOKEN_ISSUER="att.interop.pagopa.it"

SELFCARE_AUDIENCE="selfcare.att.interop.pagopa.it"
SELFCARE_WELL_KNOWN_URL="https://selfcare.pagopa.it/.well-known/jwks.json"

BACKEND_FOR_FRONTEND_RESOURCE_CPU="500m"
BACKEND_FOR_FRONTEND_RESOURCE_MEM="2Gi"

CONSUMER_DOCS_CONTAINER="interop-application-documents-att"
ESERVICE_DOCS_CONTAINER="interop-application-documents-att"
ALLOW_LIST_CONTAINER="interop-allow-list-att"
RISK_ANALYSIS_DOCS_CONTAINER="interop-application-documents-att"

BFF_RATE_LIMITER_MAX_REQUESTS="9999999"
BFF_RATE_LIMITER_BURST_PERCENTAGE="1.0"
BFF_RATE_LIMITER_RATE_INTERVAL="1.second"
BFF_RATE_LIMITER_TIMEOUT="300.milliseconds"

SUPPORT_SAML_AUDIENCE="selfcare.att.interop.pagopa.it"
SUPPORT_SAML_CALLBACK_URL="https://selfcare.att.interop.pagopa.it/ui/it/assistenza/scelta-ente"
SUPPORT_SAML_CALLBACK_ERROR_URL="https://selfcare.att.interop.pagopa.it/ui/it/assistenza/errore"
