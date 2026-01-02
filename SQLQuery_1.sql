CREATE DATABASE PUBS;

USE PUBS;

--creating tables

CREATE TABLE publishers (
    pub_id CHAR(4) PRIMARY KEY,
    pub_name VARCHAR(40),
    city VARCHAR(20),
    state CHAR(2),
    country VARCHAR(30)
);

CREATE TABLE pub_info (
    pub_id CHAR(4) PRIMARY KEY,
    logo IMAGE,
    pr_info TEXT,
    FOREIGN KEY (pub_id) REFERENCES publishers(pub_id)
);

CREATE TABLE jobs (
    job_id SMALLINT PRIMARY KEY,
    job_desc VARCHAR(50),
    min_lvl TINYINT,
    max_lvl TINYINT
);

CREATE TABLE employee (
    emp_id CHAR(9) PRIMARY KEY,
    fname VARCHAR(20),
    minit CHAR(1),
    lname VARCHAR(30),
    job_id SMALLINT,
    job_lvl TINYINT,
    pub_id CHAR(4),
    hire_date DATETIME,
    FOREIGN KEY (job_id) REFERENCES jobs(job_id),
    FOREIGN KEY (pub_id) REFERENCES publishers(pub_id)
);

CREATE TABLE authors (
    au_id VARCHAR(11) PRIMARY KEY,
    au_lname VARCHAR(40),
    au_fname VARCHAR(20),
    phone CHAR(12),
    address VARCHAR(40),
    city VARCHAR(20),
    state CHAR(2),
    zip CHAR(5),
    contract BIT
);

CREATE TABLE titles (
    title_id VARCHAR(6) PRIMARY KEY,
    title VARCHAR(80),
    type VARCHAR(12),
    pub_id CHAR(4),
    price MONEY,
    advance MONEY,
    royalty INT,
    ytd_sales INT,
    notes VARCHAR(200),
    pubdate DATETIME,
    FOREIGN KEY (pub_id) REFERENCES publishers(pub_id)
);

CREATE TABLE titleauthor (
    au_id VARCHAR(11),
    title_id VARCHAR(6),
    au_ord TINYINT,
    royaltyper INT,
    PRIMARY KEY (au_id, title_id),
    FOREIGN KEY (au_id) REFERENCES authors(au_id),
    FOREIGN KEY (title_id) REFERENCES titles(title_id)
);

CREATE TABLE roysched (
    title_id VARCHAR(6),
    lorange INT,
    hirange INT,
    royalty INT,
    FOREIGN KEY (title_id) REFERENCES titles(title_id)
);


CREATE TABLE stores (
    stor_id CHAR(4) PRIMARY KEY,
    stor_name VARCHAR(40),
    stor_address VARCHAR(40),
    city VARCHAR(20),
    state CHAR(2),
    zip CHAR(5)
);

CREATE TABLE discounts (
    discounttype VARCHAR(40),
    stor_id CHAR(4),
    lowqty SMALLINT,
    highqty SMALLINT,
    discount DECIMAL(4,2),
    FOREIGN KEY (stor_id) REFERENCES stores(stor_id)
);

CREATE TABLE sales (
    stor_id CHAR(4),
    ord_num VARCHAR(20),
    ord_date DATETIME,
    qty SMALLINT,
    payterms VARCHAR(12),
    title_id VARCHAR(6),
    FOREIGN KEY (stor_id) REFERENCES stores(stor_id),
    FOREIGN KEY (title_id) REFERENCES titles(title_id)
);

--Inserted data for all tables based on the questions...took help from chatgpt for data

INSERT INTO publishers VALUES
('0736', 'New Age Books', 'Boston', 'MA', 'USA'),
('0877', 'Tech Press', 'New York', 'NY', 'USA'),
('1389', 'Global Publications', 'London', NULL, 'UK');

SELECT * FROM publishers;

INSERT INTO pub_info (pub_id, logo, pr_info)
VALUES
('0736', NULL, 'Business and management books'),
('0877', NULL, 'Technical and IT books'),
('1389', NULL, 'International publications');

