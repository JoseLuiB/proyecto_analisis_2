-- CREACION DE LA BASE DE DATOS
-- CREATION OF THE DATABASE
CREATE DATABASE ProyectBoots;

-- CREACION DE LA TABLA boots
-- CREATION OF THE boots TABLE
CREATE TABLE boots
(RecordID int primary key,
BootsName varchar(50),
BootsMaterial varchar(50),
BootsBrand varchar(50),
BootsPack varchar(50),
BootsType varchar(50),
BootsPosition varchar(50),
BootsTopPlayers varchar(50)
);

-- CREACION DE LA TABLA players
-- CREATION OF THE players TABLE
CREATE TABLE players
(RecordID int primary key,
ClubName varchar(50),
LeagueCountry varchar(50),
PlayerName varchar(50),
PlayerPosition varchar(50),
PlayerNationality varchar(50),
PlayerMarketValue int
);

-- 1 ¿Qué país tiene la mayor cantidad de registros?
-- 1 Which country has the most records?

SELECT PlayerNationality as Country, COUNT(PlayerNationality) as QuantityCountry
FROM players
WHERE PlayerNationality IS NOT NULL
GROUP BY PlayerNationality
ORDER BY QuantityCountry DESC;

-- 2 ¿Cuál es la marca de botas más común utilizada?
-- 2 What is the most common brand of boots used?

-- SELECT BootsBrand, COUNT(BootsBrand) as QualityBrand
-- FROM boots
-- GROUP BY BootsBrand;

SELECT BootsBrand, QuantityBrand, (QuantityBrand/(SELECT COUNT(RecordID) FROM boots))*100 as MostUsedBrandPercent
FROM (SELECT BootsBrand, COUNT(BootsBrand) as QuantityBrand, COUNT(RecordID)
	FROM boots
	GROUP BY BootsBrand) as SubQuery1
ORDER BY MostUsedBrandPercent DESC;

-- 3 ¿Qué posición de jugador tiene la mayor cantidad de registros?
-- 3 Which player position has the most records?

-- SELECT PlayerPosition, COUNT(PlayerPosition) as QuantityPlayersPosition
-- FROM players
-- GROUP BY PlayerPosition
-- ORDER BY QuantityPlayersPosition DESC;

SELECT *, (QuantityPlayersPosition/(SELECT COUNT(RecordID) FROM players)*100) as MostPlayerPositionPercent
FROM (SELECT PlayerPosition, COUNT(PlayerPosition) as QuantityPlayersPosition
	FROM players
	GROUP BY PlayerPosition
	ORDER BY QuantityPlayersPosition DESC) as SubQuery2;

-- 4 ¿Cuál es el valor de mercado promedio de los jugadores?
-- 4 What is the average market value of the players?

SELECT AVG(PlayerMarketValue) as 'AvgPlayersMarketValue(MillionsEuros)'
FROM players;

-- 5 ¿Qué tipo de botas es el más popular entre los jugadores de fútbol?
-- 5 What kind of boots is the most popular among soccer players?

-- SELECT BootsType, COUNT(BootsType) as QualityByBootsType
-- FROM boots
-- WHERE BootsType IS NOT NULL
-- GROUP BY BootsType
-- ORDER BY QualityByBootsType DESC;

SELECT *, (QuantityBootsType/(SELECT COUNT(RecordID) FROM boots WHERE BootsType IS NOT NULL))*100 as MostUsedBootsTypePercent
FROM (SELECT BootsType, COUNT(BootsType) as QuantityBootsType
	FROM boots
	WHERE BootsType IS NOT NULL
	GROUP BY BootsType
	ORDER BY QuantityBootsType DESC) as SubQuery3;

-- 6 ¿Cuál es el pack de botas más utilizado?
-- 6 What is the most used pack of boots?

-- SELECT BootsPack, COUNT(BootsPack) as QualityBootsPack
-- FROM boots
-- WHERE BootsPack IS NOT NULL
-- GROUP BY BootsPack
-- ORDER BY QualityBootsPack DESC;

SELECT *, (QualityBootsPack/(SELECT COUNT(RecordID) FROM boots WHERE BootsPack IS NOT NULL))*100 as MostUsedBootsPackPercent
FROM (SELECT BootsPack, COUNT(BootsPack) as QualityBootsPack
	FROM boots
	WHERE BootsPack IS NOT NULL
	GROUP BY BootsPack
	ORDER BY QualityBootsPack DESC) as SubQuery4;

-- 7 ¿Cuál es la posición de la bota más común?
-- 7 What is the most common boot position?

-- SELECT BootsPosition, COUNT(BootsType) as QualityBootsPosition
-- FROM boots
-- WHERE BootsPosition IS NOT NULL
-- GROUP BY BootsPosition;

SELECT *, (QualityBootsPosition/(SELECT COUNT(RecordID) FROM boots WHERE BootsPosition IS NOT NULL)*100) as  MostUsedBootsPositionPercent
FROM (SELECT BootsPosition, COUNT(BootsType) as QualityBootsPosition
	FROM boots
	WHERE BootsPosition IS NOT NULL
	GROUP BY BootsPosition) as SubQuery5;
    
-- 8 ¿Qué jugador está asociado con la mayoría de las botas?
-- 8 Which player is associated with the most boots?

-- SELECT BootsTopPlayers as BootsTopPlayer, COUNT(BootsTopPlayers) as QualityBootsTopPlayer
-- FROM boots
-- GROUP BY BootsTopPlayer
-- ORDER BY QualityBootsTopPlayer DESC;

