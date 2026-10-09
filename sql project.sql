create database music_store;
use music_store;

-- 1. Genre and MediaType
CREATE TABLE Genre (
        genre_id INT PRIMARY KEY,
        name VARCHAR(120)
);
select * from genre;
CREATE TABLE MediaType (
        media_type_id INT PRIMARY KEY,
        name VARCHAR(120)
);
select count(*) as total_counnt from MediaType;
-- 2. Employee
CREATE TABLE Employee (
        employee_id INT PRIMARY KEY,
        last_name VARCHAR(120),
        first_name VARCHAR(120),
        title VARCHAR(120),
        reports_to INT,
 levels VARCHAR(255),
        birthdate DATE,
        hire_date DATE,
        address VARCHAR(255),
        city VARCHAR(100),
        state VARCHAR(100),
        country VARCHAR(100),
        postal_code VARCHAR(20),
        phone VARCHAR(50),
        fax VARCHAR(50),
        email VARCHAR(100)
);
select count(*) as total_counnt from employee;
-- 3. Customer
CREATE TABLE Customer (
        customer_id INT PRIMARY KEY,
        first_name VARCHAR(120),
        last_name VARCHAR(120),
        company VARCHAR(120),
        address VARCHAR(255),
        city VARCHAR(100),
        state VARCHAR(100),
        country VARCHAR(100),
        postal_code VARCHAR(20),
        phone VARCHAR(50),
        fax VARCHAR(50),
        email VARCHAR(100),
        support_rep_id INT,
        FOREIGN KEY (support_rep_id) REFERENCES Employee(employee_id)
);
select count(*) as total_counnt from customer;
-- 4. Artist
CREATE TABLE Artist (
        artist_id INT PRIMARY KEY,
        name VARCHAR(120)
);
select count(*) as total_counnt from artist;
-- 5. Album
CREATE TABLE Album (
        album_id INT PRIMARY KEY,
        title VARCHAR(160),
        artist_id INT,
        FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
);
select count(*) as total_counnt from album;
-- 6. Track
CREATE TABLE Track (
        track_id INT PRIMARY KEY,
        name VARCHAR(200),
        album_id INT,
        media_type_id INT,
        genre_id INT,
        composer VARCHAR(220),
        milliseconds INT,
        bytes INT,
        unit_price DECIMAL(10,2),
        FOREIGN KEY (album_id) REFERENCES Album(album_id),
        FOREIGN KEY (media_type_id) REFERENCES MediaType(media_type_id),
        FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
);
select count(*) as total_counnt from track;
-- 7. Invoice
CREATE TABLE Invoice (
        invoice_id INT PRIMARY KEY,
        customer_id INT,
        invoice_date DATE,
        billing_address VARCHAR(255),
        billing_city VARCHAR(100),
        billing_state VARCHAR(100),
        billing_country VARCHAR(100),
        billing_postal_code VARCHAR(20),
        total DECIMAL(10,2),
        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
select count(*) as total_counnt from invoice;
-- 8. InvoiceLine
CREATE TABLE InvoiceLine (
        invoice_line_id INT PRIMARY KEY,
        invoice_id INT,
        track_id INT,
        unit_price DECIMAL(10,2),
        quantity INT,
        FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id),
        FOREIGN KEY (track_id) REFERENCES Track(track_id)
);
select count(*) as total_counnt from invoiceline;
-- 9. Playlist
CREATE TABLE Playlist (
        playlist_id INT PRIMARY KEY,
        name VARCHAR(255)
);
select count(*) as total_counnt from playlist;
-- 10. PlaylistTrack
CREATE TABLE PlaylistTrack (
        playlist_id INT,
        track_id INT,
        PRIMARY KEY (playlist_id, track_id),
        FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id),
        FOREIGN KEY (track_id) REFERENCES Track(track_id)
);
select count(*) as total_counnt from playlisttrack;


-- question 1
-- 1. Who is the senior most employee based on job title?
select * from employee where reports_to is null;

-- view version
create view employees_no_manager as
select *
from employee
where reports_to is null;

