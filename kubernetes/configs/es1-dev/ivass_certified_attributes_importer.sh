#!/bin/bash

IVASS_CERTIFIED_ATTRIBUTES_IMPORTER_JWT_DURATION_SECONDS="1800"
IVASS_TENANT_ID="9e2528e5-b9bd-4eee-8ea0-161040daff47"
IVASS_CERTIFIED_ATTRIBUTES_RECORDS_PROCESS_BATCH_SIZE="100"
IVASS_SOURCE_URL="https://infostat-ivass.bancaditalia.it/RIGAInquiry-public/getAreaDownloadExport.do?referenceDate=&product=VFLUSSO_IMPRESE&language=IT&exportType=CSV&username=OBLIXANONYMOUS&isCompressed=S"
IVASS_HISTORY_BUCKET_NAME="interop-ivass-dev-es1"

JOB_IVASS_CERTIFIED_ATTRIBUTES_IMPORTER_RESOURCE_CPU="1"
JOB_IVASS_CERTIFIED_ATTRIBUTES_IMPORTER_RESOURCE_MEM="2Gi"
