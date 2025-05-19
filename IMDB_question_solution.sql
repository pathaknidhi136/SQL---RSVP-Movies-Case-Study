USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

select table_name, table_rows
from INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';

/*Number of Rows after ignoring the Null Rows

SELECT COUNT(*) AS movie
FROM movie;
-- There are total 7,997 rows

SELECT COUNT(*) AS genre
FROM genre;
-- There are total of 14,662 rows 

SELECT COUNT(*) AS director_mapping
FROM director_mapping;
-- There are total of 3,867 rows 

SELECT COUNT(*) AS role_mapping
FROM role_mapping;
-- There are total of 15,615 rows 

SELECT COUNT(*) AS 'names'
FROM names;
-- There are total of 25,735 rows 

SELECT COUNT(*) AS ratings
FROM ratings;
-- There are total of 7,997 rows */





-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) as id_nulls,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) as title_nulls,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) as year_nulls,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) as date_published_nulls,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) as duration_nulls,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) as country_nulls,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) as worldwide_gross_nulls,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) as languages_nulls,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) as production_company_nulls
FROM movies;

/* Answer_2
id_null,title_null,year_null,date_null,duration_null,country_null,world_null,language_null,production_null
0,0,0,0,0,20,3724,194,528

 */

-- the columns which have null values in the table MOVIES are country, worldwide_gross_income,languages and production_company


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year, COUNT(*) as number_of_movies
FROM movies
GROUP BY year
ORDER BY year;

/* Answer_3.1

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|	2944			|
|	2019		|	2001			|

+---------------+-------------------+ */
-- we got count movies by each year 

SELECT MONTH(date_published) as month_num, COUNT(*) as number_of_movies
FROM movies
GROUP BY month_num
ORDER BY month_num;

/* Answer_3.2

+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|		804			|
|	2			|		640			|
|	3			|		824			|
|	4			|		680			|
|	5			|		625			|
|	6			|		580			|
|	7			|		493			|
|	8			|		678			|
|	9			|		809			|
|	10			|		801			|
|	11			|		625			|
|	12			|		438			|
+---------------+-------------------+ */



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(*) as movie_count
FROM movies
WHERE year = 2019 
AND (country LIKE '%USA%' OR country LIKE '%India%');

/*Answer4:

number_of_movies_released_in_India_or_USA
1059
USA and India produced 1059 movies together*/



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre
FROM genre
ORDER BY genre;

/* Answer_5
+---------------+
|	genre		|
+---------------+
|	Drama	    |
|	Fantasy 	|
|	Thriller    |
| 	Comedy      |
|	Horror      |
| 	Family      |
| 	Romance     |
| 	Adventure   |
| 	Action   	|
| 	Sci-Fi   	|
| 	Crime   	|
| 	Mystery   	|
| 	Others   	|
+---------------+

 */


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre, count(*) as movies_produced 
from genre
group by genre
order by 2 desc
Limit 1;


/* Answer_6
genre,movies_made
Drama,4285
 */

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH MovieGenreCounts AS (
    SELECT movie_id, COUNT(genre) as genre_count
    FROM genre
    GROUP BY movie_id
)
SELECT COUNT(*) as single_genre_movies
FROM MovieGenreCounts
WHERE genre_count = 1;








/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, AVG(m.duration) as avg_duration
FROM movies m
INNER JOIN genre g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY 2 DESC;

/* Answer_8
genre,avg_duration
Drama,106.7746
Fantasy,105.1404
Thriller,101.5761
Comedy,102.6227
Horror,92.7243
Family,100.9669
Romance,109.5342
Adventure,101.8714
Action,112.8829
Sci-Fi,97.9413
Crime,107.0517
Mystery,101.8000
Others,100.1600

 */

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH GenreRanks AS (
    SELECT genre, COUNT(movie_id) as movie_count,
           RANK() OVER(ORDER BY COUNT(movie_id) DESC) as genre_rank
    FROM genre
    GROUP BY genre
)
SELECT *
FROM GenreRanks
WHERE genre = 'Thriller';








/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) as min_avg_rating,
    MAX(avg_rating) as max_avg_rating,
    MIN(total_votes) as min_total_votes,
    MAX(total_votes) as max_total_votes,
    MIN(median_rating) as min_median_rating,
    MAX(median_rating) as max_median_rating
FROM ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

-- It's ok if RANK() or DENSE_RANK() is used too

SELECT title, avg_rating,
		DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM movie AS m
