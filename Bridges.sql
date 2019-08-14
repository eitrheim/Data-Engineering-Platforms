-- -----------------------------------------------------
-- titleBasics bridge
-- -----------------------------------------------------
INSERT INTO imdb_new.titleBasics (
	tconst,
	titleType,
	primaryTitle,
	originalTitle,
	isAdult,
	startYear,
	endYear,
	runtimeMinutes,
	averageRating,
	numVotes)
(SELECT
	t.tconst,
    titleType,
    primaryTitle,
    originalTitle,
    isAdult,
    startYear,
    endYear,
    runtimeMinutes,
    averageRating,
    numVotes
FROM
	imdb.title t,
    imdb.ratings r
WHERE
	t.tconst = r.tconst);


-- -----------------------------------------------------
-- titlesGenre bridge
-- -----------------------------------------------------
INSERT INTO imdb_new.titleGenres (
	genres_genres,
    titleBasics_tconst)
(SELECT
	genre_1,
    tconst
FROM
	imdb.title);




-- -----------------------------------------------------
-- titleCastCrew bridge
-- -----------------------------------------------------
INSERT INTO imdb_new.titleCastCrew (
	titleBasics_tconst,
	castCrew_nconst,
	jobTitle,
	jobCategory,
	character)
(SELECT
	tconst,
	nconst,
	job,
	category,
	character
FROM
	imdb.principals);




-- -----------------------------------------------------
-- knownForTitles bridge
-- -----------------------------------------------------
INSERT INTO imdb_new.knownForTitles (
	castCrew_nconst,
	titleBasics_tconst)
(SELECT
	nconst,
	tconst
FROM
	
(SELECT
	nconst,
    known_1 as tconst
FROM imdb.names
UNION
SELECT
	nconst,
    known_2 as tconst
FROM imdb.names
UNION
SELECT
	nconst,
    known_3 as tconst
FROM imdb.names
UNION
SELECT
	nconst,
    known_4 as tconst
FROM imdb.names) AS known);
