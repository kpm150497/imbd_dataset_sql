USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- For table total_rows_director
SELECT	
		COUNT(*)	AS	total_rows_director
FROM	
		director_mapping;
-- Total rows in director_mapping =  3867

-- For table total_rows_genre
SELECT	
		COUNT(*)	AS	total_rows_genre
FROM	
		genre;
-- Total rows in genre            = 14662

-- For table total_rows_movie
SELECT	
		COUNT(*)	AS	total_rows_movie
FROM	
		movie;
-- Total rows in movie            =  7997

-- For table total_rows_names
SELECT	
		COUNT(*)	AS	total_rows_names
FROM	
		names;
-- Total rows in names            = 25735

-- For table total_rows_ratings
SELECT	
		COUNT(*)	AS	total_rows_ratings
FROM	
		ratings;
-- Total rows in ratings          =  7997

-- For table total_rows_role_map
SELECT	
		COUNT(*)	AS	total_rows_role_map
FROM	
		role_mapping;
-- Total rows in role_mapping     = 15615

/* INSIGHT: 

1) Table wise number of rows are as follows:

		Total rows in director_mapping =  3867
		Total rows in genre            = 14662
		Total rows in movie            =  7997
		Total rows in names            = 25735
		Total rows in ratings          =  7997
		Total rows in role_mapping     = 15615

2) Ratings and movie have exact same rows and there is one entry for all the movies in the rating table, making it 1 on 1 complete set of each other.
3) Genre is not one to one relationship with movie. One movie is having multiple genre, which is contradictory with respect to ERD diagram shared.
4) Movie and genre table share the same set of movies and both are complete set of each other. Also relation between movie and genre is one to many.
	This is verfied by using below two SQLs.

-- To further analysis verifying relation and completeness of data for movie and genre table.

-- Verfy values present in genre table, and not present in movie table. 
SELECT
		movie_id
FROM
		genre
WHERE
		movie_id	NOT IN
					(
						SELECT
								id
						FROM
								movie
					);

-- Verfy values present in movie table, and not present in genre table. 
SELECT
		id
FROM
		movie
WHERE
		id			NOT IN
					(
						SELECT
								movie_id
						FROM
								genre
                    );

*/



-- Q2. Which columns in the movie table have null values?
-- Type your code below:


-- CTE (common table expression) is created to calculate null values in each column in the movie table.
-- And this CTE is used to generate formated output with YES / NO with number of null values in each column.
WITH	null_counts_in_movie AS
(
	SELECT
		COUNT(*) - COUNT(m.id)						AS null_count_id, 
		COUNT(*) - COUNT(m.title)					AS null_count_title, 
		COUNT(*) - COUNT(m.year)					AS null_count_year, 
		COUNT(*) - COUNT(m.date_published)			AS null_count_date_published, 
		COUNT(*) - COUNT(m.duration)				AS null_count_duration, 
		COUNT(*) - COUNT(m.country)					AS null_count_country, 
		COUNT(*) - COUNT(m.worlwide_gross_income)	AS null_count_worlwide_gross_income, 
		COUNT(*) - COUNT(m.languages)				AS null_count_languages, 
		COUNT(*) - COUNT(m.production_company)		AS null_count_production_company
	FROM	movie AS m
)
SELECT
	CASE
		WHEN null_count_id = 0 THEN 'No Null Values'
        ELSE CONCAT('YES (', null_count_id, ' Null Values)')
	END AS null_id, 
	CASE
		WHEN null_count_title = 0 THEN 'No Null Values'
        ELSE CONCAT('YES (', null_count_title, ' Null Values)')
	END AS null_title, 
	CASE
		WHEN null_count_year = 0 THEN 'No Null Values'
        ELSE CONCAT('YES (', null_count_year, ' Null Values)')
	END AS null_year, 
	CASE
		WHEN null_count_date_published = 0 THEN 'No Null Values'
        ELSE CONCAT('YES (', null_count_date_published, ' Null Values)')
	END AS null_date_published, 
	CASE
		WHEN null_count_duration = 0 THEN 'No Null Values'
        ELSE CONCAT('YES (', null_count_duration, ' Null Values)')
	END AS null_duration, 
	CASE
		WHEN null_count_country = 0 THEN 'No Null Values'
        ELSE CONCAT('YES (', null_count_country, ' Null Values)')
	END AS null_country, 
	CASE
		WHEN null_count_worlwide_gross_income = 0 THEN 'No Null Values'
        ELSE CONCAT('YES (', null_count_worlwide_gross_income, ' Null Values)')
	END AS null_worlwide_gross_income, 
	CASE
		WHEN null_count_languages = 0 THEN 'No Null Values'
        ELSE CONCAT('YES (', null_count_languages, ' Null Values)')
	END AS null_languages, 
	CASE
		WHEN null_count_production_company = 0 THEN 'No Null Values'
        ELSE CONCAT('YES (', null_count_production_company, ' Null Values)')
	END AS null_production_company
