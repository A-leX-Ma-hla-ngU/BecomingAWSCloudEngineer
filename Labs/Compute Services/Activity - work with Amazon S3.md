# Activity - work with Amazon S3

## Lab journey

This document described the hands‑on journey taken while completing the "Activity - work with Amazon S3" lab. The narrative was written in past tense to capture the sequence of actions, observations, and verifications that were performed. The lab configured an S3 bucket for file sharing with an external user (mediacouser), verified permissions, and configured S3 event notifications to publish messages to an SNS topic.

---

## Lab overview

I created and configured an S3 share bucket that allowed an external media user to upload, change, and delete images under an images/ prefix. I also configured Amazon SNS and S3 event notifications so that the administrator received email alerts whenever bucket contents changed.

Architecture diagram: 

Screenshot: <img width="809" height="491" alt="Screenshot 2026-07-16 at 21 10 31" src="https://github.com/user-attachments/assets/b9eeabbb-980f-40ea-8557-fe5f7d3f0018" />

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

Screenshot placeholder: <img width="843" height="389" alt="Screenshot 2026-07-20 at 16 46 13" src="https://github.com/user-attachments/assets/3b806418-c489-483c-8038-0654ad7bd093" />

- I ran aws configure in the instance terminal and entered the provided AccessKey, SecretKey, default region `us-west-2`, and `json` as the default output format. I verified the configuration by running a simple AWS CLI command (for example, aws sts get-caller-identity) and confirmed the account and ARN.

Screenshot placeholder: <img width="756" height="152" alt="Screenshot 2026-07-20 at 16 46 46" src="https://github.com/user-attachments/assets/6b457ed5-42c5-4782-b689-b57d9f9851ab" />

<img width="576" height="77" alt="Screenshot 2026-07-20 at 16 47 18" src="https://github.com/user-attachments/assets/efe35854-d593-4aad-8585-b92635aa4240" />

<img width="519" height="119" alt="Screenshot 2026-07-20 at 16 49 10" src="https://github.com/user-attachments/assets/be179b23-930c-487b-be80-27fb42a2f35d" />



---

### Task 2 — Created and initialized the S3 share bucket

- I created a uniquely named bucket that began with the required `cafe-` prefix using the aws s3 mb command, for example:

aws s3 mb s3://cafe-2336 --region us-west-2

Screenshot placeholder: <img width="824" height="112" alt="Screenshot 2026-07-20 at 17 04 21" src="https://github.com/user-attachments/assets/c0e4d377-5a1a-4acb-83d2-a8eb27a11aae" />

- An error was raised that pointed me immediately to the AWS credentials "InvalidAccessKeyId"

- I reviewed the credentials if session token was configured in the aws credentials folder using the following command:
  
aws configure list
  
Screenshot:

<img width="802" height="183" alt="Screenshot 2026-07-20 at 17 04 38" src="https://github.com/user-attachments/assets/bdc5477a-3db3-4ac9-8876-1581c0fd5d07" />

-I then proceeded to edit the aws credentials using Vim (a text editor) with the following command:

vim .aws/credentials

Screenshot: 

<img width="626" height="47" alt="Screenshot 2026-07-28 at 13 20 28" src="https://github.com/user-attachments/assets/1428ab14-c9a4-4a44-8375-c11d74e5c7ea" />

