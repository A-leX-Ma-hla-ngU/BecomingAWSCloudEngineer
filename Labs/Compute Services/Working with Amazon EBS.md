# Working with Amazon EBS

## Lab journey

This document described the step‑by‑step journey taken while completing the "Working with Amazon EBS" lab. The narrative was written in past tense to record the sequence of actions, observations, and verifications that were performed. The lab demonstrated how to create an Amazon EBS volume, attach and mount it on an EC2 instance, create a snapshot, and restore a volume from that snapshot.

---

## Lab overview

I worked with Amazon Elastic Block Store (EBS) to create block storage, attach it to an EC2 instance, format and mount the volume, and perform snapshot and restore operations. The lab covered:

- Creating a new EBS volume (gp2), tagging it, and ensuring it was in the same Availability Zone as the instance.
- Attaching the volume to the Lab EC2 instance and mounting it at /mnt/data-store.
- Creating a small file on the volume, taking an EBS snapshot, deleting the file, then restoring a new volume from the snapshot and verifying the file was present.

Screenshot placeholder: <img width="915" height="326" alt="Screenshot 2026-07-16 at 20 05 55" src="https://github.com/user-attachments/assets/58d38b9f-3b06-4158-b6cf-e3aa4dc23c02" />

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

Screenshot placeholder: <img width="843" height="441" alt="Screenshot 2026-07-16 at 20 12 21" src="https://github.com/user-attachments/assets/8042a385-7175-4eae-9bb8-58bef465823f" />

- I selected Elastic Block Store → Volumes and clicked Create volume.
  - Volume type: General Purpose SSD (gp2)
  - Size: 1 GiB (small size used for the lab)
  - Availability Zone: the same AZ as the Lab instance (e.g., us-west-2a)
  - Tag: Name = My Volume

- I created the volume and refreshed the Volumes list until the new volume's state changed from Creating to Available.

Screenshot placeholder: <img width="826" height="741" alt="Screenshot 2026-07-16 at 20 12 50" src="https://github.com/user-attachments/assets/b629eb29-35ea-4218-8861-7e2a609c5124" />

---

### Task 2 — Attaching the volume to the EC2 instance

- I selected the newly created volume (My Volume), chose Actions → Attach volume, and selected the Lab instance.
  - I specified the device name `/dev/sdb` because the later commands used that device path.

- After attaching, the volume state changed to In‑use.

Screenshot placeholder: <img width="834" height="344" alt="Screenshot 2026-07-16 at 20 17 38" src="https://github.com/user-attachments/assets/3c0b26da-a19a-48d6-93b0-83d4c8d0ae0a" />

<img width="811" height="638" alt="Screenshot 2026-07-16 at 20 18 49" src="https://github.com/user-attachments/assets/4282f854-b420-451d-92f2-989e6537be48" />

<img width="605" height="195" alt="Screenshot 2026-07-16 at 20 19 26" src="https://github.com/user-attachments/assets/d369f616-1e71-45ce-bf15-62afcad7a2a2" />

---

### Task 3 — Connecting to the Lab EC2 instance

- I connected to the Lab instance using EC2 Instance Connect (Connect → EC2 Instance Connect → Connect), which opened an in‑browser terminal.

Screenshot placeholder: <img width="818" height="716" alt="Screenshot 2026-07-16 at 20 21 22" src="https://github.com/user-attachments/assets/f8ee0b9c-b071-4432-b906-c32efeadb4d5" />


<img width="840" height="391" alt="Screenshot 2026-07-16 at 20 22 22" src="https://github.com/user-attachments/assets/4685c9be-7ee6-45c0-a8d5-69c542869dbd" />

- I used this terminal for the filesystem creation and mounting steps that followed.

---

### Task 4 — Creating and configuring the file system

- I checked existing storage devices with df -h to confirm the instance's current disks and that the new volume did not yet appear.

Screenshot placeholder: <img width="735" height="220" alt="Screenshot 2026-07-16 at 20 23 15" src="https://github.com/user-attachments/assets/2bcf09bb-592c-49f6-91fb-6c98f25c5bdb" />

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

