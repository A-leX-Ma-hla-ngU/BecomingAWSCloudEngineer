# AWS CloudWatch EC2 Monitoring and SNS Alerting

A CloudFormation project that monitors CPU utilization for an existing EC2 instance and sends notifications when the alarm changes state.

## Architecture

```text
Existing EC2 instance
        |
        | AWS/EC2 CPUUtilization metric
        v
Amazon CloudWatch Alarm
  - 5-minute periods
  - 2 consecutive breaching datapoints
  - configurable CPU threshold
        |
        | ALARM / OK state notification
        v
Amazon SNS Topic
        |
        v
Email subscription
```

## Resources created

- One Amazon CloudWatch alarm for the selected EC2 instance's `CPUUtilization` metric.
- One Amazon SNS topic.
- One email subscription to the SNS topic.

The project does not create an EC2 instance. You must provide an existing instance ID in the same AWS Region as the CloudFormation stack.

## Deploy

1. Choose a lab EC2 instance in the AWS Region where you will deploy the stack.
2. Confirm that the instance is running and producing standard EC2 metrics.
3. Validate the template:

   ```bash
   aws cloudformation validate-template --template-body file://template.yaml
   ```

4. Deploy, replacing the example values:

   ```bash
   aws cloudformation deploy \
     --template-file template.yaml \
     --stack-name portfolio-ec2-alerting \
     --parameter-overrides InstanceId=i-0123456789abcdef0 NotificationEmail=you@example.com CpuThreshold=70
   ```

5. Check your email and confirm the SNS subscription. Until confirmed, SNS will not deliver notifications to that address.
6. Open CloudWatch → Alarms and inspect the created alarm.

## Test the notification path

The alarm triggers only when CloudWatch receives CPU datapoints at or above the configured threshold for two consecutive five-minute periods. Do not run an uncontrolled stress test on a shared or production instance.

For a safe learning exercise, you can temporarily lower the threshold to a value that the instance's normal CPU metric will exceed, or use a disposable lab instance and a controlled workload. Restore the intended threshold after testing.

The template also sends a notification when the alarm returns to the OK state. Missing metric data is treated as not breaching to avoid false alarms when the instance is stopped or metrics are unavailable.

## Cost and cleanup

CloudWatch alarms and SNS notifications may incur charges depending on usage, region, and current AWS pricing. Review the current AWS pricing pages before deployment. Keep the stack for only as long as needed for the lab.

Delete the stack when finished:

```bash
aws cloudformation delete-stack --stack-name portfolio-ec2-alerting
aws cloudformation wait stack-delete-complete --stack-name portfolio-ec2-alerting
```

The stack deletion removes the alarm, SNS topic, and subscription. It does not delete the EC2 instance you supplied.

## Evidence to add after deployment

- CloudFormation stack status showing `CREATE_COMPLETE`.
- CloudWatch alarm details showing the instance dimension and threshold.
- Screenshot of the SNS email confirmation (hide your email address).
- Example alarm and OK notification with timestamps (redact personal information).

Do not claim the alert path has been tested until you receive and verify both notifications.