FROM
		null_counts_in_movie;
-- INSIGHT: Columns country, worlwide_gross_income, languages and production_company have null values in movie table








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

-- Total number of movies released each year (First Part)
SELECT
		m.year		AS	Year, 
        COUNT(m.id)	AS	number_of_movies
FROM	
		movie AS m
GROUP BY
		m.year
ORDER BY
		m.year;
-- INSIGHT: Year by year number of movies released in a year is reducing.

-- Month wise Trend (Second Part)
SELECT
		MONTH(m.date_published)	AS	month_num, 
        COUNT(m.id)				AS	number_of_movies
FROM	
		movie AS m
GROUP BY
		MONTH(m.date_published)
ORDER BY
		number_of_movies DESC;
-- INSIGHT: March sees highest number of movie release, whereas December has least number of movies released.





/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


-- Movies produced in the USA or India in the year 2019
SELECT
		COUNT(m.id)	AS	number_of_movies
FROM	
		movie AS m
WHERE
		(
				/* As country contains comma seperated multiple countries, 
                therefore used LIKE instead of = */
				UPPER(m.country)	LIKE	'%INDIA%'
		OR		UPPER(m.country)	LIKE	'%USA%'
		)
		AND		m.year	= 2019;
-- INSIGHT: 1059 movies produced in the USA or India in the year 2019





/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- Unique list of the genres present in the data set
SELECT
		DISTINCT g.genre
FROM
		genre AS g;
-- INSIGHT: There are unique 13 genres present in the data set








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- CTE created to not use LIMIT function as best preactices.
WITH	genre_wise_number_of_movies AS
(
	SELECT
			g.genre				AS genre, 
			COUNT(g.movie_id)	AS number_of_movies, 
			RANK() OVER
				(
					ORDER BY	COUNT(g.movie_id) DESC
				)				AS genre_rank_for_number_of_movies
	FROM
			genre	AS g
	GROUP BY
			g.genre
)
SELECT
		genre, 
        number_of_movies
FROM
		genre_wise_number_of_movies
WHERE
		genre_rank_for_number_of_movies	= 1;
/* INSIGHT: Drama movies (4285 movies) are produced highest in numbers. The 'Drama' genre should be the main subject of 
			films. Nevertheless, a film may fit under two or more genres.
*/








/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH	movie_wise_genre AS
(
	SELECT
			g.movie_id		AS movie_id, 
			COUNT(g.genre)	AS number_of_movies
	FROM
			genre	AS g
	GROUP BY
			g.movie_id
	HAVING
			number_of_movies	= 1
)
SELECT
		COUNT(*)	AS	movies_with_single_genre
FROM	
		movie_wise_genre;
-- INSIGHT: There are 3289 movies belong to only one genre.








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

SELECT
		g.genre						AS genre, 
        ROUND(AVG(m.duration), 2)	AS avg_duration /* Rounded for 2 decimals*/
