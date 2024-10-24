#!/bin/bash

ESERVICE_DESCRIPTORS_ARCHIVER_SERVICE_NAME="interop-be-eservice-descriptors-archiver-refactor"
ARCHIVING_ESERVICES_QUEUE_URL="archived-agreements-for-eservices"
AGREEMENTS_COLLECTION_NAME="agreements"
ESERVICES_COLLECTION_NAME="eservices"

ESERVICE_DESCRIPTORS_ARCHIVER_RESOURCE_CPU="500m"
ESERVICE_DESCRIPTORS_ARCHIVER_RESOURCE_MEM="1Gi"

ESERVICE_DESCRIPTORS_ARCHIVER_JWT_SUBJECT="dev-refactor.interop-eservice-descriptors-archiver"
ESERVICE_DESCRIPTORS_ARCHIVER_JWT_DURATION_SECONDS=3600
