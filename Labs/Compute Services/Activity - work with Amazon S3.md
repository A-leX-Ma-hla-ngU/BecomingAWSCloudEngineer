# Activity - work with Amazon S3

## Lab journey

This document described the hands‑on journey taken while completing the "Activity - work with Amazon S3" lab. The narrative was written in past tense to capture the sequence of actions, observations, and verifications that were performed. The lab configured an S3 bucket for file sharing with an external user (mediacouser), verified permissions, and configured S3 event notifications to publish messages to an SNS topic.

---

## Lab overview

I created and configured an S3 share bucket that allowed an external media user to upload, change, and delete images under an images/ prefix. I also configured Amazon SNS and S3 event notifications so that the administrator received email alerts whenever bucket contents changed.

Architecture diagram: (insert screenshot)

Screenshot placeholder: `screenshots/architecture_overview.png`

---

## Objectives accomplished

By the end of the lab I had done the following:

- Used the s3api and s3 AWS CLI commands to create and configure an S3 bucket.
- Verified write permissions for the mediacouser user on the bucket's images/ prefix.
- Configured S3 event notifications to publish to an SNS topic and verified email notifications for object create and delete events.

---

## Duration

This lab required approximately 90 minutes to complete.

---

## Walkthrough (journey)

The following sections narrated the actions I performed during the lab. Each critical step included a placeholder for screenshots so the important console and terminal outputs could be documented.

### Task 1 — Connected to the CLI Host and configured the AWS CLI

- I opened the EC2 Management Console, selected the CLI Host instance, and connected to it using EC2 Instance Connect. The connection opened an in‑browser terminal that I used for CLI operations.

Screenshot placeholder: `screenshots/cli_host_instance_connect.png`

- I ran aws configure in the instance terminal and entered the provided AccessKey, SecretKey, default region `us-west-2`, and `json` as the default output format. I verified the configuration by running a simple AWS CLI command (for example, aws sts get-caller-identity) and confirmed the account and ARN.

Screenshot placeholder: `screenshots/aws_configure_identity.png`

---

### Task 2 — Created and initialized the S3 share bucket

- I created a uniquely named bucket that began with the required `cafe-` prefix using the aws s3 mb command, for example:

aws s3 mb s3://cafe-abc123 --region us-west-2

Screenshot placeholder: `screenshots/s3_create_bucket_cli.png`

- I synchronized sample images from the CLI Host's initial-images folder into the bucket under the images/ prefix:

aws s3 sync ~/initial-images/ s3://cafe-abc123/images

- I verified the uploaded files with: aws s3 ls s3://cafe-abc123/images/ --human-readable --summarize and confirmed file counts and total size.

Screenshot placeholder: `screenshots/s3_sync_and_ls.png`

---

### Task 3 — Reviewed IAM group and mediacouser permissions

Task 3.1 — Reviewed the mediaco IAM group

