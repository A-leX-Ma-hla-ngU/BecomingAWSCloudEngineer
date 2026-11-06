# Introduction to Amazon DynamoDB

## Lab overview

This lab introduced Amazon DynamoDB, a fully managed NoSQL database service that supported key-value and document data models. DynamoDB provided consistent, single-digit millisecond latency at scale and could be used for workloads such as mobile, web, gaming, ad-tech, and Internet of Things (IoT) applications.

I created a table for a music library, added and updated items, queried and scanned the table, and then deleted it.

## Topics completed

- I created an Amazon DynamoDB table.
- I entered data into the table.
- I updated an existing item.
- I queried and scanned the table.
- I deleted the table and its data.

**Approximate duration:** 35 minutes

## Task 1: Created a table

In the AWS Management Console, I opened **DynamoDB** and selected **Create table**. I configured the table as follows:

| Setting | Value |
| --- | --- |
| Table name | `Music` |
| Partition key | `Artist` (String) |
| Sort key | `Song` (String) |
| Indexes and capacity | Default settings |

I created the table and waited until its status changed to **Active**. The partition key distributed items across the table, and the combination of the partition key and sort key uniquely identified each item.

> **Screenshot placeholder — Create table settings:** Add a screenshot showing the `Music` table name and its `Artist` and `Song` keys.

<img width="828" height="747" alt="Screenshot 2026-08-04 at 11 52 31" src="https://github.com/user-attachments/assets/005a8f3e-005d-4d04-90a1-6be140882802" />

> **Screenshot placeholder — Active table:** Add a screenshot showing the `Music` table in the Active state.

<img width="832" height="532" alt="Screenshot 2026-08-04 at 11 53 14" src="https://github.com/user-attachments/assets/54af32c9-4edc-4d50-baad-98a7e4797e06" />

## Task 2: Added music items

I opened the `Music` table, selected **Actions** > **Create item**, and entered the first item:

| Attribute | Type | Value |
| --- | --- | --- |
| Artist | String | Pink Floyd |
| Song | String | Money |
| Album | String | The Dark Side of the Moon |
| Year | Number | 1973 |

I created the item. The key attributes were required, while the other attributes could differ from item to item because the table did not require a fixed schema for non-key attributes.

I added a second item:

| Attribute | Type | Value |
| --- | --- | --- |
| Artist | String | John Lennon |
| Song | String | Imagine |
| Album | String | Imagine |
| Year | Number | 1971 |
| Genre | String | Soft rock |

I added a third item:

| Attribute | Type | Value |
| --- | --- | --- |
| Artist | String | Psy |
| Song | String | Gangnam Style |
| Album | String | Psy 6 (Six Rules), Part 1 |
| Year | Number | 2011 |
| LengthSeconds | Number | 219 |

The second and third items included attributes that were not present in every other item, demonstrating DynamoDB's flexible item structure.

> **Screenshot placeholder — Music items:** Add a screenshot showing the three music items and their attributes.

<img width="478" height="313" alt="Screenshot 2026-08-04 at 11 58 35" src="https://github.com/user-attachments/assets/eadffaeb-5e74-4c17-848d-110e0bdb8eab" />

<img width="822" height="643" alt="Screenshot 2026-08-04 at 12 41 32" src="https://github.com/user-attachments/assets/6e1e2521-03b1-40a8-b52a-0993497b76d4" />

<img width="1283" height="488" alt="Screenshot 2026-08-04 at 13 07 21" src="https://github.com/user-attachments/assets/9e6a7ccb-4dcf-4f5a-9e59-41fbca00f96b" />


## Task 3: Modified an existing item

I opened **Explore items**, selected the `Music` table, and chose the item for Psy. I changed the `Year` value for `Gangnam Style` from `2011` to `2012` and saved the change.

> **Screenshot placeholder — Updated Psy item:** Add a screenshot showing the updated `Year` value of `2012`.

## Task 4: Queried and scanned the table

### Queried by primary key

