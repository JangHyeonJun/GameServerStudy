USE BaseballData;

-- ���� ����
	-- 1) Nested Loop (NL) ����
	-- 2) Merge(����) ����
	-- 3) Hash(�ؽ�) ����

-- NonClustered
--		1
--	2	3	4

-- Clustered
--		1
--	2	3	4

--	Merge


-- Merge
SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID

-- Nested Loop
-- ���̺� ��ĵ�� �ƽ��� ����������, ��ȸ�� �����Ͱ� 5�� ���̹Ƿ� 5���� ã�� ���� �� �ִ� NL ������ �ڵ����� ����.
SELECT TOP 5 *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID

-- Hash
SELECT *
FROM salaries AS s
	INNER JOIN teams AS t
	ON s.teamID = t.teamID;

-- NL
-- sql���� �ڵ����� players, salaries ��ĵ ������ �ٲ��ش�. players ���̺��� playerID�� ã�°� �� ȿ�����̹Ƿ�.
SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID
	OPTION(LOOP JOIN)


-- salaries �� �ε����� year, team, lg, player ������ �ε����� �ɷ������Ƿ� playerID�� ����ϸ� �ſ� ��������.	
SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID
	OPTION(FORCE ORDER, LOOP JOIN)


-- Nested Loop Ư¡
-- ���� Access�� (Outer)���̺��� row�� �ݺ������� ���� -> (Inner)���̺� random access
-- (Inner)���̺� �ε����� ������ ������.
-- �κй��� ó���� ����. (e.g. SELECT TOP 5)