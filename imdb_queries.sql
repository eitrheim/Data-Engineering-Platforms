USE imdb_new;

# Which 3 people that have worked on more than 1 movie have the highest average film rating with at least 1,000 votes in total?
SELECT
    primaryName,
	averageRating,
    totalVotes,
    numMovies
FROM(SELECT
		ROUND(AVG(tb.averageRating),2) AS averageRating,
		SUM(tb.numVotes) AS totalVotes,
		cc.nconst,
		COUNT(tb.tconst) AS numMovies,
		cc.primaryName AS primaryName
	FROM
	titleBasics tb
		INNER JOIN
	titleCastCrew tcc ON tb.tconst = tcc.titleBasics_tconst
		INNER JOIN
	castCrew cc ON tcc.castCrew_nconst = cc.nconst
	GROUP BY
		cc.nconst) AS a
WHERE
	totalVotes >=1000 AND
    numMovies > 1
ORDER BY
	2 DESC
LIMIT
	3;
  
  
# Of the people from the prior query, what 4 movies he/she is known for?
SELECT
	primaryName,
    primaryTitle
FROM(SELECT
		primaryName,
		averageRating,
		totalVotes,
		numMovies,
		nconst
	FROM(
		SELECT
			ROUND(AVG(tb.averageRating),2) AS averageRating,
			SUM(tb.numVotes) AS totalVotes,
			cc.nconst,
			COUNT(tb.tconst) AS numMovies,
			cc.primaryName AS primaryName
		FROM
		titleBasics tb
			INNER JOIN
		titleCastCrew tcc ON tb.tconst = tcc.titleBasics_tconst
			INNER JOIN
		castCrew cc ON tcc.castCrew_nconst = cc.nconst
		GROUP BY
			cc.nconst) AS A
	WHERE
	totalVotes >=1000 AND
    numMovies > 1
	ORDER BY
		2 DESC
	LIMIT
		3) AS B
	INNER JOIN
knownForTitles kft ON B.nconst=kft.castCrew_nconst
	LEFT JOIN
titleBasics tb ON kft.titleBasics_tconst=tb.tconst;


# Do adult films have a higher or lower rating and number of views than non-adult films?
SELECT
    'Not Adult' AS isAdult,
    ROUND(AVG(averageRating),2) AS averageRating,
    SUM(numVotes) AS totalVotes,
    COUNT(isAdult) AS countMovies
FROM
	titleBasics
WHERE isAdult = 0 
UNION
SELECT
    'Adult' AS isAdult,
    ROUND(AVG(averageRating),2) AS averageRating,
    SUM(numVotes) AS totalVotes,
	COUNT(isAdult) AS countMovies
FROM
	titleBasics
WHERE isAdult = 1;


# What genres have the highest ratings on average?
SELECT
	g.genres,
    ROUND(AVG(tb.averageRating),2) AS averageRating,
    ROUND(AVG(tb.numVotes),0) AS averageNumVotes
FROM
titleBasics tb
	INNER JOIN
titleGenres tg ON tb.tconst = tg.titleBasics_tconst
	INNER JOIN
genres g ON tg.genres_genres = g.genres
WHERE g.genres != 'NA'
GROUP BY 1
ORDER BY 2 DESC;


# What are the types of content have been produced over the decades?
SELECT
	g.genres,
    COUNT(IF(startYear < 1920, 1, NULL)) 'Pre 1920s',
	COUNT(IF(startYear BETWEEN 1920 AND 1930, 1, NULL)) '1920s',
	COUNT(IF(startYear BETWEEN 1930 AND 1950, 1, NULL)) '1930s',
    COUNT(IF(startYear BETWEEN 1940 AND 1950, 1, NULL)) '1940s',
    COUNT(IF(startYear BETWEEN 1950 AND 1960, 1, NULL)) '1950s',
	COUNT(IF(startYear BETWEEN 1960 AND 1970, 1, NULL)) '1960s',
    COUNT(IF(startYear BETWEEN 1970 AND 1980, 1, NULL)) '1970s',
    COUNT(IF(startYear BETWEEN 1980 AND 1990, 1, NULL)) '1980s',
    COUNT(IF(startYear BETWEEN 1990 AND 2000, 1, NULL)) '1990s',
    COUNT(IF(startYear BETWEEN 2000 AND 2010, 1, NULL)) '2000s',
    COUNT(IF(startYear >= 2010, 1, NULL)) '2010s',
    COUNT(*) AS Total
FROM
titleBasics tb
	INNER JOIN
titleGenres tg ON tb.tconst = tg.titleBasics_tconst
	INNER JOIN
genres g ON tg.genres_genres = g.genres
WHERE g.genres != 'NA'
GROUP BY 1;



















#Additional, smaller queries:


#Most common jobs
SELECT
	jobTitle,
    count(jobTitle)
FROM
	titleCastCrew
GROUP BY 1
ORDER BY 2 DESC;
