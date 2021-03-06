#Top 10 Profitable movies 

SELECT id, title, (revenue - budget ) as profit from MOVIE_DATABASE.PUBLIC.MOVIES_METADATA
where profit is not null
order by profit desc
limit 10;

#Top 10 Loss making movies

SELECT id, title, (budget- revenue ) as LOSS from MOVIE_DATABASE.PUBLIC.MOVIES_METADATA
where LOSS is not null
order by LOSS desc
limit 10; 

#Loss making production studios in year 2017

SELECT substring (PRODUCTION_COMPANIES, 12,24 ) as Production_House, SUM( budget-revenue) as Loss 
from MOVIE_TABLE.PUBLIC.MOVIES_METADATA
where  RELEASE_DATE >= '0017-01-01' AND RELEASE_DATE <= '0018-01-01'
group by Production_House
order by Loss desc
limit 20;

#Profit making production studios in year 2017

SELECT substring (PRODUCTION_COMPANIES, 6,25 ) as Production_House, SUM(revenue - budget) as Profit 
from MOVIE_TABLE.PUBLIC.MOVIES_METADATA
where  RELEASE_DATE >= '0017-01-01' AND RELEASE_DATE <= '0018-01-01'
group by Production_House
order by Profit desc
limit 20;
 
 #Number of movies release by each studio in year 2017:
 
SELECT substring (PRODUCTION_COMPANIES, 12,20 ) as Production_House, COUNT(Production_House) as total_releases
from MOVIE_TABLE.PUBLIC.MOVIES_METADATA
where  RELEASE_DATE >= '0017-01-01' AND RELEASE_DATE <= '0018-01-01'
group by Production_House
order by total_releases desc;

#Most popular Genre (In terms of number of movies released of particular genre) in the year 2017

SELECT substring (genres, 12,18 ) as Genre, COUNT(Genre) as total_genre_releases
from MOVIE_TABLE.PUBLIC.MOVIES_METADATA
where  RELEASE_DATE >= '0017-01-01' AND RELEASE_DATE <= '0018-01-01'
group by Genre
order by total_genre_releases desc;

#Most profitable Genre in the year 2017

SELECT substring (genres, 12,18 ) as Genre, SUM(revenue - budget) as Profit 
from MOVIE_TABLE.PUBLIC.MOVIES_METADATA
where  RELEASE_DATE >= '0017-01-01' AND RELEASE_DATE <= '0018-01-01'
group by Genre
order by Profit desc
limit 10;

#Join movies and ratings table to see relation between ratings and profit/loss

select id , rating, (revenue - budget) as Profit, ORIGINAL_TITLE, 
from MOVIE_TABLE.PUBLIC.MOVIES_METADATA join MOVIE_TABLE.PUBLIC.ratings
on MOVIE_TABLE.PUBLIC.MOVIES_METADATA.id = MOVIE_TABLE.PUBLIC.ratings.movieid
order by Profit desc
limit 20;

#From the result we see that we 4,58,540 ratings for movie Titanic. Means we need to average the ratings for each movie

select avg(rating) as average_rating, ORIGINAL_TITLE,(revenue - budget) as Profit 
from MOVIE_TABLE.PUBLIC.MOVIES_METADATA left join MOVIE_TABLE.PUBLIC.ratings
on MOVIE_TABLE.PUBLIC.MOVIES_METADATA.id = MOVIE_TABLE.PUBLIC.ratings.movieid
where RELEASE_DATE >= '0017-01-01' AND RELEASE_DATE <= '0018-01-01'
group by ORIGINAL_TITLE, Profit
order by Profit desc
limit 20;

#From the result we see that there are many null values for ratings columns for the year 2017.So to get the relation between ratings and profit we will
do inner join instead of left join and remove the year clause.

select avg(rating) as average_rating, ORIGINAL_TITLE,(revenue - budget) as Profit 
from MOVIE_TABLE.PUBLIC.MOVIES_METADATA join MOVIE_TABLE.PUBLIC.ratings
on MOVIE_TABLE.PUBLIC.MOVIES_METADATA.id = MOVIE_TABLE.PUBLIC.ratings.movieid
group by ORIGINAL_TITLE, Profit
order by Profit desc
limit 50;

#Relation between Loss and average rating
select avg(rating) as average_rating, ORIGINAL_TITLE,(budget - revenue) as Loss 
from MOVIE_TABLE.PUBLIC.MOVIES_METADATA join MOVIE_TABLE.PUBLIC.ratings
on MOVIE_TABLE.PUBLIC.MOVIES_METADATA.id = MOVIE_TABLE.PUBLIC.ratings.movieid
group by ORIGINAL_TITLE, Loss
order by Loss desc
limit 50;
