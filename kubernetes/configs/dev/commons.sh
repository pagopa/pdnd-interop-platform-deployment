#!/bin/bash

DOMAIN_NAME="interop.dev.selfcare.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="interop-rds-dev-auroradbcluster-1ws49gkll6459.cluster-c9zr6t2swdpb.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
REPLICAS=1
BACKEND_SERVICE_PORT="8088"

AWS_REGION="eu-central-1"
PERSISTENCE_QUEUE_NAME="${NAMESPACE}-persistence-events.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://interop.dev.selfcare.pagopa.it/.well-known/jwks.json"

INTERNAL_JWT_ISSUER="dev.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="dev.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

UI_JWT_AUDIENCE="dev.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="dev.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="dev.interop.pagopa.it/internal"
RSA_KEYS_IDENTIFIERS="interop-rsa2048-dev"
VAULT_SIGNATURE_ROUTE="/v1/transit/sign/"

PARTY_PROCESS_URL="https://api.dev.selfcare.pagopa.it/external/party-process/v1"
PARTY_MANAGEMENT_URL="https://api.dev.selfcare.pagopa.it/external/party-management/v1"
USER_REGISTRY_URL="https://api.uat.pdv.pagopa.it/user-registry/v1"
