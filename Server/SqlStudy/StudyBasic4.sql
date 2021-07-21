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

-- SubQuery (����/���� ����)
-- SQL ��ɹ� �ȿ� ���� �Ϻ� SELECT

-- ������ ��������� ���� ������ ������ ����

--SELECT TOP 1 *
--FROM salaries
--ORDER BY salary DESC;

--SELECT *
--FROM players
--WHERE playerID = 'rodrial01'

---- ������ ��������
--SELECT *
--FROM players
--WHERE playerID = (SELECT TOP 1 playerID FROM salaries ORDER BY salary DESC)


-- ������ ��������
-- IN�� ����ϸ� �ߺ������ؼ� ������
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

-- ��� ���� ��������
-- EXISTS, NOT EXIST

-- ����Ʈ ���� Ÿ�ݿ� ������ ������ ���

--SELECT *
--FROM players
--WHERE playerID IN (SELECT playerID FROm battingpost)


---- �����Ͱ� �����ϸ� �����ϰ� �ƴϸ� ��ŵ�Ѵ�.
--SELECT *
--FROM players
--WHERE EXISTS (SELECT playerID FROM battingpost WHERE battingpost.playerID = players.playerID)