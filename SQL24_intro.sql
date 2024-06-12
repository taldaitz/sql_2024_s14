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


UPDATE contact
SET is_friend = true
WHERE id IN (3, 2)
;

UPDATE contact
SET phone_number = '0623135135', 
date_of_birth = '2000-12-25'
;

USE formation;

/*1 - Modifier le client de la 1er reservation
  => Thomas Aldaitz*/
  
  UPDATE booking
  SET customer_lastname = 'Aldaitz', customer_firstname = 'Thomas'
  WHERE id = 1;
  
  SELECT * FROM booking;

/*2 - La 3eme resevation passe en payé*/

UPDATE booking
SET is_paid = true
WHERE id = 3;


/*3 - Les reservation des chambres du première étage 
doivent toutes terminé le 15/06/2024*/

UPDATE booking
SET end_date = '2024-06-15'
WHERE room_number >= 100 AND room_number < 200
/*WHERE room_number BETWEEN 100 AND 199*/
;

/*4 - Effacer les numéros de téléphone de toutes les
reservation.*/

UPDATE booking
SET customer_phone_number = ''
;


SELECT *
FROM booking
WHERE room_number IN (280, 289, 246)
;

/*-> Le nom, prénom et email des clients dont le prénom est "Julien"*/
SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_firstname = 'Julien';

/*-> Le nom, prénom et email des clients dont l'email termine par "@gmail.com"*/
SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_email LIKE '%@gmail.com'
;

/*-> toutes les commandes  non payées*/

SELECT *
FROM full_order
WHERE is_paid = false;

/*-> toutes les commandes  payées mais non livré*/

SELECT *
FROM full_order
WHERE is_paid = true
AND shipment_date IS NULL;

/*-> toutes les commandes  livré hors de France*/

SELECT * 
FROM full_order
WHERE shipment_country <> 'France'
;



SELECT customer_lastname, customer_firstname, room_number
FROM booking
ORDER BY room_number
LIMIT 10
;

/*-> toutes les commandes au montant de plus 8000€ ordonnées du plus grand au plus petit*/

SELECT * 
FROM full_order
WHERE amount > 8000
ORDER BY amount DESC;

/*-> La commande au montant le plus élevé (une seule)*/

SELECT * 
FROM full_order
ORDER BY amount DESC
LIMIT 1;

/*-> toutes les commandes réglé en Cash en 2022 livré en France dont le montant est 
inférieur à 5000 €*/

SELECT *
FROM full_order
WHERE payment_type = 'Cash'
AND YEAR(payment_date) = 2022
AND shipment_country = 'France'
AND amount < 5000
;

/*-> toutes les commandes payés par carte ou payé aprés le 15/10/2021*/

SELECT *
FROM full_order
WHERE payment_type = 'Credit Card'
	OR payment_date > '2021-10-15'
;

/*-> les 3 dernières commandes envoyées en France*/

SELECT *
FROM full_order
WHERE shipment_country = 'France'
ORDER BY shipment_date DESC
LIMIT 3;

/*-> les 10 commandes les plus élevés passé sur l'année 2021*/

SELECT * 
FROM full_order
WHERE YEAR(date) = 2021
ORDER BY amount DESC
LIMIT 10;

SELECT AVG(amount), SUM(amount), MIN(amount), MAX(amount), COUNT(amount)
FROM full_order
;

SELECT date, SUM(amount)
FROM full_order
;

/*-> la somme des commandes non payés*/

SELECT ROUND(SUM(amount), 3)  AS total_unpaid
FROM full_order
WHERE is_paid = false;


/*-> la moyenne des montants des commandes payés en cash*/

SELECT ROUND(AVG(amount), 2) AS average_cash
FROM full_order
WHERE payment_type = 'Cash';


/*-> le nombre de client dont le nom est "Laporte"*/

SELECT COUNT(id) AS nb_of_Laporte
FROM full_order
WHERE customer_lastname = 'Laporte';


/*-> Le nombre de jour Maximum entre la date de payment et la date de livraison -> DATEDIFF()*/

