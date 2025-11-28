/*BSCS2509249 MAL2018 CW1*/
/*1) CREATE A DATABASE NAMED "TrailDB"*/

IF DB_ID('TrailDB') IS NOT NULL 

BEGIN 

    ALTER DATABASE TrailDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 

    DROP DATABASE TrailDB; 

END 

GO 

CREATE DATABASE TrailDB; 

GO 

USE TrailDB; 

GO 

/*2) CREATE SCHEMA "CW1" IN "TrailDB"*/

CREATE SCHEMA CW1;


/*3) CREATE TABLES IN SCHEMA "CW1" IN "TrailDB"*/

CREATE TABLE CW1.Users(
    user_id INT IDENTITY(1, 1) PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    user_email VARCHAR(200) NOT NULL UNIQUE,
    user_password VARCHAR(200) NOT NULL
);

CREATE TABLE CW1.Geographical_Info(
    geographical_id INT IDENTITY(1, 1) PRIMARY KEY,
    trail_longitude FLOAT NOT NULL,
    trail_latitude FLOAT NOT NULL
);

CREATE TABLE CW1.Trail_Location(
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    geographical_id INT,
    location_name VARCHAR(150) NOT NULL,
    country VARCHAR(150) NOT NULL,
    state VARCHAR(150) NOT NULL,
    city VARCHAR(150) NOT NULL,
    FOREIGN KEY (geographical_id) REFERENCES CW1.Geographical_Info(geographical_id)
);

CREATE TABLE CW1.Trail(
    trail_id INT IDENTITY(1, 1) PRIMARY KEY,
    location_id INT NOT NULL,
    user_id INT NOT NULL,
    estimated_time_min TIME NOT NULL,
    estimated_time_max TIME NOT NULL,
    route_type VARCHAR(60) NOT NULL,
    difficulty VARCHAR(60) NOT NULL,
    trail_name VARCHAR(100) NOT NULL,
    elevation_gain INT NOT NULL,
    length DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (location_id) REFERENCES CW1.Trail_Location(location_id),
    FOREIGN KEY (user_id) REFERENCES CW1.Users(user_id)
);

CREATE TABLE CW1.Sights(
    sights_id INT IDENTITY(1, 1) PRIMARY KEY,
    top_sight_name VARCHAR(100) NOT NULL
);

CREATE TABLE CW1.Trail_Sights(
    sights_id INT NOT NULL,
    trail_id INT NOT NULL,
    PRIMARY KEY (sights_id, trail_id),
    FOREIGN KEY (sights_id) REFERENCES CW1.Sights(sights_id) ON DELETE CASCADE,
    FOREIGN KEY (trail_id) REFERENCES CW1.Trail(trail_id) ON DELETE CASCADE
);

CREATE TABLE CW1.Rating(
    rating_id INT IDENTITY(1, 1) PRIMARY KEY,
    user_id INT NOT NULL,
    trail_id INT NOT NULL,
    review_text VARCHAR(8000) NOT NULL,
    star_rating INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES CW1.Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (trail_id) REFERENCES CW1.Trail(trail_id) ON DELETE CASCADE
);




/*4. INSERTING DATA INTO THE TABLES*/
INSERT INTO CW1.Users (user_name,user_email,user_password) VALUES
    ('Ada Lovelace', 'grace@plymouth.ac.uk', 'ISAD123!'),
    ('Tim Berners-Lee', 'tim@plymouth.ac.uk', 'COMP2001!'),
    ('Ada Lovelace', 'ada@plymouth.ac.uk', 'insecurePassword');

INSERT INTO CW1.Geographical_Info (trail_longitude, trail_latitude) VALUES
    (-4.07859, 50.40886),
    (-4.13415, 50.36891);

INSERT INTO CW1.Trail_Location (geographical_id, location_name, country, state, city) VALUES
    (1, 'Plymbridge Circular', 'England', 'Devon', 'Plymouth'),
    (2, 'Plymouth Waterfront and Plymouth Hoe Circular', 'England', 'Devon', 'Plymouth');

INSERT INTO CW1.Trail (location_id, user_id, estimated_time_min, estimated_time_max, route_type, difficulty, trail_name, elevation_gain, length) VALUES 
    (1,1, '01:30:00', '02:00:00', 'Loop', 'Easy', 'Plymbridge Circular', 147, 5.00),
    (2,2, '01:00:00', '01:30:00', 'Loop', 'Easy', 'Plymouth Waterfront and Plymouth Hoe Circular', 83, 4.80);

INSERT INTO CW1.Sights (top_sight_name) VALUES
    ('River Plym'),
    ('Officers Quaters & Mess'),
    ('Great Store'),
    ('The Mayflower Steps'),
    ('List of Pilgrims who left Plymouth on the Mayflower'),
    ('The Belvedere'),
    ('Custom House');

INSERT INTO CW1.Trail_Sights (sights_id, trail_id) VALUES
    (1, 1),
    (2, 2),
    (3, 2),
    (4, 2),
    (5, 2),
    (6, 2),
    (7, 2);

INSERT INTO CW1.Rating (user_id, trail_id, review_text, star_rating) VALUES
    (1, 1, 'Nice place and quite an easy trail. Recommended for beginners.', 4),
    (1, 2, 'Beautiful sceneries, great place to take a morning hike. Fun family place!', 5),
    (3, 1, 'Love this place! Not really steep, quite shady.', 5);

