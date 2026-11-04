# Activity — Troubleshoot CloudFormation

## Lab journey

This document recorded my hands-on work in the **Activity — Troubleshoot CloudFormation** lab. I practiced querying JSON with JMESPath, diagnosed a failed AWS CloudFormation stack deployment, detected drift after a manual change, and resolved a failed stack deletion while retaining an S3 bucket and its object.

> **Duration:** Approximately 75 minutes
>
> **Environment:** AWS Academy lab account, a provided CLI Host EC2 instance, and the AWS CLI.

## Objectives completed

By the end of the activity, I had:

- Queried JSON-formatted data with JMESPath expressions.
- Used AWS CLI commands to create and inspect a CloudFormation stack.
- Diagnosed a failed deployment by reading EC2 cloud-init logs.
- Corrected a user-data package name and created the stack successfully.
- Modified a security group outside CloudFormation and detected drift.
- Retained a populated S3 bucket while deleting the CloudFormation stack.

## Task 1 — Practiced JMESPath

I used the JMESPath website to query sample dessert data. I selected array elements by index, retrieved selected attributes, projected values across the array, and filtered objects by a condition. I then queried a sample CloudFormation resource list to return the logical ID of an EC2 instance:

```text
StackResources[?ResourceType == 'AWS::EC2::Instance'].LogicalResourceId
```

This practice helped me understand the `--query` expressions used in subsequent AWS CLI commands.

**Screenshot placeholder:** JMESPath query results for the dessert document and CloudFormation resource example.

## Task 2 — Troubleshot the CloudFormation deployment

### Connected to the CLI Host and configured the AWS CLI

I connected to the provided CLI Host using SSH and the lab-provided key. I discovered the instance's AWS Region from instance metadata, then configured the AWS CLI with the temporary lab credentials, Region, and JSON output format. I did not include credentials in this document.

```bash
curl http://169.254.169.254/latest/dynamic/instance-identity/document | grep region
aws configure
```

**Screenshot placeholder:** CLI Host terminal showing the Region lookup and AWS CLI configuration (with all credentials obscured).

### Observed the first stack failure

I inspected `template1.yaml` and attempted to create the `myStack` stack. The first attempt rolled back because its `WaitCondition` did not receive a success signal. The stack events showed that the wait condition had timed out.

```bash
aws cloudformation create-stack \
  --stack-name myStack \
  --template-body file://template1.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters ParameterKey=KeyName,ParameterValue=vockey

aws cloudformation describe-stack-events \
  --stack-name myStack \
  --query "StackEvents[?ResourceStatus == 'CREATE_FAILED']"
```

After the rollback completed, I deleted the failed stack object so I could retry with the template and failure behavior adjusted.

**Screenshot placeholder:** CloudFormation `CREATE_FAILED` event showing the wait-condition timeout.

### Prevented rollback and inspected the instance logs

I created the stack again with `--on-failure DO_NOTHING`. This left the successfully created resources available for investigation after the wait condition failed. I found the Web Server instance's public IP with the EC2 CLI, connected to it over SSH, and inspected the cloud-init output and user-data script.

```bash
aws cloudformation create-stack \
  --stack-name myStack \
  --template-body file://template1.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --on-failure DO_NOTHING \
  --parameters ParameterKey=KeyName,ParameterValue=vockey

aws ec2 describe-instances \
  --filters "Name=tag:Name,Values='Web Server'" \
  --query 'Reservations[].Instances[].[State.Name,PublicIpAddress]'
```

On the Web Server instance, I checked the end of the cloud-init log and the generated user-data script:

```bash
tail -50 /var/log/cloud-init-output.log
sudo cat /var/lib/cloud/instance/scripts/part-001
```

The log reported `No package http available`. The user-data script had attempted to install `http`, and its `-e` option had stopped the script when that command failed. Consequently, the script never sent the signal required by the `WaitCondition`.

**Screenshot placeholder:** Cloud-init log showing the package error and the relevant user-data script line. The image should not expose credentials or public IP addresses.

### Corrected the template and created the stack successfully

I changed the package name in `template1.yaml` from `http` to `httpd`, verified the change, deleted the failed stack, and created it again. The stack then reached `CREATE_COMPLETE`, and I verified the web server response using its public IP address.