select *
from employees_no_manager;

-- stored procedure
delimiter $$

create procedure get_employees_no_manager()
begin
    select *
    from employee
    where reports_to is null;
end $$

delimiter ;
call get_employees_no_manager();

-- cte version
with employees_no_manager as (
    select *
    from employee
    where reports_to is null
)
select *
from employees_no_manager;

-- dt version
select *
from (
    select *
    from employee
    where reports_to is null
) as employees_no_manager;

-- 2. Which countries have the most Invoices?
select billing_country,count(*) as most_count 
from  invoice group by billing_country order by most_count desc;

-- sub-query version
select distinct 
       i.billing_country,
(select COUNT(*)from invoice i2
where i2.billing_country = i.billing_country) 
as most_count from invoice i
order by  most_count desc;

-- view version
create view invoice_count_by_country as
select billing_country, count(*) as most_count
from invoice
group by billing_country
order by most_count desc;

select *
from invoice_count_by_country;

-- stored procedure
delimiter //

create procedure invoice_count_by_country()
begin
    select billing_country, count(*) as most_count
    from invoice
    group by billing_country
    order by most_count desc;
end //

delimiter ;

call invoice_count_by_country();


-- cte version
with invoice_count_by_country as (
    select billing_country, count(*) as most_count
    from invoice
    group by billing_country
)
select *
from invoice_count_by_country
order by most_count desc;

-- dt version
select *
from (
    select billing_country, count(*) as most_count
    from invoice
    group by billing_country
) as invoice_count_by_country
order by most_count desc;



-- 3. What are the top 3 values of total invoice?
select total from invoice group by total order by total desc limit 3;


-- view version
create view top_3_invoice_totals as
select total
from invoice
group by total
order by total desc
limit 3;

select * 
from top_3_invoice_totals;

-- stored procedure
delimiter $$


create procedure get_three_invoice_totals()
begin
    select total
    from invoice
    group by total
    order by total desc
    limit 3;
end $$

delimiter ;
call get_three_invoice_totals();

-- cte version
with three_invoice_totals as (
    select total
    from invoice
    group by total
    order by total desc
    limit 3
)
select *
from three_invoice_totals;

-- dt version 
select *
from (
    select total
    from invoice
    group by total
    order by total desc
    limit 3
) as three_invoice_totals;

-- 4. Which city has the best customers? - 
-- We would like to throw a promotional 
-- Music Festival in the city we made the most money. 
-- Write a query that returns one city that has
-- the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals

select c.city,sum(i.total) as most_revenue from customer as c 
join invoice as i on c.customer_id=i.customer_id 
group by c.city order by most_revenue desc limit 1;

-- view version 
create view city_revenue as
select c.city, sum(i.total) as most_revenue
from customer as c
join invoice as i on c.customer_id = i.customer_id
group by c.city
order by most_revenue desc
limit 1;
select *
from city_revenue;

-- stored procedure
delimiter //

create procedure get_city_revenue()
begin
    select c.city, sum(i.total) as most_revenue
    from customer as c
    join invoice as i on c.customer_id = i.customer_id
    group by c.city
    order by most_revenue desc
    limit 1;
end //

delimiter ;
call get_city_revenue();

-- cte version
with city_revenue as (
    select c.city, sum(i.total) as most_revenue
    from customer as c
    join invoice as i on c.customer_id = i.customer_id
    group by c.city
)
select *
from city_revenue
order by most_revenue desc
limit 1;

-- derived table
select *
from (
    select c.city, sum(i.total) as most_revenue
    from customer as c
    join invoice as i on c.customer_id = i.customer_id
    group by c.city
) as city_revenue
order by most_revenue desc
limit 1;

-- 5. Who is the best customer? - 
-- The customer who has spent the most money
-- will be declared the best customer. 
-- Write a query that returns the person
-- who has spent the most money

select concat(c.first_name,c.last_name) as customer_name ,
 sum(total) as most_spent
 from customer as c 
 join invoice as i on c.customer_id = i.customer_id 
 group by customer_name 
 order by most_spent desc limit 1;
 
 -- view version
 create view top_customer as
