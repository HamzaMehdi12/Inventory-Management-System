# Inventory-Management-System
This system manages Suppliers, Inventory_Items, Product_List, Transactions, Orders, and Order_Status. A recursive CTE unrolls bulk into units in Product_List. Make_Transaction logs sales, updates inventory, and calls Dispatch. Update_Inventory auto-restocks via Refil. Update_Order_Status and Continue_ handle status changes.

## Flow of Project
Tables & Structure: Six core tables—Suppliers, Inventory_Items, Product_List, Transactions, Orders, and Order_Status—plus a staging table (Inventory_Items_Lim) support suppliers, bulk tracking, and item sales.

Unrolling Bulk Stock: A recursive CTE expands each bulk’s remaining quantity into individual Item_ID rows in Product_List, carrying description, price, and an expiry date by ID range.

Make_Transaction Workflow: Inserts a Transactions row, creates an Orders entry with its timestamp, decrements bulk quantity in Inventory_Items (advancing the next Item_ID), removes the sold unit from Product_List, and calls Dispatch to add an Order_Status record.

Restocking Logic: Update_Inventory finds bulks with fewer than five units, loops through those suppliers calling Refil, which replenishes bulk quantity, rebuilds the staging table, reruns the unrolling CTE, and reinserts new units into Product_List with updated expiry dates.

Order Status & Helpers: Update_Order_Status updates an order’s Status and Dispatch_ID in Order_Status, while Continue_ simply returns a “yes/no”-based message (“Starting adding Transaction,” “No transaction,” or “Invalid Input”).

## Images
## EER Diagram
![Inventory_Management_System](https://github.com/user-attachments/assets/d602a758-93fe-446b-b885-f6548a70f3da)


### Order Status
![Order_Status](https://github.com/user-attachments/assets/d99029c9-88b5-4e6a-8a20-8d78e826244e)
### Orders
![Orders](https://github.com/user-attachments/assets/d860e5d4-7d8a-4fee-ab99-df0cc070eeae)
### Transactions
![Transactions](https://github.com/user-attachments/assets/2aae8aa2-7488-4cbc-baa4-edc3af3c242c)
### Product List
![Product_List](https://github.com/user-attachments/assets/12aaf366-5cae-47f3-928a-0b4cd00ec87a)
### Suppliers
![Suppliers](https://github.com/user-attachments/assets/498bd2ff-b49c-4c24-9c7d-d2a5172b59b7)
### Inventory Lists
![Inventory_Items](https://github.com/user-attachments/assets/a02bd999-7d07-46fe-ac90-6dd32fffad9b)
