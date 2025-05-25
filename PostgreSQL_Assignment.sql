-- Active: 1747415487712@@127.0.0.1@5432@conservation_db@public
CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    region TEXT
);

DROP TABLE rangers;
INSERT INTO rangers (ranger_id, name, region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');


CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name TEXT,
    scientific_name TEXT,
    discovery_date DATE,
    conservation_status TEXT
);

INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

DROP TABLE species;
CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id),
    ranger_id INT REFERENCES rangers(ranger_id),
    sighting_time TIMESTAMP,
    location TEXT,
    notes TEXT
);

INSERT INTO sightings (sighting_id, species_id, ranger_id,   location, sighting_time, notes) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

DROP TABLE sightings;

SELECT * from rangers;
SELECT * from species;
SELECT * from sightings;

-- problem -1

INSERT INTO rangers (ranger_id, name, region)
 VALUES(4,'Derek Fox','Coastal Plains');

 ----- problem -2
 SELECT  count(DISTINCT species_id)as unique_species_count  from sightings;

 ---- problem 3
 SELECT * from sightings WHERE  location iLIKE '%Pass%';

 --- problem 4------

SELECT  name, count(sighting_id) as total_sightings from rangers
 JOIN sightings on rangers.ranger_id= sightings.ranger_id
 GROUP BY name;


 --- problem 5---------- 

 SELECT common_name from species
 WHERE species_id not in(
    SELECT DISTINCT species_id FROM sightings
 );

  ------problem 6 ----------------
-- Show the most recent 2 sightings.
SELECT common_name,sighting_time,name from sightings 
left JOIN species on species.species_id=sightings.species_id
left JOIN rangers on rangers.ranger_id=sightings.ranger_id 
ORDER BY sighting_time DESC
LIMIT 2;

--- problem 7
--  Update all species discovered before year 1800 to have status 'Historic'.

UPDATE species set  conservation_status='Historic'
WHERE extract  (YEAR FROM discovery_date  ) < '1800' 



--8️⃣ Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
SELECT sighting_id,sighting_time :: time from sightings

SELECT
sighting_id,
CASE 
    WHEN extract(HOUR FROM sighting_time) BETWEEN 1 AND 11 THEN 'Morning'
    WHEN extract(HOUR FROM sighting_time) BETWEEN 12 AND 16 THEN 'Afternoon'
    WHEN extract(HOUR FROM sighting_time) BETWEEN 17 AND 23 THEN 'Evening'
END as time_of_day
FROM sightings;


-- 9️⃣ Delete rangers who have never sighted any species
 DELETE  from rangers
 WHERE ranger_id not in(
    SELECT DISTINCT ranger_id FROM sightings
 );

