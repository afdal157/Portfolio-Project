/* 
 
 OpenFlights - Airport, Airline, and Route Data Exploration
  
 */



-- First, let's observe the airport table

SELECT *
FROM airport a
LIMIT 10;


-- Total number of rows from the airport table

SELECT COUNT(*) AS total_rows
FROM airport a;


-- Total number of airport and country 

SELECT
	COUNT(name) AS total_airport,
	COUNT (DISTINCT country) AS total_country
FROM airport a; 


-- Total number of airport in each country

SELECT country,
	   COUNT (name) AS total_airport
FROM airport a
GROUP BY country
ORDER BY country ASC;


-- List of countries that have more than 100 airports

SELECT country,
	   COUNT (name) AS total_airport
FROM airport a
GROUP BY country
HAVING total_airport > 100
ORDER BY total_airport DESC;


-- Total number of the international airport in each country

WITH int_airport (name, country) AS
		(SELECT name, 
				country
		 FROM airport a 
	   	 WHERE name LIKE '%International%'
	   	 )
SELECT country, COUNT(*) AS total_int_airport
FROM int_airport
GROUP BY country;


-- Total number of international airport in Indonesia

SELECT country,
	   COUNT (*) AS total_int_airport
FROM airport a 
WHERE country = 'Indonesia' AND name LIKE '%International%';


-- total number of international airport in United States

SELECT country,
	   COUNT (*) AS total_int_airport
FROM airport a 
WHERE country = 'United States' AND name LIKE '%International%';


-- Total number  of the non international airport in each country

WITH int_airport (name, country) AS
		(SELECT name, 
				country
		 FROM airport a 
		 WHERE name NOT LIKE '%International%'
		 )
SELECT country,
	   COUNT(*) AS total_airport
FROM int_airport
GROUP BY country;


-- Top 10 countries with the most international airport

WITH int_airport (name, country) AS
		(SELECT name, 
				country
		 FROM airport a 
		 WHERE name LIKE '%International%'
		 )
SELECT country, 
	   COUNT(*) AS total_int_airport
FROM int_airport
GROUP BY country
ORDER BY total_int_airport DESC 
LIMIT 10;


-- List of airports located 10000 feet (3048 meters) above sea level

SELECT name,
	   city,
	   country,
	   altitude
FROM airport a 
WHERE altitude > 10000
ORDER BY altitude DESC;


-- Total number of airports located 10000 feet (3048 meters) above sea level group by country 

WITH high_airport AS (
		SELECT name,
	   		   city,
	   		   country,
	   		   altitude
		FROM airport a 
		WHERE altitude > 10000
		)
SELECT country, 
	   COUNT (*) AS total_airport
FROM high_airport
GROUP BY country
ORDER BY total_airport;



-- Now, Let's observe the airline table 

SELECT *
FROM airline a 
LIMIT 10;


-- Total number of rows from the airline table 

SELECT COUNT(*) AS total_rows
FROM airline;


-- Total number of airline and country 

SELECT COUNT (DISTINCT airline_id) AS total_airline, 
	   COUNT (DISTINCT country) AS total_country
FROM airline;

  
-- Total number of airline in each country (country based on the airport table)

SELECT country, 
	   COUNT(airline_id) AS total_airline
FROM airline 
GROUP BY country
HAVING country IN (SELECT DISTINCT country
				   FROM airport);			
				  
				  
-- List of airlines in Indonesia and the US that still active
		  
WITH active_airline AS (
		SELECT * 
		FROM airline 
		WHERE active = 'Y'
		)
SELECT *
FROM active_airline
WHERE country = 'United States' OR country = 'Indonesia'
ORDER BY country;
				   

-- List of countries that have 50 airlines and more 

SELECT country, 
	   COUNT (airline_id) AS total_airline
FROM airline a 
GROUP BY country
HAVING total_airline >= 50
ORDER BY total_airline DESC;


-- List of countries that have more than 10 active airlines

WITH active_airline AS (
		SELECT * 
		FROM airline
		WHERE active = 'Y'
		)
SELECT country,
	   COUNT(airline_id) AS total_airline
FROM active_airline
GROUP BY country
HAVING total_airline > 10
ORDER BY total_airline DESC;


-- Total number of active and inactive airline in each country

WITH total_active AS (
		SELECT country, 
			   COUNT (*) AS total_active
		FROM airline a 
		WHERE active = 'Y'
		GROUP BY country
		HAVING country IN (SELECT DISTINCT country
				   		   FROM airport)
				  ),
	 total_inactive AS (
		SELECT country,
			   COUNT (*) AS total_inactive
		FROM airline a 
		WHERE active = 'N'
		GROUP BY country
		HAVING country IN (SELECT DISTINCT country
				  		   FROM airport)
				  ) 
SELECT *
FROM total_active ta
FULL JOIN total_inactive ti
ON ta.country = ti.country;


-- 20 active airlines that have the highest number of route

WITH active_airline AS (
		 SELECT *
		 FROM airline 
		 WHERE active = 'Y'
		 ),
	 total_route AS (
	 	 SELECT airline_id,
	 	 		COUNT (*) AS total_route
		 FROM route r
     	 GROUP BY airline_id
     	 )
SELECT name, 
	   country, 
	   total_route
FROM active_airline aa
JOIN total_route tr
ON aa.airline_id = tr.airline_id
ORDER BY total_route DESC
LIMIT 20;


-- 20 active airline that has the lowest number of route

WITH active_airline AS (
	 	SELECT * 
	 	FROM airline 
	 	WHERE active = 'Y'
	 	),
	 total_route AS (
	 	SELECT airline_id, 
	 		   COUNT (*) AS total_route
	 	FROM route r
     	GROUP BY airline_id
     	)
SELECT name, 
	   country,
	   total_route
FROM active_airline aa
JOIN total_route tr
ON aa.airline_id = tr.airline_id
ORDER BY total_route ASC
LIMIT 20;


-- Top 20 international airport with the most destination based on departure aiport

WITH int_airport AS (
		 SELECT * 
		 FROM airport 
		 WHERE name LIKE '%International%'
		 ),
	 total_destination AS (
	 	SELECT source_airport,
	 		   COUNT (*) AS total_destination
	 	FROM route r
    	GROUP BY source_airport
    	)
SELECT name,
	   city, 
	   country, 
	   total_destination
FROM int_airport ia
JOIN total_destination td  
ON ia.IATA = td.source_airport
ORDER BY total_destination DESC 
LIMIT 20;


-- Indonesia and United State international airports and their total destination

WITH int_airport AS (
		 SELECT * 
		 FROM airport 
		 WHERE name LIKE '%International%'
		 ),
	 total_destination AS (
	 	SELECT source_airport,
	 		   COUNT (*) AS total_destination
	 	FROM route r
    	GROUP BY source_airport
    	)
SELECT name, 
	   city, 
	   country, 
	   total_destination
FROM int_airport ia
JOIN total_destination td  
ON ia.IATA = td.source_airport
WHERE country = 'Indonesia' 
	  OR country = 'United States'
ORDER BY country ASC, 
	     total_destination DESC;
	    
	    
	    
/*
 
 My first SQL Data Exploration Project. Comment and feedback will be highly appreciated. 
 Data source = "https://openflights.org/data.html"
 
 */



