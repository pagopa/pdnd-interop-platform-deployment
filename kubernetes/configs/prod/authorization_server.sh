#!/bin/bash

INTEROP_JWT_DURATION_SECONDS=600
INTEROP_JWT_ISSUER="interop.selfcare.pagopa.it"

CLIENT_ASSERTION_JWT_AUDIENCE="interop.selfcare.pagopa.it/client-assertion"

AUTHORIZATION_SERVER_RESOURCE_CPU="4"
AUTHORIZATION_SERVER_RESOURCE_MEM="8Gi"

AUTH_SERVER_LIMITER_MAX_REQUESTS="30"
AUTH_SERVER_LIMITER_BURST_PERCENTAGE="1.2"
AUTH_SERVER_LIMITER_RATE_INTERVAL="1.second"
AUTH_SERVER_LIMITER_REDIS_HOST="{{REDIS_HOST}}"
AUTH_SERVER_LIMITER_REDIS_PORT"{{REDIS_PORT}}"
AUTH_SERVER_LIMITER_TIMEOUT="200.milliseconds"
