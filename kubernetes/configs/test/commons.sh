#!/bin/bash

INTERNAL_INGRESS_HOST="gateway-private.test.pdnd-interop.pagopa.it"
INTERNAL_INGRESS_CLASS="nginx-internal"
EXTERNAL_INGRESS_HOST="gateway.test.pdnd-interop.pagopa.it"
EXTERNAL_INGRESS_CLASS="nginx"
# EXTERNAL_INGRESS_HOST="gateway-private.test.pdnd-interop.pagopa.it"
# EXTERNAL_INGRESS_CLASS="nginx-internal"
### End TODO

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="pdnd-interop-test-rds.cfx5ud7lsyvt.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
REPLICAS=1
PERSISTENCE_EVENTS_QUEUE_URL="https://sqs.us-east-1.amazonaws.com/895646477129/persistence-events.fifo"
AWS_REGION="eu-central-1"

MAIN_AUDIENCE="test.interop.pagopa.it"
ENABLED_PROJECTIONS="true"
WELL_KNOWN_URL="https://pdnd-interop-test-public.s3.eu-central-1.amazonaws.com/.well-known/jwks.json"