select concat(c.first_name, c.last_name) as customer_name,
       sum(total) as most_spent
from customer as c
join invoice as i on c.customer_id = i.customer_id
group by customer_name
order by most_spent desc
limit 1;
select *
from top_customer;

-- stored procedure
delimiter //

create procedure get_top_customer()
begin
    select concat(c.first_name, c.last_name) as customer_name,
           sum(total) as most_spent
    from customer as c
    join invoice as i on c.customer_id = i.customer_id
    group by customer_name
    order by most_spent desc
    limit 1;
end //

delimiter ;
 call get_top_customer();
 
 -- cte version
 with customer_spending as (
    select concat(c.first_name, c.last_name) as customer_name,
           sum(total) as most_spent
    from customer as c
    join invoice as i on c.customer_id = i.customer_id
    group by customer_name
)
select *
from customer_spending
order by most_spent desc
limit 1;

-- derived table
select *
from (
    select concat(c.first_name, c.last_name) as customer_name,
           sum(total) as most_spent
    from customer as c
    join invoice as i on c.customer_id = i.customer_id
    group by customer_name
) as customer_spending
order by most_spent desc
limit 1;

 -- 6. Write a query to return the email,
 -- first name, last name, & Genre of all Rock Music listeners.
--  Return your list ordered alphabetically by email starting with A

	select distinct c.email,c.first_name , c.last_name ,
    g.name from customer as c
    join invoice as i on c.customer_id=i.customer_id  
    join invoiceline as il on i.invoice_id= il.invoice_id 
    join track as t on il.track_id=t.track_id
    join genre as g on t.genre_id=g.genre_id 
    where g.name ='Rock'
    order by c.email;
    
    -- cte version
    with composite as (select c.email as email,concat(c.first_name,'   ',c.last_name) as customer_name,g.name as Genre 
    from customer as c
    join invoice as i on c.customer_id=i.customer_id
    join invoiceline as il on i.invoice_id=il.invoice_id
    join track as t on il.track_id = t.track_id
    join genre as g on t.genre_id=g.genre_id)
    select email, customer_name,Genre from composite where Genre='Rock'group by email,customer_name,genre order by email;
    
    -- dt version
    select email,customer_name,Genre from (select c.email as email,concat(c.first_name,'   ',c.last_name) as customer_name,g.name as Genre 
    from customer as c
    join invoice as i on c.customer_id=i.customer_id
    join invoiceline as il on i.invoice_id=il.invoice_id
    join track as t on il.track_id = t.track_id
    join genre as g on t.genre_id=g.genre_id) as composite where Genre='Rock' group by email,customer_name,genre order by email;
    
    -- views 
    create view 7th_query as 
    select distinct c.email,c.first_name , c.last_name ,g.name from customer as c
    join invoice as i on c.customer_id=i.customer_id  
    join invoiceline as il on i.invoice_id= il.invoice_id 
    join track as t on il.track_id=t.track_id
    join genre as g on t.genre_id=g.genre_id 
    where g.name ='Rock'
    order by c.email;
    
    select * from 7th_query;
    
    -- stored_procedure
    
    delimiter $$ 
    create procedure 7th_query (in genre_name varchar(54))
    begin
    select distinct c.email,c.first_name , c.last_name ,g.name from customer as c
    join invoice as i on c.customer_id=i.customer_id  
    join invoiceline as il on i.invoice_id= il.invoice_id 
    join track as t on il.track_id=t.track_id
    join genre as g on t.genre_id=g.genre_id 
    where g.name =genre_name
    order by c.email
    ;
    end
	$$ delimiter ;
    
    call 7th_query('Rock');
    
-- 7. Let's invite the artists
-- who have written the most rock music in our dataset. 
-- Write a query that returns
-- the Artist name and total track count of the top 10 rock bands 

select a.name,count(t.track_id) as total_track_count
 from artist as a 
