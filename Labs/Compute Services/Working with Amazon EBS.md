# Working with Amazon EBS

## Lab journey

This document described the step‑by‑step journey taken while completing the "Working with Amazon EBS" lab. The narrative was written in past tense to record the sequence of actions, observations, and verifications that were performed. The lab demonstrated how to create an Amazon EBS volume, attach and mount it on an EC2 instance, create a snapshot, and restore a volume from that snapshot.

---

## Lab overview

I worked with Amazon Elastic Block Store (EBS) to create block storage, attach it to an EC2 instance, format and mount the volume, and perform snapshot and restore operations. The lab covered:

- Creating a new EBS volume (gp2), tagging it, and ensuring it was in the same Availability Zone as the instance.
- Attaching the volume to the Lab EC2 instance and mounting it at /mnt/data-store.
- Creating a small file on the volume, taking an EBS snapshot, deleting the file, then restoring a new volume from the snapshot and verifying the file was present.

Screenshot placeholder: `screenshots/ebs_architecture_diagram.png`

---

## Objectives accomplished

By the end of the lab I had done the following:

- Created an EBS volume.
- Attached and mounted an EBS volume to an EC2 instance.
- Created a snapshot of an EBS volume.
- Created an EBS volume from a snapshot and verified data restoration.

---

## Duration

This lab required approximately 45 minutes to complete.

---

## Walkthrough (journey)

The following sections narrated the actions I performed during the lab. Each important step included a placeholder for screenshots so that the key console views and terminal outputs could be documented.

### Task 1 — Creating a new EBS volume

- I opened the EC2 Management Console and navigated to Instances to locate the pre‑launched Lab instance. I noted its Availability Zone (for example `us-west-2a`).

Screenshot placeholder: `screenshots/ec2_instances_lab_instance.png`

- I selected Elastic Block Store → Volumes and clicked Create volume.
  - Volume type: General Purpose SSD (gp2)
  - Size: 1 GiB (small size used for the lab)
  - Availability Zone: the same AZ as the Lab instance (e.g., us-west-2a)
  - Tag: Name = My Volume

- I created the volume and refreshed the Volumes list until the new volume's state changed from Creating to Available.

Screenshot placeholder: `screenshots/ebs_create_volume.png`

---

### Task 2 — Attaching the volume to the EC2 instance

- I selected the newly created volume (My Volume), chose Actions → Attach volume, and selected the Lab instance.
  - I specified the device name `/dev/sdb` because the later commands used that device path.

- After attaching, the volume state changed to In‑use.

Screenshot placeholder: `screenshots/ebs_attach_volume.png`

---

### Task 3 — Connecting to the Lab EC2 instance

- I connected to the Lab instance using EC2 Instance Connect (Connect → EC2 Instance Connect → Connect), which opened an in‑browser terminal.

Screenshot placeholder: `screenshots/ec2_instance_connect_terminal.png`

- I used this terminal for the filesystem creation and mounting steps that followed.

---

### Task 4 — Creating and configuring the file system

- I checked existing storage devices with df -h to confirm the instance's current disks and that the new volume did not yet appear.

Screenshot placeholder: `screenshots/df_before_mount.png`

- I created an ext3 filesystem on the attached device and mounted it:

Commands I ran in the terminal:

sudo mkfs -t ext3 /dev/sdb
sudo mkdir -p /mnt/data-store
sudo mount /dev/sdb /mnt/data-store

- I added an /etc/fstab entry so the volume would be mounted automatically after instance reboots:

echo "/dev/sdb   /mnt/data-store ext3 defaults,noatime 1 2" | sudo tee -a /etc/fstab

- I checked /etc/fstab to confirm the new entry and re‑ran df -h to confirm the device was mounted at /mnt/data-store.

Commands and checks:

cat /etc/fstab
df -h

Screenshot placeholder: `screenshots/mount_and_fstab.png`

- I created a file on the new volume and verified its contents:

sudo sh -c "echo some text has been written > /mnt/data-store/file.txt"
cat /mnt/data-store/file.txt

Screenshot placeholder: `screenshots/file_written_on_volume.png`

---

### Task 5 — Creating an Amazon EBS snapshot

- In the EC2 console I navigated to Volumes, selected My Volume, and chose Actions → Create snapshot.
  - I tagged the snapshot: Name = My Snapshot.

- I opened Snapshots and watched the snapshot's status change from Pending to Completed.

Screenshot placeholder: `screenshots/ebs_create_snapshot.png`

- Back in the instance terminal I deleted the file I created earlier and verified it was removed:

sudo rm /mnt/data-store/file.txt
ls /mnt/data-store/file.txt  # expected: No such file or directory

Screenshot placeholder: `screenshots/file_deleted_after_snapshot.png`

---

### Task 6 — Restoring the EBS snapshot

Task 6.1 — Creating a volume from the snapshot

- I selected the snapshot in the EC2 console and chose Actions → Create volume from snapshot.
  - I selected the same Availability Zone as the Lab instance.
  - I added a tag: Name = Restored Volume.

- I created the volume and refreshed Volumes until the new volume status was Available.

Screenshot placeholder: `screenshots/ebs_create_volume_from_snapshot.png`

Task 6.2 — Attaching the restored volume

- I selected the Restored Volume, chose Actions → Attach volume, and attached it to the Lab instance.
  - I specified device `/dev/sdc` for the restored volume.

- The volume status changed to In‑use after attachment.

Screenshot placeholder: `screenshots/ebs_attach_restored_volume.png`

Task 6.3 — Mounting the restored volume and verifying data

- In the EC2 terminal I created a mount point for the restored volume and mounted it:

sudo mkdir -p /mnt/data-store2
sudo mount /dev/sdc /mnt/data-store2

- I listed the contents of the restored mount and verified that file.txt existed (the file that had been present when the snapshot was taken):

ls /mnt/data-store2/file.txt
cat /mnt/data-store2/file.txt

Screenshot placeholder: `screenshots/restore_verification_file_present.png`

---

## Troubleshooting notes

- If mkfs reported the device was in use or missing, I rechecked the device name in the EC2 console (the device mapping sometimes differed with different instance types) and reconnected via Instance Connect.
- If the mount did not persist after reboot, I inspected /etc/fstab for syntax issues and used mount -a to test entries.
- If the restored volume did not contain the expected data, I ensured the snapshot had completed successfully before creating the volume and that I mounted the correct device mapping.

Screenshot placeholder: `screenshots/troubleshooting_ebs.png`

---

## Conclusion

I had successfully completed the lab tasks: I created and attached an EBS volume, formatted and mounted it, created a snapshot, restored a new volume from that snapshot, and validated that the restored volume contained the previously created file. These steps demonstrated basic lifecycle operations for EBS volumes and snapshots.

Recommended screenshots to capture and add to the repository:

- ebs_architecture_diagram.png
- ec2_instances_lab_instance.png
- ebs_create_volume.png
- ebs_attach_volume.png
- ec2_instance_connect_terminal.png
- df_before_mount.png
- mount_and_fstab.png
- file_written_on_volume.png
- ebs_create_snapshot.png
- file_deleted_after_snapshot.png
- ebs_create_volume_from_snapshot.png
- ebs_attach_restored_volume.png
- restore_verification_file_present.png
- troubleshooting_ebs.png

---

*File created in the Labs/Compute Services folder as requested.*
