USE BaseballData;

-- INSERT DELETE UPDATE

--SELECT *
--FROM salaries
--ORDER BY yearID DESC


--INSERT INTO salaries
--VALUES (2020, 'KOR', 'NL', 'kai3', 9000000)

--INSERT INTO salaries(yearID, teamID, playerID, lgID)
--VALUES (2020, 'KOR', 'kai3', 'NL')

--DELETE FROM salaries
--WHERE playerID = 'kai3'

--UPDATE salaries
--SET salary = salary * 2, yearID = yearID + 1
--WHERE teamID = 'KOR'

--SELECT *
--FROM salaries
--ORDER BY yearID DESC

--DELETE FROM salaries
--WHERE yearID >= 2020

--SELECT * FROM salaries
--ORDER BY yearID DESC

-- SubQuery (서브/하위 쿼리)
-- SQL 명령문 안에 들어가는 하부 SELECT

-- 연봉이 역대급으로 높은 선수의 정보를 추출

--SELECT TOP 1 *
--FROM salaries
--ORDER BY salary DESC;

--SELECT *
--FROM players
--WHERE playerID = 'rodrial01'

---- 단일행 서브쿼리
--SELECT *
--FROM players
--WHERE playerID = (SELECT TOP 1 playerID FROM salaries ORDER BY salary DESC)


-- 다중행 서브쿼리
-- IN을 사용하면 중복제거해서 돌려줌
--SELECT *
--FROM players
--WHERE playerID IN (SELECT TOP 20 playerID FROM salaries ORDER BY salary DESC)


--SELECT (SELECT COUNT(*) FROM players) AS playerCount, (SELECT COUNT(*) FROM batting) AS battingCount

--SELECT *
--FROM salaries_temp
--ORDER BY yearID DESC

----INSERT INTO salaries
----VALUES (2020, 'KOR', 'NL', 'KAI', (SELECT MAX(salary) FROM salaries))

----INSERT INTO salaries
----SELECT 2020, 'KOR', 'NL', 'KAI2', (SELECT MAX(salary) FROM salaries)


---- INSERT SELECT
--INSERT INTO salaries_temp
--SELECT yearID, playerID, salary FROM salaries

--DROP TABLE salaries_temp

-- 상관 관계 서브쿼리
-- EXISTS, NOT EXIST

-- 포스트 시즌 타격에 참여한 선수들 목록

--SELECT *
--FROM players
--WHERE playerID IN (SELECT playerID FROm battingpost)


---- 데이터가 존재하면 실행하고 아니면 스킵한다.
--SELECT *
--FROM players
--WHERE EXISTS (SELECT playerID FROM battingpost WHERE battingpost.playerID = players.playerID)