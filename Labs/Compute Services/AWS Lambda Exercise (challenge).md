# AWS Lambda Exercise (challenge)

## Lab journey

This document described the hands‑on journey taken while completing the "AWS Lambda Exercise (challenge)". The narrative was written in past tense to reflect the sequence of actions, decisions, and verifications that were performed. The challenge had required creating a Lambda function that counted words in a text file, wiring it to an S3 upload event, and sending the result via SNS.

---

## Lab overview

I created an AWS Lambda function that counted the number of words in a text file. The function was automatically invoked when a text file was uploaded to an S3 bucket, and it reported the count by publishing a message to an SNS topic (email subscription).

Screenshot placeholder: <img width="1536" height="1024" alt="AWS Lambda Word Count Architecture" src="https://github.com/user-attachments/assets/eac24482-74db-4ed5-98b5-519aa4cd21b8" />

---

## Objectives accomplished

By the end of the challenge I had completed the following:

- I created a Lambda function that counted words in a text file.
- I configured an S3 bucket to invoke the Lambda function on object create (PUT) events for text files.
- I created an SNS topic and subscribed an email endpoint to receive word count notifications.

---

## Duration

This challenge required approximately 90 minutes to complete.

---

## Walkthrough (journey)

The following steps narrated what I did during the challenge. Each important step included a placeholder for screenshots so results and console views could be documented.

### Step 1 — Preparation

- I selected a single AWS Region and created all resources (Lambda function, S3 bucket, SNS topic) in that Region to avoid cross‑region issues.

Screenshot placeholder: <img width="438" height="351" alt="Screenshot 2026-10-08 at 01 20 02" src="https://github.com/user-attachments/assets/d35c2cbb-c670-4cc4-b497-1667ded93f3e" />

- I confirmed that the pre‑existing IAM role `LambdaAccessRole` was available to use for the Lambda function. The lab policy did not permit creating a new role, so I used this role which had the required managed policies attached: `AWSLambdaBasicExecutionRole`, `AmazonSNSFullAccess`, `AmazonS3FullAccess`, and `CloudWatchFullAccess`.

Screenshot placeholder: <img width="820" height="492" alt="Screenshot 2026-09-10 at 19 30 19" src="https://github.com/user-attachments/assets/0a0ef2f3-6aa4-48a2-b0a0-87e2c8cbde4b" />
---

### Step 2 — Creating the Lambda function

- I opened the Lambda console and chose to author a new function from scratch using the Python runtime.
  - Function name: wordCountHandler
  - Runtime: Python 3.14
  - Execution role: Use an existing role → LambdaAccessRole

Screenshot placeholder: 
<img width="804" height="438" alt="Screenshot 2026-09-10 at 19 30 45" src="https://github.com/user-attachments/assets/d551fa7c-7c6c-43bb-ac25-65b2a7d03fd7" />

<img width="832" height="771" alt="Screenshot 2026-09-10 at 19 31 06" src="https://github.com/user-attachments/assets/ab5a2e62-20bd-487c-9353-155b8644f7d5" />



- I implemented the function logic in the inline editor (or uploaded a .zip) so that it:
  1. Received the S3 event and identified the uploaded object's bucket and key.
  2. Downloaded the text file from S3.
  3. Counted the words in the file (splitting on whitespace, trimming punctuation as needed).
  4. Published a message to an SNS topic with the subject "Word Count Result" and the body formatted like:

  The word count in the sample1.txt file was 15.

Screenshot placeholder: <img width="796" height="709" alt="Screenshot 2026-09-10 at 19 31 27" src="https://github.com/user-attachments/assets/538b91f6-7d30-4d8b-a03b-76790467059f" />

- Example (illustrative) Python function outline that I adapted:

````python name=example_word_count.py
import boto3
import urllib.parse

s3 = boto3.client('s3')
sns = boto3.client('sns')

TOPIC_ARN = 'arn:aws:sns:...:salesAnalysisReportTopic'  # replaced with actual ARN or Environment variable

def lambda_handler(event, context):
    # Extract bucket and key
    record = event['Records'][0]['s3']
    bucket = record['bucket']['name']
    key = urllib.parse.unquote_plus(record['object']['key'])

    obj = s3.get_object(Bucket=bucket, Key=key)
    text = obj['Body'].read().decode('utf-8')

    # Basic word count
    words = [w for w in text.split() if w.strip()]
    count = len(words)

    subject = 'Word Count Result'
    message = f"The word count in the {key} file was {count}."

    sns.publish(TopicArn=TOPIC_ARN, Subject=subject, Message=message)

    return { 'statusCode': 200, 'body': message }
````

Note: The code block above was illustrative; I recommended using an environment variable for the SNS topic ARN instead of hardcoding.

Screenshot placeholder: <img width="1601" height="724" alt="Screenshot 2026-09-10 at 19 32 20" src="https://github.com/user-attachments/assets/288a887c-3de5-481f-9df8-49aaebad66da" />

<img width="1313" height="640" alt="Screenshot 2026-09-10 at 19 32 59" src="https://github.com/user-attachments/assets/eb53ac0e-e3c2-4cf8-bbf4-092093a69e2c" />

<img width="714" height="69" alt="Screenshot 2026-09-10 at 19 38 20" src="https://github.com/user-attachments/assets/59ad17c4-b27e-4c0b-8249-d524d5c43eee" />

---

### Step 3 — Creating and configuring the SNS topic

- I created an SNS topic (Standard) named `WordCountTopic` and added an Email subscription for my inbox.

Screenshot placeholder: <img width="822" height="266" alt="Screenshot 2026-09-10 at 17 09 18" src="https://github.com/user-attachments/assets/9cff86be-07f9-4368-9c4e-26c601b7050b" />