FROM
		movie AS m
		INNER JOIN	genre	AS g
				ON	m.id	= g.movie_id
GROUP BY
		g.genre
ORDER BY
		avg_duration DESC;
-- INSIGHT: Action movies are having longest duration, whereas Horror movies are having shortest duration.







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
WITH	genre_ranking AS
(
	SELECT
			g.genre				AS genre, 
			COUNT(g.movie_id)	AS movie_count, 
			RANK() OVER
				(
					ORDER BY	COUNT(g.movie_id) DESC
				)				AS genre_rank
	FROM
			genre	AS g
	GROUP BY
			g.genre
	ORDER BY
			genre_rank
)
SELECT
		*
FROM
		genre_ranking AS gr
WHERE
		genre	= 'Thriller';
-- INSIGHT: Thriller movies are ranked 3 (in terms of number of movies produced) with 1484 movies.









/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
-- DESCRIBE ratings;
SELECT
		MIN(r.avg_rating)		AS	min_avg_rating, 
		MAX(r.avg_rating)		AS	max_avg_rating, 
		MIN(r.total_votes)		AS	min_total_votes, 
		MAX(r.total_votes)		AS	max_total_votes, 
		MIN(r.median_rating)	AS	min_median_rating, 
		MAX(r.median_rating)	AS	max_median_rating
FROM
		ratings AS r;
/* INSIGHT: There is huge range followed by all three columns with range from 1 to 10 for Rating columns
			and range from 100 to 7,25,138 for number of votes. There are no outliers observed in table data.
*/



    

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
-- It's ok if RANK() or DENSE_RANK() is used too


/* CTE to capture ranking of movies based on average rating */
WITH	movie_rating_ranking AS
(
	SELECT
			m.title			AS title, 
			r.avg_rating	AS avg_rating, 
			RANK() OVER
				(
					ORDER BY r.avg_rating DESC
				)			AS movie_rank
	FROM
			movie AS m
			INNER JOIN	ratings	AS r
					ON	m.id	= r.movie_id
)
SELECT
		*
FROM
		movie_rating_ranking
WHERE
		movie_rank	<= 10
ORDER BY
		movie_rank;
-- INSIGHT: Movies Kirket and Love in Kilnerry have highest rating of 10.







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

-- For check DISTINCT values (Commented)
-- SELECT	DISTINCT median_rating	FROM	ratings;


-- Summarise the ratings table based on the movie counts by median ratings.
SELECT
		r.median_rating		AS	median_rating, 
        COUNT(r.movie_id)	AS	movie_count
FROM
		ratings	AS r
GROUP BY
		median_rating
ORDER BY
		movie_count	DESC;
-- INSIGHT: 66% movies (5,262 out of 7,997) have median rating between 6 to 8, with most movies with median rating of 7.






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

/* CTE for capturing ranking of production companies with highest number of movies with average rating > 8 */
WITH	production_company_with_hits_ranking AS
(
	SELECT
			m.production_company	AS production_company, 
			COUNT(m.id)				AS movie_count, 
			RANK() OVER
				(
					ORDER BY COUNT(m.id) DESC
				)					AS prod_company_rank
	FROM
			movie AS m
			INNER JOIN	ratings	AS r
					ON	m.id	= r.movie_id
	WHERE
					m.production_company	IS NOT NULL
			AND		r.avg_rating			> 8
	GROUP BY
			m.production_company
)
SELECT
		*
FROM
		production_company_with_hits_ranking
WHERE
		prod_company_rank	= 1;
-- INSIGHT: 'Dream Warrior Pictures' and 'National Theatre Live' production house has produced the most number of hit movies (average rating > 8)






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
SELECT
		g.genre			AS genre, 
		COUNT(m.id)		AS movie_count
