#!/bin/bash

SELFCARE_BROKER_URLS="selc-u-eventhub-ns.servicebus.windows.net:9093"
KAFKA_CLIENT_ID="interop-dev"
KAFKA_GROUP_ID="interop-onboarding-dev"
TOPIC_NAME="sc-contracts"

SELFCARE_ONBOARDING_CONSUMER_RESOURCE_CPU="250m"
SELFCARE_ONBOARDING_CONSUMER_RESOURCE_MEM="512Mi"