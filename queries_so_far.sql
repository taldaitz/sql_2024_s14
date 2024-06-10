CREATE DATABASE formation;

SHOW DATABASES;

USE formation;

SHOW TABLES;

DROP DATABASE formation;

CREATE TABLE contact (
	id INT PRIMARY KEY AUTO_INCREMENT,
    lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) NULL,
    date_of_birth DATE NULL
);

DESCRIBE contact;

DROP TABLE contact;


ALTER TABLE contact	
	ADD COLUMN is_friend BOOL, 
    MODIFY email VARCHAR(240) NULL;

CREATE TABLE booking (
	id INT PRIMARY KEY AUTO_INCREMENT,
    customer_lastname VARCHAR(100) NOT NULL,
    customer_firstname VARCHAR(100) NOT NULL,
    customer_email VARCHAR(255) NOT NULL,
    customer_phone_number VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    room_number INT NOT NULL,
    room_floor INT NOT NULL,
    room_type VARCHAR(100) NOT NULL
);

DESCRIBE booking;

ALTER TABLE  booking
	DROP COLUMN room_floor;
    
DESCRIBE booking;

ALTER TABLE booking
	ADD COLUMN is_paid BOOL NOT NULL,
    MODIFY room_type VARCHAR(100) NOT NULL DEFAULT 'Single';
    
INSERT INTO contact (firstname, lastname, email, date_of_birth, is_friend)
VALUES ('Thomas', 'Aldaitz', 'taldaitz@dawan.fr', '1985-04-28', true);


INSERT INTO contact (firstname, lastname, email, date_of_birth, is_friend)
VALUES ('Robert', 'Test', 'rtest@dawan.fr', '1985-05-28', true),
		('Jean', 'Retest', 'jretest@dawan.fr', null, false)
;


SELECT * FROM contact;

UPDATE contact
SET is_friend = true
WHERE id IN (3, 2)
;

UPDATE contact
SET phone_number = '0623135135', date_of_birth = '2000-12-25'
;
