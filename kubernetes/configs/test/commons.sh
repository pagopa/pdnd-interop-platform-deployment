#!/bin/bash

INTERNAL_INGRESS_HOST="gateway-private.test.pdnd-interop.pagopa.it"
INTERNAL_INGRESS_CLASS="nginx-internal"
EXTERNAL_INGRESS_HOST="gateway.test.pdnd-interop.pagopa.it"
EXTERNAL_INGRESS_CLASS="nginx"
# EXTERNAL_INGRESS_HOST="gateway-private.test.pdnd-interop.pagopa.it"
# EXTERNAL_INGRESS_CLASS="nginx-internal"
### End TODO

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="pdnd-interop-aurora-auroradbcluster-9wzdmx7vohc9.cluster-ciwztfqful5r.eu-south-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
REPLICAS=1

AWS_REGION="eu-central-1"
PERSISTENCE_QUEUE_NAME="${NAMESPACE}-persistence-events.fifo"
AWS_SQS_DOMAIN="https://sqs.${AWS_REGION}.amazonaws.com"

ENABLED_PROJECTIONS="true"
WELL_KNOWN_URLS="https://pdnd-interop-test-public.s3.eu-central-1.amazonaws.com/.well-known/jwks.json"

UI_JWT_AUDIENCE="test.interop.pagopa.it/ui"
M2M_JWT_AUDIENCE="test.interop.pagopa.it/m2m"
INTERNAL_JWT_AUDIENCE="test.interop.pagopa.it/internal"
EC_KEYS_IDENTIFIERS="interop-ecdsa-p256-01"
RSA_KEYS_IDENTIFIERS="interop-rsa4096-01"
VAULT_SIGNATURE_ROUTE="/v1/transit/sign/"

PARTY_PROCESS_URL="https://api.uat.selfcare.pagopa.it/external/party-process/v1"
PARTY_MANAGEMENT_URL="https://api.uat.selfcare.pagopa.it/external/party-management/v1"
USER_REGISTRY_URL="https://api.uat.pdv.pagopa.it/user-registry/v1"

INTERNAL_JWT_ISSUER="test.interop.pagopa.it"
INTERNAL_JWT_SUBJECT="test.interop-m2m"
INTERNAL_JWT_DURATION_SECONDS=3600