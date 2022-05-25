#!/bin/bash

INTEROP_SESSION_TOKEN_DURATION_SECONDS=600
INTEROP_SESSION_TOKEN_ISSUER="test.interop.pagopa.it"

INTERNAL_JWT_ISSUER="test.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="test.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

PARTY_PROCESS_URL: "https://api.uat.selfcare.pagopa.it/external/party-process/v1"
USER_REGISTRY_URL: "https://api.uat.pdv.pagopa.it/user-registry/v1"