INNER JOIN ratings AS r
ON r.movie_id = m.id
LIMIT 10;






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating, COUNT(*) as movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;








/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_hits AS
(
    SELECT m.production_company,
           COUNT(m.id) as movie_count,
           RANK() OVER(ORDER BY COUNT(m.id) DESC) as prod_company_rank
    FROM movie m 
    INNER JOIN ratings r ON m.id = r.movie_id
    WHERE r.avg_rating > 8 
    AND m.production_company IS NOT NULL
    AND m.production_company != ''  -- Handle empty strings
    GROUP BY m.production_company
)
SELECT * 
FROM production_company_hits 
WHERE prod_company_rank = 1;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, COUNT(DISTINCT m.id) as movie_count
FROM movies m
INNER JOIN genre g ON m.id = g.movie_id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE YEAR(m.date_published) = 2017
AND MONTH(m.date_published) = 3
AND m.country LIKE '%USA%'
AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY 2 DESC;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT m.title, r.avg_rating, g.genre
FROM movies m
INNER JOIN ratings r ON m.id = r.movie_id
INNER JOIN genre g ON m.id = g.movie_id
WHERE m.title LIKE 'The%'
AND r.avg_rating > 8
ORDER BY r.avg_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(*) as movie_count
FROM movies m
INNER JOIN ratings r ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
AND r.median_rating = 8;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    total_votes, languages
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    languages = 'German'
        OR languages = 'Italian'
GROUP BY languages
ORDER BY total_votes DESC; 

-- Answer is Yes
-- German movies got more votes than Italian movies





-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) as name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) as height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) as date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) as known_for_movies_nulls
FROM names;

/*Answer_18
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|		17335		|	       13431	  |	      15226      	 |
+---------------+-------------------+---------------------+----------------------+*/


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH TopGenres AS (
    SELECT g.genre, COUNT(m.id) as movie_count
    FROM movies m
    INNER JOIN genre g ON m.id = g.movie_id
    INNER JOIN ratings r ON m.id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
    ORDER BY movie_count DESC
    LIMIT 3
),
DirectorStats AS (
    SELECT n.name as director_name, COUNT(m.id) as movie_count,
           ROW_NUMBER() OVER(ORDER BY COUNT(m.id) DESC) as director_rank
    FROM names n
    INNER JOIN director_mapping dm ON n.id = dm.name_id
    INNER JOIN movies m ON dm.movie_id = m.id
    INNER JOIN ratings r ON m.id = r.movie_id
    INNER JOIN genre g ON m.id = g.movie_id
    WHERE r.avg_rating > 8
    AND g.genre IN (SELECT genre FROM TopGenres)
    GROUP BY n.name
)
SELECT director_name, movie_count
FROM DirectorStats
WHERE director_rank <= 3;



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name as actor_name, COUNT(rm.movie_id) as movie_count
FROM names n
INNER JOIN role_mapping rm ON n.id = rm.name_id
INNER JOIN movies m ON rm.movie_id = m.id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE r.median_rating >= 8
AND rm.category = 'actor'
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, SUM(r.total_votes) as vote_count,
       RANK() OVER(ORDER BY SUM(r.total_votes) DESC) as prod_comp_rank
FROM movies m
INNER JOIN ratings r ON m.id = r.movie_id
WHERE m.production_company IS NOT NULL
GROUP BY m.production_company
ORDER BY 2 DESC
LIMIT 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_ratings AS
(
SELECT n.name as actor_name,
       SUM(r.total_votes) as total_votes,
       COUNT(m.id) as movie_count,
       ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes), 2) as actor_avg_rating
FROM movie m
INNER JOIN role_mapping rm ON m.id = rm.movie_id
INNER JOIN names n ON rm.name_id = n.id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE rm.category = 'actor' AND m.country LIKE '%India%'
GROUP BY n.name
HAVING COUNT(m.id) >= 5
)
SELECT *,
       RANK() OVER(ORDER BY actor_avg_rating DESC, total_votes DESC) as actor_rank
FROM actor_ratings;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH ActressStats AS (
    SELECT n.name as actress_name,
           SUM(r.total_votes) as total_votes,
           COUNT(DISTINCT m.id) as movie_count,
           ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes), 2) as actress_avg_rating
    FROM names n
    INNER JOIN role_mapping rm ON n.id = rm.name_id
    INNER JOIN movies m ON rm.movie_id = m.id
    INNER JOIN ratings r ON m.id = r.movie_id
    WHERE m.country LIKE '%India%'
    AND m.languages LIKE '%Hindi%'
    AND rm.category = 'actress'
    GROUP BY n.name
    HAVING COUNT(DISTINCT m.id) >= 3
)
SELECT *,
       RANK() OVER(ORDER BY actress_avg_rating DESC, total_votes DESC) as actress_rank
