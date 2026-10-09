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

Screenshot placeholder: <img width="708" height="338" alt="Screenshot 2026-10-09 at 02 32 57" src="https://github.com/user-attachments/assets/f2b02668-92cf-40a4-8c1f-577d78113598" />

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

Screenshot placeholder: <img width="777" height="684" alt="Screenshot 2026-10-09 at 02 42 01" src="https://github.com/user-attachments/assets/fbaf286e-a96b-44d3-a692-38e491fc28bb" />

<img width="789" height="323" alt="Screenshot 2026-10-09 at 02 42 22" src="https://github.com/user-attachments/assets/6a2cb546-1a89-4990-a568-08a485ae661b" />

<img width="374" height="104" alt="Screenshot 2026-07-01 at 18 20 03" src="https://github.com/user-attachments/assets/4c7996fa-5d89-4b63-bfaf-bb59f6e765c4" />

---

### Task 2 — Configured the AWS CLI

- I ran aws configure in the SSH session and entered the credentials provided in the lab: AccessKey, SecretKey, region `us-west-2`, and output format `json`.
- I verified the configuration by running aws sts get-caller-identity and confirming the returned account and ARN.

Screenshot placeholder: <img width="585" height="142" alt="Screenshot 2026-10-09 at 02 50 19" src="https://github.com/user-attachments/assets/db08ac66-bac1-4394-9024-927e4edafc2c" />

<img width="790" height="178" alt="Screenshot 2026-10-09 at 02 52 38" src="https://github.com/user-attachments/assets/620e11ae-246b-40f7-b845-310473cb2f76" />


---

### Task 3 — Created an S3 bucket using the AWS CLI

- I chose a globally unique bucket name (for example: twhitlock256) and created the bucket in the us-west-2 Region with the following command:

aws s3api create-bucket --bucket <my-bucket> --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2

- I verified the command returned a JSON Location entry indicating the bucket URL.

Screenshot placeholder: <img width="750" height="153" alt="Screenshot 2026-07-01 at 18 28 56" src="https://github.com/user-attachments/assets/d1b66f5e-c279-4545-a6c5-dbdf762af264" />

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

Screenshot placeholder: <img width="691" height="160" alt="Screenshot 2026-07-01 at 18 36 38" src="https://github.com/user-attachments/assets/e87a0ab0-94e3-46ad-bd5d-123a9a6e0abe" />

<img width="767" height="174" alt="Screenshot 2026-07-01 at 18 38 29" src="https://github.com/user-attachments/assets/8b688903-a6ee-4504-bd8f-02fd20f24824" />


- I signed out of the Management Console and signed back in as the new IAM user to confirm the sign‑in worked and to inspect the S3 console as the new user.

Screenshot placeholder: <img width="381" height="312" alt="Screenshot 2026-07-01 at 18 43 10" src="https://github.com/user-attachments/assets/0133382a-aa12-4681-97a0-b44aeea50ea2" />

<img width="731" height="488" alt="Screenshot 2026-07-01 at 18 46 05" src="https://github.com/user-attachments/assets/a5630b06-4787-4465-83eb-88ffe64bcc39" />

<img width="764" height="428" alt="Screenshot 2026-07-01 at 18 46 33" src="https://github.com/user-attachments/assets/26ff65cf-661d-4d8f-bb15-c269ac6f0552" />



Notes: In the lab I copied the 12‑digit AWS Account ID when required and confirmed that the awsS3user could see the S3 console (permissions were granted by the attached managed policy).

---

### Task 5 — Adjusted bucket permissions for public website hosting

- I opened the S3 bucket's Permissions tab in the console and edited Block Public Access to disable the setting that blocked all public access.
- I changed Object Ownership to enable ACLs if the lab required ACL-based public access and acknowledged the change.

Screenshot placeholder: <img width="801" height="466" alt="Screenshot 2026-07-01 at 19 20 43" src="https://github.com/user-attachments/assets/c9de6821-a9c0-499a-b28c-76d6c01bff77" />

<img width="1680" height="1050" alt="Screenshot 2026-07-01 at 19 36 53" src="https://github.com/user-attachments/assets/6d5b647a-643d-48be-9455-8a7419c7a7e2" />

<img width="780" height="677" alt="Screenshot 2026-07-01 at 20 36 36" src="https://github.com/user-attachments/assets/e9715edb-62b3-4a41-a099-ecf4f3cc93b6" />

<img width="759" height="654" alt="Screenshot 2026-07-01 at 20 37 06" src="https://github.com/user-attachments/assets/87c48227-1ab4-4b86-b4ca-ee80cb89e501" />

<img width="773" height="383" alt="Screenshot 2026-07-01 at 20 37 30" src="https://github.com/user-attachments/assets/50c45f6f-fec8-4145-a653-677fed513f0e" />

<img width="779" height="309" alt="Screenshot 2026-07-01 at 20 37 49" src="https://github.com/user-attachments/assets/aeb0d802-8393-4cb3-b0b0-864755562cc2" />

<img width="793" height="561" alt="Screenshot 2026-07-01 at 20 39 12" src="https://github.com/user-attachments/assets/7bddba93-6f7f-4e54-bee3-10f6bb2e3eaf" />

<img width="727" height="405" alt="Screenshot 2026-07-01 at 20 41 33" src="https://github.com/user-attachments/assets/15391d57-6cf8-4b32-8e2d-295ec0a0ac72" />