FROM
		movie AS m
		INNER JOIN	ratings	AS r
				ON	m.id	= r.movie_id
		INNER JOIN	genre AS g
				ON	m.id	= g.movie_id
WHERE
				m.year					= 2017
		AND		MONTH(m.date_published)	= 3		/* For March */
        AND		m.country				LIKE '%USA%'
		AND		r.total_votes			> 1000
GROUP BY
		g.genre
ORDER BY
		movie_count DESC;
-- INSIGHT: Drama movies have highest released during March 2017 in the USA had more than 1,000 votes.







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

SELECT
		m.title					AS title, 
        r.avg_rating			AS avg_rating, 
		g.genre					AS genre
FROM
		movie AS m
		INNER JOIN	ratings	AS r
				ON	m.id	= r.movie_id
		INNER JOIN	genre AS g
				ON	m.id	= g.movie_id
WHERE
				r.avg_rating	> 8
        AND		UPPER(m.title)	regexp '^THE' /* Start with The */
ORDER BY
		r.avg_rating DESC, genre;


/*
-- As single movie can have multiple genre, so A better view using GROUP_CONCAT can be generated for better representation.
SELECT
		m.title					AS title, 
        r.avg_rating			AS avg_rating, 
		GROUP_CONCAT(g.genre)	AS genre
FROM
		movie AS m
		INNER JOIN	ratings	AS r
				ON	m.id	= r.movie_id
		INNER JOIN	genre AS g
				ON	m.id	= g.movie_id
WHERE
				r.avg_rating	> 8
        AND		UPPER(m.title)	regexp '^THE'
GROUP BY
		m.title, 
        r.avg_rating
ORDER BY
		r.avg_rating DESC, genre;
*/
/* Output Will be:
+-------------------------------------------+---------------+-------------------------------+
|	title									|	avg_rating	|		genre					|
+-------------------------------------------+---------------+-------------------------------+
|	The Brighton Miracle					|		9.5		|		Drama					|
|	The Colour of Darkness					|		9.1		|		Drama					|
|	The Blue Elephant 2						|		8.8		|		Drama,Horror,Mystery	|
|	The Irishman							|		8.7		|		Crime,Drama				|
|	The Mystery of Godliness: The Sequel	|		8.5		|		Drama					|
|	The Gambinos							|		8.4		|		Crime,Drama		  		|
|	Theeran Adhigaaram Ondru				|		8.3		|		Action,Crime,Thriller	|
|	The King and I							|		8.2		|		Drama,Romance			|
+-------------------------------------------+---------------+-------------------------------+*/

-- INSIGHT: There are 8 movies that start with the word ‘The’ and which have an average rating > 8.







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT
		COUNT(*)	AS	movies_count
FROM
		movie AS m
		INNER JOIN	ratings	AS r
				ON	m.id	= r.movie_id
WHERE
				r.median_rating			= 8
		AND		m.date_published	BETWEEN		'2018-04-01'
									AND			'2019-04-01';
-- INSIGHT: Of the movies released between 1 April 2018 and 1 April 2019, 361 movies were given a median rating of 8.






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

/* CTE to capture total votes for German movies */
WITH	german_movies_total_votes AS
(
	SELECT
			SUM(r.total_votes)	AS	total_votes
	FROM
			movie AS m
			INNER JOIN	ratings	AS r
					ON	m.id	= r.movie_id
	WHERE
					UPPER(m.languages)	LIKE	'%GERMAN%'
), 
/* CTE to capture total votes for Italian movies */
italian_movies_total_votes AS
(
	SELECT
			SUM(r.total_votes)	AS	total_votes
	FROM
			movie AS m
			INNER JOIN	ratings	AS r
					ON	m.id	= r.movie_id
	WHERE
					UPPER(m.languages)	LIKE	'%ITALIAN%'
)
SELECT
		grm.total_votes	AS german_movies_total_votes, 
        itl.total_votes	AS italian_movies_total_votes, 
        CASE
			WHEN grm.total_votes > itl.total_votes	THEN	'Yes, German movies get more votes than Italian movies'
            WHEN grm.total_votes = itl.total_votes	THEN	'German and Italian movies get same votes'
            Else 'No, German movies do not get more votes than Italian movies'
		END AS comparison_result
