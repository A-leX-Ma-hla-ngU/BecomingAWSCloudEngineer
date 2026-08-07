# Working with AWS Lambda

## Lab journey

This document described the step‑by‑step journey taken while completing the "Working with AWS Lambda" lab. The narrative was written in past tense to reflect the sequence of actions and decisions during the lab. The lab deployed and configured a serverless solution where a Lambda function generated a daily sales analysis report by pulling data from a MySQL database on an EC2 LAMP instance and emailing the results via Amazon SNS.

---

## Overview

I deployed a Lambda‑based serverless solution that generated a sales analysis report each day. The solution used:

- AWS Lambda (two functions: a report generator and a data extractor)
- AWS Systems Manager Parameter Store (to store DB connection information)
- Amazon EC2 (LAMP instance hosting the cafe database)
- Amazon SNS (to send the report by email)
- Amazon EventBridge / CloudWatch Events (to schedule the report)

Architecture diagram: (insert screenshot or diagram)

Screenshot placeholder: `screenshots/architecture_diagram.png`

---

## Objectives accomplished

I completed the following objectives during the lab:

- I identified the required IAM permissions for Lambda functions that accessed other AWS services.
- I created a Lambda layer to satisfy external (PyMySQL) dependencies.
- I created two Lambda functions: one to extract data and another to orchestrate the report and send notifications.
- I deployed and tested a scheduled Lambda function that invoked another function.
- I used CloudWatch Logs to troubleshoot and resolve a timeout/network issue.

---

## Duration

The lab required approximately 60 minutes to complete.

---

## Walkthrough (journey)

This section narrated the lab steps I followed, grouped into tasks. For each important step I left room for one or more screenshots.

### Task 1 — Observing IAM role settings

I inspected IAM roles before creating functions so I understood which permissions would be needed.

- I opened the IAM console and viewed Roles.
- I searched for roles containing `sales` and examined `salesAnalysisReportRole`.
  - I confirmed that `lambda.amazonaws.com` was a trusted entity under Trust relationships.
  - I reviewed the attached policies: `AmazonSNSFullAccess`, `AmazonSSMReadOnlyAccess`, `AWSLambdaBasicRunRole`, and `AWSLambdaRole`.

Screenshot placeholder: `screenshots/iam_salesAnalysisReportRole.png` — (showing Trust relationships and attached policies)

- I then inspected `salesAnalysisReportDERole` and confirmed it had `AWSLambdaBasicRunRole` and `AWSLambdaVPCAccessRunRole` attached so the function could write logs and attach to a VPC.

Screenshot placeholder: `screenshots/iam_salesAnalysisReportDERole.png` — (showing role policies)

---

### Task 2 — Creating a Lambda layer and data extractor function

I prepared and uploaded the library and the data extractor function.

- I downloaded the two provided zip files: `pymysql-v3.zip` and `salesAnalysisReportDataExtractor-v3.zip`.

- I created a Lambda layer named `pymysqlLibrary` and uploaded `pymysql-v3.zip` as version 1, selecting Python 3.9 as the compatible runtime.

Screenshot placeholder: `screenshots/lambda_layer_create.png` — (layer creation page with file uploaded)

- I created the `salesAnalysisReportDataExtractor` function (author from scratch, Python 3.9) and assigned the existing role `salesAnalysisReportDERole`.

Screenshot placeholder: `screenshots/create_data_extractor_function.png` — (function overview after creation)

- I added the `pymysqlLibrary` layer (version 1) to the function so it could import PyMySQL without bundling it in the deployment package.

Screenshot placeholder: `screenshots/add_layer_to_function.png` — (Layers panel showing the layer attached)

- I uploaded the `salesAnalysisReportDataExtractor-v3.zip` package, set the handler to `salesAnalysisReportDataExtractor.lambda_handler`, and reviewed the Python code in the console editor. The code expected the database connection info (dbURL, dbName, dbUser, dbPassword) in the event payload.

Screenshot placeholder: `screenshots/code_uploaded_data_extractor.png` — (code source panel showing the function file)

- I configured VPC settings for the function to allow it to reach the EC2 database. I selected the VPC named `Cafe VPC`, the `Cafe Public Subnet 1`, and the `CafeSecurityGroup` security group.

Screenshot placeholder: `screenshots/function_vpc_configuration.png` — (VPC configuration page)

---

### Task 3 — Testing and troubleshooting the data extractor

I tested the data extractor and resolved an initial timeout.

- I opened Systems Manager Parameter Store and copied the four parameters that stored the DB connection information: `/cafe/dbUrl`, `/cafe/dbName`, `/cafe/dbUser`, `/cafe/dbPassword`.

Screenshot placeholder: `screenshots/parameter_store_values.png` — (Parameter Store list and a parameter value)

- I configured a Lambda test event (`SARDETestEvent`) and supplied the DB parameters in the JSON event body.

Screenshot placeholder: `screenshots/lambda_test_event_configure.png` — (test event JSON editor showing db values)

- The first test produced a timeout error: "Task timed out after 3.00 seconds." I inspected the Execution result and CloudWatch log output to gather details.

Screenshot placeholder: `screenshots/lambda_timeout_error.png` — (execution result with timeout message)

- I analyzed the cause and found the function was unable to connect to the MySQL server on port 3306 because the EC2 instance security group did not allow inbound traffic on 3306 from the Lambda's security group or subnet.

- I updated the EC2 instance security group inbound rule to allow MySQL (TCP 3306) from the Lambda's security group (or the appropriate subnet range). After saving the change I tested the function again.

Screenshot placeholder: `screenshots/security_group_inbound_rule.png` — (Security Group inbound rules showing port 3306 allowed)

