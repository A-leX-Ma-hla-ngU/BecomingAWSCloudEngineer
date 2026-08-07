# Creating a website on S3

## Lab journey

This document described the hands‑on journey taken while completing the "Creating a website on S3" lab. The narrative was written in past tense to capture the exact sequence of actions, observations, and verifications that were performed. The lab used the AWS CLI from an Amazon Linux EC2 instance to create and configure an S3 bucket to host a static website, create an IAM user with S3 access, upload website files, and create a repeatable deployment script.

---

## Lab overview

I used the AWS CLI from an EC2 instance to:

- Create an S3 bucket configured for static website hosting.
- Create an IAM user (awsS3user) and granted it Amazon S3 full access.
- Upload the Café & Bakery static website files to S3.
- Create a shell script to update the site later by copying local files to S3.

Website endpoint (example): http://<bucket-name>.s3-website-us-west-2.amazonaws.com

Screenshot placeholder: `screenshots/architecture_overview.png`

---

## Objectives accomplished

After the lab I had done the following:

- Run AWS CLI commands that used IAM and S3 services from an EC2 instance.
- Deployed a static website to an S3 bucket and enabled static website hosting.
- Created an update script (batch file) to push local changes to the S3 website.

---

## Duration

This activity required approximately 45 minutes to complete.

---

## Walkthrough (journey)

The following steps narrated what I performed during the lab. Each major step included a screenshot placeholder so the most important console or terminal outputs could be captured.

### Task 1 — Connected to the EC2 instance using Session Manager

- I opened the Details pane, clicked Show, copied the InstanceSessionUrl, and opened it in a new browser tab.
- I connected to the instance as ssm-user, switched to the ec2‑user account, and confirmed the working directory.

Commands I ran (in the instance terminal):

sudo su -l ec2-user
pwd

Screenshot placeholder: `screenshots/ssm_instance_connect.png`

---

### Task 2 — Configured the AWS CLI

- I ran aws configure in the SSH session and entered the credentials provided in the lab: AccessKey, SecretKey, region `us-west-2`, and output format `json`.
- I verified the configuration by running aws sts get-caller-identity and confirming the returned account and ARN.

Screenshot placeholder: `screenshots/aws_configure_and_identity.png`

---

### Task 3 — Created an S3 bucket using the AWS CLI

- I chose a globally unique bucket name (for example: twhitlock256) and created the bucket in the us-west-2 Region with the following command:

aws s3api create-bucket --bucket <my-bucket> --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2

- I verified the command returned a JSON Location entry indicating the bucket URL.

Screenshot placeholder: `screenshots/s3_create_bucket_cli.png`

---

### Task 4 — Created an IAM user and granted S3 access

- I created a new IAM user named awsS3user using the CLI:

aws iam create-user --user-name awsS3user

- I created a login profile so the user could sign in to the console:

aws iam create-login-profile --user-name awsS3user --password Training123!

- I listed available IAM policies that included S3 in the name to locate the managed policy granting full S3 access:

aws iam list-policies --query "Policies[?contains(PolicyName,'S3')]"

- I attached the appropriate policy (for example `AmazonS3FullAccess`) to the awsS3user:

aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --user-name awsS3user

Screenshot placeholder: `screenshots/iam_create_user_and_attach_policy.png`

- I signed out of the Management Console and signed back in as the new IAM user to confirm the sign‑in worked and to inspect the S3 console as the new user.

Screenshot placeholder: `screenshots/iam_signed_in_as_awsS3user.png`

Notes: In the lab I copied the 12‑digit AWS Account ID when required and confirmed that the awsS3user could see the S3 console (permissions were granted by the attached managed policy).

---

### Task 5 — Adjusted bucket permissions for public website hosting

- I opened the S3 bucket's Permissions tab in the console and edited Block Public Access to disable the setting that blocked all public access.
- I changed Object Ownership to enable ACLs if the lab required ACL-based public access and acknowledged the change.

Screenshot placeholder: `screenshots/s3_permissions_edit.png`

Important: For production environments, I noted that making buckets public must be reviewed carefully for security and compliance.

---

### Task 6 — Extracted website files on the EC2 instance

- In the SSH terminal I navigated to the activity files, extracted the static website archive, and verified the files were present.

Commands I ran:

cd ~/sysops-activity-files
tar xvzf static-website-v2.tar.gz
cd static-website
ls

I confirmed that index.html and the css and images directories were present.

Screenshot placeholder: `screenshots/extracted_website_files.png`

---

### Task 7 — Enabled website hosting and uploaded files using the AWS CLI

- I configured the bucket for static website hosting so the index document was index.html:

aws s3 website s3://<my-bucket>/ --index-document index.html

- I uploaded the website contents recursively and set the objects to public read so browsers could access the site:

aws s3 cp /home/ec2-user/sysops-activity-files/static-website/ s3://<my-bucket>/ --recursive --acl public-read

- I listed the bucket contents to verify the upload:

aws s3 ls s3://<my-bucket>/

- In the S3 console I opened the bucket Properties and confirmed that Static website hosting was Enabled and I opened the Bucket website endpoint URL to view the Café & Bakery site.

Screenshot placeholder: `screenshots/s3_website_enabled_and_upload.png`
Screenshot placeholder: `screenshots/cafe_website_initial_view.png`

---

### Task 8 — Created an update script to simplify future deployments

- I reviewed my shell history to find the exact aws s3 cp command I used and created an executable shell script `update-website.sh` in my home directory.

Commands I ran (examples):

history
cd ~
touch update-website.sh
vi update-website.sh

- In the editor I added the bash shebang and the s3 copy command (replacing `<my-bucket>` with the actual bucket name):

#!/bin/bash
aws s3 cp /home/ec2-user/sysops-activity-files/static-website/ s3://<my-bucket>/ --recursive --acl public-read

- I saved the file, made it executable, and used it to push updates after editing index.html.

Commands I ran:

chmod +x update-website.sh
./update-website.sh

- I edited the local index.html using vi to change background color values and re-ran the update script to push the change. I refreshed the site in the browser to confirm the update.

Screenshot placeholder: `screenshots/update_website_script_and_edit.png`
Screenshot placeholder: `screenshots/cafe_website_after_update.png`

---

## Troubleshooting notes

- If the bucket did not appear in the awsS3user console view, I refreshed the page and verified the user's permissions were correctly attached.
- If static website hosting did not appear enabled after running the CLI command, I verified the command syntax and region, and checked bucket properties in the console.
- If objects were inaccessible in the browser, I checked object ACLs and bucket public access settings, and I verified that the objects had public-read ACL set when uploaded.

Screenshot placeholder: `screenshots/troubleshooting_checks.png`

---

## Conclusion

I had successfully used the AWS CLI on an EC2 instance to create an S3 bucket, create an IAM user with S3 access, upload a static website to S3, enable static website hosting, and create a repeatable deployment script to update the website.

Recommended screenshots to capture and add to the repository:

- ssm_instance_connect.png
- aws_configure_and_identity.png
- s3_create_bucket_cli.png
- iam_create_user_and_attach_policy.png
- iam_signed_in_as_awsS3user.png
- s3_permissions_edit.png
- extracted_website_files.png
- s3_website_enabled_and_upload.png
- cafe_website_initial_view.png
- update_website_script_and_edit.png
- cafe_website_after_update.png
- troubleshooting_checks.png

---

*File created in the Labs/Compute Services folder as requested.*