INSERT INTO jobs VALUES
(1, 'Editor', 10, 50),
(2, 'Manager', 20, 60),
(3, 'Designer', 10, 40);

INSERT INTO employee VALUES
('E001', 'John', 'A', 'Smith', 1, 20, '0736', GETDATE()),
('E002', 'Sara', 'B', 'Brown', 2, 30, '0877', GETDATE());

INSERT INTO authors VALUES
('A001', 'Dean', 'Mark', '123-456', 'Street 1', 'Menlo Park', 'CA', '94025', 1),
('A002', 'Scott', 'Sam', '234-567', 'Street 2', 'New York', 'NY', '10001', 1),
('A003', 'James', 'Sara', '345-678', 'Street 3', 'Menlo Park', 'CA', '94025', 0),
('A004', 'Taylor', 'Steve', '456-789', 'Street 4', 'Boston', 'MA', '02101', 1);

INSERT INTO titles VALUES
('BU1111', 'Business Skills', 'business', '0736', 19.99, 5000, 15, 12000, 'Business book', '2015-06-01'),
('PS2222', 'Psychology Basics', 'psychology', '0877', 25.50, 6000, 18, 8000, 'Psychology book', '2018-03-15'),
('MC2222', 'Modern Computing', 'technology', '0877', 30.00, 8000, 20, 15000, 'Tech book', '2021-08-10'),
('UN3333', 'Unknown Paths', NULL, '1389', NULL, 3000, 10, 4000, 'General book', '2010-01-01');

INSERT INTO titleauthor VALUES
('A001', 'BU1111', 1, 60),
('A002', 'PS2222', 1, 70),
('A003', 'BU1111', 2, 40),
('A001', 'MC2222', 1, 100),
('A004', 'UN3333', 1, 100);

INSERT INTO roysched VALUES
('BU1111', 0, 5000, 10),
('BU1111', 5001, 10000, 15),
('MC2222', 0, 10000, 20);

INSERT INTO stores VALUES
('S001', 'Book World', 'Main Street', 'Boston', 'MA', '02101'),
('S002', 'Readers Hub', 'Market Road', 'New York', 'NY', '10001');

INSERT INTO discounts VALUES
('Seasonal', 'S001', 10, 50, 5.00),
('Bulk', 'S002', 20, 100, 10.00);

INSERT INTO sales VALUES
('S001', 'ORD001', '2022-01-10', 25, 'Net 30', 'BU1111'),
('S002', 'ORD002', '2022-02-15', 40, 'Net 60', 'MC2222');


--1
ALTER TABLE titles
ADD tax_rate DECIMAL(5,2);

UPDATE titles
SET tax_rate = 12;

SELECT * FROM titles;

--2

SELECT title
FROM titles
WHERE title LIKE '%s' OR title LIKE '%t';

--3

SELECT title, type
FROM titles
WHERE type IN ('business', 'psychology', 'undecided');

--4

SELECT title, ytd_sales, royalty
FROM titles
WHERE ytd_sales > 5000
  AND royalty < 20;

--5

SELECT title, ytd_sales
FROM titles
WHERE pub_id = '0736'
ORDER BY ytd_sales ASC;

--6

SELECT MAX(royalty) - MIN(royalty) AS royalty_difference
FROM titles
WHERE pub_id = '0877';

--7

SELECT au_id, COUNT(title_id) AS no_of_books
FROM titleauthor
GROUP BY au_id;

--8

SELECT title_id, COUNT(au_id) AS author_count
FROM titleauthor
GROUP BY title_id;

--9
SELECT au_id, AVG(royaltyper) AS avg_royalty
FROM titleauthor
WHERE au_ord = 1
GROUP BY au_id;

--10
SELECT title, price, ytd_sales
FROM titles
WHERE ytd_sales BETWEEN 10000 AND 20000
ORDER BY price;

--11
SELECT COUNT(*) AS total_authors
FROM authors
WHERE city = 'Menlo Park';

--12
SELECT state, COUNT(*) AS author_count
FROM authors
GROUP BY state
ORDER BY state;

--13
SELECT state, COUNT(*) AS author_count
FROM authors
WHERE au_fname LIKE 's%'
GROUP BY state
HAVING COUNT(*) > 2;


