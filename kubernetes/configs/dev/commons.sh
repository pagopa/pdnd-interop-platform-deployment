#!/bin/bash

INTERNAL_INGRESS_HOST="gateway-private.dev.pdnd-interop.pagopa.it"
EXTERNAL_INGRESS_HOST="gateway-private.dev.pdnd-interop.pagopa.it"
INTERNAL_INGRESS_CLASS="nginx"
EXTERNAL_INGRESS_CLASS="nginx"

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="pdnd-interop-dev-rds.c9zr6t2swdpb.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
REPLICAS=1

AWS_REGION="eu-central-1"
PERSISTENCE_QUEUE_NAME="${NAMESPACE}-persistence-events.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URL="https://pdnd-interop-dev-public.s3.eu-central-1.amazonaws.com/.well-known/jwks.json"

UI_JWT_AUDIENCE="dev.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="dev.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="dev.interop.pagopa.it/internal"
EC_KEYS_IDENTIFIERS="ec-202205061026"
RSA_KEYS_IDENTIFIERS="rsa-202205061335"
VAULT_SIGNATURE_ROUTE="/v1/transit/sign/"