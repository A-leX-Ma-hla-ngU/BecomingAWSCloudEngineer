# Systems Hardening with Patch Manager via AWS Systems Manager

## Lab overview

In this lab, I used Patch Manager, a feature of AWS Systems Manager, to scan and install updates on the EC2 instances in my lab environment. I created a custom patch baseline for the Windows instances, used the default baseline for the Linux instances, and verified that all managed instances were compliant.

Managing updates across many workstation and server environments can be challenging. Patch Manager helped me automate security patching and enforce a consistent baseline across the lab environment. The environment already included the EC2 instances, supporting IAM roles, and the necessary AWS services needed for patch management.

- **Estimated duration:** Approximately 60 minutes
- **Environment:** Three Linux EC2 instances and three Windows EC2 instances

## Objectives

After completing this lab, I was able to:

- Patch Linux instances using the default patch baseline.
- Create a custom patch baseline.
- Use patch groups to patch Windows instances with the custom baseline.
- Verify patch compliance.

## Task 1: Patch Linux instances using the default baseline

In this task, I patched the Linux EC2 instances using the default patch baseline that AWS Systems Manager provides for Amazon Linux 2.

1. In the AWS Management Console, I searched for **Systems Manager** and selected it.
2. In the left navigation pane, I chose **Fleet Manager** under **Node Management** and reviewed the pre-configured EC2 instances.
3. I selected the **Linux-1** instance, chose **Node actions**, and selected **View details** to review the operating system and IAM role associated with the node.
4. I returned to the Systems Manager console home page and chose **Patch Manager**.
5. If the overview page appeared, I chose **Start with an overview**.
6. I chose **Patch now** and configured the patch operation as follows:
   - **Patching operation:** Scan and install
   - **Reboot option:** Reboot if needed
   - **Instances to patch:** Patch only the target instances I specify
   - **Target selection:** Specify instance tags
   - **Tag key:** `Patch Group`
   - **Tag value:** `LinuxProd`
7. I chose **Add** and then **Patch now**.
8. I monitored the patch operation until all three Linux instances completed the scan and install process.

<!-- Screenshot placeholder: Systems Manager Fleet Manager showing the Linux and Windows nodes -->

<!-- Screenshot placeholder: Patch Manager configuration for LinuxProd patch operation -->

<!-- Screenshot placeholder: Linux patch execution showing all three instances completed -->

## Task 2: Create a custom patch baseline for Windows instances

In this task, I created a custom patch baseline for Windows security updates and associated it with a patch group.

1. I returned to **Systems Manager > Patch Manager**.
2. I chose the **Patch baselines** tab and selected **Create patch baseline**.
3. I configured the baseline details as follows:
   - **Name:** `WindowsServerSecurityUpdates`
   - **Description:** `Windows security baseline patch`
   - **Operating system:** Windows
   - **Default patch baseline:** Unselected
4. In the **Approval rules for operating systems** section, I configured the first rule:
   - **Products:** `WindowsServer2019`
   - **Severity:** Critical
   - **Classification:** SecurityUpdates
   - **Auto-approval:** 3 days
   - **Compliance reporting:** Critical
5. I chose **Add rule** and configured the second rule:
   - **Products:** `WindowsServer2019`
   - **Severity:** Important
   - **Classification:** SecurityUpdates
   - **Auto-approval:** 3 days
   - **Compliance reporting:** High
6. I chose **Create patch baseline**.
7. I selected the new baseline, chose **Actions**, and then selected **Modify patch groups**.
8. I entered `WindowsProd` under **Patch groups**, chose **Add**, and then chose **Close**.

<!-- Screenshot placeholder: Create patch baseline page for WindowsServerSecurityUpdates -->

<!-- Screenshot placeholder: WindowsServerSecurityUpdates patch baseline with the WindowsProd patch group attached -->

## Task 3: Patch the Windows instances

In this task, I assigned the Windows EC2 instances to the `WindowsProd` patch group and then ran a patch operation against that group.

### Task 3.1: Tag the Windows instances

The Linux instances were already configured with the `LinuxProd` tag during the lab setup, so I only needed to add the patch group tag to the Windows instances.

1. In the AWS Management Console, I opened **EC2** and chose **Instances**.
2. I selected **Windows-1**, opened the **Tags** tab, and chose **Manage tags**.
3. I chose **Add new tag** and configured the following values:
   - **Key:** `Patch Group`
   - **Value:** `WindowsProd`
4. I chose **Save**.
5. I repeated the same steps for **Windows-2** and **Windows-3**.

<!-- Screenshot placeholder: Windows-1 EC2 instance tagged with Patch Group=WindowsProd -->

### Task 3.2: Patch the Windows instances by patch group

1. I returned to **Systems Manager > Patch Manager**.
2. I chose **Patch now**.
3. I configured the patch operation as follows:
   - **Patching operation:** Scan and install
   - **Reboot option:** Reboot if needed
   - **Instances to patch:** Patch only the target instances I specify
   - **Target selection:** Specify instance tags
   - **Tag key:** `Patch Group`
   - **Tag value:** `WindowsProd`
4. I chose **Add** and then **Patch now**.
5. I selected the **Execution ID** link when it became available.
6. I opened the **Output** link for one managed instance with a status of **InProgress** and expanded the output panel.
7. I reviewed the command output and confirmed that the output included `PatchGroup: WindowsProd`.

Patch Manager used the Run Command feature to execute the patch baseline operations on the managed instances. The Systems Manager document defined the actions performed on each instance.

<!-- Screenshot placeholder: Patch Manager configuration for WindowsProd patch operation -->

<!-- Screenshot placeholder: Output panel showing PatchGroup: WindowsProd -->

## Task 4: Verify compliance

In this task, I validated the patch status across both the Linux and Windows instances.

1. In **Systems Manager > Patch Manager**, I opened the **Dashboard** tab.
2. Under **Compliance summary**, I reviewed the total compliant state and confirmed that all six instances were compliant.
3. I opened the **Compliance reporting** tab and verified that the compliance status for all Linux and Windows instances was **Compliant**.
4. I reviewed the patching details for each instance, including:
   - Critical noncompliant count
   - Security noncompliant count
   - Other noncompliant count
   - Last operation date
   - Baseline ID
5. I selected the **Node ID** for one Windows instance and opened the **Patch** tab.
6. I reviewed the installed patches and the **Installed Time** values for that instance.

<!-- Screenshot placeholder: Patch Manager Dashboard showing six compliant instances -->

<!-- Screenshot placeholder: Compliance reporting showing all instances compliant -->

<!-- Screenshot placeholder: Windows node patch details with installed patches and timestamps -->

## Conclusion

I completed the lab after patching the Linux instances with the default baseline, creating a custom Windows patch baseline, associating the baseline with a patch group, and verifying compliance for all six EC2 instances. I then chose **End Lab** and confirmed that I wanted to end the lab environment.