SELECT MAX(DATEDIFF(payment_date, shipment_date)) AS maximum_delay
FROM full_order
;


/*-> Le délai moyen (en jour) de réglement d'une commande*/
SELECT ROUND(AVG(ABS(DATEDIFF(payment_date, date)))) AS Average_delay
FROM full_order
;


/*-> le nombre de commande payés en chèque sur 2021*/

SELECT COUNT(id) AS nb_Order_Paid_By_Check_In_2021
FROM full_order
WHERE payment_type = 'Check'
	AND YEAR(payment_date) = 2021
;

SELECT room_number, COUNT(id) AS nb_booking
FROM booking
GROUP BY room_number
ORDER BY nb_booking DESC
;

/*-> Le montant total des commandes par type de paiement*/

SELECT payment_type, ROUND(SUM(amount), 2) AS total_amount
FROM full_order
WHERE payment_type IS NOT NULL
GROUP BY payment_type
ORDER BY payment_type
;

/*-> La moyenne des montants des commandes par Pays*/
SELECT shipment_country, ROUND(AVG(amount), 2) AS average_amount
FROM full_order
WHERE shipment_country IS NOT NULL
GROUP BY shipment_country
ORDER BY shipment_country
;


/*-> Par année la somme des montants des commandes*/
SELECT YEAR(date) AS year_order, ROUND(SUM(amount), 2) AS total_amount
FROM full_order
GROUP BY year_order
ORDER BY year_order
;


/*-> Liste des clients (nom, prénom) qui ont au moins deux commandes*/

SELECT customer_lastname, customer_firstname, COUNT(id) AS nb_order
FROM full_order
GROUP BY customer_lastname, customer_firstname
	HAVING nb_order > 1 
ORDER BY customer_lastname, customer_firstname
;


/*-> Liste des clients (nom, prénom) avec le montant de leur commande
la plus élevé en 2021 (TOP 3)*/

SELECT customer_lastname, customer_firstname, MAX(amount) AS max_amount
FROM full_order
WHERE YEAR(date) = 2021
GROUP BY customer_lastname, customer_firstname
ORDER BY max_amount DESC
LIMIT 3
;


SELECT * FROM product;
SELECT * FROM category;

SELECT pr.id, pr.name, ca.label
FROM product pr
	JOIN category ca ON pr.category_id = ca.id
;

/*-> Pour chaque facture, afficher id de la facture, le nom et le prénom du client*/
SELECT *
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
;


SELECT bi.id, cu.lastname, cu.firstname
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
;


/*-> Pour chaque client (nom, prénom) remonter le nombre de facture associé*/

SELECT *
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
;


SELECT cu.lastname, cu.firstname, bi.id
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
ORDER BY cu.lastname, cu.firstname
;

SELECT cu.lastname, cu.firstname, COUNT(bi.id) AS nb_bills
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
GROUP BY cu.id
ORDER BY cu.lastname, cu.firstname
;


/*-> Pour chaque catégorie de produit, la moyenne des prix unitaires de 
produits associés*/

SELECT *
FROM category ca 
	JOIN product pr ON ca.id = pr.category_id
;


SELECT ca.label, pr.unit_price
FROM category ca 
	JOIN product pr ON ca.id = pr.category_id
;


SELECT ca.label, ROUND(AVG(pr.unit_price), 2) AS average_price
FROM category ca 
	JOIN product pr ON ca.id = pr.category_id
GROUP BY ca.id
;

/*-> Pour Chaque produit toutes les lignes de facture avec la date et la quantité*/

SELECT pr.id, pr.name, pr.unit_price, li.quantity, bi.date
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
    ;


/*-> Pour Chaque produit la quantité commandée depuis le 01/01/2021*/
SELECT pr.id, pr.name, SUM(li.quantity) AS total_quantity
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
WHERE bi.date >= '2021-01-01'
GROUP BY pr.id
ORDER BY pr.id
;


