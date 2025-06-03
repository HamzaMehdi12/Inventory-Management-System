# Inventory-Management-System
This system manages Suppliers, Inventory_Items, Product_List, Transactions, Orders, and Order_Status. A recursive CTE unrolls bulk into units in Product_List. Make_Transaction logs sales, updates inventory, and calls Dispatch. Update_Inventory auto-restocks via Refil. Update_Order_Status and Continue_ handle status changes.