- After the security group update the test succeeded. The Lambda returned statusCode 200 and an empty body (because there were no orders yet).

Screenshot placeholder: `screenshots/lambda_execution_success.png` — (successful execution result)

---

### Task 3.4 — Populating the database and re-testing

I populated the database by placing sample orders on the café website.

- I located the public IP of the EC2 instance running the café app (`CafeInstance`) and opened the site at `http://<publicIP>/cafe`.

Screenshot placeholder: `screenshots/cafe_website_home.png` — (café website homepage)

- I placed several orders from the website Menu to create order rows in the `cafe_db` database.

Screenshot placeholder: `screenshots/cafe_place_order.png` — (placing an order on the website)

- I re-ran the `salesAnalysisReportDataExtractor` test and confirmed the returned JSON body included product quantity details.

Screenshot placeholder: `screenshots/data_extractor_output.png` — (Lambda output showing returned report data)

---

### Task 4 — Configuring notifications (SNS)

I created an SNS topic and subscribed an email endpoint.

- I created a Standard SNS topic named `salesAnalysisReportTopic` with display name `SARTopic` and saved the ARN for later.

Screenshot placeholder: `screenshots/sns_topic_create.png` — (SNS topic details with ARN visible)

- I created an Email subscription for my inbox and confirmed the subscription from the email link.

Screenshot placeholder: `screenshots/sns_subscription_confirmation.png` — (email showing subscription confirmation link)

---

### Task 5 — Creating the salesAnalysisReport Lambda function

I created and configured the orchestrator function that retrieved the DB parameters, invoked the extractor, formatted results, and published to SNS.

- I connected to the CLI Host EC2 instance using EC2 Instance Connect and ran `aws configure` to supply the access key, secret, region `us-west-2`, and output format `json`.

Screenshot placeholder: `screenshots/ec2_instance_connect_cli.png` — (terminal showing connection)

- From the activity-files directory on the CLI Host I confirmed `salesAnalysisReport-v2.zip` was present, retrieved the `salesAnalysisReportRole` ARN from IAM, and ran the `aws lambda create-function` command to create the function with Python 3.9 and handler `salesAnalysisReport.lambda_handler`.

Screenshot placeholder: `screenshots/aws_cli_create_function.png` — (CLI command and success response)

- I opened the function in the Lambda console, added an environment variable `topicARN` with the SNS ARN, and saved the configuration.

Screenshot placeholder: `screenshots/environment_variable_topicARN.png` — (Environment variables panel showing topicARN)

- I created a test event (`SARTestEvent`) and invoked the function. The first run succeeded (or, if it timed out due to cold start, I re-ran after increasing timeout). The function returned statusCode 200 and a body noting the report was sent.

Screenshot placeholder: `screenshots/report_lambda_success_email.png` — (execution result and sample email in inbox)

---

### Task 5.6 — Scheduling the report (CloudWatch Events / EventBridge)

I added an EventBridge rule as a trigger to run the `salesAnalysisReport` function Monday through Saturday at the scheduled UTC time.

- I added a trigger on the function using EventBridge and created a rule named `salesAnalysisReportDailyTrigger` with a cron schedule expression such as `cron(0 20 ? * MON-SAT *)` (adjusted for UTC to match 8 PM local target time as required).

Screenshot placeholder: `screenshots/add_trigger_eventbridge.png` — (Add trigger panel with schedule expression)

- I verified that an email arrived after the scheduled invocation.

Screenshot placeholder: `screenshots/scheduled_report_email.png` — (Scheduled report email in inbox)

---

## Troubleshooting notes

- The most common failure during this lab was a Lambda timeout caused by inability to reach the database. I resolved it by verifying VPC configuration and security group inbound rules (MySQL TCP 3306).
- CloudWatch Logs were essential for diagnosing the timeout. I confirmed that `AWSLambdaBasicRunRole` had been attached to functions so logs were writable.

Screenshot placeholder: `screenshots/cloudwatch_logs_example.png` — (CloudWatch Logs showing START/END/REPORT and the timeout)

---

## Conclusion

I had successfully deployed a small serverless pipeline that:

- Used a Lambda layer to share PyMySQL across functions.
- Used Parameter Store for secure database credentials.
- Ran a scheduled report that invoked a second function to extract data and published results via SNS.
- Used CloudWatch Logs and IAM role inspection to troubleshoot and fix connectivity/timeouts.

I left several screenshot placeholders in the `screenshots/` path. I recommended capturing the following images during or after lab runs and replacing the placeholder names with actual images in the repository:

- architecture_diagram.png
- iam_salesAnalysisReportRole.png
- iam_salesAnalysisReportDERole.png
- lambda_layer_create.png
- create_data_extractor_function.png
- add_layer_to_function.png
- code_uploaded_data_extractor.png
- function_vpc_configuration.png
- parameter_store_values.png
- lambda_test_event_configure.png
- lambda_timeout_error.png
- security_group_inbound_rule.png
- lambda_execution_success.png
- cafe_website_home.png
- cafe_place_order.png
- data_extractor_output.png
- sns_topic_create.png
- sns_subscription_confirmation.png
- ec2_instance_connect_cli.png
- aws_cli_create_function.png
- environment_variable_topicARN.png
- report_lambda_success_email.png
- add_trigger_eventbridge.png
- scheduled_report_email.png
- cloudwatch_logs_example.png

---

## Further reading

- AWS Lambda Developer Guide
- AWS Systems Manager Parameter Store documentation
- Amazon SNS User Guide
- Amazon EventBridge schedule expressions

---

*File created in the Labs/Compute Services directory as requested.*
