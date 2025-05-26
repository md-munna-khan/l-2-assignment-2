-- Active: 1747415487712@@127.0.0.1@5432@conservation_db@public
CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    region TEXT
);

INSERT INTO rangers ( name, region) VALUES
( 'Alice Green', 'Northern Hills'),
( 'Bob White', 'River Delta'),
( 'Carol King', 'Mountain Range');


CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name TEXT,
    scientific_name TEXT,
    discovery_date DATE,
    conservation_status TEXT
);

INSERT INTO species ( common_name, scientific_name, discovery_date, conservation_status) VALUES
( 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
( 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
( 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
( 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');


CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,                     -- Auto-incrementing ID
    species_id INT REFERENCES species(species_id),      -- Foreign Key to species table
    ranger_id INT REFERENCES rangers(ranger_id),        -- Foreign Key to rangers table
    location TEXT,
    sighting_time TIMESTAMP,
    notes TEXT
);

DROP table sightings;
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);




--=========================================== All Problems      =================================

-- problem -1️⃣ Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT INTO rangers ( name, region)
 VALUES('Derek Fox','Coastal Plains');


 ----- problem 2️⃣ Count unique species ever sighted.
 SELECT  count(DISTINCT species_id)as unique_species_count  from sightings;

 ---- problem 3️⃣ Find all sightings where the location includes "Pass".
 SELECT * from sightings WHERE  location iLIKE '%Pass%';

 --- problem 4️⃣ List each ranger's name and their total number of sightings.

SELECT  name, count(sighting_id) as total_sightings from rangers
 JOIN sightings on rangers.ranger_id= sightings.ranger_id
 GROUP BY name
 ORDER BY name;


 --- problem 5️⃣ List species that have never been sighted.

 SELECT common_name from species
 WHERE species_id not in(
    SELECT DISTINCT species_id FROM sightings
 );

  ------problem 6️⃣ Show the most recent 2 sightings.


SELECT common_name,sighting_time,name from sightings 
 JOIN species on species.species_id=sightings.species_id
 JOIN rangers on rangers.ranger_id=sightings.ranger_id 
ORDER BY sighting_time DESC
LIMIT 2;

--- problem 7️⃣ Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species set  conservation_status='Historic'
WHERE extract  (YEAR FROM discovery_date  ) < 1800 


--problem 8️⃣ Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.


SELECT 
  sighting_id,
  CASE
    WHEN extract(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN extract(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sightings ORDER BY sighting_id;




-- problem 9️⃣ Delete rangers who have never sighted any species

DELETE FROM rangers
WHERE NOT EXISTS (
  SELECT 1 
  FROM sightings 
  WHERE sightings.ranger_id = rangers.ranger_id
);





















