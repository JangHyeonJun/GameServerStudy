USE BaseballData;

--SELECT *,
--	CASE birthMonth
--		WHEN 1 THEN N'�ܿ�'
--		WHEN 2 THEN N'�ܿ�'
--		WHEN 3 THEN N'��'
--		WHEN 4 THEN N'��'
--		WHEN 5 THEN N'��'
--		WHEN 6 THEN N'����'
--		WHEN 7 THEN N'����'
--		WHEN 8 THEN N'����'
--		WHEN 9 THEN N'����'
--		WHEN 10 THEN N'����'
--		WHEN 11 THEN N'����'
--		WHEN 12 THEN N'�ܿ�'
--		ELSE N'��' -- ELSE�� �ۼ����� ������ NULL�� ��
--	END As birthSeason
--FROM players;

--SELECT *,
--	CASE 
--		WHEN birthMonth <= 2 THEN N'�ܿ�'
--		WHEN birthMonth <= 5 THEN N'��'
--		WHEN birthMonth <= 8 THEN N'����'
--		WHEN birthMonth <= 11 THEN N'����'
--		ELSE N'�ܿ�'
--	END As birthSeason
--FROM players;

-- COUNT
--SUM
--AVG
--MIN
--MAX

--SELECT COUNT(*)
--FROM players;

--SELECT COUNT(birthYear) -- ���� �Լ����� NULL�� ī���� ���� �ʴ´�.
--FROM players;

--SELECT DISTINCT birthCity
--FROM players;

--SELECT DISTINCT birthYear, birthMonth, birthDay -- 3���� ��� �޶�� �ٸ� ������ ���
--FROM players
--ORDER BY birthYear

---- �����Լ�(DISTINCT ����)
--SELECT COUNT(DISTINCT birthCity)
--FROM players;

-- �������� ��� weight 
-- ��, weight == NULL �̸� weight = 0
--SELECT AVG(CASE WHEN weight IS NULL THEN 0 ELSE weight END) -- NULL �� ��쵵 �����Լ��� 0���� ����ؼ� ����ϵ��� �ϴ� ����
--FROM players

--SELECT SUM(weight) / COUNT(weight)
--FROM players

--SELECT MIN(weight), MAX(weight) -- ���ڿ����� ��� ����
--FROM players

--SELECT *
--FROM batting
--WHERE teamID = 'BOS'

--SELECT COUNT(DISTINCT playerID)
--FROM batting
--WHERE teamID = 'BOS'

--SELECT SUM(HR)
--FROM batting
--WHERE teamID = 'BOS' AND yearID = 2004

--SELECT TOP 1 *
--FROM batting
--WHERE teamID = 'BOS'
--ORDER BY HR DESC

--SELECT *
--FROM batting
--WHERE HR = (SELECT MAX(HR)
--			FROM batting
--			WHERE teamID = 'BOS') AND teamID = 'BOS'

---- 2004�⵵�� ���� ���� Ȩ���� ���� �� 5����?
--SELECT TOP 5 teamID, COUNT(teamID) AS playerCount, SUM(HR) AS homeRuns
--FROM batting
--WHERE yearID = 2004
--GROUP BY teamID
--ORDER BY homeRuns DESC

---- 2004�⵵�� 200Ȩ�� �̻��� ���� ���� ���
--SELECT TOP 10 teamID, COUNT(teamID) AS playerCount, SUM(HR) AS homeRuns
--FROM batting
--WHERE yearID = 2004
--GROUP BY teamID
--HAVING SUM(HR) >= 200 --Grouping ������ �߰� ������ �Ŵ� ��
--ORDER BY homeRuns DESC


---- ���� ���� ���� ����
-- FROM			å�󿡼�
-- WHERE		����
-- GROUP BY		���󺰷� �з��ؼ�
-- HAVING		�з��� ������ �������� �����ϰ�
-- SELECT		������ �ͼ�
-- ORDER BY		ũ�⺰�� �������ּ���

 --�� �ص��� ���� ���� Ȩ���� ���� ����?
--SELECT teamID, yearID, SUM(HR) AS homeRuns
--FROM batting
--GROUP BY teamID, yearID
--ORDER BY homeRuns DESC

-- BOS 2004
-- BOS 2005