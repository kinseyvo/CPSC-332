-- CPSC 332 Project Queries

SELECT * FROM Country; -- Continent, Region, SurfaceArea, IndepYear, Population, LifeExpectancy, GNP, GNPOld, Local Name, GovernmentForm, HeadOfState, Capital, Code2
SELECT * FROM City; -- ID, Name, CountryCode, District, Population
SELECT * FROM CountryLanguage; -- CountryCode, Language, IsOfficial, Percentage
SELECT * FROM WorldHappiness; -- CountryName, Region, WorldRank, HappinessScore, Economy, Family, Health, Freedom, Trust, Generosity, DystopiaResidual, CountryCode
SELECT * FROM Firepower; -- Country, CountryCode, ActivePersonnel, Aircraft, ArmoredVehicles, Helicopters, NavyShips, Tanks, ReservePersonnel, RocketProjectors
SELECT * FROM Passwords; -- CountryCode, CountryName, CountryRank, PasswordText, UserCount, TimeToCrackInSeconds, GlobalRank, CountryISO

-- ===== BASIC QUERIES =====
-- 1. How many users in the US have bad passwords?
SELECT SUM(Passwords.UserCount)
FROM Passwords
WHERE Passwords.CountryISO = "USA" AND Passwords.TimeToCrackInSeconds < 10;

-- 2. View only CountryName, PasswordText, and UserCount from the passwords table to eliminate other distracting attributes and focus only on these three
SELECT Passwords.CountryName, Passwords.PasswordText, Passwords.UserCount
FROM Passwords;

-- 3. Display Happiness Score for different countries
SELECT WorldHappiness.HappinessScore, WorldHappiness.CountryName
FROM WorldHappiness;

-- 4. Display Password Security in differen countries
SELECT CountryName, PasswordText, UserCount, TimeToCrackInSecond
FROM Passwords;

-- 5. What is the average WorldHappiness Score?
SELECT AVG(WorldHappiness.HappinessScore)
FROM WorldHappiness;

-- 6. Combine the populations of each city and show the country code and its population
SELECT City.CountryCode, SUM(City.Population) AS 'CountryPopulation'
FROM City 
GROUP BY City.CountryCode;

-- 7. How many cities are in each country, based off of the city database
SELECT City.CountryCode, COUNT(City.Name)
FROM City
GROUP BY City.CountryCode;

-- 8. What passwords are common in different countries?
SELECT Passwords.PasswordText, COUNT(Passwords.CountryISO) AS "#OfCountries"
FROM Passwords
GROUP BY Passwords.PasswordText
ORDER BY COUNT(Passwords.CountryISO) DESC;

-- 9. Which country has the most active personnel?
SELECT Firepower.CountryCode, Firepower.Tanks
FROM Firepower
ORDER BY Firepower.Tanks DESC;

-- ===== JOIN QUERIES =====
-- 1.  
SELECT firepower.Country, firepower.CountryCode, firepower.ActivePersonnel, Country.population, Country.SurfaceArea, WorldHappiness.HappinessScore
FROM (Country NATURAL JOIN Firepower) NATURAL JOIN WorldHappiness
WHERE Country.Code = Firepower.CountryCode = WorldHappiness.CountryCode;

-- 2.
SELECT Country.Code, Country.Name, CountryLanguage.Language, CountryLanguage.Percentage
FROM Country
INNER JOIN CountryLanguage
ON Country.Code = CountryLanguage.CountryCode;

-- 3. 
SELECT Code, Country.Region, SurfaceArea, Population, HappinessScore, DystopiaResidual, 
ActivePersonnel, RocketProjectors
FROM WorldHappiness 
JOIN Country ON Code = CountryCode
JOIN Firepower ON Country = Name
WHERE WorldHappiness.Region = Country.Region;

-- 4. General query: Full join of WorldHappiness and Country
SELECT * FROM WorldHappiness
LEFT JOIN Country ON WorldHappiness.CountryCode = Country.Code
UNION
SELECT * FROM WorldHappiness
RIGHT JOIN Country ON WorldHappiness.CountryCode = Country.Code;

-- 5. Compare GNP to HappinessScores to see if there is obvious trend
SELECT WorldHappiness.CountryName, WorldHappiness.HappinessScore, Country.GNP
FROM WorldHappiness NATURAL JOIN Country
WHERE WorldHappiness.CountryCode = Country.Code
ORDER BY WorldHappiness.HappinessScore DESC LIMIT 20;

-- 6. Compare GNP to HappinessScores to see if there is obvious trend
SELECT WorldHappiness.CountryName, WorldHappiness.HappinessScore, Country.GNP
FROM WorldHappiness NATURAL JOIN Country
WHERE WorldHappiness.CountryCode = Country.Code
ORDER BY Country.GNP DESC;

-- ===== SUBQUERIES =====
-- 1. What countries have life expectancies greater than the average?
SELECT Country.Name, Country.LifeExpectancy
FROM Country
WHERE Country.LifeExpectancy > 
	(SELECT AVG(Country.LifeExpectancy) FROM Country)
ORDER BY Country.LifeExpectancy DESC;


-- 2. Is there a relationship between a country’s amount of firepower and happiness score?
SELECT Firepower.Country, Country.Population, Firepower.ActivePersonnel, Firepower.Aircraft, Firepower.ArmoredVehicles, Firepower.Helicopters, Firepower.NavyShips, Firepower.Tanks, Firepower.ReservePersonnel, Firepower.RocketProjectors, WorldHappiness.HappinessScore
FROM country
INNER JOIN Firepower ON Firepower.CountryCode = Country.Code
INNER JOIN WorldHappiness ON WorldHappiness.CountryCode = Country.Code
WHERE WorldHappiness.HappinessScore > 
	(SELECT AVG(WorldHappiness.HappinessScore) FROM WorldHappiness)
ORDER BY WorldHappiness.HappinessScore DESC;

-- 3.  For countries with happiness scores greater than the average, what are the languages spoken and in how many countries?
SELECT y.Language, COUNT(y.language) AS "#OfCountriesSpokenIn"
FROM
(SELECT WorldHappiness.CountryCode, WorldHappiness.CountryName, WorldHappiness.HappinessScore
FROM WorldHappiness 
WHERE WorldHappiness.HappinessScore > 
(SELECT AVG(WorldHappiness.HappinessScore) FROM WorldHappiness)) AS x
INNER JOIN
(SELECT CountryLanguage.CountryCode, CountryLanguage.Language
FROM CountryLanguage) AS y
ON x.CountryCode = y.CountryCode
GROUP BY y.Language 
ORDER BY COUNT(y.language) DESC;

-- 4. Show data for countries without info in the firepower table
SELECT * FROM WorldHappiness
WHERE WorldHappiness.CountryCode NOT IN (SELECT Firepower.CountryCode FROM Firepower);

-- 5. Show cities with populations that make up 50% or more of their country's population
SELECT y.CountryCode, y.Name AS "City Name", y.Population AS "Cities that make up 50%+ of the Country's Population"
FROM
(SELECT City.CountryCode, SUM(City.Population) AS 'CountryPopulation'
FROM City
GROUP BY City.CountryCode) AS x
INNER JOIN
(SELECT City.CountryCode, City.Name, City.Population
FROM City) AS y
WHERE y.CountryCode = x.CountryCode AND y.Population > x.CountryPopulation / 2;

