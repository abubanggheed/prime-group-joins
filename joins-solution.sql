
--1. Get all customers and their addresses.
SELECT * FROM "customers"
JOIN "addresses" ON "customers"."id" = "addresses"."customer_id";

--2. Get all orders and their line items (orders, quantity and product).
SELECT "orders"."order_date", "line_items"."quantity", "products"."description"  FROM "line_items"
JOIN "orders" ON "line_items"."order_id" = "orders"."id"
JOIN "products" ON "line_items"."product_id" = "products"."id";

--3. Which warehouses have cheetos?
SELECT "warehouse" FROM "warehouse_product"
JOIN "products" ON "products"."id" = "warehouse_product"."product_id"
JOIN "warehouse" ON "warehouse_product"."warehouse_id" = "warehouse"."id"
WHERE "description" = 'cheetos' AND "on_hand" > 0;

--4. Which warehouses have diet pepsi?
SELECT "warehouse" FROM "warehouse_product"
JOIN "products" ON "products"."id" = "warehouse_product"."product_id"
JOIN "warehouse" ON "warehouse_product"."warehouse_id" = "warehouse"."id"
WHERE "description" = 'diet pepsi' AND "on_hand" > 0;

--5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT "first_name", "last_name", COALESCE(SUM("quantity"), 0) FROM "customers"
FULL OUTER JOIN "addresses" ON "addresses"."customer_id" = "customers"."id"
FULL OUTER JOIN "orders" ON "orders"."address_id" = "addresses"."id"
FULL OUTER JOIN "line_items" ON "line_items"."order_id" = "orders"."id"
GROUP BY "first_name", "last_name";

--6. How many customers do we have?
SELECT COUNT("id") FROM "customers";

--7. How many products do we carry?
SELECT COUNT("id") FROM "products";

--8. What is the total available on-hand quantity of diet pepsi?
SELECT SUM("quantity") FROM "line_items"
JOIN "products" ON "line_items"."product_id" = "products"."id"
WHERE "description" = 'diet pepsi';

--9. How much was the total cost for each order?
SELECT "description", SUM("quantity") * "unit_price" FROM "line_items"
JOIN "products" ON "line_items"."product_id" = "products"."id"
GROUP BY "description", "unit_price";

--10. How much has each customer spent in total?
SELECT "first_name", "last_name", SUM("quantity" * "unit_price") FROM "customers"
LEFT OUTER JOIN "addresses" ON "addresses"."customer_id" = "customers"."id"
LEFT OUTER JOIN "orders" ON "orders"."address_id" = "addresses"."id"
LEFT OUTER JOIN "line_items" ON "line_items"."order_id" = "orders"."id"
LEFT OUTER JOIN "products" ON "line_items"."product_id" = "products"."id"
GROUP BY "first_name", "last_name";

--11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT "first_name", "last_name", COALESCE(SUM("quantity" * "unit_price"), 0) FROM "customers"
LEFT OUTER JOIN "addresses" ON "addresses"."customer_id" = "customers"."id"
LEFT OUTER JOIN "orders" ON "orders"."address_id" = "addresses"."id"
LEFT OUTER JOIN "line_items" ON "line_items"."order_id" = "orders"."id"
LEFT OUTER JOIN "products" ON "line_items"."product_id" = "products"."id"
GROUP BY "first_name", "last_name";