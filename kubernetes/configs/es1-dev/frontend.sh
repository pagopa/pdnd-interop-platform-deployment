#!/bin/bash

SELFCARE_LOGIN_URL="https://uat.selfcare.pagopa.it/auth/login"
FRONTEND_SERVICE_PORT="80"
PUBLIC_BUCKET_URL="https://interop-${ENVIRONMENT}-public${REGION_SUFFIX}.s3.${AWS_REGION}.amazonaws.com"
MIXPANEL_PROJECT_ID="b6c8c3c3ed0b32d66c61593bcb84e705"
ONETRUST_DOMAIN_SCRIPT_ID="018ef6c1-31f6-70a6-bf72-d7d45c0ade7e"
SELFCARE_BASE_URL="https://uat.selfcare.pagopa.it"
API_SIGNAL_HUB_PUSH_INTERFACE_URL="https://raw.githubusercontent.com/pagopa/interop-signalhub-core/refs/heads/develop/docs/openAPI/push-signals.yaml"
API_SIGNAL_HUB_PULL_INTERFACE_URL="https://raw.githubusercontent.com/pagopa/interop-signalhub-core/refs/heads/develop/docs/openAPI/pull-signals.yaml"

FEATURE_FLAG_SIGNALHUB_WHITELIST=true
SIGNALHUB_WHITELIST_PRODUCER=69e2865e-65ab-4e48-a638-2037a9ee2ee7  # PagoPA
SIGNALHUB_WHITELIST_CONSUMER="69e2865e-65ab-4e48-a638-2037a9ee2ee7,e79a24cd-8edc-441e-ae8d-e87c3aea0059"  # PagoPA, Comune di Milano

FRONTEND_RESOURCE_CPU="250m"
FRONTEND_RESOURCE_MEM="1Gi"
