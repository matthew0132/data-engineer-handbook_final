CREATE TYPE films as(
	film text,
	votes integer,
	rating real,
	filmid text
);

create type quality_class as ENUM(
	'star',
	'good',
	'average',
	'bad'
);

CREATE TABLE actors (
	actor text,
	films films[],
	quality_class quality_class,
	is_active BOOLEAN,
	year integer
);

WITH yesterday AS(
	SELECTFROM actors
	WHERE year = 1970
),
today as (
	SELECTFROM actor_films
	WHERE year = 1971
)
SELECT
	coalesce(t.actor, y.actor) as actor,
	CASE
		WHEN y.films IS NULL THEN ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
			)films]
		WHEN t.film IS NOT NULL THEN y.films  ARRAY[ROW(
			t.film,
			t.votes,
			t.rating,
			t.filmid
			)films]
		ELSE y.films
	END as films,
	CASE
		WHEN t.rating  8 THEN 'star'
		WHEN t.rating  7 AND t.rating = 8 THEN 'good'
		WHEN t.rating  6 AND t.rating = 7 THEN 'average'
		WHEN t.rating = 6 THEN 'bad'
	END AS quality_class,
	CASE WHEN t.actor IS NOT NULL THEN TRUE ELSE FALSE END AS is_active,
	coalesce(t.year, y.year + 1) as year
FROM today t full outer join yesterday y
	on t.actor = y.actor;