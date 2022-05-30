#!/bin/bash

DOMAIN_NAME="gateway.test.pdnd-interop.pagopa.it"

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="interop-rds-prod-auroradbcluster-n6mrmtikvktv.cluster-clwq8rah1dfz.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
REPLICAS=2

AWS_REGION="eu-central-1"
PERSISTENCE_QUEUE_NAME="persistence-events.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

ENABLED_PROJECTIONS="true"
# TODO Update this when ready
WELL_KNOWN_URLS="https://pdnd-interop-test-public.s3.eu-central-1.amazonaws.com/.well-known/jwks.json"

INTERNAL_JWT_ISSUER="prod.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="prod.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600

UI_JWT_AUDIENCE="prod.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="prod.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="prod.interop.pagopa.it/internal"
EC_KEYS_IDENTIFIERS="interop-ecdsa-p256-01"
RSA_KEYS_IDENTIFIERS="interop-rsa4096-01"
VAULT_SIGNATURE_ROUTE="/v1/transit/sign/"