FROM
		german_movies_total_votes	AS grm, 
        italian_movies_total_votes	AS itl;
-- INSIGHT: Yes, German movies get more votes (44,21,525) than Italian movies (25,59,540).







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
	COUNT(*) - COUNT(n.id)					AS name_nulls, 
	COUNT(*) - COUNT(n.height)				AS height_nulls, 
	COUNT(*) - COUNT(n.date_of_birth)		AS date_of_birth_nulls, 
	COUNT(*) - COUNT(n.known_for_movies)	AS known_for_movies_nulls
FROM	names AS n;
-- INSIGHT: Columns height, date_of_birth and known_for_movies have null values.






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
-- Type your code below;

/* CTE to capture top three genre */
WITH	top_three_genres AS
(
	SELECT
			g.genre				AS genre, 
			COUNT(g.movie_id)	AS movie_count, 
			RANK() OVER
				(
					ORDER BY	COUNT(g.movie_id) DESC
				)				AS genre_rank
	FROM
			genre	AS g
            INNER JOIN	ratings	AS r
					ON	g.movie_id	= r.movie_id
	WHERE
			r.avg_rating	> 8
    GROUP BY
			g.genre
	ORDER BY
			genre_rank
), 
top_directors_with_top_three_genre AS
(
	SELECT
			n.name						AS director_name, 
			COUNT(DISTINCT d.movie_id)	AS movie_count, 	-- As one movie can have multiple genre, so count only DISTINCT movies
			RANK() OVER
				(
					ORDER BY	COUNT(DISTINCT d.movie_id) DESC
				)						AS director_rank
	FROM
			top_three_genres AS ttg
			INNER JOIN	genre AS g
					ON	ttg.genre	= g.genre
			INNER JOIN	ratings	AS r
					ON	g.movie_id	= r.movie_id
			INNER JOIN	director_mapping AS d
					ON	g.movie_id	= d.movie_id
			INNER JOIN	names AS n
					ON	d.name_id	= n.id
	WHERE
					r.avg_rating	> 8
			AND		ttg.genre_rank	<= 3
	GROUP BY
			n.name
)
SELECT
		director_name, 
        movie_count
FROM
		top_directors_with_top_three_genre
WHERE
		director_rank	<= 3
ORDER BY
		movie_count DESC;

/* INSIGHT: Anthony Russo, James Mangold, Joe Russo and Marianne Elliott are the top directors in the top three genres whose 
			movies have an average rating > 8. As all 4 directors have equal number of movies, Further information is needed 
            to limit it to 3 only.
*/






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

WITH	top_actors_basedon_median_rating AS
(
	SELECT
			n.name				AS actor_name, 
			COUNT(rm.movie_id)	AS movie_count, 
			RANK() OVER
				(
					ORDER BY	COUNT(DISTINCT rm.movie_id) DESC
				)				AS actor_rank
	FROM
			role_mapping AS rm
			INNER JOIN	ratings AS r
					ON	rm.movie_id		= r.movie_id
			INNER JOIN	names AS n
					ON	rm.name_id		= n.id
	WHERE
					rm.category			= 'actor'
			AND		r.median_rating		>=8
	GROUP BY
			n.name
)
SELECT
		actor_name, 
        movie_count
FROM
		top_actors_basedon_median_rating
WHERE
		actor_rank	<= 2
ORDER BY
		actor_rank;
-- INSIGHT: Mammootty and Mohanlal are the top two actors whose movies have a median rating >= 8




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