SELECT *, (QualityBootsTopPlayer/(SELECT COUNT(RecordID) FROM boots))*100 as MostUsedBootsTopPlayerPercent
FROM (SELECT BootsTopPlayers as BootsTopPlayer, COUNT(BootsTopPlayers) as QualityBootsTopPlayer
	FROM boots
	GROUP BY BootsTopPlayer
	ORDER BY QualityBootsTopPlayer DESC) as SubQuery6;
    
-- 9 ¿Cómo varía el valor de mercado de los jugadores entre las diferentes posiciones y nacionalidades de los jugadores?
-- 9 How does the market value of players vary between different player positions and nationalities?

SELECT PlayerPosition, PlayerNationality, COUNT(RecordID) as QuantityPlayers, MIN(PlayerMarketValue) as MinMarketValue, AVG(PlayerMarketValue) as AvgMarketValue, MAX(PlayerMarketValue) as MaxMarketValue
FROM players
WHERE PlayerNationality IS NOT NULL
GROUP BY PlayerPosition, PlayerNationality
ORDER BY AvgMarketValue DESC;

-- 10 ¿Cuál es la distribución de las nacionalidades de los jugadores en la Premier League?
-- 10 What is the distribution of player nationalities in the Premier League?

SELECT PlayerNationality, COUNT(PlayerNationality) as QuantityPlayersPremierLeague
FROM players
WHERE (PlayerNationality IS NOT NULL) and (LeagueCountry = 'Premier League')
GROUP BY PlayerNationality
ORDER BY QuantityPlayersPremierLeague DESC;

-- 11 ¿Cual es el top 10 jugadores con mayor valor de mercado y que botas usan?
-- 11 What is the top 10 players with the highest market value and what boots do they use?

SELECT ROW_NUMBER() OVER(ORDER BY p.PlayerMarketValue DESC) as Ranking, p.PlayerName, p.ClubName, p.PlayerNationality, p.PlayerPosition, p.PlayerMarketValue, b.BootsBrand, b.BootsName, b.BootsMaterial, b.BootsType, b.BootsPosition  
FROM players as p
	JOIN boots as b ON p.RecordID = b.RecordID
ORDER BY p.PlayerMarketValue DESC
LIMIT 10;

-- 12 ¿Cuál es el material de las botas más común utilizado?
-- 12 What is the most common boot material used?

-- SELECT BootsMaterial, COUNT(BootsMaterial) as QuantityBootsMaterial
-- FROM boots
-- WHERE BootsMaterial IS NOT NULL
-- GROUP BY BootsMaterial
-- ORDER BY QuantityBootsMaterial DESC;

SELECT *, (QuantityBootsMaterial/(SELECT COUNT(RecordID) FROM boots WHERE BootsMaterial IS NOT NULL))*100 as PercentageBootsMaterial
FROM (SELECT BootsMaterial, COUNT(BootsMaterial) as QuantityBootsMaterial
	FROM boots
	WHERE BootsMaterial IS NOT NULL
	GROUP BY BootsMaterial
	ORDER BY QuantityBootsMaterial DESC) as SubQuery7;
    
-- 13 ¿Qué posición está asociada con el valor de mercado más alto?
-- 13 Which position is associated with the highest market value?

SELECT PlayerPosition, COUNT(RecordID) as QuantityPosition, AVG(PlayerMarketValue) as AvgValuePerPosition
FROM players
GROUP BY PlayerPosition
ORDER BY AvgValuePerPosition DESC;

-- 14 ¿Cuales son las botas más populares en las 5 ligas principales?
-- 14 What are the most popular boots in the top 5 leagues?

SELECT
CASE
	WHEN LeagueCountry = 'Premier League' THEN 1
    WHEN LeagueCountry = 'La Liga' THEN 2
    WHEN LeagueCountry = 'Bundesliga' THEN 3
    WHEN LeagueCountry = 'Serie A' THEN 4
    ELSE 5
END as RankingLeague, p.LeagueCountry, b.BootsBrand, COUNT(BootsBrand) as QuantityBrand, b.BootsTopPlayers
FROM boots as b
	JOIN players as p ON b.RecordID = p.RecordID
WHERE (BootsType IS NOT NULL) AND (LeagueCountry in ('Premier League', 'La Liga', 'Bundesliga', 'Serie A', 'Ligue 1'))
GROUP BY BootsBrand, LeagueCountry
ORDER BY 1, 4 DESC;

-- 15 ¿Cuáles son las botas más utilizadas por marca?
-- 15 Which are the most used boots by brand?

SELECT BootsBrand, BootsName, COALESCE(BootsType, "Other") as BootsType, COUNT(BootsName) as QuantityBoots
FROM boots
GROUP BY BootsName
ORDER BY QuantityBoots DESC;

-- Pregunta planteada por el lider de ventas de la empresa: 
-- ¿Cuáles son las marcas y modelos de botas de fútbol más populares entre los jugadores de las principales ligas del mundo?
-- Question posed by the sales leader of the company: 
-- What are the brands and models of soccer boots most popular among the players of the main leagues in the world?

SELECT p.RecordID, b.BootsBrand, b.BootsName, b.BootsTopPlayers, p.LeagueCountry
FROM boots as b
JOIN players as p ON b.RecordID = p.RecordID
WHERE p.LeagueCountry in ('Premier League', 'La Liga', 'Bundesliga', 'Serie A', 'Ligue 1');