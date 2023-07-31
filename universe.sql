DROP DATABASE universe;

CREATE DATABASE universe;

\c universe

CREATE TABLE galaxy (
    galaxy_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL UNIQUE,
    size INT NOT NULL,
    age INT,
    info TEXT,
    position NUMERIC UNIQUE,
    has_a_life BOOLEAN
);

CREATE TABLE star (
    star_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL UNIQUE,
    more_info TEXT UNIQUE,
    size INT NOT NULL,
    age INT,
    galaxy_id INT,
    FOREIGN KEY (galaxy_id) REFERENCES galaxy(galaxy_id)
);

CREATE TABLE planet (
    planet_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL UNIQUE,
    size INT NOT NULL,
    age INT,
    position NUMERIC,
    more_info TEXT UNIQUE,
    good_for_humans BOOLEAN,
    star_id INT,
    FOREIGN KEY (star_id) REFERENCES star(star_id)
);

CREATE TABLE moon (
    moon_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL UNIQUE,
    size INT NOT NULL,
    age INT,
    position NUMERIC,
    more_info TEXT UNIQUE,
    planet_id INT,
    FOREIGN KEY (planet_id) REFERENCES planet(planet_id)
);

CREATE TABLE black_hole (
    black_hole_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL UNIQUE,
    mass NUMERIC NOT NULL,
    age INT,
    position NUMERIC,
    more_info TEXT UNIQUE,
    galaxy_id INT,
    FOREIGN KEY (galaxy_id) REFERENCES galaxy(galaxy_id)
);


INSERT INTO galaxy (name, size, age, info, position, has_a_life)
VALUES
    ('Milky Way', 100000, 13, 'Spiral galaxy', 1.0, TRUE),
    ('Andromeda', 120000, 200, 'Spiral galaxy', 2.5, FALSE),
    ('Triangulum', 40000, 800, 'Spiral galaxy', 1.8, FALSE),
    ('Sombrero', 20000, 1500, 'Spiral galaxy', 3.2, FALSE),
    ('Whirlpool', 25000, 1500, 'Spiral galaxy', 1.5, FALSE),
    ('Centaurus A', 60000, 1300, 'Elliptical galaxy', 5.0, FALSE);

INSERT INTO star (name, size, age, galaxy_id)
VALUES
    ('Sun', 1, 4600, 1),
    ('Sirius', 2, 230, 1),
    ('Alpha Centauri', 3, 6000, 1),
    ('Betelgeuse', 1000, 10, 2),
    ('Vega', 5, 400, 2),
    ('Polaris', 50, 300, 3);

INSERT INTO planet (name, size, age, position, good_for_humans, star_id)
VALUES
    ('Earth', 1, 4500, 3.5, true, 1),
    ('Mars', 0, 4, 1.5, false, 1),
    ('Venus', 0, 4700, 2, false, 1),
    ('Jupiter', 10, 4300, 5.2, false, 2),
    ('Saturn', 8, 4100, 9.5, false, 2),
    ('Neptune', 4, 4600, 30, false, 3),
    ('Uranus', 6, 4200, 20, false, 3),
    ('Pluto', 0, 4400, 40, false, 4),
    ('Mercury', 0, 4400, 2, false, 3),
    ('Kepler-452b', 1, 6000, 2, true, 2),
    ('HD 189733 b', 2, 10, 1, false, 1),
    ('Gliese 581 c', 1, 8, 1, true, 1);

INSERT INTO moon (name, size, age, position, planet_id)
VALUES
    ('Moon', 0, 4.5, 1.0, 1),
    ('Phobos', 0, 3.8, 0.5, 2),
    ('Deimos', 0, 3.9, 0.3, 2),
    ('Ganymede', 0, 4.3, 1.0, 4),
    ('Europa', 0, 4.2, 0.8, 4),
    ('Titan', 0, 4.2, 1.5, 5),
    ('Triton', 0, 4.1, 1.2, 6),
    ('Charon', 0, 4.1, 0.7, 7),
    ('Callisto', 0, 4.3, 1.2, 4),
    ('Io', 0, 4.2, 0.8, 4),
    ('Enceladus', 0, 4.2, 1.5, 5),
    ('Europaa', 0, 4.1, 1.2, 6),
    ('Dione', 0, 4.1, 0.7, 7),
    ('Rhea', 0, 4.3, 1.2, 4),
    ('Oberon', 0, 4.2, 0.8, 4),
    ('Miranda', 0, 4.2, 1.5, 5),
    ('Nereid', 0, 4.1, 1.2, 6),
    ('Ariel', 0, 4.1, 0.7, 7),
    ('Tethys', 0, 4.3, 1.2, 4),
    ('Umbriel', 0, 4.2, 0.8, 4),
    ('Proteus', 0, 4.2, 1.5, 5),
    ('Hyperion', 0, 4.1, 1.2, 6);


INSERT INTO black_hole (name, mass, age, position, more_info, galaxy_id)
VALUES
    ('BlackHole1', 1000000, 13, 1.0, 'Supermassive black hole in the center of the Milky Way', 1),
    ('BlackHole2', 500000, 10, 2.5, 'Intermediate-mass black hole in the Andromeda galaxy', 2),
    ('BlackHole3', 2000, 2, 1.8, 'Stellar-mass black hole in the Triangulum galaxy', 3),
    ('BlackHole4', 80000000, 1500, 3.2, 'Supermassive black hole in the Sombrero galaxy', 4),
    ('BlackHole5', 750000, 1500, 1.5, 'Supermassive black hole in the Whirlpool galaxy', 5),
    ('BlackHole6', 30000, 1300, 5.0, 'Intermediate-mass black hole in the Centaurus A galaxy', 6);
