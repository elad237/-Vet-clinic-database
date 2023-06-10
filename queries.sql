/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals
WHERE name LIKE '%mon';

SELECT name FROM animals
WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-01-01';

SELECT name FROM animals
WHERE neutered = '1' AND escape_attempts < 3;

SELECT date_of_birth FROM animals
WHERE name = 'Agumon' OR name = 'Pikachu';

SELECT name, escape_attempts FROM animals
WHERE weight_kg > 10.5;

SELECT * FROM animals
WHERE neutered = '1';

SELECT * FROM animals
WHERE name NOT LIKE 'Gabumon';

SELECT * FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- SECOND DAY
-- #1
BEGIN;

UPDATE animals
SET species = 'unspecified';

ROLLBACK;

-- #2
BEGIN;

UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species is null;

-- #3
BEGIN;

DELETE FROM animals;

ROLLBACK;

-- #4
BEGIN;

DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

SAVEPOINT DEL_YEAR_2022;

UPDATE animals
SET weight_kg = (weight_kg * -1);

ROLLBACK TO DEL_YEAR_2022;

UPDATE animals
SET weight_kg = (weight_kg * -1)
WHERE weight_kg < 0;

-- How many animals are there?
SELECT COUNT(name) AS total
FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(name) AS total
FROM animals
WHERE escape_attempts = 0
GROUP BY name;

-- What is the average weight of animals?
SELECT AVG(weight_kg)
FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts)
FROM animals
GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS min, MAX(weight_kg) AS max
FROM animals
GROUP BY species;

--What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts)
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

-- day3

-- What animals belong to Melody Pond?
SELECT animals.name, owners.full_name
FROM animals
INNER JOIN owners
ON animals.owner_id = owners.id
WHERE owners.full_name LIKE 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name, species.name
FROM animals
INNER JOIN species
ON animals.species_id = species.id
WHERE species.name LIKE 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name, animals.name
FROM owners
LEFT JOIN animals
ON animals.owner_id = owners.id;

-- How many animals are there per species?
SELECT species.name, COUNT(animals.species_id)
FROM animals
INNER JOIN species
ON animals.species_id = species.id
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name, species.name, owners.full_name
FROM animals
INNER JOIN owners
ON animals.owner_id = owners.id
INNER JOIN species
ON animals.species_id = species.id
WHERE owners.full_name LIKE 'Jennifer Orwell' AND species.name LIKE 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name, owners.full_name
FROM animals
INNER JOIN owners
ON animals.owner_id = owners.id
WHERE owners.full_name LIKE 'Dean Winchester' AND animals.escape_attempts = 0;

--Who owns the most animals?
SELECT owners.full_name, count(animals.id)
FROM animals
LEFT JOIN owners
ON animals.owner_id = owners.id
GROUP BY owners.full_name
ORDER BY count(animals.id) desc limit 1;

-- day4

-- Who was the last animal seen by William Tatcher?
SELECT animals.name, vets.name, visits.date_of_visit
FROM animals
JOIN visits
ON animals.id = visits.animals_id
JOIN vets
ON vets.id = visits.vets_id
WHERE vets_id = 1
ORDER BY visits.date_of_visit desc limit 1;

-- How many different animals did Stephanie Mendez see?
SELECT animals.name, vets.name
FROM animals
JOIN visits
ON animals.id = visits.animals_id
JOIN vets
ON vets.id = visits.vets_id
WHERE vets_id = 3;

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name
FROM vets
LEFT JOIN specializations
ON vets.id = specializations.vets_id
LEFT JOIN species
ON species.id = specializations.species_id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name, vets.name, visits.date_of_visit
FROM animals
JOIN visits
ON animals.id = visits.animals_id
JOIN vets
ON vets.id = visits.vets_id
WHERE (visits.vets_id = 3) AND (visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30');

-- What animal has the most visits to vets?
SELECT animals.name, COUNT(visits.animals_id) as total
FROM animals
JOIN visits
ON animals.id = visits.animals_id
GROUP BY animals.name
ORDER BY total DESC limit 1;

-- Who was Maisy Smith's first visit?
SELECT animals.name, vets.name, visits.date_of_visit
FROM animals
JOIN visits
ON animals.id = visits.animals_id
JOIN vets
ON vets.id = visits.vets_id
WHERE vets_id = 2
ORDER BY visits.date_of_visit asc limit 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name, vets.name, visits.date_of_visit
FROM animals
JOIN visits
ON animals.id = visits.animals_id
JOIN vets
ON vets.id = visits.vets_id
ORDER BY visits.date_of_visit DESC;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(visits.vets_id)
FROM visits
JOIN vets
ON visits.vets_id = vets.id
LEFT JOIN specializations
ON specializations.vets_id = vets.id
WHERE specializations.vets_id IS null;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name, COUNT(species.name)
FROM visits
JOIN vets
ON visits.vets_id = vets.id
JOIN animals
ON visits.animals_id = animals.id
JOIN species
ON animals.species_id = species.id
WHERE vets.id = 2
GROUP BY species.name
ORDER BY COUNT(species.name) DESC LIMIT 1;
