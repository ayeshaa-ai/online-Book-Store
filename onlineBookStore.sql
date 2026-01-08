drop table if exists Books;

-- TABLE 1: BOOKS
CREATE TABLE Books(
Book_ID serial PRIMARY KEY,
Title VARCHAR (100),
Author VARCHAR (100),
Genre VARCHAR (50),
Published_Year INT,
Price NUMERIC (10,2),
Stock INT
);
-- TABLE 2: CUSTOMERS
CREATE TABLE customers(
Customer_ID serial PRIMARY KEY ,
Name	VARCHAR(100),
Email	VARCHAR(100),
Phone   VARCHAR(100),
City	VARCHAR(100),
Country VARCHAR(100)
);
-- TABLE 3:ORDERS
CREATE TABLE orders(
Order_ID	serial PRIMARY KEY ,
Customer_ID INT  references customers(customer_id),
Book_ID	int references books(book_id),
Order_Date date,
Quantity	int,
Total_Amount numeric(10,2)
)

-- data of book file:
copy Books(Book_ID  ,Title ,Author ,Genre ,Published_Year,Price ,Stock )
from 'C:\Files\Books.csv'
csv header
select * from Books;

--  data of customer file:
copy customers(Customer_ID, Name, Email	,Phone,	City,Country)
from 'C:\Files\Customers.csv'
csv header
select * from customers;

-- data of orders file:
copy orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
from 'C:\Files\Orders.csv'
csv header
select * from orders;

-- select query
select * from Books;
select * from customers;
select * from orders;

-- "all the books in the 'FICTION GENRE': "
 select * from Books
 where genre='Fiction';

-- "find the books published after the year 1950:"
select * from Books
where published_year>1950;

-- list all the customers from canada:
select * from customers
where country='Canada';

-- show orders placed in november 2023:
select * from orders
where order_date between '2023-11-01' and '2023-11-30';

-- retrieve the total stock of books available:
select sum(stock)as total_stock
from Books;

-- find the details of the most expensive books:
select * from Books order by price Desc limit 1;

-- show all customers who ordered more than 1 quantity of book:
select * from orders
where quantity>1;

-- retrieve all orders where the total amount exceeds 520;
select * from orders
where total_amount>250;

-- list all the genres avaliable in the books table:(for unique use distinct)
select  distinct genre from Books;

-- find the book the with the lowest stock:
select* from Books order by stock asc limit 1;

--) calculate  the total revenue generated from all orders:
select sum(total_amount)as REVENUE from orders;

-- ADVANCED QUERYY:
 -- RETRIEVE THE TOTAL NUMBER OF BOOKS SOLD FOR EACH GENRE:
 SELECT b.Genre, sum(o.quantity)
 from orders o
 join 
 Books b on o.book_id= b.book_id
 group by b.genre;

-- find the average price of books in the "fantasy" genre:
select avg(price) as average_price
from Books 
where genre='Fantasy';

-- list customers who have placed at least 2 orders:
select customer_id , count(order_id)as Order_count 
from orders
group by customer_id
having count(order_id)>=2;

-- find the most frequently ordered book:
select o.Book_id,b.title, count(o.order_id)as ORDER_COUNT
FROM orders o
join
Books b on o.book_id=b.book_id
group by o.Book_id, b.book_id
order by ORDER_COUNT desc limit  1;

-- show the top 3 most expensive books of "fantasy " genre:
select * from books
where genre ='Fantasy'
order by price desc limit 3;

-- retrieve  the total quantity of  books sold by each author
select b.author , sum(o.quantity) as TOTAL_BOOK_SOLD
FROM orders o
join
Books b on o.book_id=b.book_id
group  by b.author;

-- list the cities where customers who spent over $30 are located:

select  distinct c.city,total_amount
from orders o
join customers c on o.customer_id=c.customer_id 
where o.total_amount>300;

-- find the customers who spend the most on orders:
select c.customer_id, c.name, sum(total_amount) as total_spent
from orders o
join customers c on o.customer_id=c.customer_id
group by c.customer_id,c.name
order by total_spent desc limit 2;

-- claculate the stock remaining after fulfilling all orders:
select b.book_id, b.title,b.stock,coalesce (sum(quantity),0) as order_quantity,
b.stock - coalesce (sum(o.quantity),0) as rema_quantity
from books b 
left join orders o on b.book_id=o.book_id
group by b.book_id order by b.book_id;




