#!/bin/bash
SELFCARE_LOGIN_URL="https://selfcare.pagopa.it/auth/login"
FRONTEND_SERVICE_PORT="80"
PUBLIC_BUCKET_URL="https://interop-${ENVIRONMENT}-public${REGION_SUFFIX}.s3.${AWS_REGION}.amazonaws.com"
MIXPANEL_PROJECT_ID="fill_me"
ONETRUST_DOMAIN_SCRIPT_ID="43ec7a2e-aca5-4317-810d-8f80dea732e2"
SELFCARE_BASE_URL="https://selfcare.pagopa.it"

FRONTEND_RESOURCE_CPU="250m"
FRONTEND_RESOURCE_MEM="1Gi"
