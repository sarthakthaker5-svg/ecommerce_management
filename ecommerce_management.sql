create database ECommerce_Order_Management_System;

create table categories(category_id int primary key, category_name varchar(50));

create table products(product_id int primary key, name varchar(50), category_id int, price Decimal(10,2), stock_quantity int, added_date Date, foreign key (category_id) references categories(category_id));

create table customers(customer_id int primary key, name varchar(50), email varchar(50), phone_number varchar(20), address varchar(50), registrationdate date);

create table Orders(order_id int primary key, customer_id int, order_date date, total_amount decimal(10,2), status enum('pending','shipped','delivered','cancelled'),foreign key (customer_id) references customers(customer_id));

create table Orders_Items(order_item_id int primary key, order_id int, product_id int, quantity int, subtotal decimal(10,2), foreign key (order_id) references Orders(order_id), foreign key (product_id) references products(product_id));

create table Payments(payment_id int primary key, order_id int, payment_date date, payment_method enum('Credit Card', 'Paypal','Upi'), payment_status enum('paid','pending','failed'), foreign key (order_id) references Orders(order_id));

create table Shipping(shipping_id int primary key, order_id int, shipping_date date, delivery_date date, shpping_status enum('Dispatched','In Transit','Delivered'),foreign key (order_id) references Orders(order_id));

insert into categories values(1,'Electronics');
insert into categories values(2,'Apparel');
insert into categories values(3,'Home & Kitchen');
insert into categories values(4,'Books');
insert into categories values(5,'Sports & Fitness');

select * from categories;

insert into products values(101, 'Smartphone X', 1, 699.99, 50, '2026-01-15');
insert into products values(102, 'Wireless Headphones', 1, 149.50, 120, '2026-02-10');
insert into products values(103, 'Cotton T-Shirt', 2, 19.99, 200, '2026-03-01');
insert into products values(104, 'Blender 5000', 3, 89.95, 35, '2026-04-18');
insert into products values(105, 'Sci-Fi Novel', 4, 14.99, 80, '2026-05-22');

select * from products;

insert into customers values(1, 'John Doe', 'john.doe@email.com', '123-456-7890', '123 Elm St, New York', '2026-01-10');
insert into customers values(2, 'Jane Smith', 'jane.smith@email.com', '234-567-8901', '456 Oak Ave, California', '2026-02-14');
insert into customers values(3, 'Michael Brown', 'mike.b@email.com', '345-678-9012', '789 Pine Rd, Texas', '2026-03-20');
insert into customers values(4, 'Emily Davis', 'emily.d@email.com', '456-789-0123', '321 Maple Dr, Florida', '2026-04-05');
insert into customers values(5, 'David Wilson', 'david.w@email.com', '567-890-1234', '654 Cedar Ln, Illinois', '2026-05-12');

select * from customers;

insert into Orders values(1001, 1, '2026-06-01', 849.49, 'delivered');
insert into Orders values(1002, 2, '2026-06-02', 19.99, 'shipped');
insert into Orders values(1003, 3, '2026-06-03', 149.50, 'pending');
insert into Orders values(1004, 4, '2026-06-04', 104.94, 'delivered');
insert into Orders values(1005, 5, '2026-06-05', 699.99, 'cancelled');

select * from Orders;

insert into Orders_Items values(5001, 1001, 101, 1, 699.99);
insert into Orders_Items values(5002, 1001, 102, 1, 149.50);
insert into Orders_Items values(5003, 1002, 103, 1, 19.99);
insert into Orders_Items values(5004, 1003, 102, 1, 149.50);
insert into Orders_Items values(5005, 1004, 104, 1, 89.95);

select * from Orders_Items;

insert into Payments values(901, 1001, '2026-06-01', 'Credit Card', 'paid');
insert into Payments values(902, 1002, '2026-06-02', 'Paypal', 'paid');
insert into Payments values(903, 1003, '2026-06-03', 'Upi', 'pending');
insert into Payments values(904, 1004, '2026-06-04', 'Credit Card', 'paid');
insert into Payments values(905, 1005, '2026-06-05', 'Upi', 'failed');

select * from Payments;

insert into Shipping values(801, 1001, '2026-06-02', '2026-06-05', 'Delivered');
insert into Shipping values(802, 1002, '2026-06-03', NULL, 'In Transit');
insert into Shipping values(803, 1003, NULL, NULL, 'Dispatched');
insert into Shipping values(804, 1004, '2026-06-04', '2026-06-07', 'Delivered');
insert into Shipping values(805, 1005, NULL, NULL, 'Dispatched');

