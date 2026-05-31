/*--------------------------------------------
    SECTION-01: Data Exploration
--------------------------------------------*/

/* Question 1:
List the total sales for each year. */
/* Prompt: List the total sales for each year. Use the table invoice (invoice_date, total_price).*/
SELECT 
    STRFTIME('%Y',DATE(invoice_date)) AS YR, 
    SUM(total_price)
FROM 
    invoice
GROUP BY 
    STRFTIME('%Y',DATE(invoice_date));
-- In MySQL, you can simply use the YEAR() function to extract the year from a datatime data type. Eg: YEAR(invoice_date) AS YR.
-- Refer to the "Note - Inbuilt Functions" content page available on the dashboard for the differences in syntax between SQLite and MySQL.

/* Question 2:
Check the distribution of the month wise sales for the year 2010. */
/*Prompt: Check the distribution of the month-wise sales for the year 2010. Use the table invoice (invoice_date, total_price).*/
SELECT 
    STRFTIME('%m',DATE(invoice_date)) AS MTH, 
    SUM(total_price)
FROM 
    invoice
WHERE
    SUBSTR(invoice_date,1,4) = '2010'
GROUP BY 
    STRFTIME('%m',DATE(invoice_date));
-- In MYSQL, you can simply use the YEAR() and MONTH() to extract the year and month from a datetime data type. Eg: MONTH(invoice_date) as MTH.
-- Refer to the "Note - Inbuilt Functions" content page available on the dashboard for the differences in syntax between SQLite and MySQL.

/* Question 3:
List the full names of the customers in decreasing order of sales. */
/*Prompt: List the full names of the customers in decreasing order of sales. 
Use the tables customers (customer_id, first_name, last_name) and invoice (customer_id, total_price). */
SELECT 
    first_name || ' ' || last_name AS full_name, 
    SUM(total_price)
FROM 
    customers
    LEFT JOIN invoice USING(customer_id)
GROUP BY 
    first_name || ' ' || last_name
ORDER BY 
    SUM(total_price) DESC;
-- In MySQL, you can use the CONCAT() function to combine two strings. Eg: CONCAT(first_name, last_name) AS full_name.
-- Refer to the "Note - Inbuilt Functions" content page available on the dashboard for the differences in syntax between SQLite and MySQL.

/* Question 4:
List all artists with their respective albums names, including artists with no albums. */
/*Prompt:List all artists with their respective album names, including artists with no albums. Use the tables artist (artist_id, artist_name) and album (album_id, title_name, artist_id).*/
SELECT 
    artist.artist_name AS Artist,
    album.title_name AS Album
FROM 
    artist
    LEFT JOIN album ON album.artist_id = artist.artist_id;
-- This query displays all artists present in the database irrespective of whether they have any linked albums.

/* Question 5:
Display each artist along with the count of albums they have produced, including artists with no albums. */
/*Prompt:Display each artist along with the count of albums they have produced, including artists with no albums. 
Use the tables artist (artist_id, artist_name) and album (album_id, artist_id). */
SELECT 
    artist.artist_name AS Artist, 
    COUNT(album.album_id) AS Album_Count
FROM 
    artist
    LEFT JOIN album ON artist.artist_id = album.artist_id
GROUP BY 
    artist.artist_name;
-- This query will return all artists along with the count of all albums they have produced.

/* Question 6:
Identify the total revenue for each album by summing the total prices from all invoices associated with the album. */
/* Prompt: Identify the total revenue for each album by summing the prices from all invoices associated with it. Include the artist's name in your output. 
Use the tables invoice_items (track_id, unit_price, quantity), tracks (track_id, album_id), album (album_id, title_name, artist_id), and artist (artist_id, artist_name). */
SELECT 
    al.title_name AS album_title, 
    SUM(ii.unit_price * ii.quantity) AS total_revenue, 
    ar.artist_name
FROM 
    invoice_items ii
    INNER JOIN tracks t ON ii.track_id = t.track_id
    INNER JOIN album al ON t.album_id = al.album_id
    INNER JOIN artist ar ON al.artist_id = ar.artist_id
GROUP BY 
    al.album_id;
-- This query displatys the total revenue for each album along with the artist's name.


/* -----------------------------------
    SECTION-02: Recommendations
------------------------------------*/

/* Question 1:
What are the most popular genres in each country, ranked by the number of purchases? */
/* Prompt:What are the most popular genres in each country, ranked by the number of purchases? 
Use the tables invoice_items (invoice_id, track_id, invoice_line_id), invoice (invoice_id, customer_id), customers (customer_id, customer_country), tracks (track_id, genre_id), and genre (genre_id, genre_name).
 */
 --Prompt Explanation:Break down why each JOIN is needed, what the GROUP BY is doing, and how the results are ordered to show the most purchased genre per country.
SELECT 
    c.customer_country, 
    g.genre_name, 
    COUNT(ii.invoice_line_id) AS purchase_count
FROM 
    invoice_items ii
    JOIN invoice i ON ii.invoice_id = i.invoice_id
    JOIN customers c ON i.customer_id = c.customer_id
    JOIN tracks t ON ii.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
GROUP BY 
    c.customer_country, 
    g.genre_name
ORDER BY 
    c.customer_country, 
    purchase_count DESC;
-- This query provides insight on the most popular genres in each country.

/* Question 2:
Which artists are the most popular in each country? */
/* Prompt: Which artists are the most popular in each country? 
Use the tables invoice_items (invoice_id, track_id, invoice_line_id), invoice (invoice_id, customer_id), customers (customer_id, customer_country), tracks (track_id, album_id), album (album_id, artist_id), and artist (artist_id, artist_name).
 */
 --Explanation: Walk through of each JOIN step by step — how do we get from a purchase in invoice_items all the way to an artist's name — and explain why GROUP BY and ORDER BY are used the way they are.
SELECT 
    c.customer_country, 
    ar.artist_name, 
    COUNT(ii.invoice_line_id) AS purchase_count
FROM 
    invoice_items ii
    JOIN invoice i ON ii.invoice_id = i.invoice_id
    JOIN customers c ON i.customer_id = c.customer_id
    JOIN tracks t ON ii.track_id = t.track_id
    JOIN album al ON t.album_id = al.album_id
    JOIN artist ar ON al.artist_id = ar.artist_id
GROUP BY 
    c.customer_country, 
    ar.artist_name
ORDER BY 
    c.customer_country, 
    purchase_count DESC;
-- Using this query, you can find out the most popular artists in each country.