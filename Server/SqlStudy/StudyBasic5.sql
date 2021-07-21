

-- �����ͺ��̽� Schema �����

--CREATE DATABASE GameDB;

--USE GameDB;

-- CREATE TABLE ���̺��(���̸� �ڷ��� [DEFAULT ��] [NULL | NOT NULL], ...)

--CREATE TABLE accounts(
--	accountId INT NOT NULL,
--	accountName VARCHAR(10) NOT NULL,
--	coins INT DEFAULT 0,
--	createdTime DATETIME
--)



--DROP TABLE accounts

--ALTER TABLE accounts
--ADD lastEnterTime DATETIME;

--ALTER TABLE accounts
--DROP COLUMN lastEnterTime

--ALTER TABLE accounts
--ALTER COLUMN accountNAme VARCHAR(20) NOT NULL;

-- ����(CONSTRAINT) �߰� /����
-- NOT NULL
-- UNIQUE
-- PRIMARY KEY
-- FOREIGN KEY

-- C# class Player() {}
-- List<Player> == PK�� �ƹ��͵� �������� �ʾ��� ��� List���·� �����Ѵ�. (���̺� ��ĵ)
-- Dictionary<int, Player> == int���� PK�� �������� ��� (Ŭ������ �ε��� ��ĵ) ����Ʈ�� ���

--ALTER TABLE accounts
--ADD PRIMARY KEY (accountId)

--ALTER TABLE accounts
--ADD CONSTRAINT PK_Account PRIMARY KEY (accountId)

--ALTER TABLE accounts
--DROP CONSTRAINT PK_Account

--SELECT *
--FROM accounts
--WHERE accountId = 1111;

-- PK, Ŭ������ �ε���(Clustered Index)�� �������� ������ ��ü�� ���ĵ��־ �ε����� ���� ������ ������ �ʿ� ����, ���̺�� 1���� �����ϸ�, ���� �ӵ��� ������. (������ ����)
-- ���� �����Ǵ� Lookup ���̺�, ��Ŭ������ �ε���(NonClustered Index)�� ������ ������ ����. (å�� ���ΰ� ����)

--CREATE UNIQUE INDEX i1 ON accounts(accountName) -- UNIQUE�� ����/������� ��Ÿ��
--DROP INDEX accounts.i1

--CREATE CLUSTERED INDEX i1 ON accounts(accountName) -- ���� Ŭ�������� �ε����� PK�� �����ؾ� �� Ŭ������ �ε����� �߰��� �� �ִ�.

-- RDBMS (relational ������) �����͸� �������� ����.
-- ������ ���̺� �ٷ��

--USE BaseballData;


---- Ŀ���� ��� ������ 300,0000 �̻��� �������� playerId
--SELECT playerId, AVG(salary) AS avgSalary
--FROM salaries
--GROUP BY playerID
--HAVING AVG(salary) >= 3000000

---- 12���� �¾ �������� playerId
--SELECT playerID, birthMonth
--FROM players
--WHERE birthMonth = 12 AND playerID IS NOT NULL

---- [Ŀ���� ��� ������ 300,0000 �̻��� ����] || [12���� �¾ ����] (������)
---- UNION (�ߺ� ����) UNION ALL (�ߺ� ���)

--SELECT playerId
--FROM salaries
--GROUP BY playerID
--HAVING AVG(salary) >= 3000000
--UNION
--SELECT playerID
--FROM players
--WHERE birthMonth = 12 AND playerID IS NOT NULL

--SELECT playerId
--FROM salaries
--GROUP BY playerID
--HAVING AVG(salary) >= 3000000
--UNION ALL
--SELECT playerID
--FROM players
--WHERE birthMonth = 12 AND playerID IS NOT NULL
--ORDER BY playerID


---- [Ŀ���� ��� ������ 300,0000 �̻��� ����] && [12���� �¾ ����] (������)

--SELECT playerId
--FROM salaries
--GROUP BY playerID
--HAVING AVG(salary) >= 3000000
--INTERSECT
--SELECT playerID
--FROM players
--WHERE birthMonth = 12 AND playerID IS NOT NULL
--ORDER BY playerID

---- [Ŀ���� ��� ������ 300,0000 �̻��� ����] - [12���� �¾ ����] (������)

--SELECT playerId
--FROM salaries
--GROUP BY playerID
--HAVING AVG(salary) >= 3000000
--EXCEPT
--SELECT playerID
--FROM players
--WHERE birthMonth = 12 AND playerID IS NOT NULL
--ORDER BY playerID


---- JOIN(����)

--USE GameDB;

--CREATE TABLE testA
--(
--	a INT
--)

--CREATE TABLE testB
--(
--	b varchar(10)
--)

--INSERT INTO testA VALUES(1);
--INSERT INTO testA VALUES(2);
--INSERT INTO testA VALUES(3);


--INSERT INTO testB VALUES('A');
--INSERT INTO testB VALUES('B');
--INSERT INTO testB VALUES('C');

---- CROSS JOIN (���� ����)

--SELECT *
--FROM testA
--	CROSS JOIN testB

--SELECT *
--FROM testA, testB;

-----------------------------------
--USE BaseballData;

--SELECT *
--FROM players
--ORDER BY playerID

--SELECT *
--FROM salaries
--ORDER BY playerID

---- INNER JOIN (�� ���� ���̺��� ���η� ���� + ���� ������ ON����)
---- playerID �� ���� ���̺� �� �ְ� ��ġ�ϴ� �ֵ��� ����

--SELECT *
--FROM players AS p
--	INNER JOIN salaries AS s
--	ON p.playerID = s.playerID


---- OUTER JOIN (�ܺ� ����)
--	-- LEFT / RIGHT
--	-- ��� ���ʿ��� �����Ͱ� ������ ���

---- LEFT JOIN (�� ���� ���̺��� ���η� ���� + ���� ������ ON����)
---- playerID�� ����(players)�� ������ ������ ǥ��, ������(salaries)�� ������ ������ ������ NULL�� ä��.

--SELECT *
--FROM players AS p
--	LEFT JOIN salaries AS s
--	ON p.playerID = s.playerID

---- RIGHT JOIN (�� ���� ���̺��� ���η� ���� + ���� ������ ON����)
---- playerID�� ������(salaries)�� ������ ������ ǥ��, ����(players)�� ������ ���� ������ NULL�� ä��.

--SELECT *
--FROM players AS p
--	RIGHT JOIN salaries AS s
--	ON p.playerID = s.playerID