join album as al on a.artist_id=al.artist_id 
join track as t on al.album_id=t.album_id 
join genre as g on t.genre_id=g.genre_id
where g.name='Rock'
group by a.artist_id,a.name
order by total_track_count desc
limit 10;

-- cte version
with composite as (select a.name as Artist_name,a.artist_id as artist_id,count(t.track_id) as total_track_count,g.name as Genre 
from artist as a 
join album as al on a.artist_id=al.artist_id 
join track as t on al.album_id=t.album_id 
join genre as g on t.genre_id=g.genre_id
group by artist_id,Artist_name,Genre
)
select Artist_name, total_track_count, Genre from (select Artist_name,artist_id,total_track_count, Genre 
from composite
group by artist_id,Artist_name,Genre) as 
composite
where Genre='Rock'
order by total_track_count desc
limit 10;

-- dt version
select Artist_name, total_track_count, Genre from (select a.name as Artist_name,a.artist_id as artist_id,count(t.track_id) as total_track_count,g.name as Genre 
from artist as a 
join album as al on a.artist_id=al.artist_id 
join track as t on al.album_id=t.album_id 
join genre as g on t.genre_id=g.genre_id
group by artist_id,Artist_name,Genre) as composite
where Genre='Rock'
order by total_track_count desc
limit 10;

-- view version 
create view 8th_query as 
select a.name,count(t.track_id) as total_track_count from artist as a 
join album as al on a.artist_id=al.artist_id 
join track as t on al.album_id=t.album_id 
join genre as g on t.genre_id=g.genre_id
where g.name='Rock'
group by a.artist_id,a.name
order by total_track_count desc
limit 10;


select * from 8th_query;

-- storedProcedure

delimiter $$
create procedure 8th_query(in genre_name varchar(53),in limits int)
begin
select a.name,count(t.track_id) as total_track_count from artist as a 
join album as al on a.artist_id=al.artist_id 
join track as t on al.album_id=t.album_id 
join genre as g on t.genre_id=g.genre_id
where g.name= genre_name
group by a.artist_id,a.name
order by total_track_count desc
limit limits;
end
$$ delimiter ;

call 8th_query('Rock',10);

-- 8. Return all the track names that
-- have a song length longer than the average song length.
-- Return the Name and Milliseconds for each track. 
-- Order by the song length, with the longest songs listed first

select name,milliseconds from track
 where milliseconds > (select avg(milliseconds) from track)
 order by milliseconds desc;

-- view version
create view tracks_above_average as
select name, milliseconds
from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;
select *
from tracks_above_average;

-- stored procedure
delimiter //

create procedure get_tracks_above_average()
begin
    select name, milliseconds
    from track
    where milliseconds > (select avg(milliseconds) from track)
    order by milliseconds desc;
end //

delimiter ;
call get_tracks_above_average();

-- cte version
with average_track_length as (
    select avg(milliseconds) as avg_milliseconds
    from track
)
select t.name, t.milliseconds
from track as t
cross join average_track_length as a
where t.milliseconds > a.avg_milliseconds
order by t.milliseconds desc;

-- dt version
select t.name, t.milliseconds
from track as t
cross join (
    select avg(milliseconds) as avg_milliseconds
    from track
) as average_track_length
where t.milliseconds > average_track_length.avg_milliseconds
order by t.milliseconds desc;


-- 9. Find how much amount is spent by each customer on artists? 
-- Write a query to return customer name, artist name and total spent 

select distinct concat(c.first_name , c.last_name) as customer_name ,
ar.name as artist,
 SUM(il.unit_price * il.quantity) AS total_spent
  from customer as c
    join invoice as i on c.customer_id=i.customer_id  
    join invoiceline as il on i.invoice_id= il.invoice_id 
    join track as t on il.track_id=t.track_id
    join album as al on t.album_id=al.album_id 
	join artist as ar on al.artist_id=ar.artist_id
    group by customer_name,ar.name
    order by total_spent desc;

-- view version
create view customer_artist_spending as
select concat(c.first_name, ' ', c.last_name) as customer_name,
       ar.name as artist,
       sum(il.unit_price * il.quantity) as total_spent
