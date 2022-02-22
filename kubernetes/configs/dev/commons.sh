#!/bin/bash

INTERNAL_INGRESS_HOST="gateway-private.dev.pdnd-interop.pagopa.it"
EXTERNAL_INGRESS_HOST="gateway-private.dev.pdnd-interop.pagopa.it"
INTERNAL_INGRESS_CLASS="nginx"
EXTERNAL_INGRESS_CLASS="nginx"

REPOSITORY="505630707203.dkr.ecr.eu-central-1.amazonaws.com"
POSTGRES_HOST="pdnd-interop-dev-rds.c9zr6t2swdpb.eu-central-1.rds.amazonaws.com"
POSTGRES_PORT="5432"
REPLICAS=1
WELL_KNOWN_URL="https://pdnd-interop-dev-public.s3.eu-central-1.amazonaws.com/.well-known/jwks.json"
