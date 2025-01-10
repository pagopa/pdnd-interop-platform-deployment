#!/bin/bash

SELFCARE_LOGIN_URL="https://selfcare.pagopa.it/auth/login"
FRONTEND_SERVICE_PORT="80"
PUBLIC_BUCKET_URL="https://interop-${ENVIRONMENT}-public${REGION_SUFFIX}.s3.${AWS_REGION}.amazonaws.com"
MIXPANEL_PROJECT_ID="fill_me"
ONETRUST_DOMAIN_SCRIPT_ID="fill_me"
SELFCARE_BASE_URL="https://selfcare.pagopa.it"
API_SIGNAL_HUB_PUSH_INTERFACE_URL="https://raw.githubusercontent.com/pagopa/interop-signalhub-core/refs/heads/main/docs/openAPI/push-signals.yaml"
API_SIGNAL_HUB_PULL_INTERFACE_URL="https://raw.githubusercontent.com/pagopa/interop-signalhub-core/refs/heads/main/docs/openAPI/pull-signals.yaml"

FRONTEND_RESOURCE_CPU="250m"
FRONTEND_RESOURCE_MEM="1Gi"