- I opened the IAM console, navigated to User groups, and inspected the mediaco group.
  - I expanded IAMUserChangePassword to confirm password‑change permissions.
  - I expanded mediaCoPolicy and reviewed the policy statements that allowed console listing of buckets, allowed root level bucket listing for cafe buckets, and restricted object operations (GetObject, PutObject, DeleteObject) to the cafe-*/images/* prefix.

Screenshot placeholder: `screenshots/iam_mediaco_group_policy.png`

Task 3.2 — Reviewed the mediacouser IAM user

- I navigated to Users, selected mediacouser, and verified that the user inherited IAMUserChangePassword and mediaCoPolicy via membership in the mediaco group.
- I created an access key for mediacouser (CLI option) and downloaded the access key CSV (mediacouser_accessKeys.csv). I copied the Console sign-in link for mediacouser for later use.

Screenshot placeholder: `screenshots/iam_mediacouser_accesskeys.png`

Task 3.3 — Tested mediacouser permissions (console)

- I signed in to the Console as mediacouser in a separate browser or private window, navigated to S3, and opened the share bucket.
- I navigated to images/ and opened Donuts.jpg to confirm the view use case worked.

Screenshot placeholder: `screenshots/s3_mediacouser_view_image.png`

- I uploaded a test image via the console (Upload → Add files → Upload) and confirmed the uploaded image could be opened.

Screenshot placeholder: `screenshots/s3_mediacouser_upload_image.png`

- I deleted an existing image (e.g., Cup-of-Hot-Chocolate.jpg) through the console and confirmed deletion.

Screenshot placeholder: `screenshots/s3_mediacouser_delete_image.png`

- I attempted to change the bucket's Permissions as mediacouser and observed an "Insufficient permissions" message, confirming that the user could not change bucket-level permissions.

Screenshot placeholder: `screenshots/s3_mediacouser_insufficient_permissions.png`

---

### Task 4 — Configured event notifications (SNS + S3)

Task 4.1 — Created and configured the s3NotificationTopic SNS topic

- I created a Standard SNS topic named s3NotificationTopic in the SNS console and copied its ARN for configuration.

Screenshot placeholder: `screenshots/sns_create_topic.png`

- I edited the topic's access policy to allow S3 to publish to it. I replaced placeholders in the policy JSON with the topic ARN and my bucket ARN (arn:aws:s3:::cafe-abc123) and saved the policy. This policy explicitly allowed the s3.amazonaws.com service to call SNS:Publish when the source ARN matched the bucket.

Screenshot placeholder: `screenshots/sns_topic_policy_edit.png`

- I created an Email subscription on the topic and confirmed the subscription by clicking the confirmation link in the received email.

Screenshot placeholder: `screenshots/sns_subscription_confirmed.png`

Task 4.2 — Added event notification configuration to the S3 bucket

- On the CLI Host I created a JSON file named s3EventNotification.json that defined a TopicConfigurations array with TopicArn set to the s3NotificationTopic ARN, Events set to ["s3:ObjectCreated:*","s3:ObjectRemoved:*"], and a Filter matching the prefix images/.

Screenshot placeholder: `screenshots/s3_event_notification_json.png`

- I associated the notification configuration with the bucket via:

aws s3api put-bucket-notification-configuration --bucket cafe-abc123 --notification-configuration file://s3EventNotification.json

- A short time later I received a test notification email from Amazon S3 with Event = s3:TestEvent, confirming the configuration.

Screenshot placeholder: `screenshots/s3_test_notification_email.png`

---

### Task 5 — Tested S3 event notifications and mediacouser CLI use cases

- I reconfigured the CLI Host's AWS CLI to use mediacouser credentials (aws configure) with the access key values from mediacouser_accessKeys.csv.

Screenshot placeholder: `screenshots/aws_configure_mediacouser.png`

- I tested the put use case by uploading Caramel-Delight.jpg from the CLI Host new-images folder using aws s3api put-object --bucket cafe-abc123 --key images/Caramel-Delight.jpg --body ~/new-images/Caramel-Delight.jpg and confirmed I received an email notification with eventName ObjectCreated:Put and object key images/Caramel-Delight.jpg.

Screenshot placeholder: `screenshots/s3_cli_put_and_email.png`

- I tested the get use case with aws s3api get-object --bucket cafe-abc123 --key images/Donuts.jpg Donuts.jpg; no notification email was expected because Get operations were not configured to trigger notifications.

Screenshot placeholder: `screenshots/s3_cli_get_object.png`

- I tested the delete use case with aws s3api delete-object --bucket cafe-abc123 --key images/Strawberry-Tarts.jpg and confirmed an email notification arrived with eventName ObjectRemoved:Delete and object key images/Strawberry-Tarts.jpg.

Screenshot placeholder: `screenshots/s3_cli_delete_and_email.png`

- I tested an unauthorized operation (attempting to set a public ACL) with aws s3api put-object-acl --bucket cafe-abc123 --key images/Donuts.jpg --acl public-read and observed the expected AccessDenied error, confirming the policy restrictions.

Screenshot placeholder: `screenshots/s3_cli_put_acl_access_denied.png`

---

## Troubleshooting notes

- If notifications did not arrive, I checked the SNS topic's access policy, verified that the bucket ARN matched the policy condition, and confirmed the subscription was confirmed. I also inspected CloudWatch Logs (if configured) or retried the test operations.
- If mediacouser could not perform object operations, I rechecked the mediaCoPolicy statements for correct resource ARNs and the user's group membership.

Screenshot placeholder: `screenshots/troubleshoot_s3_notifications.png`

---

## Conclusion

I had successfully configured an S3 share bucket for collaboration with an external media user, verified user permissions for the images/ prefix, and configured S3 event notifications to publish change events to an SNS topic that emailed the administrator.

Recommended screenshot filenames to capture and add to the repository:

- architecture_overview.png
- cli_host_instance_connect.png
- aws_configure_identity.png
- s3_create_bucket_cli.png
- s3_sync_and_ls.png
- iam_mediaco_group_policy.png
- iam_mediacouser_accesskeys.png
- s3_mediacouser_view_image.png
- s3_mediacouser_upload_image.png
- s3_mediacouser_delete_image.png
- s3_mediacouser_insufficient_permissions.png
- sns_create_topic.png
- sns_topic_policy_edit.png
- sns_subscription_confirmed.png
- s3_event_notification_json.png
- s3_test_notification_email.png
- aws_configure_mediacouser.png
- s3_cli_put_and_email.png
- s3_cli_get_object.png
- s3_cli_delete_and_email.png
- s3_cli_put_acl_access_denied.png
- troubleshoot_s3_notifications.png

---

*File created in the Labs/Compute Services folder as requested.*
