# Managing Storage

## Lab journey

This document described the hands‑on journey taken while completing the "Managing Storage" lab. The narrative was written in past tense to capture the sequence of actions, observations, and verifications that were performed. The lab used the AWS CLI and EC2 instances to create and manage EBS snapshots, schedule automated snapshot creation, and synchronize files from an EBS volume to an S3 bucket with versioning enabled.

---

## Lab overview

I managed EBS snapshots and synchronized data to Amazon S3. The environment included a VPC with public subnets and two EC2 instances named "Command Host" and "Processor." I used the Command Host to administer resources and the Processor to host the EBS volume whose contents I backed up and synchronized to S3.

Screenshot placeholder: `screenshots/architecture_diagram.png`

---

## Objectives accomplished

By the end of the lab I had done the following:

- Created and maintained snapshots for Amazon EC2 EBS volumes.
- Synchronized files from an EBS volume to an S3 bucket using aws s3 sync.
- Enabled S3 versioning and recovered deleted files from previous versions.

---

## Duration

This lab required approximately 45 minutes to complete.

---

## Walkthrough (journey)

The following sections narrated the actions I performed during the lab. Each important step included placeholders for screenshots so that key console views and terminal outputs could be captured.

### Task 1 — Creating and configuring resources

Task 1.1 — Created an S3 bucket

- I opened the S3 console and created a bucket to receive the synced files. I chose a unique name (referred to in the lab as `s3-bucket-name`) and left the default Region.

Screenshot placeholder: `screenshots/s3_create_bucket.png`

Task 1.2 — Attached an instance profile to Processor

- I opened the EC2 console, selected the Processor instance, and attached the pre-created IAM role `S3BucketAccess` via Actions > Security > Modify IAM role. This role allowed the Processor to interact with S3 and EBS as required.

Screenshot placeholder: `screenshots/ec2_modify_iam_role.png`

---

### Task 2 — Taking snapshots of the Processor instance

Task 2.1 — Connected to the Command Host

- I connected to the Command Host instance using EC2 Instance Connect. I used the in‑browser terminal to run AWS CLI commands for snapshot and scheduling tasks.

Screenshot placeholder: `screenshots/command_host_connect.png`

Task 2.2 — Identified the Processor volume and took an initial snapshot

- I retrieved the EBS VolumeId attached to the Processor by running a filtered describe-instances command and captured the VolumeId (for example `vol-1234abcd`).

Example command I ran:

aws ec2 describe-instances --filter 'Name=tag:Name,Values=Processor' --query 'Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.{VolumeId:VolumeId}'

Screenshot placeholder: `screenshots/describe_instances_volumeid.png`

- I retrieved the Processor instance ID, stopped the instance, and waited for it to reach the stopped state before creating a snapshot to ensure a consistent backup.

Commands I ran (examples):

aws ec2 describe-instances --filters 'Name=tag:Name,Values=Processor' --query 'Reservations[0].Instances[0].InstanceId'
aws ec2 stop-instances --instance-ids INSTANCE-ID
aws ec2 wait instance-stopped --instance-id INSTANCE-ID

- I created a snapshot of the identified volume and recorded the SnapshotId (for example `snap-0643809e73e6cce13`). I then waited for the snapshot to complete.

Command I ran:

aws ec2 create-snapshot --volume-id VOLUME-ID
aws ec2 wait snapshot-completed --snapshot-id SNAPSHOT-ID

Screenshot placeholder: `screenshots/create_snapshot_cli.png`

- After the snapshot completed I restarted the Processor instance:

aws ec2 start-instances --instance-ids INSTANCE-ID

Screenshot placeholder: `screenshots/start_processor_instance.png`

Task 2.3 — Scheduled automated snapshot creation (cron)

- For testing, I scheduled a cron job on the Command Host that created a snapshot of the volume every minute. I wrote a small cron file and installed it with crontab so that snapshots were created repeatedly.

Commands I ran (example):

echo "* * * * *  aws ec2 create-snapshot --volume-id VOLUME-ID 2>&1 >> /tmp/cronlog" > cronjob
crontab cronjob

- I observed multiple snapshots being created by running:

aws ec2 describe-snapshots --filters "Name=volume-id,Values=VOLUME-ID"

Screenshot placeholder: `screenshots/describe_snapshots_list.png`

Task 2.4 — Retained only the last two snapshots with a Python script

- After allowing several snapshots to be created, I stopped the cron job to prevent further snapshots:

crontab -r

