#!/bin/bash

INTEROP_JWT_DURATION_SECONDS=99999999
INTEROP_JWT_ISSUER="dev.interop.pagopa.it"

CLIENT_ASSERTION_JWT_AUDIENCE="interop.dev.selfcare.pagopa.it/client-assertion"

AUTHORIZATION_SERVER_RESOURCE_CPU="500m"
AUTHORIZATION_SERVER_RESOURCE_MEM="2Gi"

AUTH_SERVER_RATE_LIMITER_MAX_REQUESTS="10"
AUTH_SERVER_RATE_LIMITER_BURST_PERCENTAGE="1.0"
AUTH_SERVER_RATE_LIMITER_RATE_INTERVAL="1.second"
AUTH_SERVER_RATE_LIMITER_TIMEOUT="300.milliseconds"