WITH	production_company_total_votes AS
(
	SELECT
			m.production_company	AS production_company, 
			SUM(r.total_votes)		AS vote_count, 
			RANK()	OVER
				(
					ORDER BY SUM(r.total_votes)	DESC
				)	AS	prod_comp_rank
	FROM
			movie AS m
			INNER JOIN	ratings AS r
					ON	m.id		= r.movie_id
	GROUP BY
			m.production_company
)
SELECT
		production_company, 
        vote_count
FROM
		production_company_total_votes
WHERE
		prod_comp_rank			<= 3
ORDER BY
		vote_count DESC;
/* INSIGHT: Marvel Studios, Twentieth Century Fox and Warner Bros. are the top three production houses based 
			on the number of votes received by their movies.
*/







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

SELECT
		n.name				AS actor_name, 
        SUM(r.total_votes)	AS total_votes, 
        COUNT(m.id)			AS movie_count, 
        ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2)	AS actor_avg_rating, 
        RANK()	OVER
			(
				ORDER BY	SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) DESC, SUM(r.total_votes) DESC
            )	AS	actor_rank
FROM
		movie AS m
        INNER JOIN	ratings AS r
				ON	m.id		= r.movie_id
        INNER JOIN	role_mapping AS rm
				ON	m.id		= rm.movie_id
		INNER JOIN	names AS n
				ON	rm.name_id	= n.id
WHERE
				rm.category			= 'actor'
        AND		UPPER(m.country)	LIKE	'%INDIA%'
GROUP BY
		n.name
HAVING
		COUNT(m.id)		>= 5
ORDER BY
		actor_avg_rating DESC, total_votes DESC;
-- INSIGHT: Vijay Sethupathi is best actor in movies released in India based on average ratings with rating 8.42.






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

WITH	actress_votes_movie_count AS
(
	SELECT
			n.name				AS actress_name, 
			SUM(r.total_votes)	AS total_votes, 
			COUNT(m.id)			AS movie_count, 
			ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2)	AS actress_avg_rating, 
			RANK()	OVER
				(
					ORDER BY	SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) DESC, SUM(r.total_votes) DESC
				)	AS	actress_rank
	FROM
			movie AS m
			INNER JOIN	ratings AS r
					ON	m.id		= r.movie_id
			INNER JOIN	role_mapping AS rm
					ON	m.id		= rm.movie_id
			INNER JOIN	names AS n
					ON	rm.name_id	= n.id
	WHERE
					rm.category			= 'actress'
			AND		UPPER(m.languages)	LIKE	'%HINDI%'
			AND		UPPER(m.country)	LIKE	'%INDIA%'
	GROUP BY
			n.name
	HAVING
			COUNT(m.id)		>= 3
)
SELECT
		actress_name, 
		total_votes, 
		movie_count, 
		actress_avg_rating, 
		actress_rank
FROM
		actress_votes_movie_count
WHERE
		actress_rank		<= 5
ORDER BY
		actress_rank;
-- INSIGHT: Taapsee Pannu is best actress in Hindi movies released in India based on their average ratings.








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT
		DISTINCT
		m.title			AS title, 
        r.avg_rating	AS avg_rating, 
        CASE
			WHEN r.avg_rating > 8				THEN	'Superhit movies'
            WHEN r.avg_rating BETWEEN 7 AND 8	THEN	'Hit movies'
            WHEN r.avg_rating BETWEEN 5 AND 7	THEN	'One-time-watch movies'
            WHEN r.avg_rating < 5				THEN	'Flop movies'
		END AS movies_classification
FROM
		movie AS m
        INNER JOIN	ratings AS r
				ON	m.id	= r.movie_id
		INNER JOIN	genre AS g
				ON	m.id	= g.movie_id
WHERE
		g.genre		= 'Thriller'
ORDER BY
		avg_rating DESC;
