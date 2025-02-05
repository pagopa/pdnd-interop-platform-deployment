#!/bin/bash
SELFCARE_LOGIN_URL="https://selfcare.pagopa.it/auth/login"
FRONTEND_SERVICE_PORT="80"
PUBLIC_BUCKET_URL="https://interop-${ENVIRONMENT}-public${REGION_SUFFIX}.s3.${AWS_REGION}.amazonaws.com"
MIXPANEL_PROJECT_ID="fill_me"
ONETRUST_DOMAIN_SCRIPT_ID="43ec7a2e-aca5-4317-810d-8f80dea732e2"
SELFCARE_BASE_URL="https://selfcare.pagopa.it"
API_SIGNAL_HUB_PUSH_INTERFACE_URL="https://raw.githubusercontent.com/pagopa/interop-signalhub-core/refs/heads/main/docs/openAPI/push-signals.yaml"
API_SIGNAL_HUB_PULL_INTERFACE_URL="https://raw.githubusercontent.com/pagopa/interop-signalhub-core/refs/heads/main/docs/openAPI/pull-signals.yaml"
FEATURE_FLAG_SIGNALHUB_WHITELIST_PRODUCER=true
SIGNALHUB_WHITELIST_PRODUCER=84871fd4-2fd7-46ab-9d22-f6b452f4b3c5 # PagoPA
SIGNALHUB_WHITELIST_CONSUMER=69e2865e-65ab-4e48-a638-2037a9ee2ee7  # PagoPA


FRONTEND_RESOURCE_CPU="250m"
FRONTEND_RESOURCE_MEM="1Gi"
