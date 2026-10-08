# Challenge Lab — Amazon S3

## Lab journey

This document described the hands‑on journey taken while completing the "Challenge Lab — Amazon S3". The narrative was written in past tense to record the sequence of actions, observations, and verifications that were performed. The challenge required creating an S3 bucket, uploading an object, making the object publicly accessible, and listing contents with the AWS CLI.

---

## Lab overview

I created an Amazon S3 bucket, uploaded an object to it, made that object publicly accessible via a browser, and listed the bucket contents using the AWS CLI. The work was performed from the provided CLI Host EC2 instance using EC2 Instance Connect and the AWS CLI.

Screenshot placeholder: <img width="1312" height="1199" alt="AWS EC2 to S3 Access Flow" src="https://github.com/user-attachments/assets/077e882e-ef5b-4bb7-b45e-39283fa8fc04" />

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

Screenshot placeholder: 

<img width="831" height="716" alt="Screenshot 2026-07-29 at 11 36 06" src="https://github.com/user-attachments/assets/47f179c5-df85-4f40-b0ab-fe4b5bb124fb" />

<img width="835" height="348" alt="Screenshot 2026-07-29 at 11 36 35" src="https://github.com/user-attachments/assets/3fb9941d-d191-4d3d-aebe-dc0e9427ffec" />


---

### Task 2 — Configured the AWS CLI

- In the CLI Host terminal I ran aws configure and provided the lab credentials and default settings:
  - AWS Access Key ID: (pasted AccessKey)
  - AWS Secret Access Key: (pasted SecretKey)
  - Default region name: us-west-2
  - Default output format: json

- I verified the configuration by running aws sts get-caller-identity and confirming the returned account and ARN.
- Initially the congfiguration could not be verified due to a missing session token in the `~/.aws/credentials` folder which was replaced using Vim text editor. 

Screenshot placeholder: 

<img width="788" height="113" alt="Screenshot 2026-10-08 at 02 41 13" src="https://github.com/user-attachments/assets/a0760432-76da-40b1-b8a4-521f538650c4" />

<img width="741" height="48" alt="Screenshot 2026-10-08 at 02 39 10" src="https://github.com/user-attachments/assets/efffbe21-f9fa-4b1a-b35d-0132b3850552" />

<img width="284" height="615" alt="Screenshot 2026-10-08 at 02 39 25" src="https://github.com/user-attachments/assets/eb146d3f-f7e7-4682-ab53-f3c67acc4f01" />

<img width="358" height="137" alt="Screenshot 2026-10-08 at 02 39 37" src="https://github.com/user-attachments/assets/98ce3143-35c1-4c59-816a-f5afee33d748" />

<img width="228" height="87" alt="Screenshot 2026-10-08 at 02 40 20" src="https://github.com/user-attachments/assets/18d73ae2-707c-448e-8795-daecc8206bbb" />

<img width="911" height="193" alt="Screenshot 2026-07-29 at 11 54 40" src="https://github.com/user-attachments/assets/1f344128-d333-4f08-9fa1-0719a8911955" />


<img width="790" height="188" alt="Screenshot 2026-10-08 at 02 40 57" src="https://github.com/user-attachments/assets/79d1dcaa-5db4-43ec-b7ba-f2d3eafe10f1" />


---

### Task 3 — Created an S3 bucket and uploaded an object

- I selected a globally unique bucket name (for example: `cafe‑challenge‑123`) and created the bucket in the us-west-2 Region. Example CLI command I used:

  aws s3 mb s3://cafe-challenge-123 --region us-west-2

Screenshot placeholder: <img width="854" height="75" alt="Screenshot 2026-07-29 at 13 34 36" src="https://github.com/user-attachments/assets/e9af22ce-1a8c-497a-8fe5-20b678ae2bb6" />

<img width="918" height="54" alt="Screenshot 2026-07-29 at 13 53 59" src="https://github.com/user-attachments/assets/3897a4ea-aa39-4714-b07a-37ec49025599" />


- I uploaded a sample object (for example `hello.txt` or an image) to the bucket. Example CLI commands I used:

  aws s3 cp ~/sample-files/hello.txt s3://cafe-challenge-123/hello.txt

Screenshot placeholder: <img width="1677" height="545" alt="Screenshot 2026-07-29 at 14 07 20" src="https://github.com/user-attachments/assets/e14ab783-a848-4308-b766-af5c6b5195cf" />

- I listed the bucket contents to verify the object was present:

  aws s3 ls s3://cafe-challenge-123/ --human-readable --summarize

Screenshot placeholder: <img width="905" height="318" alt="Screenshot 2026-07-29 at 15 38 15" src="https://github.com/user-attachments/assets/bf8b4033-9705-4a7b-ba07-9760fc0b4685" />

---

### Task 4 — Made the object publicly accessible and accessed it in a browser

- I made the specific object public (object-level ACL) so it could be accessed via its S3 object URL. Example CLI command I used:

  aws s3api put-object-acl --bucket cafe-challenge-123 --key hello.txt --acl public-read

Screenshot placeholder: <img width="1663" height="771" alt="Screenshot 2026-07-29 at 15 03 24" src="https://github.com/user-attachments/assets/967d22b2-c956-44e6-8c28-645c90781ee0" />

<img width="912" height="417" alt="Screenshot 2026-07-29 at 15 14 05" src="https://github.com/user-attachments/assets/c42400ec-4be7-4fef-a835-27904244013a" />

<img width="888" height="619" alt="Screenshot 2026-07-29 at 15 16 03" src="https://github.com/user-attachments/assets/39e9e451-e062-43d9-b820-5d752d46c7cb" />

<img width="925" height="514" alt="Screenshot 2026-07-29 at 15 17 33" src="https://github.com/user-attachments/assets/3985e4a3-f75c-4760-b071-2dac0d0a7a04" />



- I then opened the object URL in a browser to confirm it was publicly accessible. The object URL format was:

  https://cafe-2129.s3.us-west-2.amazonaws.com/cake-vitrine.png

- The browser displayed the object content (or image) as expected.

Screenshot placeholder: <img width="909" height="696" alt="Screenshot 2026-07-29 at 15 35 26" src="https://github.com/user-attachments/assets/947c6221-597d-4648-ac77-e2211cbf5b06" />

Notes: For production environments or larger deployments, I preferred using pre-signed URLs or bucket policies rather than object ACLs to manage public access.

---

### Task 5 — Verified with the AWS CLI

- I re-ran aws s3 ls to confirm the object appeared in the bucket and used aws s3api head-object to check metadata if needed:

  aws s3api head-object --bucket cafe-2129 --key Cake-Vitrine.png

Screenshot placeholder: <img width="905" height="318" alt="Screenshot 2026-07-29 at 15 38 15" src="https://github.com/user-attachments/assets/b4d1cc34-3206-4d76-b9dd-81b05639c975" />
---

## Troubleshooting notes

- If the object remained inaccessible in the browser after applying the ACL, I checked the bucket public access block settings in the S3 console and ensured that Block Public Access settings did not prevent the object ACL from taking effect.
- If the object URL returned a 403 error, I verified the bucket name, object key, and ACL; I also inspected any applicable bucket policy that could override object ACLs.
- If aws configure failed, I rechecked the AccessKey/SecretKey values and region setting.


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