from customer as c
join invoice as i on c.customer_id = i.customer_id
join invoiceline as il on i.invoice_id = il.invoice_id
join track as t on il.track_id = t.track_id
join album as al on t.album_id = al.album_id
join artist as ar on al.artist_id = ar.artist_id
group by customer_name, ar.name;
select *
from customer_artist_spending
order by total_spent desc;


-- 10. We want to find out the most popular music Genre for each country.
--  We determine the most popular genre as
--  the genre with the highest amount of purchases. 
-- Write a query that returns each country along with the top Genre. 
-- For countries where the maximum number of purchases is shared, return all Genres

with composite as 
(select i.billing_country,g.name as genre_name,
count(*) total_count from invoice as i 
join invoiceline as il on i.invoice_id=il.invoice_id
join track as t on il.track_id = t.track_id
join genre as g on t.genre_id=g.genre_id
group by i.billing_country,g.genre_id,g.name),
ranked AS 
(select billing_country,genre_name,total_count,
 rank() over 
 (partition by billing_country
order by total_count desc)
as ranked_no from composite)
select billing_country,genre_name,total_count 
from ranked where ranked_no=1;

-- stored procedure
delimiter //

create procedure get_customer_artist_spending()
begin
    select concat(c.first_name, ' ', c.last_name) as customer_name,
           ar.name as artist,
           sum(il.unit_price * il.quantity) as total_spent
    from customer as c
    join invoice as i on c.customer_id = i.customer_id
    join invoiceline as il on i.invoice_id = il.invoice_id
    join track as t on il.track_id = t.track_id
    join album as al on t.album_id = al.album_id
    join artist as ar on al.artist_id = ar.artist_id
    group by customer_name, ar.name
    order by total_spent desc;
end //

delimiter ;
call get_customer_artist_spending();



select *
from (
    select concat(c.first_name, ' ', c.last_name) as customer_name,
           ar.name as artist,
           sum(il.unit_price * il.quantity) as total_spent
    from customer as c
    join invoice as i on c.customer_id = i.customer_id
    join invoiceline as il on i.invoice_id = il.invoice_id
    join track as t on il.track_id = t.track_id
    join album as al on t.album_id = al.album_id
    join artist as ar on al.artist_id = ar.artist_id
    group by customer_name, ar.name
) as customer_artist_spending
order by total_spent desc;


    -- 11. Write a query that determines the customer that has spent the most on music for each country. 
    -- Write a query that returns the country along with the top customer and how much they spent.
    -- For countries where the top amount spent is shared, provide all customers who spent this amount

with composite as
 (select c.country,concat(c.first_name,c.last_name) as customer_name,
 sum(il.unit_price*il.quantity) as total_count from customer as c 
join invoice as i  on c.customer_id=i.customer_id
join invoiceline as il on i.invoice_id=il.invoice_id
join track as t on il.track_id = t.track_id
join genre as g on t.genre_id=g.genre_id
group by c.country,customer_name),
ranked AS (select country,customer_name,total_count,
 rank() over (partition by country order by total_count desc)
 as ranked_no from composite)
select country,customer_name,total_count 
from ranked where ranked_no=1 order by country;

-- view version
create view top_customer_by_country as
with composite as (
    select c.country,
           concat(c.first_name, ' ', c.last_name) as customer_name,
           sum(il.unit_price * il.quantity) as total_count
    from customer as c
    join invoice as i on c.customer_id = i.customer_id
    join invoiceline as il on i.invoice_id = il.invoice_id
    join track as t on il.track_id = t.track_id
    join genre as g on t.genre_id = g.genre_id
    group by c.country, customer_name
),
ranked as (
    select country,
           customer_name,
           total_count,
           rank() over (
               partition by country
               order by total_count desc
           ) as ranked_no
    from composite
)
select country, customer_name, total_count
from ranked
where ranked_no = 1;
select *
from top_customer_by_country

-- end of the file ---
order by country;


    