#!/bin/bash
NOTIFICATION_DYNAMO_TABLE_NAME="interop-notification-events"
NOTIFICATION_RESOURCES_DYNAMO_TABLE_NAME="interop-notification-resources"
NOTIFICATION_QUEUE_READER_THREAD_POOL_SIZE=3

NOTIFIER_RESOURCE_CPU="2"
NOTIFIER_RESOURCE_MEM="2Gi"

KEY_NOTIFICATION_POSTGRES_TABLE_NAME="key_notification"