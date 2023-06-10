/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    name varchar(100)
    id INT GENERATED ALWAYS AS IDENTITY,
    name varchar(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT NOT NULL,
    neutered BIT boolean NOT NULL,
    weight_kg DECIMAL NOT NULL
);

ALTER TABLE animals
ADD species varchar(255);

-- day3

CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    full_name varchar(100) NOT NULL,
    age INT NOT NULL
);

CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    name varchar(100) NOT NULL
);



ALTER TABLE animals
DROP COLUMN id,
DROP COLUMN species;

ALTER TABLE animals
ADD COLUMN id SERIAL PRIMARY KEY;

UPDATE animals SET id = id;

ALTER TABLE animals
ADD COLUMN species_id INTEGER,
ADD CONSTRAINT fk_species
    FOREIGN KEY (species_id)
    REFERENCES species (id);

ALTER TABLE animals
ADD COLUMN owner_id INTEGER,
ADD CONSTRAINT fk_owners
    FOREIGN KEY (owner_id)
    REFERENCES owners (id);


-- day 4

CREATE TABLE vets (
    id SERIAL PRIMARY KEY,
    name varchar(100) NOT NULL,
    age INT NOT NULL,
    date_of_graduation DATE NOT NULL
);

CREATE TABLE specializations (
    vets_id SERIAL REFERENCES vets (id),
    species_id SERIAL REFERENCES species (id),
    PRIMARY KEY (vets_id, species_id)
);

CREATE TABLE visits (
    animals_id SERIAL REFERENCES animals (id),
    vets_id SERIAL REFERENCES vets (id),
    date_of_visit DATE,
    PRIMARY KEY (animals_id, vets_id, date_of_visit)
);

-- Second week - Performance Audit

CREATE INDEX animal_id_asc ON visits (animal_id);

CREATE INDEX mail_asc ON owners (email);

CREATE INDEX vet_id_asc ON visits (vet_id)
vets_clinic-# WHERE (extract(dow from vet_id) = 2);