I expanded **Scan/Query items**, selected **Query**, and entered the partition key and sort key values:

| Key | Value |
| --- | --- |
| Artist (Partition key) | `Psy` |
| Song (Sort key) | `Gangnam Style` |

I ran the query and found the matching song. A query used the table's key schema and was the efficient way to retrieve items by key.

> **Screenshot placeholder — Query result:** Add a screenshot showing the result for artist `Psy` and song `Gangnam Style`.

<img width="362" height="390" alt="Screenshot 2026-08-04 at 13 08 25" src="https://github.com/user-attachments/assets/d7361b80-3b5e-44a4-8c17-9c34cfa7ed21" />

<img width="768" height="90" alt="Screenshot 2026-08-04 at 13 08 53" src="https://github.com/user-attachments/assets/4a5001df-1fbe-4ce2-83fe-2c789273ec0e" />

<img width="1218" height="52" alt="Screenshot 2026-08-04 at 13 09 49" src="https://github.com/user-attachments/assets/a1ef1fe4-a517-46c2-9698-8f9fc8bdc174" />

<img width="1248" height="555" alt="Screenshot 2026-08-04 at 13 20 49" src="https://github.com/user-attachments/assets/6d90bf2f-0560-4a2b-a877-5c5eee6d0211" />

<img width="1295" height="377" alt="Screenshot 2026-08-04 at 13 21 05" src="https://github.com/user-attachments/assets/7a072838-da60-4ec5-8ef6-61f7c6d77047" />


### Scanned with a filter

I selected **Scan**, expanded **Filters**, and entered a filter for the year:

| Filter setting | Value |
| --- | --- |
| Attribute name | `Year` |
| Type | Number |
| Value | `1971` |

I ran the scan, and the John Lennon item for `Imagine` was displayed. A scan examined table items rather than locating them through the primary key, so it was less efficient than a query for large tables.

> **Screenshot placeholder — Scan result:** Add a screenshot showing the item matching `Year` = `1971`.

<img width="1243" height="595" alt="Screenshot 2026-08-04 at 13 35 26" src="https://github.com/user-attachments/assets/37414c1a-aad1-45d4-831e-8b73e2f0a67a" />

<img width="1271" height="382" alt="Screenshot 2026-08-04 at 13 36 45" src="https://github.com/user-attachments/assets/b3a50960-1b84-4017-9958-a504f948c863" />


## Task 5: Deleted the table

After completing the exercises, I opened the `Music` table's actions and selected **Delete table**. On the confirmation panel, I entered `delete` and confirmed the deletion. The table and all its data were removed.

> **Screenshot placeholder — Delete confirmation:** Add a screenshot of the confirmation step, or the table list after deletion.

<img width="1333" height="392" alt="Screenshot 2026-08-04 at 13 38 32" src="https://github.com/user-attachments/assets/79aab66e-441e-48cc-b32d-ff25cd458c91" />

<img width="1382" height="717" alt="Screenshot 2026-08-04 at 13 38 51" src="https://github.com/user-attachments/assets/804b1024-ce3f-4eac-b4f5-c1d708467a1b" />

<img width="1312" height="412" alt="Screenshot 2026-08-04 at 13 39 06" src="https://github.com/user-attachments/assets/ae458b93-e40a-4337-acff-1ec107ec4dde" />

<img width="1305" height="719" alt="Screenshot 2026-08-04 at 13 39 19" src="https://github.com/user-attachments/assets/062ea30c-7e5d-4e41-a2c0-6d4d52799716" />


## Conclusion

I completed the lab by creating a DynamoDB table, adding music items with flexible attributes, modifying an item, retrieving records with a query and a scan, and deleting the table. I ended the lab using **End Lab** and confirmed the action.

> **Cleanup note:** Deleting the `Music` table removed its data. I ended the lab after finishing the exercise.

## Further reading

For more information, I referred to the [Amazon DynamoDB documentation](https://docs.aws.amazon.com/amazondynamodb/).
