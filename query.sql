--              Create a database and use it
CREATE DATABASE auction;

USE auction;
--              Create a user table with appropriate fields
CREATE TABLE `user` (
    user_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, full_name VARCHAR(50) NOT NULL, email VARCHAR(30) UNIQUE NOT NULL, password VARCHAR(30) NOT NULL, phone_number VARCHAR(20) UNIQUE NOT NULL, address VARCHAR(200) NOT NULL, account_balance FLOAT DEFAULT 0.0, role ENUM('buyer', 'seller') NOT NULL
);

CREATE TABLE seller (
    seller_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, info_id INT NOT NULL, FOREIGN KEY (info_id) REFERENCES `user` (user_id), status ENUM(
        'active', 'suspended', 'banned'
    ), total_items_posted INT DEFAULT(0), rating FLOAT CHECK (rating <= 5) DEFAULT 0.0, total_transactions INT DEFAULT 0, last_transaction_date DATE
);

CREATE TABLE item (
    item_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, seller_id INT NOT NULL, FOREIGN KEY (seller_id) REFERENCES seller (seller_id), item_title VARCHAR(200) NOT NULL, item_description VARCHAR(500), posted_date DATE DEFAULT CURRENT_TIMESTAMP, start_date DATE DEFAULT CURRENT_TIMESTAMP, end_date DATE NOT NULL, starting_price FLOAT NOT NULL DEFAULT 0.0, CURRENT_STATUS ENUM(
        'pending', 'active', 'sold', 'expired', 'rejected'
    ) DEFAULT 'pending', total_bidders INT DEFAULT 0, highest_bid INT, FOREIGN KEY (highest_bid) REFERENCES bid (bid_id)
);

CREATE TABLE bid (
    bid_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, bidder_id INT NOT NULL, FOREIGN KEY (bidder_id) REFERENCES `user` (user_id), item_id INT NOT NULL, FOREIGN KEY (item_id) REFERENCES item (item_id), bid_amount FLOAT NOT NULL CHECK (bid_amount > 0.0), bid_date DATE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `transaction` (
    transaction_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, item_id INT NOT NULL, FOREIGN KEY (item_id) REFERENCES item (item_id), seller_id INT NOT NULL, FOREIGN KEY (seller_id) REFERENCES seller (seller_id), transaction_amount FLOAT NOT NULL CHECK (transaction_amount > 0.0), transaction_date DATE DEFAULT CURRENT_TIMESTAMP, payment_status ENUM('pending', 'completed') DEFAULT 'pending'
);

CREATE TABLE complain (
    complain_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, complainer_id INT NOT NULL, FOREIGN KEY (complainer_id) REFERENCES `user` (user_id), seller_id INT NOT NULL, FOREIGN KEY (seller_id) REFERENCES seller (seller_id), complain_text VARCHAR(700) NOT NULL, status ENUM('read', 'unread') DEFAULT 'unread'
);

CREATE TABLE `admin` (
    admin_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, full_name VARCHAR(30) NOT NULL, email VARCHAR(30) NOT NULL, password VARCHAR(30) NOT NULL, position ENUM(
        'usersAdmin', 'itemsAdmin', 'superAdmin'
    ) NOT NULL
)