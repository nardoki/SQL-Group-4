-- Active: 1700161145836@@127.0.0.1@3306@auction
--              Create a database and use it
CREATE DATABASE auction;

USE auction;

--              Create tables with appropriate fields
CREATE TABLE seller (
    seller_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    phone_number VARCHAR(100) UNIQUE NOT NULL,
    `address` VARCHAR(100) NOT NULL,
    account_balance FLOAT DEFAULT 0.0,
    `status` ENUM('active', 'suspended', 'banned') DEFAULT 'active',
    total_items_posted INT DEFAULT(0),
    rating FLOAT CHECK (rating <= 5) DEFAULT 0.0,
    total_transactions INT DEFAULT 0,
    last_transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE buyer (
    buyer_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    email VARCHAR(30) UNIQUE NOT NULL,
    `password` VARCHAR(30) NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    address VARCHAR(200) NOT NULL,
    account_balance FLOAT DEFAULT 0.0
);

CREATE TABLE item (
    item_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    seller_id INT NOT NULL,
    FOREIGN KEY (seller_id) REFERENCES seller (seller_id),
    item_title VARCHAR(200) NOT NULL,
    item_description VARCHAR(500),
    posted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP NOT NULL,
    starting_price FLOAT NOT NULL DEFAULT 0.0,
    CURRENT_STATUS ENUM(
        'pending',
        'active',
        'sold',
        'expired',
        'rejected'
    ) DEFAULT 'pending',
    total_bidders INT DEFAULT 0,
    highest_bid INT,
    FOREIGN KEY (highest_bid) REFERENCES bid (bid_id)
);

CREATE TABLE bid (
    bid_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    bidder_id INT NOT NULL,
    FOREIGN KEY (bidder_id) REFERENCES buyer (buyer_id),
    item_id INT NOT NULL,
    FOREIGN KEY (item_id) REFERENCES item (item_id),
    bid_amount FLOAT NOT NULL CHECK (bid_amount > 0.0),
    bid_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `transaction` (
    transaction_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    item_id INT NOT NULL,
    FOREIGN KEY (item_id) REFERENCES item (item_id),
    seller_id INT NOT NULL,
    FOREIGN KEY (seller_id) REFERENCES seller (seller_id),
    buyer_id INT NOT NULL,
    FOREIGN KEY (buyer_id) REFERENCES buyer (buyer_id),
    transaction_amount FLOAT NOT NULL CHECK (transaction_amount > 0.0),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('pending', 'completed') DEFAULT 'pending'
);

CREATE TABLE complain (
    complain_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    complainer_id INT NOT NULL,
    FOREIGN KEY (complainer_id) REFERENCES buyer (buyer_id),
    seller_id INT NOT NULL,
    FOREIGN KEY (seller_id) REFERENCES seller (seller_id),
    complain_text VARCHAR(700) NOT NULL,
    `status` ENUM('read', 'unread') DEFAULT 'unread'
);

CREATE TABLE usersAdmin (
    users_admin_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL,
    `password` VARCHAR(30) NOT NULL,
    `role` VARCHAR(20) DEFAULT 'userAdmin'
);

CREATE TABLE itemAdmin (
    items_admin_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL,
    `password` VARCHAR(30) NOT NULL,
    `role` VARCHAR(20) DEFAULT 'itemsAdmin'
);

CREATE TABLE superAdmin (
    super_admin_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL,
    `password` VARCHAR(30) NOT NULL,
    `role` VARCHAR(20) DEFAULT 'itemsAdmin'
);

CREATE TABLE `statistics` (
    total_users INT DEFAULT 0,
    total_sellers INT DEFAULT 0,
    total_buyers INT DEFAULT 0,
    total_posted_items INT DEFAULT 0,
    total_active_items INT DEFAULT 0,
    total_sold_items INT DEFAULT 0,
    total_rejected_items INT DEFAULT 0,
    total_transactions INT DEFAULT 0,
    total_transaction_money FLOAT DEFAULT 0,
    total_profit FLOAT DEFAULT 0
);

-- ########## Procedures ##########

-- ## Create sign up as a seller
DELIMITER &&
CREATE PROCEDURE CreateSeller (IN full_name VARCHAR(100), IN email VARCHAR(100), IN `password` VARCHAR(100), IN phone_number VARCHAR(100), IN `address` VARCHAR(100))
BEGIN
INSERT INTO seller (full_name, email, `password`, phone_number, `address`) VALUES(full_name, email, `password`, phone_number, `address`);
END &&
DELIMITER ;

CALL CreateSeller('Faysel Abdella', 'fayselcode@gmail.com', '123', '0968137473', 'Adama, Ethiopia');

SELECT * FROM seller