/*5. SELECTING TABLES WITH DATA*/
SELECT * FROM CW1.Users;
SELECT * FROM CW1.Geographical_Info;
SELECT * FROM CW1.[Trail_Location];
SELECT * FROM CW1.Trail;
SELECT * FROM CW1.Sights;
SELECT * FROM CW1.Trail_Sights;
SELECT * FROM CW1.Rating;
SELECT * FROM CW1.Users WHERE user_name LIKE 'A%'; 
SELECT * FROM CW1.Rating WHERE star_rating = 5;
SELECT * FROM CW1.Sights ORDER BY top_sight_name ASC;

/*6. CREATING VIEW*/
CREATE VIEW CW1.TrailCreatedBy AS
SELECT 
    CW1.Trail.trail_name,
    CW1.Trail_Location.location_name,
    CW1.Users.user_name
FROM CW1.Trail
JOIN CW1.Trail_Location
    ON CW1.Trail.location_id = CW1.Trail_Location.location_id
JOIN CW1.Users  
    ON CW1.Trail.user_id = CW1.Users.user_id;

SELECT * FROM CW1.TrailCreatedBy;

CREATE VIEW CW1.SpecificTrailLocationInfo AS
SELECT 
    CW1.Trail.trail_name,
    CW1.Geographical_Info.trail_latitude,
    CW1.Geographical_Info.trail_longitude,
    CW1.Trail_Location.country,
    CW1.Trail_Location.state,
    CW1.Trail_Location.city,
    CW1.Sights.top_sight_name
FROM CW1.Trail
JOIN CW1.Trail_Location
    ON CW1.Trail.location_id = CW1.Trail_Location.location_id
JOIN CW1.Geographical_Info
    ON CW1.Trail_Location.geographical_id = CW1.Geographical_Info.geographical_id
JOIN CW1.Trail_Sights
    ON CW1.Trail.trail_id = CW1.Trail_Sights.trail_id
JOIN CW1.Sights
    ON CW1.Trail_Sights.sights_id = CW1.Sights.sights_id;

SELECT * FROM CW1.SpecificTrailLocationInfo;

/*7. CRUD Methods*/
/*CREATE*/
CREATE PROCEDURE CW1.InsertSight
    @top_sight_name VARCHAR(100)
AS
BEGIN
    INSERT INTO CW1.Sights (top_sight_name) VALUES
    (@top_sight_name);

    SELECT SCOPE_IDENTITY() AS new_sight_id;
END;


/*READ*/
CREATE Procedure CW1.RetrieveSightThroughID
    @sights_id INT
AS
BEGIN
    SELECT * FROM CW1.Sights
    WHERE sights_id = @sights_id;
END;


/*UPDATE*/
CREATE PROCEDURE CW1.UpdateSights
    @sights_id INT,
    @top_sight_name VARCHAR(100)
AS
BEGIN
    UPDATE CW1.Sights
    SET top_sight_name = @top_sight_name
    WHERE sights_id = @sights_id;
END;


/*DELETE*/
CREATE PROCEDURE CW1.DeleteSights
    @sights_id INT
AS
BEGIN
    DELETE FROM CW1.Sights
    WHERE sights_id = @sights_id;
END;

/*Functionality Testing*/
SELECT * FROM CW1.Sights;

EXEC CW1.InsertSight @top_sight_name = 'The Ride';
SELECT * FROM CW1.Sights;

EXEC CW1.RetrieveSightThroughID @sights_id = 1;
EXEC CW1.RetrieveSightThroughID @sights_id = 1002;

SELECT * FROM CW1.Sights WHERE sights_id= 1;
EXEC CW1.UpdateSights
    @sights_id = 1,
    @top_sight_name = 'The Ampitheatre';

SELECT * FROM CW1.Sights WHERE sights_id= 1;

EXEC CW1.DeleteSights
    @sights_id = 1;

SELECT * FROM CW1.Sights;

/*TRIGGER: CREATE LOG TABLE AND TRIGGER*/
CREATE TABLE CW1.TrailAdded_Log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    trail_id INT NOT NULL,
    user_id INT NOT NULL,
    trail_name VARCHAR(100) NOT NULL,
    datetime_added DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (trail_id) REFERENCES CW1.Trail(trail_id),
    FOREIGN KEY (user_id) REFERENCES CW1.Users(user_id)
);

CREATE TRIGGER CW1.LogNewAddedTrail
ON CW1.Trail
AFTER INSERT
AS
BEGIN
    INSERT INTO CW1.TrailAdded_Log (trail_id, user_id, trail_name)
    SELECT
        INSERTED.trail_id,
        INSERTED.user_id,
        INSERTED.trail_name
    FROM INSERTED;
END;


/*TRIGGER TESTING*/

INSERT INTO CW1.Trail (
    location_id, user_id, estimated_time_min, estimated_time_max, 
    route_type, difficulty, trail_name, elevation_gain, length)
VALUES (
    2,
    2,
    '02:00:00',
    '02:30:00',
    'Loop',
    'Moderate',
    'Plymbridge Woods',
    222,
    7.70
);

INSERT INTO CW1.Trail (
    location_id, user_id, estimated_time_min, estimated_time_max, 
    route_type, difficulty, trail_name, elevation_gain, length)
VALUES (
    1,
    3,
    '00:30:00',
    '01:00:00',
    'Loop',
    'Easy',
    'Plymbridge Old Canal and River Walk',
    65,
    2.70
);

SELECT * FROM CW1.TrailAdded_Log;