-- INSIGHT: Classification based on average rating is done. Safe is best Thriller movie.







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
SELECT
		g.genre						AS genre, 
        ROUND(AVG(m.duration), 2)	AS avg_duration, 
        ROUND(SUM(AVG(m.duration))
				OVER
				(
					ORDER BY g.genre ROWS UNBOUNDED PRECEDING
				), 2)	AS running_total_duration,
        ROUND(AVG(AVG(m.duration))
				OVER
				(
					ORDER BY g.genre ROWS UNBOUNDED PRECEDING
				), 2)	AS moving_avg_duration
FROM
		movie AS m
        INNER JOIN	genre AS g
				ON	m.id	= g.movie_id
GROUP BY
		g.genre
ORDER BY
		g.genre;
-- INSIGHT: 103.16 is the moving average of mean of all genre.







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

-- DESCRIBE movie;
-- SELECT * FROM movie WHERE worlwide_gross_income NOT LIKE '$%';
-- SELECT * FROM genre WHERE movie_id IN ('tt6203302', 'tt6417204', 'tt6568474');



-- Top 3 Genres based on most number of movies
/* CTE to capture Top 3 Genres based on most number of movies */
WITH	top_three_genre AS
(
	SELECT
			genre, 
			RANK()	OVER
				(
					ORDER BY COUNT(movie_id)	DESC
				)	AS	genre_rank
            
    FROM
			genre
	GROUP BY
			genre
), 
year_wise_movie AS /* CTE to capture year wise movie detail.*/
(
	SELECT
			g.genre		AS genre, 
			m.year		AS year, 
			m.title		AS movie_name, 
			CASE
					WHEN	SUBSTRING(worlwide_gross_income, 1, 3) = 'INR'	THEN CAST(SUBSTRING(worlwide_gross_income, 5)/83 AS DECIMAL)
					WHEN	SUBSTRING(worlwide_gross_income, 1, 1) = '$'	THEN CAST(SUBSTRING(worlwide_gross_income, 3) AS DECIMAL)
					ELSE	0
				END		AS worldwide_gross_income, 
			RANK()	OVER
				(
					PARTITION BY g.genre, m.year
					ORDER BY
						CASE
							WHEN	SUBSTRING(worlwide_gross_income, 1, 3) = 'INR'	THEN CAST(SUBSTRING(worlwide_gross_income, 5)/83 AS DECIMAL)
							WHEN	SUBSTRING(worlwide_gross_income, 1, 1) = '$'	THEN CAST(SUBSTRING(worlwide_gross_income, 3) AS DECIMAL)
							ELSE	0
						END DESC
				)	AS movie_rank
	FROM
			movie AS m
			INNER JOIN	genre AS g
					ON	m.id	= g.movie_id
)
SELECT
		ywm.*
FROM
		year_wise_movie	AS ywm
		INNER JOIN	top_three_genre AS ttg
				ON	ywm.genre	= ttg.genre
WHERE
				movie_rank	<= 5
        AND		genre_rank	<= 3
ORDER BY
		ywm.genre, year, worldwide_gross_income DESC, movie_name;
/* INSIGHT: Despicable Me 3 in 2017, Deadpool 2 in 2018 and Toy Story 4 in 2019 were highest grossing Comedy movies.
			Zhan lang II in 2017, Bohemian Rhapsody in 2018 and Avengers: Endgame in 2019 were highest grossing Drama movies.
            The Fate of the Furious in 2017, Venom in 2018 and Joker in 2019 were highest grossing Thriller movies.
*/








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

WITH	production_company_movie_count AS
(
	SELECT
			m.production_company	AS production_company, 
			COUNT(m.id)				AS movie_count, 
			RANK()	OVER
				(
					ORDER BY COUNT(m.id)	DESC
				)					AS	prod_comp_rank
	FROM
			movie AS m
			INNER JOIN	ratings AS r
					ON	m.id		= r.movie_id
	WHERE
					r.median_rating				>=8
			AND		m.production_company		IS NOT NULL
			-- AND		m.languages					LIKE '%,%' /* This can also be used */
			AND		POSITION(',' IN m.languages)> 0
	GROUP BY
			m.production_company
)
SELECT
		production_company, 
		movie_count, 
		prod_comp_rank
