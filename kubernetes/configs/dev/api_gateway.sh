#!/bin/bash

API_GATEWAY_RESOURCE_CPU="500m"
API_GATEWAY_RESOURCE_MEM="2Gi"

API_GATEWAY_RATE_LIMITER_MAX_REQUESTS="10"
API_GATEWAY_RATE_LIMITER_BURST_PERCENTAGE="1.0"
API_GATEWAY_RATE_LIMITER_RATE_INTERVAL="1.second"
API_GATEWAY_RATE_LIMITER_TIMEOUT="300.milliseconds"