# Challenge Lab — Amazon S3

## Lab journey

This document described the hands‑on journey taken while completing the "Challenge Lab — Amazon S3". The narrative was written in past tense to record the sequence of actions, observations, and verifications that were performed. The challenge required creating an S3 bucket, uploading an object, making the object publicly accessible, and listing contents with the AWS CLI.

---

## Lab overview

I created an Amazon S3 bucket, uploaded an object to it, made that object publicly accessible via a browser, and listed the bucket contents using the AWS CLI. The work was performed from the provided CLI Host EC2 instance using EC2 Instance Connect and the AWS CLI.

Screenshot placeholder: `screenshots/architecture_overview.png`

---

## Objectives accomplished

By the end of the challenge I had:

- Created an S3 bucket.
- Uploaded an object into the bucket.
- Accessed the object in a web browser after making it public.
- Listed the bucket contents with the AWS CLI.

---

## Duration

This lab required approximately 45 minutes to complete.

---

## Walkthrough (journey)

The following steps narrated what I did during the challenge. Each important step included a placeholder for screenshots so key outputs and console views could be documented.

### Task 1 — Connected to the CLI Host instance

- I opened the EC2 Management Console, located the CLI Host instance, and connected using EC2 Instance Connect (Connect → EC2 Instance Connect → Connect). The connection opened an in‑browser terminal that I used for CLI operations.

Screenshot placeholder: `screenshots/ec2_instance_connect.png`

---

### Task 2 — Configured the AWS CLI

- In the CLI Host terminal I ran aws configure and provided the lab credentials and default settings:
  - AWS Access Key ID: (pasted AccessKey)
  - AWS Secret Access Key: (pasted SecretKey)
  - Default region name: us-west-2
  - Default output format: json

- I verified the configuration by running aws sts get-caller-identity and confirming the returned account and ARN.

Screenshot placeholder: `screenshots/aws_configure_and_identity.png`

---

### Task 3 — Created an S3 bucket and uploaded an object

- I selected a globally unique bucket name (for example: `cafe‑challenge‑123`) and created the bucket in the us-west-2 Region. Example CLI command I used:

  aws s3 mb s3://cafe-challenge-123 --region us-west-2

Screenshot placeholder: `screenshots/s3_create_bucket_cli.png`

- I uploaded a sample object (for example `hello.txt` or an image) to the bucket. Example CLI commands I used:

  aws s3 cp ~/sample-files/hello.txt s3://cafe-challenge-123/hello.txt

Screenshot placeholder: `screenshots/s3_upload_object_cli.png`

- I listed the bucket contents to verify the object was present:

  aws s3 ls s3://cafe-challenge-123/ --human-readable --summarize

Screenshot placeholder: `screenshots/s3_ls_bucket.png`

---

### Task 4 — Made the object publicly accessible and accessed it in a browser

- I made the specific object public (object-level ACL) so it could be accessed via its S3 object URL. Example CLI command I used:

  aws s3api put-object-acl --bucket cafe-challenge-123 --key hello.txt --acl public-read

Screenshot placeholder: `screenshots/s3_put_object_acl.png`

- I then opened the object URL in a browser to confirm it was publicly accessible. The object URL format was:

  https://cafe-challenge-123.s3.amazonaws.com/hello.txt

- The browser displayed the object content (or image) as expected.

Screenshot placeholder: `screenshots/browser_object_view.png`

Notes: For production environments or larger deployments, I preferred using pre-signed URLs or bucket policies rather than object ACLs to manage public access.

---

### Task 5 — Verified with the AWS CLI

- I re-ran aws s3 ls to confirm the object appeared in the bucket and used aws s3api head-object to check metadata if needed:

  aws s3api head-object --bucket cafe-challenge-123 --key hello.txt

Screenshot placeholder: `screenshots/s3api_head_object.png`

---

## Troubleshooting notes

- If the object remained inaccessible in the browser after applying the ACL, I checked the bucket public access block settings in the S3 console and ensured that Block Public Access settings did not prevent the object ACL from taking effect.
- If the object URL returned a 403 error, I verified the bucket name, object key, and ACL; I also inspected any applicable bucket policy that could override object ACLs.
- If aws configure failed, I rechecked the AccessKey/SecretKey values and region setting.

Screenshot placeholder: `screenshots/troubleshooting_s3.png`

---

## Conclusion

I had successfully completed the challenge: I created an S3 bucket, uploaded an object, made that object publicly accessible, accessed it in a browser, and listed bucket contents via the AWS CLI. I documented the steps and left placeholders for screenshots to show the most important verification points.

Recommended screenshot filenames to capture and add to the repository:

- ec2_instance_connect.png
- aws_configure_and_identity.png
- s3_create_bucket_cli.png
- s3_upload_object_cli.png
- s3_ls_bucket.png
- s3_put_object_acl.png
- browser_object_view.png
- s3api_head_object.png
- troubleshooting_s3.png

---

*File created in the Labs/Compute Services folder as requested.*