FROM
		production_company_movie_count
WHERE
		prod_comp_rank	<= 2
ORDER BY
		prod_comp_rank;
/* INSIGHT: Star Cinema and Twentieth Century Fox are the top two production houses that have 
			produced the highest number of hits (median rating >= 8) among multilingual movies.
*/





-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH	actress_with_super_hits	AS
(
	SELECT
			n.name				AS actress_name, 
			SUM(r.total_votes)	AS total_votes, 
			COUNT(r.movie_id)	AS movie_count, 
			ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2)	AS actress_avg_rating, 
			RANK()	OVER
				(
					ORDER BY	COUNT(r.movie_id) DESC
				)				AS	actress_rank
	FROM
			genre AS g
			INNER JOIN	ratings AS r
					ON	g.movie_id	= r.movie_id
			INNER JOIN	role_mapping AS rm
					ON	g.movie_id	= rm.movie_id
			INNER JOIN	names AS n
					ON	rm.name_id	= n.id
	WHERE
					rm.category			= 'actress'
			AND		r.avg_rating		> 8
			AND		g.genre				= 'Drama'
	GROUP BY
			n.name
)
SELECT
		actress_name, 
		total_votes, 
		movie_count, 
		actress_avg_rating, 
		actress_rank
FROM
		actress_with_super_hits
WHERE
		actress_rank	<= 3
ORDER BY
		actress_rank;
/* INSIGHT: Parvathy Thiruvothu, Susan Brown, Amanda Lawrence and Denise Gough are the among top actresses with later 3 having 
			same number of movies and average rating, based on number of Super Hit movies (average rating >8) in drama genre.
*/







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

/* CTE to capture director's movie details */
WITH	director_movie_details AS
(
	SELECT
			d.name_id			AS director_id, 
			n.name				AS director_name, 
			d.movie_id			AS movie_id, 
			m.date_published	AS date_published_current, 
			LEAD(m.date_published, 1)	OVER
				(
					PARTITION BY	d.name_id
					ORDER BY		m.date_published
				)				AS date_published_next, 
			r.avg_rating		AS avg_rating, 
			r.total_votes		AS total_votes, 
			m.duration			AS duration
	FROM
			movie AS m
			INNER JOIN	ratings	AS r
					ON	m.id		= r.movie_id
			INNER JOIN	director_mapping AS d
					ON	r.movie_id	= d.movie_id
			INNER JOIN	names AS n
					ON	d.name_id	= n.id
), 
director_ranking AS
(
	SELECT
			dmd.director_id					AS director_id, 
			dmd.director_name				AS director_name, 
			COUNT(dmd.movie_id)				AS number_of_movies, 
			ROUND(AVG(Datediff(dmd.date_published_next, dmd.date_published_current)), 2) AS avg_inter_movie_days, 
			ROUND(AVG(dmd.avg_rating), 2)	AS avg_rating, 
			SUM(dmd.total_votes)			AS total_votes, 
			MIN(dmd.avg_rating)				AS min_rating, 
			MAX(dmd.avg_rating)				AS max_rating, 
			SUM(dmd.duration)				AS total_duration, 
			RANK()	OVER
				(
					ORDER BY	COUNT(dmd.movie_id) DESC
				)							AS	director_rank
	FROM
			director_movie_details AS dmd
	GROUP BY
			dmd.director_id, 
			dmd.director_name
)
SELECT
		director_id, 
		director_name, 
		number_of_movies, 
		avg_inter_movie_days, 
		avg_rating, 
		total_votes, 
		min_rating, 
		max_rating, 
		total_duration
FROM
		director_ranking
WHERE
		director_rank	<= 9
ORDER BY
		director_rank;
-- INSIGHT: Andrew Jones and A.L. Vijay have directed highest number of movies.

