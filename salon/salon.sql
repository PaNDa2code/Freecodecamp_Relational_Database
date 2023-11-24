DROP DATABASE IF EXISTS salon;

-- Create a new database called 'salon'
CREATE DATABASE salon;

\c salon

CREATE TABLE customers(
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(30),
    phone VARCHAR(15) UNIQUE
);

CREATE TABLE services(
    service_id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE appointments(
    appointment_id SERIAL PRIMARY KEY,
    time VARCHAR(12),
    customer_id INT,
    service_id INT
);

ALTER TABLE appointments ADD FOREIGN KEY(customer_id) REFERENCES customers(customer_id);
ALTER TABLE appointments ADD FOREIGN KEY(service_id) REFERENCES services(service_id);

INSERT INTO services(name) VALUES('hair-cutting'),('skin-care'),('waxing');
