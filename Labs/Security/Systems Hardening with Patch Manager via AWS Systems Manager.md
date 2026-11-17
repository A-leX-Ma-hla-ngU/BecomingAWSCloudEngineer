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

<img width="1669" height="851" alt="Screenshot 2026-08-19 at 17 52 30" src="https://github.com/user-attachments/assets/9c0902ff-c0d6-4259-abba-c56252936f2f" />
<img width="1670" height="848" alt="Screenshot 2026-08-19 at 17 55 16" src="https://github.com/user-attachments/assets/abbbf7ea-d60e-440e-a761-b6d9fa1ce69d" />
<img width="1669" height="497" alt="Screenshot 2026-08-19 at 17 55 29" src="https://github.com/user-attachments/assets/cb060498-d1fb-480b-a95f-a8f7c01ba024" />
<img width="804" height="600" alt="Screenshot 2026-08-19 at 18 18 26" src="https://github.com/user-attachments/assets/b6fb96cc-20a3-4b8c-84f6-5be39f6cffe3" />
<img width="771" height="566" alt="Screenshot 2026-08-19 at 18 25 45" src="https://github.com/user-attachments/assets/0782893c-08fa-436e-955b-6e4c02a1c964" />
<img width="802" height="525" alt="Screenshot 2026-08-19 at 18 30 12" src="https://github.com/user-attachments/assets/e30c7431-185a-4dc8-99f9-d81394ae3b32" />

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

<img width="811" height="656" alt="Screenshot 2026-08-19 at 18 31 13" src="https://github.com/user-attachments/assets/fb3fff1c-e28a-49af-9a0d-34c1cb4bf7a9" />
<img width="730" height="404" alt="Screenshot 2026-08-19 at 18 36 33" src="https://github.com/user-attachments/assets/f7cc3d6d-38c2-4dc2-add0-46aec3243ae3" />
<img width="798" height="706" alt="Screenshot 2026-08-19 at 18 40 30" src="https://github.com/user-attachments/assets/d4584abf-0ec5-46b8-a6b7-5813dded6012" />
<img width="838" height="703" alt="Screenshot 2026-08-19 at 18 44 51" src="https://github.com/user-attachments/assets/c714718c-795f-4f2a-9dc8-c86989368032" />
<img width="759" height="155" alt="Screenshot 2026-08-19 at 18 46 11" src="https://github.com/user-attachments/assets/63cdbd9d-8508-4fe2-af78-323dc20538d5" />
<img width="747" height="197" alt="Screenshot 2026-08-19 at 18 46 25" src="https://github.com/user-attachments/assets/fa978ac3-0857-4782-a79d-dd0ea5493146" />
<img width="786" height="207" alt="Screenshot 2026-08-19 at 18 46 56" src="https://github.com/user-attachments/assets/22d58eec-d606-4e5e-a963-265b2c828417" />


<img width="801" height="617" alt="Screenshot 2026-08-19 at 18 48 37" src="https://github.com/user-attachments/assets/89edccd7-cea1-46db-9a98-2c3049c9dbee" />

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

<img width="820" height="322" alt="Screenshot 2026-08-19 at 18 51 20" src="https://github.com/user-attachments/assets/5f7b9ff4-83ec-44ba-858b-d13f3c354b1a" />
<img width="799" height="703" alt="Screenshot 2026-08-19 at 18 54 22" src="https://github.com/user-attachments/assets/be34f43a-4c09-4485-8fde-88a4eae690a1" />
<img width="775" height="367" alt="Screenshot 2026-08-19 at 18 54 46" src="https://github.com/user-attachments/assets/91865357-3000-44ec-8fcb-22a8a81e484e" />
<img width="821" height="426" alt="Screenshot 2026-08-19 at 18 55 02" src="https://github.com/user-attachments/assets/caa8a52e-99a6-464d-82d8-3b123f74941e" />
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

<img width="812" height="707" alt="Screenshot 2026-08-19 at 19 04 36" src="https://github.com/user-attachments/assets/a38df28e-f96c-4037-bcd2-f81a8c4e42c4" />
<img width="817" height="699" alt="Screenshot 2026-08-19 at 19 06 03" src="https://github.com/user-attachments/assets/a447f0fe-6cc7-414e-ae4c-2f032940c018" />
<img width="822" height="659" alt="Screenshot 2026-08-19 at 19 09 13" src="https://github.com/user-attachments/assets/3d8169c6-83e5-483b-9f04-1a8e39890051" />
<img width="805" height="592" alt="Screenshot 2026-08-19 at 19 10 08" src="https://github.com/user-attachments/assets/6e8f623b-ac92-4f5f-8fc9-a3e0181c1ab3" />


<img width="801" height="515" alt="Screenshot 2026-08-19 at 19 10 29" src="https://github.com/user-attachments/assets/9f23a2a6-ba42-4ac7-8078-14291c40f8e1" />

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

<img width="1199" height="791" alt="Screenshot 2026-08-19 at 19 16 19" src="https://github.com/user-attachments/assets/78722f77-bd7f-4e66-a822-c20203499b0d" />

<img width="1671" height="851" alt="Screenshot 2026-08-19 at 19 17 06" src="https://github.com/user-attachments/assets/2eafe83e-b3f4-4c56-909e-079cc0083f0e" />
<img width="1364" height="602" alt="Screenshot 2026-08-19 at 19 13 39" src="https://github.com/user-attachments/assets/86c17781-682b-4e76-857a-ea672080f3e3" />

## Conclusion

I completed the lab after patching the Linux instances with the default baseline, creating a custom Windows patch baseline, associating the baseline with a patch group, and verifying compliance for all six EC2 instances. I then chose **End Lab** and confirmed that I wanted to end the lab environment.
