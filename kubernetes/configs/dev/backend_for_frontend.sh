#!/bin/bash

INTEROP_SESSION_TOKEN_DURATION_SECONDS=99999999
INTEROP_SESSION_TOKEN_ISSUER="dev.interop.pagopa.it"

SELFCARE_AUDIENCE="fe-test.gateway-private.test.pdnd-interop.pagopa.it"
SELFCARE_WELL_KNOWN_URL="https://uat.selfcare.pagopa.it/.well-known/jwks.json"

INTERNAL_JWT_ISSUER="dev.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="dev.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600