Confirmed using Vim that only Access Key ID and Secrets key are the only credentials added. The lab provided Access key ID, Secret access key, and Session token (which is missing from the aws configuration credentials.

Screenshot: 
<img width="230" height="154" alt="Screenshot 2026-07-28 at 13 18 38" src="https://github.com/user-attachments/assets/54e7bc26-9994-4c83-a8e7-e88bdfc34fb4" />

Edited the credentials and successfully added the session token.

Screenshot: 
<img width="838" height="246" alt="Screenshot 2026-07-28 at 13 19 07" src="https://github.com/user-attachments/assets/5a769661-fb47-480f-b8f2-e4807d7c054d" />
<img width="199" height="131" alt="Screenshot 2026-07-28 at 13 19 52" src="https://github.com/user-attachments/assets/faf3d861-acef-482a-8ee0-36433b04e2f4" />
<img width="828" height="159" alt="Screenshot 2026-07-28 at 13 20 20" src="https://github.com/user-attachments/assets/191c06c4-ae18-41b0-9cc7-ac6331faffde" />

- I then faced another minor issue with the name of the bucket already existence. I immediately changed the bucket name to a unique one (s3 bucket names need to be *globally unique*. The new bucket name was accepted and my bucket was successfully created.

Screenshot: 

<img width="845" height="216" alt="Screenshot 2026-07-28 at 15 45 33" src="https://github.com/user-attachments/assets/f7f246ef-6b22-4f8c-953b-6389158f5c42" />


- I synchronized sample images from the CLI Host's initial-images folder into the bucket under the images/ prefix:

aws s3 sync ~/initial-images/ s3://cafe-0246/images

- I verified the uploaded files with: aws s3 ls s3://cafe-0246/images/ --human-readable --summarize and confirmed file counts and total size.

Screenshot placeholder: <img width="846" height="179" alt="Screenshot 2026-07-28 at 15 58 03" src="https://github.com/user-attachments/assets/cfe10d80-b505-4281-b8da-b0b1b6073e0e" />

<img width="829" height="192" alt="Screenshot 2026-07-28 at 15 58 50" src="https://github.com/user-attachments/assets/3df82b07-ceb4-4cb4-ac43-f42dbfad7f13" />


---

### Task 3 — Reviewed IAM group and mediacouser permissions

Task 3.1 — Reviewed the mediaco IAM group

- I opened the IAM console, navigated to User groups, and inspected the mediaco group.
  - I expanded IAMUserChangePassword to confirm password‑change permissions.
  - I expanded mediaCoPolicy and reviewed the policy statements that allowed console listing of buckets, allowed root level bucket listing for cafe buckets, and restricted object operations (GetObject, PutObject, DeleteObject) to the cafe-*/images/* prefix.

Screenshot placeholder: <img width="1317" height="435" alt="Screenshot 2026-07-28 at 13 47 25" src="https://github.com/user-attachments/assets/8a152e80-0354-4509-b5de-fe96568b9652" />

Task 3.2 — Reviewed the mediacouser IAM user

- I navigated to Users, selected mediacouser, and verified that the user inherited IAMUserChangePassword and mediaCoPolicy via membership in the mediaco group.
- I created an access key for mediacouser (CLI option) and downloaded the access key CSV (mediacouser_accessKeys.csv). I copied the Console sign-in link for mediacouser for later use.

Screenshot placeholder: <img width="827" height="290" alt="Screenshot 2026-07-28 at 13 59 30" src="https://github.com/user-attachments/assets/02e00edb-e156-4f30-b8ba-7c8ff6594863" />

<img width="360" height="88" alt="Screenshot 2026-07-28 at 14 00 26" src="https://github.com/user-attachments/assets/96e2451f-3cd6-4cc8-aeb8-751721578c04" />

<img width="534" height="41" alt="Screenshot 2026-07-28 at 14 02 59" src="https://github.com/user-attachments/assets/80fdd210-f469-4c29-9af6-316fcdbe033d" />


Task 3.3 — Tested mediacouser permissions (console)

- I signed in to the Console as mediacouser in a separate browser or private window, navigated to S3, and opened the share bucket.
- I navigated to images/ and opened Donuts.jpg to confirm the view use case worked.

Screenshot placeholder: <img width="886" height="782" alt="Screenshot 2026-07-28 at 16 22 59" src="https://github.com/user-attachments/assets/3dc32511-bd85-4257-a9a2-b05f3b3723af" />

- I uploaded a test image via the console (Upload → Add files → Upload) and confirmed the uploaded image could be opened.

Screenshot: 
<img width="885" height="663" alt="Screenshot 2026-07-28 at 16 27 37" src="https://github.com/user-attachments/assets/bd96b2ac-af60-4282-8a24-9f572d4e8227" />

<img width="888" height="401" alt="Screenshot 2026-07-28 at 16 28 19" src="https://github.com/user-attachments/assets/6ad639d3-b247-4c44-91bd-69e08b8d4456" />

<img width="888" height="398" alt="Screenshot 2026-07-28 at 16 28 31" src="https://github.com/user-attachments/assets/b1f7d955-bf49-4f03-bf0c-d0d0be83f2ce" />




- I deleted an existing image (e.g., Cup-of-Hot-Chocolate.jpg) through the console and confirmed deletion.

Screenshot placeholder: <img width="871" height="382" alt="Screenshot 2026-07-28 at 16 33 28" src="https://github.com/user-attachments/assets/8ea0a78a-dd43-4a97-b558-0b052f8b77dc" />

<img width="864" height="389" alt="Screenshot 2026-07-28 at 16 34 52" src="https://github.com/user-attachments/assets/257941a4-5304-4c87-bfed-aa67b2b82c81" />



- I attempted to change the bucket's Permissions as mediacouser and observed an "Insufficient permissions" message, confirming that the user could not change bucket-level permissions.
<img width="1674" height="884" alt="Screenshot 2026-07-28 at 16 38 55" src="https://github.com/user-attachments/assets/93427da7-a9d7-4525-bc66-8cb3d49a2ce3" />

---

### Task 4 — Configured event notifications (SNS + S3)

Task 4.1 — Created and configured the s3NotificationTopic SNS topic

- I created a Standard SNS topic named s3NotificationTopic in the SNS console and copied its ARN for configuration.

Screenshot placeholder: <img width="803" height="507" alt="Screenshot 2026-07-28 at 16 52 15" src="https://github.com/user-attachments/assets/70cd3ab2-9c02-41e6-b345-0749219a46aa" />

<img width="1607" height="590" alt="Screenshot 2026-07-28 at 16 53 09" src="https://github.com/user-attachments/assets/378ecfd4-41f8-4ecd-98a8-1323ed6286c1" />

<img width="453" height="154" alt="Screenshot 2026-07-28 at 17 00 26" src="https://github.com/user-attachments/assets/9d22798c-efc0-4756-abfb-67f05e2c6baf" />


- I edited the topic's access policy to allow S3 to publish to it. I replaced placeholders in the policy JSON with the topic ARN and my bucket ARN (arn:aws:s3:::cafe-0246) and saved the policy. This policy explicitly allowed the s3.amazonaws.com service to call SNS:Publish when the source ARN matched the bucket.

Screenshot placeholder: <img width="806" height="571" alt="Screenshot 2026-07-28 at 17 04 41" src="https://github.com/user-attachments/assets/c94b7f2e-1003-4f1d-a11d-ed297ae2a236" />

- I created an Email subscription on the topic and confirmed the subscription by clicking the confirmation link in the received email.

Screenshot placeholder: <img width="209" height="81" alt="Screenshot 2026-07-28 at 17 13 05" src="https://github.com/user-attachments/assets/8494d047-efbe-40e4-9514-3ca8a820d90f" />
Task 4.2 — Added event notification configuration to the S3 bucket

- On the CLI Host I created a JSON file named s3EventNotification.json that defined a TopicConfigurations array with TopicArn set to the s3NotificationTopic ARN, Events set to ["s3:ObjectCreated:*","s3:ObjectRemoved:*"], and a Filter matching the prefix images/.

Screenshot placeholder: <img width="776" height="39" alt="Screenshot 2026-07-28 at 17 17 34" src="https://github.com/user-attachments/assets/52483e20-cefe-4bf1-a7ca-804a489f6e32" />

<img width="839" height="623" alt="Screenshot 2026-07-28 at 17 18 07" src="https://github.com/user-attachments/assets/84af29c8-b193-458f-ac1b-bc4c61985615" />

<img width="854" height="613" alt="Screenshot 2026-07-28 at 17 19 48" src="https://github.com/user-attachments/assets/8d1ae1c9-2950-4c66-b9a1-6a0b2fc40bc9" />

<img width="522" height="229" alt="Screenshot 2026-07-28 at 17 21 41" src="https://github.com/user-attachments/assets/88ac5354-b699-4a16-82e1-555453c45e9f" />


- I associated the notification configuration with the bucket via:

aws s3api put-bucket-notification-configuration --bucket cafe-0246 --notification-configuration file://s3EventNotification.json

- A short time later I received a test notification email from Amazon S3 with Event = s3:TestEvent, confirming the configuration.

Screenshot placeholder: <img width="1072" height="163" alt="Screenshot 2026-07-28 at 17 24 03" src="https://github.com/user-attachments/assets/ca89df84-fd3f-4dfd-8fa0-d7506d342410" />

---

### Task 5 — Tested S3 event notifications and mediacouser CLI use cases

- I reconfigured the CLI Host's AWS CLI to use mediacouser credentials (aws configure) with the access key values from mediacouser_accessKeys.csv.

Screenshot placeholder: <img width="1072" height="163" alt="Screenshot 2026-07-28 at 17 24 03" src="https://github.com/user-attachments/assets/a08ff70a-05aa-4b32-9057-3fe82e11c1d9" />

- I tested the put use case by uploading Caramel-Delight.jpg from the CLI Host new-images folder using aws s3api put-object --bucket cafe-abc123 --key images/Caramel-Delight.jpg --body ~/new-images/Caramel-Delight.jpg and confirmed I received an email notification with eventName ObjectCreated:Put and object key images/Caramel-Delight.jpg.

Screenshot placeholder: <img width="827" height="154" alt="Screenshot 2026-07-28 at 17 56 26" src="https://github.com/user-attachments/assets/6236f7e9-35ac-4ebf-bab8-660f5a603e0d" />

<img width="1033" height="212" alt="Screenshot 2026-07-28 at 17 56 52" src="https://github.com/user-attachments/assets/26bcab6f-af04-4d15-8e21-b4ad7109a294" />


- I tested the delete use case with aws s3api delete-object --bucket cafe-abc123 --key images/Strawberry-Tarts.jpg and confirmed an email notification arrived with eventName ObjectRemoved:Delete and object key images/Strawberry-Tarts.jpg.

Screenshot placeholder: <img width="841" height="52" alt="Screenshot 2026-07-28 at 17 58 19" src="https://github.com/user-attachments/assets/cda4a0f2-a26c-49ce-ada0-aa5f835d3fce" />

<img width="1078" height="208" alt="Screenshot 2026-07-28 at 17 58 36" src="https://github.com/user-attachments/assets/f0a444ac-b5bc-440b-ba14-1aaeb4c8dd94" />


- I tested an unauthorized operation (attempting to set a public ACL) with aws s3api put-object-acl --bucket cafe-abc123 --key images/Donuts.jpg --acl public-read and observed the expected AccessDenied error, confirming the policy restrictions.

Screenshot placeholder: <img width="858" height="219" alt="Screenshot 2026-07-28 at 17 59 40" src="https://github.com/user-attachments/assets/6187e5da-7122-417e-8609-84371ae07d8b" />


---

## Troubleshooting notes

- If notifications did not arrive, I checked the SNS topic's access policy, verified that the bucket ARN matched the policy condition, and confirmed the subscription was confirmed. I also inspected CloudWatch Logs (if configured) or retried the test operations.
- If mediacouser could not perform object operations, I rechecked the mediaCoPolicy statements for correct resource ARNs and the user's group membership.


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
