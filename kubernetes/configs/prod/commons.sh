#!/bin/bash

DOMAIN_NAME="interop.selfcare.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="interop-rds-prod-auroradbcluster-n6mrmtikvktv.cluster-clwq8rah1dfz.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
CQRS_PROJECTION_DB_HOST="read-model.cluster-clwq8rah1dfz.eu-central-1.docdb.amazonaws.com"
CQRS_PROJECTION_DB_PORT="27017"
CQRS_PROJECTION_DB_NAME="read-model"
REPLICAS=2
BACKEND_SERVICE_PORT="8088"

AWS_REGION="eu-central-1"
PERSISTENCE_QUEUE_NAME="persistence-events.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://interop.selfcare.pagopa.it/.well-known/jwks.json"

INTERNAL_JWT_ISSUER="interop.selfcare.pagopa.it"
INTERNAL_JWT_SUBJECT="interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

UI_JWT_AUDIENCE="interop.selfcare.pagopa.it/ui"
M2M_JWT_AUDIENCE="interop.selfcare.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="interop.selfcare.pagopa.it/internal"
RSA_KEYS_IDENTIFIERS="199d08d2-9971-4979-a78d-e6f7a544f296"
VAULT_SIGNATURE_ROUTE="/v1/transit/sign/"

PARTY_PROCESS_URL="https://api.selfcare.pagopa.it/external/party-process/v1"
PARTY_MANAGEMENT_URL="https://api.selfcare.pagopa.it/external/party-management/v1"
USER_REGISTRY_URL="https://api.pdv.pagopa.it/user-registry/v1"