Screenshot placeholder: <img width="846" height="135" alt="Screenshot 2026-07-16 at 20 34 16" src="https://github.com/user-attachments/assets/568c7106-bc3e-451a-8780-24a2c4f9fe49" />

- I created a file on the new volume and verified its contents:

sudo sh -c "echo some text has been written > /mnt/data-store/file.txt"
cat /mnt/data-store/file.txt

Screenshot placeholder: <img width="822" height="50" alt="Screenshot 2026-07-16 at 20 39 10" src="https://github.com/user-attachments/assets/a1737f91-4404-4aed-84bc-fe895a44595d" />

<img width="647" height="70" alt="Screenshot 2026-07-16 at 20 40 27" src="https://github.com/user-attachments/assets/be7c344d-8ce6-4880-b4a0-11e4974dc095" />


---

### Task 5 — Creating an Amazon EBS snapshot

- In the EC2 console I navigated to Volumes, selected My Volume, and chose Actions → Create snapshot.
  - I tagged the snapshot: Name = My Snapshot.

- I opened Snapshots and watched the snapshot's status change from Pending to Completed.

Screenshot placeholder: <img width="813" height="317" alt="Screenshot 2026-07-16 at 20 46 07" src="https://github.com/user-attachments/assets/b1d9e62b-2642-46c8-afa1-9c64bab377fb" />

- Back in the instance terminal I deleted the file I created earlier and verified it was removed:

sudo rm /mnt/data-store/file.txt
ls /mnt/data-store/file.txt  # expected: No such file or directory

Screenshot placeholder: <img width="835" height="71" alt="Screenshot 2026-07-16 at 20 48 02" src="https://github.com/user-attachments/assets/9869fcba-3eae-4f2a-909f-866934d2177a" />

---

### Task 6 — Restoring the EBS snapshot

Task 6.1 — Creating a volume from the snapshot

- I selected the snapshot in the EC2 console and chose Actions → Create volume from snapshot.
  - I selected the same Availability Zone as the Lab instance.
  - I added a tag: Name = Restored Volume.

- I created the volume and refreshed Volumes until the new volume status was Available.

Screenshot placeholder: <img width="800" height="394" alt="Screenshot 2026-07-16 at 20 50 37" src="https://github.com/user-attachments/assets/b6e439d7-c778-4cd9-8c96-26f11c3c3a13" />

<img width="828" height="386" alt="Screenshot 2026-07-16 at 20 50 50" src="https://github.com/user-attachments/assets/2146cdb5-1540-466d-bac1-fac0bbe9c774" />


Task 6.2 — Attaching the restored volume

- I selected the Restored Volume, chose Actions → Attach volume, and attached it to the Lab instance.
  - I specified device `/dev/sdc` for the restored volume.

- The volume status changed to In‑use after attachment.

Screenshot placeholder: <img width="824" height="477" alt="Screenshot 2026-07-16 at 20 53 35" src="https://github.com/user-attachments/assets/82f3c39d-7d47-4430-b1f7-177f70887540" />

Task 6.3 — Mounting the restored volume and verifying data

- In the EC2 terminal I created a mount point for the restored volume and mounted it:

sudo mkdir -p /mnt/data-store2
sudo mount /dev/sdc /mnt/data-store2

- I listed the contents of the restored mount and verified that file.txt existed (the file that had been present when the snapshot was taken):

ls /mnt/data-store2/file.txt

sudo sh -c "echo Just testing out this snapshotted volume /mnt/data-store2/file.txt

Screenshot placeholder: <img width="786" height="77" alt="Screenshot 2026-07-16 at 20 55 57" src="https://github.com/user-attachments/assets/8fb65ee0-fba5-418c-91ad-7b572b33e073" />

<img width="828" height="86" alt="Screenshot 2026-07-16 at 20 58 21" src="https://github.com/user-attachments/assets/ebbd1f7b-3b9e-4d5a-8d60-28f244062c4d" />

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
