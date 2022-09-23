#!/bin/bash

INTEROP_SESSION_TOKEN_DURATION_SECONDS=86400
INTEROP_SESSION_TOKEN_ISSUER="dev.interop.pagopa.it"

SELFCARE_AUDIENCE="api.interop.selfcare.pagopa.it"
SELFCARE_WELL_KNOWN_URL="https://dev.selfcare.pagopa.it/.well-known/jwks.json"

BACKEND_FOR_FRONTEND_RESOURCE_CPU="500m"
BACKEND_FOR_FRONTEND_RESOURCE_MEM="2Gi"

BFF_RATE_LIMITER_MAX_REQUESTS="10"
BFF_RATE_LIMITER_BURST_PERCENTAGE="1.0"
BFF_RATE_LIMITER_RATE_INTERVAL="1.second"
BFF_RATE_LIMITER_REDIS_HOST="{{REDIS_HOST}}"
BFF_RATE_LIMITER_REDIS_PORT"{{REDIS_PORT}}"
BFF_RATE_LIMITER_TIMEOUT="300.milliseconds"