/*-> La liste des Facture (ref) qui ont plus de 2 produits différends commandé*/
SELECT bi.id, bi.ref, COUNT(DISTINCT li.product_id) AS nb_product
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
GROUP BY bi.id
	HAVING nb_product > 2
;


/*-> Pour chaque Facture afficher le montant total*/

SELECT bi.id, bi.ref, SUM(pr.unit_price * li.quantity) AS total_amount
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
GROUP BY bi.id
ORDER BY bi.id
    ;

USE formation;


USE billings;
/*-> Pour chaque client compter le nombre de produit différents qu'il a commandé*/

SELECT cu.id, cu.firstname, cu.lastname, COUNT(DISTINCT li.product_id) AS nb_Product
FROM customer cu
	JOIN bill bi ON cu.id = bi.customer_id
    JOIN line_item li ON bi.id = li.bill_id
GROUP BY cu.id
;

/*-> Pour chaque produit compter le nombre de client différents qu'ils l'ont commandé*/

SELECT pr.id, pr.name, COUNT(DISTINCT bi.customer_id) AS nb_customer
FROM product pr
	JOIN line_item li ON pr.id = li.product_id
    JOIN bill bi ON bi.id = li.bill_id
GROUP BY pr.id
;


/*-> pour chaque catégorie de produit la somme des facture payées*/

SELECT ca.label, SUM(pr.unit_price * li.quantity) AS total_sold
FROM category ca
	JOIN product pr ON ca.id = pr.category_id
    JOIN line_item li ON pr.id = li.product_id
    JOIN bill bi ON bi.id = li.bill_id
WHERE is_paid = true
GROUP BY ca.id
ORDER BY ca.label
;


/*-> par Année la moyenne d'age des clients*/

SELECT YEAR(bi.date) AS Year_Bill, ROUND(AVG(TIMESTAMPDIFF(YEAR, cu.date_of_birth , NOW()))) AS Age
FROM bill bi
	JOIN customer cu ON cu.id = bi.customer_id
GROUP BY Year_Bill
ORDER BY Year_Bill
;


CREATE VIEW customer_age_by_year AS
SELECT YEAR(bi.date) AS Year_Bill, 
		ROUND(AVG(TIMESTAMPDIFF(YEAR, cu.date_of_birth , NOW()))) AS Age
FROM bill bi
	JOIN customer cu ON cu.id = bi.customer_id
GROUP BY Year_Bill
ORDER BY Year_Bill
;



SELECT * FROM customer_age_by_year;



/*1 - Créer une vue qui afficher toutes les colonnes des factures avec en plus la somme des
factures*/

CREATE VIEW bills_with_amount AS 
SELECT bi.*, SUM(pr.unit_price * li.quantity) AS total_amount
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
GROUP BY bi.id
ORDER BY bi.id
    ;
    

/*2 - La tester dans une requete*/

SELECT * FROM bills_with_amount;

/*3 - Executer les requêtes :*/

/*-> le nom, prénom et somme des factures des 3 clients qui ont passé le plus grand nombre 
de facture*/

SELECT cu.lastname, cu.firstname, SUM(bwa.total_amount), COUNT(bwa.id) AS nb_bills
FROM bills_with_amount bwa
	JOIN customer cu ON bwa.customer_id = cu.id
GROUP BY cu.id
ORDER BY nb_bills DESC, cu.lastname
LIMIT 3
;



/*-> le nom, prénom et (somme des factures) des 3 clients qui ont passé les factures 
les plus chers*/


SELECT cu.lastname, cu.firstname, SUM(bwa.total_amount), MAX(bwa.total_amount) AS max_bill
FROM bills_with_amount bwa
	JOIN customer cu ON bwa.customer_id = cu.id
GROUP BY cu.id
ORDER BY max_bill DESC, cu.lastname
LIMIT 3
;



/*-> le nom, prénom et somme des factures des 3 clients qui ont  le total des factures 
les plus élevés*/


SELECT cu.lastname, cu.firstname, SUM(bwa.total_amount) AS total_bills
FROM bills_with_amount bwa
	JOIN customer cu ON bwa.customer_id = cu.id