--14
SELECT REPLACE(REPLACE(title, ' ', '.'), '-', '*') AS modified_title
FROM titles;

--15
SELECT REPLACE(title, ' ', '') AS title_no_spaces
FROM titles;

--16
SELECT LEFT(title, CHARINDEX(' ', title + ' ') - 1) AS first_word
FROM titles;


--17
SELECT MONTH(pubdate) AS pub_month,
       COUNT(*) AS total_books
FROM titles
GROUP BY MONTH(pubdate);


--18
SELECT t.title, p.pub_name
FROM titles t
JOIN publishers p ON t.pub_id = p.pub_id
WHERE p.country = 'USA';

--19
SELECT p.pub_name, AVG(t.price) AS avg_price
FROM publishers p
JOIN titles t ON p.pub_id = t.pub_id
GROUP BY p.pub_name;

--20
SELECT a.city, COUNT(ta.title_id) AS total_books
FROM authors a
JOIN titleauthor ta ON a.au_id = ta.au_id
GROUP BY a.city;

--21
SELECT a.au_fname, a.au_lname, t.title
FROM authors a
LEFT JOIN titleauthor ta ON a.au_id = ta.au_id
LEFT JOIN titles t ON ta.title_id = t.title_id;

--22
SELECT t.title, p.pub_name, a.au_fname, a.au_lname
FROM titles t
JOIN publishers p ON t.pub_id = p.pub_id
JOIN titleauthor ta ON t.title_id = ta.title_id
JOIN authors a ON ta.au_id = a.au_id
WHERE ta.au_ord = 1;

--23
SELECT p.city, MAX(t.price) AS max_price
FROM publishers p
JOIN titles t ON p.pub_id = t.pub_id
GROUP BY p.city;

--24
SELECT DISTINCT t.title
FROM titles t
JOIN titleauthor ta ON t.title_id = ta.title_id
JOIN authors a ON ta.au_id = a.au_id
WHERE a.city = 'Menlo Park';

--25
SELECT DISTINCT p.pub_name
FROM publishers p
JOIN titles t ON p.pub_id = t.pub_id
WHERE YEAR(t.pubdate) = 1991;

--26
SELECT t.title
FROM titles t
JOIN publishers p ON t.pub_id = p.pub_id
WHERE p.country <> 'USA';

--27
SELECT t.title
FROM titles t
JOIN publishers p ON t.pub_id = p.pub_id
WHERE p.country = 'USA'
   OR t.price < 5;

--28
CREATE VIEW vw_titles_info AS
SELECT title,
       pub_id,
       YEAR(pubdate) AS publish_year,
       ISNULL(price, 0) AS price,
       ISNULL(type, 'Unknown') AS type
FROM titles;
SELECT * FROM vw_titles_info;


--29
SELECT DISTINCT p.pub_name
FROM publishers p
JOIN titles t ON p.pub_id = t.pub_id
JOIN titleauthor ta ON t.title_id = ta.title_id
WHERE ta.au_id IN (
    SELECT au_id
    FROM titleauthor
    GROUP BY au_id
    HAVING COUNT(title_id) > 2
);

--30
DELETE FROM titleauthor
WHERE au_id IN (
    SELECT au_id
    FROM authors
    WHERE au_fname = 'Dean'
);
SELECT *FROM titleauthor;

--31
UPDATE titles
SET price = (SELECT price FROM titles WHERE title_id = 'MC2222')
WHERE title_id = 'BU1111';
SELECT *FROM titles;

--32
SELECT title
FROM titles
WHERE pubdate >= DATEADD(YEAR, -25, GETDATE());

--33
SELECT title
FROM titles
WHERE pub_id IN (
    SELECT pub_id
    FROM titles
    WHERE YEAR(pubdate) = 2021
);

--34
CREATE VIEW vw_publisher_books AS
SELECT p.pub_name, p.city, COUNT(t.title_id) AS total_books
FROM publishers p
LEFT JOIN titles t ON p.pub_id = t.pub_id
GROUP BY p.pub_name, p.city;
SELECT * FROM vw_publisher_books;


































