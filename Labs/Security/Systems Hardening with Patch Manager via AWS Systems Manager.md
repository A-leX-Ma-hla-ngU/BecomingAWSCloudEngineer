# Systems Hardening with Patch Manager via AWS Systems Manager

## Lab overview

In this lab, I used Patch Manager, a capability of AWS Systems Manager, to scan and install patches on six pre-created Amazon EC2 instances: three Linux instances and three Windows instances. I used the default patch baseline for the Linux instances, created a custom patch baseline for Windows security updates, associated that baseline with a patch group, and verified patch compliance.

Keeping operating systems and application software current across many workstations can be challenging. A clear security policy and baseline help ensure that systems meet minimum software versions and receive appropriate updates.

The lab environment already included the EC2 instances, the required AWS Identity and Access Management (IAM) roles, and other supporting services.

- **Estimated duration:** Approximately 60 minutes
- **Instances:** Three Linux and three Windows EC2 instances

## Objectives

After completing the lab, I had:

- Patched Linux instances using the default baseline.
- Created a custom patch baseline.
- Used a patch group to patch Windows instances with the custom baseline.
- Verified patch compliance.

## Task 1: Patch Linux instances using the default baseline

I used the predefined Amazon Linux 2 baseline to scan and install patches on the Linux instances.

1. In the AWS Management Console, I searched for and opened **Systems Manager**.
2. Under **Node Management**, I chose **Fleet Manager** and confirmed that the pre-configured fleet contained three Linux and three Windows instances. The instances appeared as managed nodes because the lab had associated the necessary IAM role with them.
3. I selected **Linux-1**, opened **Node actions**, and chose **View details**. I reviewed the platform type, node type, operating system, and associated IAM role.
4. I returned to the Systems Manager home page and opened **Patch Manager** under **Node Management**.
5. If the overview prompt appeared, I chose **Start with an overview**.
6. I chose **Patch now** and configured the operation:
   - **Patching operation:** Scan and install
   - **Reboot option:** Reboot if needed
   - **Instances to patch:** Patch only the target instances I specify
   - **Target selection:** Specify instance tags
   - **Tag key:** `Patch Group`
   - **Tag value:** `LinuxProd`
7. I chose **Add**, then **Patch now**.
8. I monitored the **AWS-PatchNowAssociation** status and the **Scan/Install operation summary** until the operation completed for all three Linux instances.

<!-- Screenshot placeholder: Fleet Manager showing the pre-configured Linux and Windows managed nodes -->

<!-- Screenshot placeholder: Linux Patch now configuration targeting Patch Group=LinuxProd -->

<!-- Screenshot placeholder: Linux scan/install operation completed for all three instances -->

## Task 2: Create a custom Windows patch baseline

I created a Windows Server 2019 baseline that selected security updates by severity and assigned the `WindowsProd` patch group to it.

1. I returned to **Systems Manager > Patch Manager** and opened the **Patch baselines** tab.
2. I chose **Create patch baseline** and entered the following baseline details:
   - **Name:** `WindowsServerSecurityUpdates`
   - **Description:** `Windows security baseline patch`
   - **Operating system:** Windows
   - **Default patch baseline:** I left the checkbox unselected.
3. I configured the first approval rule:
   - **Product:** `WindowsServer2019` (I removed **All** from the selection.)
   - **Severity:** Critical
   - **Classification:** SecurityUpdates
   - **Auto-approval:** 3 days
   - **Compliance reporting:** Critical
4. I added a second rule:
   - **Product:** `WindowsServer2019` (I removed **All** from the selection.)
   - **Severity:** Important
   - **Classification:** SecurityUpdates
   - **Auto-approval:** 3 days
   - **Compliance reporting:** High
5. I chose **Create patch baseline**.
6. In the patch baselines list, I selected `WindowsServerSecurityUpdates`, opened **Actions**, and chose **Modify patch groups**.
7. Under **Patch groups**, I entered `WindowsProd`, chose **Add**, and then chose **Close**.

<!-- Screenshot placeholder: WindowsServerSecurityUpdates baseline details and approval rules -->

<!-- Screenshot placeholder: WindowsProd associated with the custom patch baseline -->

## Task 3: Patch the Windows instances

I tagged the Windows instances with the patch group associated with my custom baseline, then ran a scan and installation operation against that tag.

### Task 3.1: Tag the Windows instances

The Linux instances already had the `LinuxProd` patch group tag, so I did not change their tags.

1. In the AWS Management Console, I opened **EC2** and chose **Instances**.
2. I selected **Windows-1**, opened the **Tags** tab, and chose **Manage tags**.
3. I chose **Add new tag** and entered:
   - **Key:** `Patch Group`
   - **Value:** `WindowsProd`
4. I chose **Save**.
5. I repeated the same steps for **Windows-2** and **Windows-3**.

<!-- Screenshot placeholder: Windows EC2 instance tagged with Patch Group=WindowsProd -->

### Task 3.2: Run the Windows patch operation

1. I returned to **Systems Manager > Patch Manager** and chose **Patch now**.
2. I configured the operation:
   - **Patching operation:** Scan and install
   - **Reboot option:** Reboot if needed
   - **Instances to patch:** Patch only the target instances I specify
   - **Target selection:** Specify instance tags
   - **Tag key:** `Patch Group`
   - **Tag value:** `WindowsProd`
3. I chose **Add**, then **Patch now**.
4. When the execution appeared, I opened its **Execution ID** link.
5. In State Manager, I chose the **Output** link for a managed instance whose status was **InProgress**.
6. In Run Command, I expanded the **Output** panel and reviewed the command output. The Patch Manager operation used Run Command to run the patch baseline operations, and I confirmed that the output included `PatchGroup: WindowsProd`.

An SSM document defined the actions that Systems Manager performed on the managed instances.

<!-- Screenshot placeholder: Windows Patch now configuration targeting Patch Group=WindowsProd -->

<!-- Screenshot placeholder: Run Command output showing PatchGroup: WindowsProd -->

## Task 4: Verify patch compliance

I checked the compliance summary and the per-node patch details after the patch operations had finished.

1. In Systems Manager, I opened **Patch Manager** and selected the **Dashboard** tab.
2. Under **Compliance summary**, I confirmed that the summary showed **Compliant: 6**.
3. I opened the **Compliance reporting** tab and verified that all six Linux and Windows instances had a **Compliant** status.
4. In the **Node patching details** panel, I reviewed each instance's critical, security, and other noncompliant counts, last operation date, and baseline ID.
5. I opened the **Node ID** for a Windows instance and selected its **Patch** tab.
6. I reviewed the patches applied to that instance and their installed times.

<!-- Screenshot placeholder: Patch Manager dashboard showing six compliant instances -->

<!-- Screenshot placeholder: Compliance reporting with all Linux and Windows nodes compliant -->

<!-- Screenshot placeholder: Windows node Patch tab showing applied patches and installed times -->

## Conclusion

I completed the lab after patching the Linux instances with the default baseline, creating and using a custom Windows security baseline, associating the baseline with a patch group, and verifying compliance across all six instances.

I then chose **End Lab** and confirmed with **Yes** to end the lab environment.