GROUP BY cu.id
ORDER BY total_bills DESC, cu.lastname
LIMIT 3
;


USE formation;

SELECT * FROM booking;
SELECT * FROM payment;

CALL reset_payments(false);

DROP PROCEDURE reset_payments;
DELIMITER //
CREATE PROCEDURE reset_payments(newStatus bool)
BEGIN

	UPDATE booking
	SET is_paid = newStatus
    ;
    
    DELETE FROM payment;	


END//


USE billings;

SELECT * FROM customer;

ALTER TABLE customer
	ADD COLUMN is_vip bool; 
    
DROP PROCEDURE update_vips;
DELIMITER //
CREATE PROCEDURE update_vips(vip_limit FLOAT)
BEGIN

	UPDATE customer SET is_vip = false;

	UPDATE customer
	SET is_vip = true
	WHERE id IN (
		SELECT customer_id
		FROM bills_with_amount
		GROUP BY customer_id
			HAVING SUM(total_amount) > vip_limit
	);
    
END//
    
    CALL update_vips(20000);



SELECT * FROM customer;

WITH vips AS  (
	SELECT * FROM customer WHERE is_vip = true
)

SELECT * FROM vips;

SELECT * FROM booking;
SELECT * FROM payment;


CREATE TABLE payment (
	id INT PRIMARY KEY AUTO_INCREMENT,
    date DATETIME NOT NULL,
    amount FLOAT NOT NULL,
    booking_id INT NOT NULL
);

INSERT INTO payment (date, amount, booking_id)
VALUES (NOW(), 100, 1);

INSERT INTO payment (date, amount, booking_id)
VALUES 
	(NOW(), 50, 1),
	(NOW(), 200, 2),
	(NOW(), 75, 3),
	(NOW(), 150, 5),
	(NOW(), 60, 5)
;



SELECT * FROM booking;
SELECT * FROM payment;

SELECT *
FROM booking bo
	JOIN payment pa ON bo.id = pa.booking_id
;

/* OLD JOIN */
SELECT *
FROM booking bo, payment pa 
WHERE pa.booking_id = bo.id
;
/* OLD JOIN */




SELECT 
	bo.customer_firstname, 
    bo.customer_lastname, 
    bo.start_date, 
    bo.room_number, 
    SUM(pa.amount) AS total_payment
FROM booking bo
	JOIN payment pa ON bo.id = pa.booking_id
GROUP BY bo.id
;

INSERT INTO payment (date, amount, booking_id)
VALUES (NOW(), 100, 220);

SELECT * FROM booking;
SELECT * FROM payment;

DELETE FROM booking
WHERE id = 7;

ALTER TABLE payment
ADD CONSTRAINT FK_payment_booking
FOREIGN KEY payment (booking_id)
REFERENCES booking (id)
;





/*SELECT ...
   SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS total_1,
   SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END),
   SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END),*/


/*1 - Creer room_type
    - id
    - label
    - price*/
    
    CREATE TABLE room_type (
		id INT PRIMARY KEY AUTO_INCREMENT,
        label VARCHAR(100) NOT NULL,
        price FLOAT NOT NULL
    );

/*2 - Sur la table booking ajouter la colone room_type_id*/

	ALTER TABLE booking
		ADD COLUMN room_type_id INT NOT NULL; 

/*3 - Créer une contrainte d'intégrité entre room_type et booking*/

ALTER TABLE booking
	ADD CONSTRAINT FK_booking_room_type
    FOREIGN KEY booking (room_type_id)
    REFERENCES room_type (id);
    
SELECT * FROM room_type;
SELECT * FROM booking;

UPDATE booking SET room_type_id = 1 WHERE room_type = 'Single';
UPDATE booking SET room_type_id = 2 WHERE room_type = 'Double';
UPDATE booking SET room_type_id = 3 WHERE room_type = 'Premium';

/*4 - Supprimer la colonne room_type dans booking*/


ALTER TABLE booking
	DROP COLUMN room_type;