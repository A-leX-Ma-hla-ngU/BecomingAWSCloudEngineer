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
>
> **Screenshot placeholder — Active table:** Add a screenshot showing the `Music` table in the Active state.

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

### Scanned with a filter

I selected **Scan**, expanded **Filters**, and entered a filter for the year:

| Filter setting | Value |
| --- | --- |
| Attribute name | `Year` |
| Type | Number |
| Value | `1971` |

I ran the scan, and the John Lennon item for `Imagine` was displayed. A scan examined table items rather than locating them through the primary key, so it was less efficient than a query for large tables.

> **Screenshot placeholder — Scan result:** Add a screenshot showing the item matching `Year` = `1971`.

## Task 5: Deleted the table

After completing the exercises, I opened the `Music` table's actions and selected **Delete table**. On the confirmation panel, I entered `delete` and confirmed the deletion. The table and all its data were removed.

> **Screenshot placeholder — Delete confirmation:** Add a screenshot of the confirmation step, or the table list after deletion.

## Conclusion

I completed the lab by creating a DynamoDB table, adding music items with flexible attributes, modifying an item, retrieving records with a query and a scan, and deleting the table. I ended the lab using **End Lab** and confirmed the action.

> **Cleanup note:** Deleting the `Music` table removed its data. I ended the lab after finishing the exercise.

## Further reading

For more information, I referred to the [Amazon DynamoDB documentation](https://docs.aws.amazon.com/amazondynamodb/).