```bash
# The template's user-data install command was changed to:
yum install -y httpd

aws cloudformation delete-stack --stack-name myStack

aws cloudformation create-stack \
  --stack-name myStack \
  --template-body file://template1.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --on-failure DO_NOTHING \
  --parameters ParameterKey=KeyName,ParameterValue=vockey

aws cloudformation describe-stacks --stack-name myStack --output table
```

**Screenshot placeholder:** Successful `CREATE_COMPLETE` stack output, including outputs with sensitive details obscured.

**Screenshot placeholder:** Browser displaying `Hello from your web server!`.

## Task 3 — Changed a resource and detected drift

I changed the WebServerSG inbound SSH rule in the AWS Management Console so it allowed access from my IP instead of the template's `0.0.0.0/0` CIDR. From the CLI Host, I looked up the stack-created bucket name, created an empty file, copied it to the bucket, and confirmed the object was present.

```bash
bucketName=$(aws cloudformation describe-stacks \
  --stack-name myStack \
  --query "Stacks[*].Outputs[?OutputKey == 'BucketName'].[OutputValue]" \
  --output text)
echo "bucketName = $bucketName"

touch myfile
aws s3 cp myfile "s3://$bucketName/"
aws s3 ls "$bucketName/"
```

I started drift detection and checked its status. The stack was reported as `DRIFTED`. A JMESPath query made the resource statuses easier to review, and the security group showed `MODIFIED`. The S3 bucket remained `IN_SYNC` because adding an object did not change a property tracked by CloudFormation drift detection.

```bash
aws cloudformation detect-stack-drift --stack-name myStack

aws cloudformation describe-stack-resources \
  --stack-name myStack \
  --query 'StackResources[*].[ResourceType,ResourceStatus,DriftInformation.StackResourceDriftStatus]' \
  --output table

aws cloudformation describe-stack-resource-drifts \
  --stack-name myStack \
  --stack-resource-drift-status-filters MODIFIED
```

The drift details showed that the actual SSH source differed from the template. I also attempted `update-stack`; the attempt did not automatically resolve the out-of-band security-group change.

**Screenshot placeholder:** Security-group inbound rule showing the manually changed SSH source (with the IP address obscured).

**Screenshot placeholder:** Drift-detection status and filtered resource output showing the modified security group.

**Screenshot placeholder:** S3 listing showing `myfile` in the bucket (bucket name may be obscured).

## Task 4 — Retained the bucket and deleted the stack

I attempted to delete `myStack`. CloudFormation deleted the other resources but could not delete `MyBucket` because it contained an object, leaving the stack in `DELETE_FAILED`.

To keep the bucket and its object while completing stack deletion, I retrieved the bucket's CloudFormation logical resource ID and passed it to the `--retain-resources` option. The JMESPath expression returned only the logical ID for the S3 bucket:

```bash
aws cloudformation describe-stack-resources \
  --stack-name myStack \
  --query "StackResources[?ResourceType=='AWS::S3::Bucket'].LogicalResourceId" \
  --output text
```

The bucket's logical ID was `MyBucket`. I retained that resource during deletion:

```bash
aws cloudformation delete-stack \
  --stack-name myStack \
  --retain-resources MyBucket
```

I waited for deletion to finish, confirmed that the stack reached `DELETE_COMPLETE`, and verified that the retained bucket and its object remained. The bucket was no longer managed by the deleted stack.

**Screenshot placeholder:** `DELETE_FAILED` status and the S3 bucket deletion reason.

**Screenshot placeholder:** AWS CLI command retaining `MyBucket` and final `DELETE_COMPLETE` status.

**Screenshot placeholder:** S3 listing confirming that the bucket and `myfile` remained after stack deletion.

## Key takeaways

- A CloudFormation wait-condition timeout can be a symptom of an earlier user-data failure; inspecting cloud-init logs helped me find the root cause.
- `--on-failure DO_NOTHING` preserved created resources for troubleshooting after a failed create operation.
- CloudFormation drift detection identified the manual security-group change, while the uploaded S3 object did not count as resource-property drift.
- `delete-stack --retain-resources` allowed me to remove the stack while preserving the populated bucket and its data.
- JMESPath queries helped me filter stack events, outputs, and resources to the information I needed.

## Completion

I completed the lab by troubleshooting the deployment, correcting the template, detecting drift, and deleting the stack while retaining the bucket and its object. I ended the lab environment after confirming the final results.
