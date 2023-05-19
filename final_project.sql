USE world;

-- create relation between City and Country by Country Code
ALTER TABLE City ADD CONSTRAINT FOREIGN KEY (CountryCode) REFERENCES Country(Code);

-- create relation between CountryLanguage and Country by Country Code
ALTER TABLE CountryLanguage ADD CONSTRAINT FOREIGN KEY (CountryCode) REFERENCES Country(Code); 


-- WorldHappiness table
CREATE TABLE WorldHappiness(
	CountryName CHAR(35) NOT NULL DEFAULT '',
	Region CHAR(50) NOT NULL DEFAULT '',
	WorldRank INT NOT NULL DEFAULT 0,
	HappinessScore FLOAT(4,3) NOT NULL DEFAULT 0,
	Economy FLOAT(5,4) NOT NULL DEFAULT 0,
	Family FLOAT(5,4) NOT NULL DEFAULT 0,
	Health FLOAT(5,4) NOT NULL DEFAULT 0,
	Freedom FLOAT(5,4) NOT NULL DEFAULT 0,
	Trust FLOAT(5,4) NOT NULL DEFAULT 0,
	Generosity FLOAT(5,4) NOT NULL DEFAULT 0,
	DystopiaResidual FLOAT(5,4) NOT NULL DEFAULT 0,
	PRIMARY KEY (CountryName)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- add country code depend on name
ALTER TABLE WorldHappiness ADD CountryCode CHAR(3);
UPDATE WorldHappiness AS w
INNER JOIN Country AS c ON w.CountryName = c.Name 
SET w.CountryCode = c.Code;

-- trim the region not in country table
DELETE
FROM
	WorldHappiness
WHERE
	CountryCode IS NULL;

-- construct relation to country
ALTER TABLE WorldHappiness ADD CONSTRAINT FOREIGN KEY (CountryCode) REFERENCES Country(Code);

-- create Firepower table
CREATE TABLE Firepower (
	Country CHAR(35) NOT NULL DEFAULT '',
	CountryCode CHAR(3) NOT NULL DEFAULT '',
	ActivePersonnel INT NOT NULL DEFAULT 0,
	Aircraft INT NOT NULL DEFAULT 0,
	ArmoredVehicles INT NOT NULL DEFAULT 0,
	Helicopters INT NOT NULL DEFAULT 0,
	NavyShips INT NOT NULL DEFAULT 0,
	Tanks INT NOT NULL DEFAULT 0,
	ReservePersonnel INT NOT NULL DEFAULT 0,
	RocketProjectors INT NOT NULL DEFAULT 0,
	PRIMARY KEY (CountryCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- trim the records not in our country list
DELETE
FROM
	Firepower f
WHERE
	CountryCode NOT IN (SELECT c.Code FROM Country c);

-- add relation between firepower and country
ALTER TABLE Firepower ADD CONSTRAINT FOREIGN KEY (CountryCode) REFERENCES Country(Code);

-- create Passwords table( top 200 most popular passwords in each country)
DROP TABLE IF EXISTS Passwords;
CREATE TABLE Passwords (
	CountryCode CHAR(2) NOT NULL DEFAULT '',
	CountryName CHAR(35) NOT NULL DEFAULT '',
	CountryRank INT NOT NULL DEFAULT 0,
	PasswordText VARCHAR(100) NOT NULL DEFAULT '',
	UserCount INT NOT NULL DEFAULT 0,
	TimeToCrackInSeconds BIGINT NOT NULL DEFAULT 0,
	GlobalRank INT DEFAULT NULL,
	PRIMARY KEY (CountryCode,CountryRank)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- change country code to upper case 
UPDATE Passwords SET CountryCode = UPPER(CountryCode); 

-- add a standard ISO code column for each country in password table
ALTER TABLE Passwords ADD CountryISO CHAR(3);

-- update country ISO code in Passwords table by match the two letter country code
UPDATE Passwords AS p
INNER JOIN Country AS c ON p.CountryCode = c.Code2  
SET p.CountryISO = c.Code;

-- create relation between passwords and country table
ALTER TABLE Passwords ADD CONSTRAINT FOREIGN KEY (CountryISO) REFERENCES Country(Code);


