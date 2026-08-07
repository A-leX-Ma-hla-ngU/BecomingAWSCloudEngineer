# AWS Lambda Exercise (challenge)

## Lab journey

This document described the hands‑on journey taken while completing the "AWS Lambda Exercise (challenge)". The narrative was written in past tense to reflect the sequence of actions, decisions, and verifications that were performed. The challenge had required creating a Lambda function that counted words in a text file, wiring it to an S3 upload event, and sending the result via SNS.

---

## Lab overview

I created an AWS Lambda function that counted the number of words in a text file. The function was automatically invoked when a text file was uploaded to an S3 bucket, and it reported the count by publishing a message to an SNS topic (email subscription).

Screenshot placeholder: `screenshots/architecture_overview.png`

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

Screenshot placeholder: `screenshots/console_region_selection.png`

- I confirmed that the pre‑existing IAM role `LambdaAccessRole` was available to use for the Lambda function. The lab policy did not permit creating a new role, so I used this role which had the required managed policies attached: `AWSLambdaBasicExecutionRole`, `AmazonSNSFullAccess`, `AmazonS3FullAccess`, and `CloudWatchFullAccess`.

Screenshot placeholder: `screenshots/iam_lambdaaccessrole.png`

---

### Step 2 — Creating the Lambda function

- I opened the Lambda console and chose to author a new function from scratch using the Python runtime.
  - Function name: wordCountHandler
  - Runtime: Python 3.9 (or later, depending on availability)
  - Execution role: Use an existing role → LambdaAccessRole

Screenshot placeholder: `screenshots/create_lambda_function.png`

- I implemented the function logic in the inline editor (or uploaded a .zip) so that it:
  1. Received the S3 event and identified the uploaded object's bucket and key.
  2. Downloaded the text file from S3.
  3. Counted the words in the file (splitting on whitespace, trimming punctuation as needed).
  4. Published a message to an SNS topic with the subject "Word Count Result" and the body formatted like:

  The word count in the <textFileName> file was nnn.

Screenshot placeholder: `screenshots/lambda_code_editor.png`

- Example (illustrative) Python function outline that I used or adapted:

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

Screenshot placeholder: `screenshots/lambda_function_details.png`

---

### Step 3 — Creating and configuring the SNS topic

- I created an SNS topic (Standard) named `WordCountTopic` and added an Email subscription for my inbox.

Screenshot placeholder: `screenshots/sns_topic_create.png`

- I confirmed the subscription by clicking the confirmation link in the received email so the topic was active and ready to receive messages.

Screenshot placeholder: `screenshots/sns_subscription_confirmed.png`

- I recorded the topic ARN and, in the Lambda function configuration, set an environment variable TOPIC_ARN (or passed the ARN directly in code) so the function could publish its results.

Screenshot placeholder: `screenshots/environment_variable_topicarn.png`

---

### Step 4 — Creating the S3 bucket and configuring the trigger

- I created an S3 bucket (unique name, same Region) to host the uploaded text files. I ensured public access settings were compatible with the lab policies and that the Lambda role had S3 read permissions.

Screenshot placeholder: `screenshots/s3_bucket_create.png`

- I configured an event notification on the bucket to invoke the Lambda function on the `s3:ObjectCreated:Put` event. I scoped the notification to a prefix or suffix (for example `.txt`) to ensure only text files triggered the function.

Screenshot placeholder: `screenshots/s3_event_notification.png`

---

### Step 5 — Testing the function

- I uploaded several sample text files with different word counts to the S3 bucket (for example `sample1.txt`, `lorem_ipsum.txt`, `report.txt`).

Screenshot placeholder: `screenshots/s3_upload_sample_files.png`

- After each upload I verified that the Lambda function executed (using the Lambda console or CloudWatch Logs) and that the SNS email arrived containing the formatted message.

Screenshot placeholder: `screenshots/sns_email_wordcount.png`

- Example message content I observed:

  Subject: Word Count Result

  Body: The word count in the sample1.txt file was 147.

Screenshot placeholder: `screenshots/lambda_execution_logs.png`

---

### Step 6 — Deliverables

- I saved an email produced by one of my tests and captured a screenshot of the Lambda function console (showing function configuration and the last successful invocation). I prepared these for submission to the instructor.

Screenshot placeholder: `screenshots/email_forward_example.png`
Screenshot placeholder: `screenshots/lambda_function_screenshot_for_instructor.png`

---

## Hints and troubleshooting notes

- I ensured all resources were created in the same Region to avoid invocation and permission issues.
- I used the provided `LambdaAccessRole` IAM role since the lab policy prevented creating roles. I verified it had the required managed policies attached.
- If the Lambda did not trigger on upload, I checked the S3 event notification configuration and CloudWatch Logs for invocation errors.
- If SNS emails did not arrive, I verified that the subscription was confirmed and that the SNS topic ARN used by the Lambda matched the created topic.

Screenshot placeholder: `screenshots/cloudwatch_logs_troubleshoot.png`

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