- I inspected the provided Python script snapshotter_v2.py to understand its logic; the script enumerated snapshots per volume, sorted them by date, and deleted all but the two most recent snapshots.

Command I ran to view the script:

more /home/ec2-user/snapshotter_v2.py

Screenshot placeholder: `screenshots/snapshotter_script_preview.png`

- I listed the existing snapshot IDs for the volume to confirm there were multiple snapshots prior to cleanup:

aws ec2 describe-snapshots --filters "Name=volume-id, Values=VOLUME-ID" --query 'Snapshots[*].SnapshotId'

- I executed the script to prune snapshots to the latest two:

python3.8 snapshotter_v2.py

- The script reported the snapshots it deleted, and I then re-ran the describe-snapshots command to confirm only two SnapshotIds remained.

Screenshot placeholder: `screenshots/snapshotter_deleted_list.png`

---

### Task 3 — Challenge: Synchronize files with Amazon S3

Task 3.1 — Downloaded sample files on the Processor

- I connected to the Processor instance via EC2 Instance Connect and downloaded a zip archive of sample files with wget, then unzipped it.

Commands I ran:

wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-RSJAWS-3-124627/183-lab-JAWS-managing-storage/s3/files.zip
unzip files.zip

Screenshot placeholder: `screenshots/wget_unzip_files.png`

Task 3.2 — Activated versioning and synced files to S3

- I enabled versioning on the S3 bucket I created earlier so that deleted files could be recovered later:

aws s3api put-bucket-versioning --bucket S3-BUCKET-NAME --versioning-configuration Status=Enabled

Screenshot placeholder: `screenshots/enable_bucket_versioning.png`

- I synchronized the local files directory with the S3 bucket using aws s3 sync:

aws s3 sync files s3://S3-BUCKET-NAME/files/

- I verified the three files were present by listing the bucket prefix:

aws s3 ls s3://S3-BUCKET-NAME/files/

Screenshot placeholder: `screenshots/s3_sync_and_ls.png`

- I deleted a local file (for example `files/file1.txt`) and ran sync with the --delete option to remove the corresponding S3 object:

rm files/file1.txt
aws s3 sync files s3://S3-BUCKET-NAME/files/ --delete

- I confirmed the delete was reflected in the S3 listing and that a Delete marker or version was present in object versions.

Screenshot placeholder: `screenshots/s3_sync_delete_and_ls.png`

- To recover the deleted file, I used list-object-versions to find the previous VersionId and then downloaded that specific version with get-object:

aws s3api list-object-versions --bucket S3-BUCKET-NAME --prefix files/file1.txt
aws s3api get-object --bucket S3-BUCKET-NAME --key files/file1.txt --version-id VERSION-ID files/file1.txt

- I verified the file was restored locally and then re-synced the files directory to S3 so the recovered file became the latest version in the bucket.

aws s3 sync files s3://S3-BUCKET-NAME/files/
aws s3 ls s3://S3-BUCKET-NAME/files/

Screenshot placeholder: `screenshots/s3_recover_version_and_sync.png`

---

## Troubleshooting notes

- If snapshot creation failed, I verified the AWS CLI credentials and permissions and ensured the correct VolumeId and region were used.
- If cron jobs did not run, I examined /tmp/cronlog for errors and confirmed crond was running on the instance.
- If aws s3 sync did not reflect local changes, I checked the local path, S3 prefix, and used --delete to force deletes to propagate.
- If versioning was not enabled, I verified the bucket name and re-ran the put-bucket-versioning command.

Screenshot placeholder: `screenshots/troubleshooting_notes.png`

---

## Conclusion

I had successfully managed EBS snapshots (including automated snapshot creation and pruning), synchronized a directory from an EBS volume to an S3 bucket, and used S3 versioning to recover deleted files. These operations demonstrated practical backup and retention techniques for EBS and S3.

Recommended screenshot filenames to capture and add to the repository:

- architecture_diagram.png
- s3_create_bucket.png
- ec2_modify_iam_role.png
- command_host_connect.png
- describe_instances_volumeid.png
- create_snapshot_cli.png
- start_processor_instance.png
- describe_snapshots_list.png
- snapshotter_script_preview.png
- snapshotter_deleted_list.png
- wget_unzip_files.png
- enable_bucket_versioning.png
- s3_sync_and_ls.png
- s3_sync_delete_and_ls.png
- s3_recover_version_and_sync.png
- troubleshooting_notes.png

---

*File created in the Labs/Compute Services folder as requested.*
