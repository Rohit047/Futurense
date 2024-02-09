show databases;
use world;
-- Analyzing country table
DESCRIBE country;

-- Selecting all columns from country table
SELECT * FROM country;

-- Analyzing city table
DESCRIBE city;

-- Selecting all columns from city table
SELECT * FROM city;

-- Analyzing countrylanguage table
DESCRIBE countrylanguage;

-- Selecting all columns from countrylanguage table
SELECT * FROM countrylanguage;

#2 
-- Select all countries and sort them by population in descending order, then sort cities within each country alphabetically
SELECT c.*, city.Name AS CityName
FROM country c
LEFT JOIN city ON c.Capital = city.ID
ORDER BY c.Population DESC, city.Name;
-- Select all countries in Europe with a population greater than 50 million
SELECT *
FROM country
WHERE Continent = 'Europe' AND Population > 50000000;

-- Select cities in Brazil or Argentina
SELECT *
FROM city
WHERE CountryCode IN ('BRA', 'ARG');

-- Select languages in countries not in the 'Europe' continent
SELECT *
FROM countrylanguage
WHERE CountryCode NOT IN (SELECT Code FROM country WHERE Continent = 'Europe');
-- Select countries in the 'Americas' or 'Asia' continent using IN
SELECT *
FROM country
WHERE Continent IN ('Americas', 'Asia');

-- Select countries with populations between 10 and 50 million using BETWEEN
SELECT *
FROM country
WHERE Population BETWEEN 10000000 AND 50000000;

-- Find cities with names starting with 'San' using LIKE
SELECT *
FROM city
WHERE Name LIKE 'San%';

-- Select countries in the 'Americas' or 'Asia' continent using IN
SELECT *
FROM country
WHERE Continent IN ('Americas', 'Asia');

-- Select countries with populations between 10 and 50 million using BETWEEN
SELECT *
FROM country
WHERE Population BETWEEN 10000000 AND 50000000;

-- Find cities with names starting with 'San' using LIKE
SELECT *
FROM city
WHERE Name LIKE 'San%';

-- Select the top 10 most populous cities in the world
SELECT *
FROM city
ORDER BY Population DESC
LIMIT 10;


-- Find countries where the HeadOfState is not specified (IS NULL)
SELECT *
FROM country
WHERE HeadOfState IS NULL;

-- List all unique continents where the countries are located
SELECT DISTINCT Continent
FROM country;
