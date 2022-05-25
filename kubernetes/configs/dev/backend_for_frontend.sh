#!/bin/bash

INTEROP_SESSION_TOKEN_DURATION_SECONDS=99999999
INTEROP_SESSION_TOKEN_ISSUER="dev.interop.pagopa.it"

INTERNAL_JWT_ISSUER="dev.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="dev.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

PARTY_PROCESS_URL: "https://api.dev.selfcare.pagopa.it/external/party-process/v1"
USER_REGISTRY_URL: "https://api.uat.pdv.pagopa.it/user-registry/v1"