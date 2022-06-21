#!/bin/bash

DOMAIN_NAME="interop.selfcare.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="interop-rds-prod-auroradbcluster-n6mrmtikvktv.cluster-clwq8rah1dfz.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
REPLICAS=2
BACKEND_SERVICE_PORT="8088"

AWS_REGION="eu-central-1"
PERSISTENCE_QUEUE_NAME="persistence-events.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://interop.selfcare.pagopa.it/.well-known/jwks.json"

INTERNAL_JWT_ISSUER="prod.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="prod.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

UI_JWT_AUDIENCE="prod.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="prod.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="prod.interop.pagopa.it/internal"
RSA_KEYS_IDENTIFIERS="199d08d2-9971-4979-a78d-e6f7a544f296"
VAULT_SIGNATURE_ROUTE="/v1/transit/sign/"