select * from Shipping;

insert into products values(106,'Wireless Headphones',1,2999.00,50, curdate());

insert into customers values(6,'Sarth Thakar','sarth.thakar@gmail.com','132-645-8794', '123 Elm Ave, New York','2022-01-01');

insert into Orders values(1006,6,curdate(),'2999.00','pending');

update products set stock_quantity=100 where product_id=102;

delete from payments where order_id in (select order_id from Orders where status = 'cancelled' and order_date < DATE_SUB(CURDATE(), interval 30 day));

select * from Orders where order_date>= date_sub(curdate(), interval 6 Month);

select * from products order by price Desc limit 5;

select customer_id, Count(order_id) As Total_Orders from Orders group by customer_id having count(order_id)>3;

select * from Orders join Payments on Orders.order_id=Payments.order_id where status = 'pending' And payment_status='paid';

select * from products where stock_quantity>0;

select distinct * from customers left join Orders on customers.customer_id=Orders.customer_id where year(registrationdate)>2022 or total_amount>10000;

select * from products order by price Desc;

select customer_id, Count(order_id) as Total_Orders from Orders group by customer_id;

select categories.category_id, categories.category_name, SUM(Orders_Items.subtotal) as total_revenue from categories join products on categories.category_id = products.category_id join Orders_Items ON products.product_id = Orders_Items.product_id group by category_id, categories.category_name;

select SUM(total_amount) as total_revenue from Orders;

select products.name, SUM(Orders_Items.quantity) as total_quantity_sold from Orders_Items join products on Orders_Items.product_id = products.product_id group by products.product_id, products.name order by total_quantity_sold desc limit 1;

select avg(total_amount) as average_order_value from Orders;

select products.product_id, products.name as product_name, categories.category_name from products inner join categories on products.category_id = categories.category_id;

select Orders.order_id, Orders.order_date, Orders.total_amount, customers.name as customer_name, customers.email from Orders left join customers on Orders.customer_id = customers.customer_id;

select Orders.order_id, Orders.status, Shipping.shipping_id, Shipping.shpping_status from Shipping right join Orders on Shipping.order_id = Orders.order_id where Shipping.shpping_status != 'Delivered' or Shipping.shpping_status is null;

select customers.customer_id, customers.name from customers left join Orders ON customers.customer_id = Orders.customer_id where Orders.order_id is null;

select * from Orders where customer_id in (select customer_id from customers where year(registrationdate) > 2022);

select * from customers where customer_id = (select customer_id from Orders group by customer_id order by SUM(total_amount) desc limit 1);

select * from products where product_id not in( select distinct product_id from Orders_Items);

select MONTHNAME(order_date) as order_month, COUNT(order_id) as total_orders from Orders group by month(order_date), MONTHNAME(order_date);

select shipping_id, order_id, DATEDIFF(delivery_date, shipping_date) as delivery_time_days from Shipping where delivery_date is not null;

select order_id, DATE_FORMAT(order_date, '%d-%m-%Y') as formatted_order_date from Orders;

select UPPER(name) as uppercase_product_name from products;

select TRIM(name) as clean_customer_name from customers;

select customer_id, name, coalesce(NULLIF(email, ''), 'Not Provided') as email from customers;

select customer_id, SUM(total_amount) as total_spent, dense_rank() over (order by SUM(total_amount) desc) as customer_rank from Orders group by customer_id;

select  order_date, total_amount, SUM(total_amount) over (order by order_date) as cumulative_revenue from Orders;

select order_id, order_date, COUNT(order_id) OVER (order by order_date) as running_order_count from Orders;

select c.customer_id,c.name, coalesce(SUM(o.total_amount), 0) as total_spent, case when SUM(o.total_amount) > 50000 then 'Gold' when SUM(o.total_amount) between 20000 and 50000 then 'Silver' else 'Bronze' end as Loyalty_Status from Customers c left join Orders o on c.customer_id = o.customer_id group by c.customer_id, c.name;

select  product_id, name, coalesce(sum(quantity), 0) as total_units_sold, case  when sum(quantity) > 500 then 'Best Seller'  when sum(quantity) between 200 and 500 then 'Popular'  else 'Regular'  end as product_category from Products  left join Order_Items on products.product_id = Order_Items.product_id  group by product_id, name limit 0, 1000;