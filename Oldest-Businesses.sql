-- What is the oldest business on each continent?
 SELECT country.continent, 
	   country.country,
	   business.business, 
	   oldest_continent.year_founded
  FROM public.businesses AS business
-- query to add country information
	   INNER JOIN public.countries AS country
	        USING (country_code)
-- subquery for min year per continent	
	   INNER JOIN
	
	      (SELECT continent,
	              MIN(year_founded) AS year_founded
             FROM public.businesses AS business
	   	          INNER JOIN public.countries AS country
	   	          ON business.country_code = country.country_code
 		    GROUP BY continent) AS oldest_continent
	
		ON business.year_founded = oldest_continent.year_founded
		   AND country.continent = oldest_continent.continent


-- How many countries per continent lack data on the oldest businesses
SELECT continent, 
	   COUNT(country) AS countries_without_businesses
  FROM countries

	   LEFT JOIN businesses
	   USING (country_code)

 WHERE business IS NULL
 GROUP BY continent;
-- Does including the `new_businesses` data change this?

SELECT continent, 
	   COUNT(country) AS countries_without_businesses
  FROM countries
		-- add new businesses to the lsit
	   LEFT JOIN (SELECT country_code FROM businesses
				  UNION
				  SELECT country_code FROM new_businesses) AS all_business
	   ON countries.country_code = all_business.country_code

 WHERE all_business.country_code IS NULL
 GROUP BY continent

-- Which business categories are best suited to last over the course of centuries?
SELECT country.continent,
	   cat.category,
	   MIN(biz.year_founded) AS year_founded
  FROM public.businesses as biz
	   INNER JOIN public.countries AS country
	   ON biz.country_code = country.country_code
	   INNER JOIN public.categories AS cat
	   ON biz.category_code = cat.category_code
 GROUP BY country.continent, 
	      cat.category
 ORDER BY country.continent ASC,
     	  year_founded DESC
