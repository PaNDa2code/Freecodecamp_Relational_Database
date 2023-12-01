ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;

ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;

ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;

ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;

ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;

ALTER TABLE elements ALTER COLUMN name SET NOT NULL, ALTER COLUMN symbol SET NOT NULL;

ALTER TABLE elements ADD CONSTRAINT unique_name UNIQUE(name);

ALTER TABLE elements ADD CONSTRAINT unique_symbol UNIQUE(symbol);

ALTER TABLE properties ADD FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);

CREATE TABLE types(
    type_id SERIAL PRIMARY KEY,
    type VARCHAR(15) NOT NULL
);

INSERT INTO types(type) VALUES('metalloid'),('nonmetal'),('metal');

ALTER TABLE properties ADD COLUMN type_id INT;

UPDATE properties SET type_id = 1 WHERE type = 'metalloid';
-- UPDATE 2
UPDATE properties SET type_id = 2 WHERE type = 'nonmetal';
-- UPDATE 5
UPDATE properties SET type_id = 3 WHERE type = 'metal';
-- UPDATE 2

ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;

ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id);

UPDATE elements SET symbol = INITCAP(symbol);

ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL;

UPDATE properties SET atomic_mass = atomic_mass::REAL;

-- You should add the element with atomic number 9 to your database. Its name is Fluorine,
--  symbol is F, mass is 18.998, melting point is -220, boiling point is -188.1,
--  and it's a nonmetal

-- You should add the element with atomic number 10 to your database. Its name is Neon,
--  symbol is Ne, mass is 20.18, melting point is -248.6, boiling point is -246.1,
--  and it's a nonmetal
INSERT INTO elements(atomic_number,name,symbol)
            VALUES(9,'Fluorine','F'),
                  (10, 'Neon','Ne');
INSERT INTO properties(atomic_number,atomic_mass,melting_point_celsius,boiling_point_celsius,type_id)
            VALUES(9,18.998,-220,-188.1,2),
                  (10,20.18,-248.6,-246.1,2);

DELETE FROM properties WHERE atomic_number = 1000;

DELETE FROM elements WHERE atomic_number = 1000;

ALTER TABLE properties DROP COLUMN type;