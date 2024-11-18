#!/bin/bash

SELFCARE_LOGIN_URL="https://uat.selfcare.pagopa.it/auth/login"
FRONTEND_SERVICE_PORT="80"
PUBLIC_BUCKET_URL="https://interop-${ENVIRONMENT}-public${REGION_SUFFIX}.s3.${AWS_REGION}.amazonaws.com"
MIXPANEL_PROJECT_ID="b6c8c3c3ed0b32d66c61593bcb84e705"
ONETRUST_DOMAIN_SCRIPT_ID="018ef6c1-31f6-70a6-bf72-d7d45c0ade7e"
SELFCARE_BASE_URL="https://uat.selfcare.pagopa.it"
API_SIGNAL_HUB_PUSH_INTEFACE_URL="https://github.com/pagopa/interop-signalhub-core/blob/main/docs/openAPI/push-signals_1.0.0.yaml"
API_SIGNAL_HUB_PULL_INTEFACE_URL="https://github.com/pagopa/interop-signalhub-core/blob/main/docs/openAPI/pull-signals_1.0.0.yaml"

FRONTEND_RESOURCE_CPU="250m"
FRONTEND_RESOURCE_MEM="1Gi"
