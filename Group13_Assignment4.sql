-- 1.
SELECT Fname, Lname, Country
FROM PARTICIPANT P, ATHLETE A
WHERE P.OlympicID=A.OlympicID;


-- 2.
SELECT Fname, Lname, Country
FROM PARTICIPANT P, COACH C
WHERE P.OlympicID=C.OlympicID AND Orientation="Pending";


-- 3.
SELECT Country, COUNT(*)
FROM PARTICIPANT P, ATHLETE A, COUNTRY
WHERE P.OlympicID=A.OlympicID AND CName=Country
GROUP BY Country;


-- 4.
SELECT P.OlympicID, BirthYear
FROM ((PARTICIPANT P LEFT OUTER JOIN 
       ATHLETE A ON P.OlympicID=A.OlympicID) LEFT OUTER JOIN 
       COACH C ON P.OlympicID=C.OlympicID)
ORDER BY BirthYear ASC;


-- 5.
SELECT Country
FROM PARTICIPANT P, ATHLETE A, COUNTRY
WHERE P.OlympicID=A.OlympicID AND CName=Country
GROUP BY Country
HAVING COUNT(*) > 1;


-- 6. 
(SELECT Fname, Lname
FROM (PARTICIPANT NATURAL JOIN ATHLETE), INDIVIDUAL_RESULTS R
WHERE R.Olympian=OlympicID)
UNION DISTINCT
(SELECT Fname, Lname
FROM (PARTICIPANT NATURAL JOIN ATHLETE), 
     (TEAM JOIN TEAM_RESULTS ON Team=TeamID)
WHERE OlympicID IN (Member1, Member2, Member3, Member4, Member5, Member6));


-- 7.
SELECT CName
FROM COUNTRY
WHERE (AllTimeGold+AllTimeSilver+AllTimeBronze)>=5;


-- 8.
SELECT Country, COUNT(*)
FROM ((SELECT Country
      FROM (PARTICIPANT JOIN INDIVIDUAL_RESULTS ON OlympicID=Olympian))
      UNION ALL
      (SELECT Country
      FROM (TEAM JOIN 
            TEAM_RESULTS ON Team=TeamID) JOIN 
            PARTICIPANT ON OlympicID=Member1)
     ) AS ALL_RESULTS
GROUP BY Country;


-- 9.
SELECT Fname, Lname
FROM (PARTICIPANT NATURAL JOIN ATHLETE)
WHERE FirstGames="Tokyo 2020";


-- 10.
(SELECT Fname, Lname, BirthYear
FROM (PARTICIPANT NATURAL JOIN ATHLETE)
WHERE BirthYear=(SELECT MAX(BirthYear) FROM ATHLETE))
UNION ALL
(SELECT Fname, Lname, BirthYear
FROM (PARTICIPANT NATURAL JOIN ATHLETE)
WHERE BirthYear=(SELECT MIN(BirthYear) FROM ATHLETE));


-- 11.
DROP VIEW IF EXISTS TEAM_ATHLETES;
CREATE VIEW TEAM_ATHLETES
AS SELECT Fname, Lname, BirthYear
   FROM (PARTICIPANT NATURAL JOIN ATHLETE)
   ORDER BY BirthYear DESC;

SELECT *
FROM TEAM_ATHLETES;


-- 12.
DROP TABLE IF EXISTS INDIVID_W;
CREATE TABLE INDIVID_W (
  EventDate VARCHAR(15) NOT NULL,
  Location VARCHAR(30) NOT NULL,
  Lname VARCHAR(25) NOT NULL,
  Country VARCHAR(30) NOT NULL,
  PRIMARY KEY (Lname),
  FOREIGN KEY (Country) REFERENCES COUNTRY(CName)
);

INSERT INTO INDIVID_W(EventDate, Location, Lname, Country)
  SELECT EventDate, Location, Lname, Country
  FROM EVENT_SCHEDULE, (PARTICIPANT NATURAL JOIN ATHLETE)
  WHERE EventDate='July 30' AND Sex='F';

SELECT *
FROM INDIVID_W;

-- Q13 :
-- This INSERT will fail because 'T2020_046' does not exist in the
-- PARTICIPANT table. COACH.OlympicID is a foreign key referencing
-- PARTICIPANT(OlympicID), so inserting a coach with an unknown ID
-- violates referential integrity.

-- Q14:
-- This DELETE will fail because OlympicID 'T2020_001' is referenced by
-- other tables (ATHLETE, TEAM, INDIVIDUAL_RESULTS). Since there is no
-- ON DELETE CASCADE, the database prevents the deletion to maintain
-- referential integrity.

-- Q15:
-- A possible constraint for the TEAM table would be to ensure that all
-- members of a team come from the same country. This requires checking
-- the PARTICIPANT table, because that's where each member's Country is
-- stored.