FROM ActressStats;







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

SELECT 
    m.title,
    r.avg_rating,
    CASE 
        WHEN r.avg_rating > 8 THEN 'Superhit movies'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS movie_category
FROM movie m
INNER JOIN genre g ON m.id = g.movie_id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE g.genre = 'Thriller'
AND r.total_votes >= 25000  -- Added minimum votes threshold
ORDER BY r.avg_rating DESC;



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_stats AS (
    SELECT 
        g.genre,
        ROUND(AVG(m.duration), 2) as avg_duration
    FROM movie m
    INNER JOIN genre g ON m.id = g.movie_id
    GROUP BY g.genre
)
SELECT 
    genre,
    avg_duration,
    SUM(avg_duration) OVER(ORDER BY genre) as running_total_duration,
    AVG(avg_duration) OVER(ORDER BY genre 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg_duration
FROM genre_stats
ORDER BY genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH TopGenres AS (
    SELECT genre, COUNT(*) as movie_count
    FROM genre
    GROUP BY genre
    ORDER BY movie_count DESC
    LIMIT 3
),
MovieRanks AS (
    SELECT g.genre, m.year, m.title, m.worlwide_gross_income,
           RANK() OVER(PARTITION BY m.year, g.genre 
                      ORDER BY CAST(REPLACE(REPLACE(m.worlwide_gross_income, '$ ', ''), ',', '') AS DECIMAL) DESC) as movie_rank
    FROM movies m
    INNER JOIN genre g ON m.id = g.movie_id
    WHERE g.genre IN (SELECT genre FROM TopGenres)
)
SELECT *
FROM MovieRanks
WHERE movie_rank <= 5;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH multilingual_hits AS
(
    SELECT 
        m.production_company,
        COUNT(DISTINCT m.id) as movie_count,
        DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT m.id) DESC) as prod_comp_rank
    FROM movie m
    INNER JOIN ratings r ON m.id = r.movie_id
    WHERE r.median_rating >= 8
    AND m.production_company IS NOT NULL
    AND LENGTH(m.languages) - LENGTH(REPLACE(m.languages, ',', '')) >= 1
    GROUP BY m.production_company
)
SELECT *
FROM multilingual_hits
WHERE prod_comp_rank <= 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH ActressStats AS (
    SELECT n.name as actress_name,
           SUM(r.total_votes) as total_votes,
           COUNT(DISTINCT m.id) as movie_count,
           ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes), 2) as actress_avg_rating
    FROM names n
    INNER JOIN role_mapping rm ON n.id = rm.name_id
    INNER JOIN movies m ON rm.movie_id = m.id
    INNER JOIN ratings r ON m.id = r.movie_id
    INNER JOIN genre g ON m.id = g.movie_id
    WHERE g.genre = 'Drama'
    AND r.avg_rating > 8
    AND rm.category = 'actress'
    GROUP BY n.name
)
SELECT *,
       RANK() OVER(ORDER BY actress_avg_rating DESC, total_votes DESC) as actress_rank
FROM ActressStats
WHERE actress_rank <= 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH DirectorStats AS (
    SELECT 
        dm.name_id as director_id,
        n.name as director_name,
        COUNT(DISTINCT m.id) as number_of_movies,
        ROUND(AVG(DATEDIFF(LEAD(date_published) OVER(PARTITION BY dm.name_id ORDER BY date_published),
                          date_published))) as avg_inter_movie_days,
        ROUND(AVG(r.avg_rating), 2) as avg_rating,
        SUM(r.total_votes) as total_votes,
        MIN(r.avg_rating) as min_rating,
        MAX(r.avg_rating) as max_rating,
        SUM(m.duration) as total_duration
    FROM director_mapping dm
    INNER JOIN names n ON dm.name_id = n.id
    INNER JOIN movies m ON dm.movie_id = m.id
    INNER JOIN ratings r ON m.id = r.movie_id
    GROUP BY dm.name_id, n.name
    HAVING COUNT(DISTINCT m.id) > 1
)
SELECT *
FROM DirectorStats
ORDER BY number_of_movies DESC
LIMIT 9;