<img width="803" height="443" alt="Screenshot 2026-09-10 at 19 01 31" src="https://github.com/user-attachments/assets/6b513e2e-c9a7-44bd-bf87-713fa85d6258" />


- I confirmed the subscription by clicking the confirmation link in the received email so the topic was active and ready to receive messages.

Screenshot placeholder: <img width="799" height="341" alt="Screenshot 2026-09-10 at 19 02 35" src="https://github.com/user-attachments/assets/10cf6a87-499e-42b9-ab53-de95655a07b8" />

<img width="246" height="158" alt="Screenshot 2026-09-10 at 19 05 54" src="https://github.com/user-attachments/assets/bbe7a83a-20ae-485f-b420-4c41287ccdd2" />


- I recorded the topic ARN and, in the Lambda function configuration, set an environment variable TOPIC_ARN (or passed the ARN directly in code) so the function could publish its results.

Screenshot placeholder: <img width="674" height="90" alt="Screenshot 2026-09-10 at 19 38 36" src="https://github.com/user-attachments/assets/b8a24440-6f04-4b98-a00c-2095779d5644" />

---

### Step 4 — Creating the S3 bucket and configuring the trigger

- I created an S3 bucket (unique name, same Region) to host the uploaded text files. I ensured public access settings were compatible with the lab policies and that the Lambda role had S3 read permissions.

Screenshot placeholder: <img width="818" height="556" alt="Screenshot 2026-09-10 at 19 15 48" src="https://github.com/user-attachments/assets/5daab411-440e-4de3-9ca9-486da35b17c3" />

<img width="423" height="156" alt="Screenshot 2026-09-10 at 19 15 59" src="https://github.com/user-attachments/assets/dc777d74-9d6d-4fec-a95b-e2dbb344df6d" />

<img width="834" height="716" alt="Screenshot 2026-09-10 at 19 16 17" src="https://github.com/user-attachments/assets/9471575a-9d56-47a5-a543-cab046da8cd7" />

- I configured an event notification on the bucket to invoke the Lambda function on the `s3:ObjectCreated:Put` event. I scoped the notification to a suffix (for example `.txt`) to ensure only text files triggered the function.

Screenshot placeholder: <img width="825" height="331" alt="Screenshot 2026-09-10 at 19 46 20" src="https://github.com/user-attachments/assets/464a4769-6caa-4b1c-b6e2-c718384ba164" />

<img width="781" height="214" alt="Screenshot 2026-09-10 at 19 46 31" src="https://github.com/user-attachments/assets/fb60dfd3-6527-40db-b08b-855cfaace8a6" />

<img width="777" height="198" alt="Screenshot 2026-09-10 at 19 46 47" src="https://github.com/user-attachments/assets/a169f02a-39d4-40ff-b14c-2648d14b6667" />

<img width="781" height="158" alt="Screenshot 2026-09-10 at 19 47 22" src="https://github.com/user-attachments/assets/3b5d92f5-d948-4598-85d0-525a6ae64bad" />

<img width="813" height="704" alt="Screenshot 2026-09-10 at 19 49 38" src="https://github.com/user-attachments/assets/83771838-9bd8-4c62-8608-6a80406b266f" />

---

### Step 5 — Testing the function

- I uploaded several sample text files with different word counts to the S3 bucket (for example `sample1.txt`, `sample2.txt`, `report.txt`).

Screenshot placeholder: <img width="827" height="523" alt="Screenshot 2026-09-10 at 20 01 58" src="https://github.com/user-attachments/assets/44b5ba0e-e86b-4885-8dc3-100f64043ba8" />



- After each upload I verified that the Lambda function executed (using the Lambda console) and that the SNS email arrived containing the formatted message.

Screenshot placeholder: <img width="873" height="320" alt="Screenshot 2026-09-10 at 20 14 56" src="https://github.com/user-attachments/assets/98840d1d-11a9-4b67-b70f-0005da03d6f6" />

- Example message content I observed:

  Subject: Word Count Result

  Body: The word count in the sample1.txt file was 147.

Screenshot placeholder: `<img width="899" height="275" alt="Screenshot 2026-09-10 at 20 17 13" src="https://github.com/user-attachments/assets/b3113c0c-90cb-4477-8a04-0f29592e7140" />

---

## Hints and troubleshooting notes

- I ensured all resources were created in the same Region to avoid invocation and permission issues.
- I used the provided `LambdaAccessRole` IAM role since the lab policy prevented creating roles. I verified it had the required managed policies attached.
- If the Lambda did not trigger on upload, I checked the S3 event notification configuration and CloudWatch Logs for invocation errors.
- If SNS emails did not arrive, I verified that the subscription was confirmed and that the SNS topic ARN used by the Lambda matched the created topic.

---

## Conclusion

I had successfully built and tested a complete pipeline that:

- Counted words in text files with a Python Lambda function.
- Used S3 object creation events to automatically invoke the function.
- Reported the result via SNS email with the subject "Word Count Result" and the message formatted as required.

Congratulations — the challenge was completed.

---

## Recommended filenames for screenshots

- architecture_overview.png
- console_region_selection.png
- iam_lambdaaccessrole.png
- create_lambda_function.png
- lambda_code_editor.png
- lambda_function_details.png
- sns_topic_create.png
- sns_subscription_confirmed.png
- environment_variable_topicarn.png
- s3_bucket_create.png
- s3_event_notification.png
- s3_upload_sample_files.png
- sns_email_wordcount.png
- lambda_execution_logs.png
- email_forward_example.png
- lambda_function_screenshot_for_instructor.png
- cloudwatch_logs_troubleshoot.png

---

*File created in the Labs/Compute Services folder as requested.*
