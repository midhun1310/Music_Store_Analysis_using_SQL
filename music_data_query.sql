1: Who is the senior most employee based on job title?
 
 select * from employee
 order by levels desc
 limit 1
 
2:which countries have th most invoices?
  
  select count(*),billing_country as c from invoice group by billing_country 
  order by c desc
  
3:What are the top 3 values ot total invoice

  select * from invoice
  order by total desc
  limit 3
  
  
4:which city has the best customers?We would like to throw a promotional music 
festival in the city we made the most money.write a query that returns one city 
that has the highest sum of invoice totals.Return both the city & sum of all 
invoice totals     

 select billing_city,sum(total) from invoice
 group by billing_city
 order by sum(total) desc
 limit 3
 
 
5:Who is the best customer?The customer who has spent the most money will
be declared the best customer.Write a query that returns the persons who 
has spent the most money

  select first_name,last_name,sum(total) as total from invoice join customer 
  on customer.customer_id=invoice.customer_id
  group by customer.first_name,customer.last_name
  order by total desc
  limit 3
  
  
Write query to return the email,first name,last name & genre of all Rock Music 
listeners.Return your list ordered alphabetically by email  starting with A


  select distinct email,first_name,last_name from customer
  join invoice on customer.customer_id=invoice.customer_id
  join invoice_line on invoice.invoice_id=invoice_line.invoice_id
  where track_id IN(
                select track_id from track
                 join genre on track.genre_id=genre.genre_id
                 where genre.name like 'Rock')
 order by email



Lets invite the artists who have written the most rock music in our 
dataset.Write a query that returns the artist name and total track count 
of the top 10 rock bands

select * from artist
  select artist.name,count(artist.artist_id) as no_of_songs
  from track
  join album on album.album_id=track.album_id
  join artist on artist.artist_id=album.artist_id
  join genre on genre.genre_id=track.genre_id
  where genre.name like 'Rock'
  group by artist.name
  order by no_of_songs desc
  limit 10
  
  
Return all the track names that have a song length longer than the average 
song length.Return the name and milliseconds for each track.
Order by the song length with the longest songs listed first.


  select name,milliseconds from track
  where milliseconds> (
                  select avg(milliseconds) as avg_track_length from track)
  order by milliseconds desc;
  
  
  
  
Find how much amount spent by each customer on artists?Write a query to 
return customer name,artist name and total spent

with best_selling_artist AS (
    select artist.artist_id as artist_id,artist.name as artist_name,
    sum(invoice_line.unit_price * invoice_line.quantity) as total_spent
    from invoice_line
    join track on track.track_id=invoice_line.track_id
    join album on album.album_id=track.album_id
    join artist on artist.artist_id=album.artist_id
    group by 1
    order by 3 desc
	limit 1 
)

 select c.customer_id,c.first_name,c.last_name,bsa.artist_name,
 sum(il.unit_price*il.quantity) as total_spent
 from invoice  as i
 join customer c on c.customer_id=i.customer_id
 join invoice_line as il on il.invoice_id=i.invoice_id
 join track t on t.track_id=il.track_id
 join album as alb on alb.album_id=t.album_id
 "join best_selling_artist as bsa on bsa.artist_id=alb.artist_id"
 group by 1,2,3,4
 order by 5 desc;


We want to find out the most popular music genre for each country.
We determine the most popular genre as the genre with the highest amount of 
purchases.Write a query that returns each country along with the top genre
For countries where the maximum number of purchases is shared return all genres

with popular_genre as(
select count(invoice_line.quantity) as purchases,customer.country,genre.name,
genre.genre_id from invoice_line
join invoice on invoice.invoice_id=invoice.invoice_id
join customer on customer.customer_id=invoice.customer_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id 
group by 2,3,4
order by 2 asc,1 desc
	)
	

