#!/bin/bash

PARTY_PROCESS_STORAGE_TYPE="S3"
PARTY_PROCESS_STORAGE_CONTAINER="interop-pdnd-dev-support"
PARTY_PROCESS_STORAGE_ENDPOINT=""

PARTY_PROCESS_MAIL_TEMPLATE_PATH="mail-templates/onboarding-interop-template.json"
PARTY_PROCESS_MAIL_ONBOARDING_CONFIRMATION_LINK_PATH="ui/conferma-registrazione?jwt="
PARTY_PROCESS_MAIL_ONBOARDING_REJECTION_LINK_PATH="ui/cancella-registrazione?jwt="
PARTY_PROCESS_MAIL_SENDER_ADDRESS="dev-pdnd-interop@pagopa.it"
PARTY_PROCESS_SMTP_HOST="smtps.pec.aruba.it"
PARTY_PROCESS_SMTP_SSL="true"
PARTY_PROCESS_SMTP_PORT="465"
PARTY_PROCESS_EU_LIST_OF_TRUSTED_LISTS_URL="https://ec.europa.eu/tools/lotl/eu-lotl.xml"
PARTY_PROCESS_EU_OFFICIAL_JOURNAL_URL="https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=uriserv:OJ.C_.2019.276.01.0001.01.ENG"