<img width="799" height="286" alt="Screenshot 2026-07-01 at 20 42 02" src="https://github.com/user-attachments/assets/d2de8c00-57e0-4373-b1c8-2d0437896fbf" />

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

Screenshot placeholder: <img width="657" height="56" alt="Screenshot 2026-07-01 at 20 46 11" src="https://github.com/user-attachments/assets/5bfc5bee-5f67-4be7-a448-b6ea82099f7d" />

<img width="869" height="59" alt="Screenshot 2026-07-01 at 20 49 22" src="https://github.com/user-attachments/assets/3ef8778d-3cd3-464c-95b8-8735ef1552c8" />

<img width="870" height="367" alt="Screenshot 2026-07-01 at 20 49 51" src="https://github.com/user-attachments/assets/09621067-2752-4039-a9b1-ba3ffa3084d9" />

<img width="798" height="61" alt="Screenshot 2026-07-01 at 20 51 55" src="https://github.com/user-attachments/assets/995adbec-2472-4784-8004-bb88422c18bd" />

<img width="613" height="76" alt="Screenshot 2026-07-01 at 20 52 14" src="https://github.com/user-attachments/assets/39ca0967-d890-491b-9c83-77f86aa03828" />

---

### Task 7 — Enabled website hosting and uploaded files using the AWS CLI

- I configured the bucket for static website hosting so the index document was index.html:

aws s3 website s3://<my-bucket>/ --index-document index.html

- I uploaded the website contents recursively and set the objects to public read so browsers could access the site:

aws s3 cp /home/ec2-user/sysops-activity-files/static-website/ s3://<my-bucket>/ --recursive --acl public-read

- I listed the bucket contents to verify the upload:

aws s3 ls s3://<my-bucket>/

- In the S3 console I opened the bucket Properties and confirmed that Static website hosting was Enabled and I opened the Bucket website endpoint URL to view the Café & Bakery site.

Screenshot placeholder: <img width="772" height="381" alt="Screenshot 2026-07-01 at 20 59 59" src="https://github.com/user-attachments/assets/e697d5da-c8f7-44af-9dda-d7a2067c2fdf" />
<img width="292" height="318" alt="Screenshot 2026-07-01 at 21 02 20" src="https://github.com/user-attachments/assets/b91951b0-20f1-4445-81cf-08e63fdebbdb" />

Screenshot placeholder: <img width="757" height="143" alt="Screenshot 2026-07-01 at 21 02 59" src="https://github.com/user-attachments/assets/543318aa-ced9-4a8b-96bb-1f05e7404741" />

<img width="1680" height="1050" alt="Screenshot 2026-07-01 at 21 07 17" src="https://github.com/user-attachments/assets/868c03cd-b31d-4786-a8ec-0aae9767e8fe" />


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

Screenshot placeholder: <img width="840" height="753" alt="Screenshot 2026-07-01 at 21 21 00" src="https://github.com/user-attachments/assets/ee0cdc0a-7305-4064-b23b-8ac0dfbc709c" />

Screenshot placeholder: <img width="838" height="56" alt="Screenshot 2026-07-01 at 21 30 41" src="https://github.com/user-attachments/assets/f46a8735-9f62-4304-a45d-86a433b79a68" />

<img width="823" height="158" alt="Screenshot 2026-07-01 at 21 36 25" src="https://github.com/user-attachments/assets/8601509e-21fe-492a-aa04-c0abe34de223" />

<img width="842" height="746" alt="Screenshot 2026-07-01 at 21 38 14" src="https://github.com/user-attachments/assets/e657a7bf-b562-42ef-8b58-b3817ab9b4ed" />

<img width="847" height="755" alt="Screenshot 2026-07-01 at 21 38 39" src="https://github.com/user-attachments/assets/e9161c47-5027-4cf0-940e-a593fdc91662" />

<img width="626" height="44" alt="Screenshot 2026-07-01 at 21 39 06" src="https://github.com/user-attachments/assets/79854c60-09de-4b89-a97d-9d6cdc192267" />

<img width="854" height="544" alt="Screenshot 2026-07-01 at 21 39 20" src="https://github.com/user-attachments/assets/0e7174a7-f206-444a-912a-1d9cfdecb24d" />

<img width="495" height="43" alt="Screenshot 2026-07-01 at 21 40 58" src="https://github.com/user-attachments/assets/57848328-998b-4f04-897f-99ccb44689ef" />


<img width="1680" height="1050" alt="Screenshot 2026-07-01 at 21 40 26" src="https://github.com/user-attachments/assets/a3492417-766f-4f82-8ee3-744d5e1329d5" />

<img width="1680" height="1050" alt="Screenshot 2026-07-01 at 21 40 33" src="https://github.com/user-attachments/assets/460ff5a4-85b1-4484-86b4-33ee40ff0ad0" />


---

## Troubleshooting notes

- If the bucket did not appear in the awsS3user console view, I refreshed the page and verified the user's permissions were correctly attached.
- If static website hosting did not appear enabled after running the CLI command, I verified the command syntax and region, and checked bucket properties in the console.
- If objects were inaccessible in the browser, I checked object ACLs and bucket public access settings, and I verified that the objects had public-read ACL set when uploaded.

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
