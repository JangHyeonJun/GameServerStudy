

-- 데이터베이스 Schema 만들기

--CREATE DATABASE GameDB;

--USE GameDB;

-- CREATE TABLE 테이블명(열이름 자료형 [DEFAULT 값] [NULL | NOT NULL], ...)

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

-- 제약(CONSTRAINT) 추가 /삭제
-- NOT NULL
-- UNIQUE
-- PRIMARY KEY
-- FOREIGN KEY

-- C# class Player() {}
-- List<Player> == PK를 아무것도 지정하지 않았을 경우 List형태로 동작한다. (테이블 스캔)
-- Dictionary<int, Player> == int형의 PK를 지정했을 경우 (클러스터 인덱스 스캔) 이진트리 사용

--ALTER TABLE accounts
--ADD PRIMARY KEY (accountId)

--ALTER TABLE accounts
--ADD CONSTRAINT PK_Account PRIMARY KEY (accountId)

--ALTER TABLE accounts
--DROP CONSTRAINT PK_Account

--SELECT *
--FROM accounts
--WHERE accountId = 1111;

-- PK, 클러스터 인덱스(Clustered Index)는 물리적인 데이터 자체가 정렬돼있어서 인덱스를 위한 별도의 공간이 필요 없고, 테이블당 1개만 가능하며, 가장 속도가 빠르다. (사전과 같음)
-- 따로 관리되는 Lookup 테이블, 논클러스터 인덱스(NonClustered Index)는 별도의 제약이 없다. (책의 색인과 같음)

--CREATE UNIQUE INDEX i1 ON accounts(accountName) -- UNIQUE는 고유/비고유를 나타냄
--DROP INDEX accounts.i1

--CREATE CLUSTERED INDEX i1 ON accounts(accountName) -- 기존 클러스터형 인덱스인 PK를 제거해야 새 클러스터 인덱스를 추가할 수 있다.

-- RDBMS (relational 관계형) 데이터를 집합으로 간주.
-- 복수의 테이블 다루기

--USE BaseballData;


---- 커리어 평균 연봉이 300,0000 이상인 선수들의 playerId
--SELECT playerId, AVG(salary) AS avgSalary
--FROM salaries
--GROUP BY playerID
--HAVING AVG(salary) >= 3000000

---- 12월에 태어난 선수들의 playerId
--SELECT playerID, birthMonth
--FROM players
--WHERE birthMonth = 12 AND playerID IS NOT NULL

---- [커리어 평균 연봉이 300,0000 이상인 선수] || [12월에 태어난 선수] (합집합)
---- UNION (중복 제거) UNION ALL (중복 허용)

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


---- [커리어 평균 연봉이 300,0000 이상인 선수] && [12월에 태어난 선수] (교집합)

--SELECT playerId
--FROM salaries
--GROUP BY playerID
--HAVING AVG(salary) >= 3000000
--INTERSECT
--SELECT playerID
--FROM players
--WHERE birthMonth = 12 AND playerID IS NOT NULL
--ORDER BY playerID

---- [커리어 평균 연봉이 300,0000 이상인 선수] - [12월에 태어난 선수] (차집합)

--SELECT playerId
--FROM salaries
--GROUP BY playerID
--HAVING AVG(salary) >= 3000000
--EXCEPT
--SELECT playerID
--FROM players
--WHERE birthMonth = 12 AND playerID IS NOT NULL
--ORDER BY playerID


---- JOIN(결합)

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

---- CROSS JOIN (교차 결합)

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

---- INNER JOIN (두 개의 테이블을 가로로 결합 + 결합 기준을 ON으로)
---- playerID 가 양쪽 테이블에 다 있고 일치하는 애들을 결합

--SELECT *
--FROM players AS p
--	INNER JOIN salaries AS s
--	ON p.playerID = s.playerID


---- OUTER JOIN (외부 결합)
--	-- LEFT / RIGHT
--	-- 어느 한쪽에만 데이터가 존재할 경우

---- LEFT JOIN (두 개의 테이블을 가로로 결합 + 결합 기준을 ON으로)
---- playerID가 왼쪽(players)에 있으면 무조건 표시, 오른쪽(salaries)에 없으면 오른쪽 정보는 NULL로 채움.

--SELECT *
--FROM players AS p
--	LEFT JOIN salaries AS s
--	ON p.playerID = s.playerID

---- RIGHT JOIN (두 개의 테이블을 가로로 결합 + 결합 기준을 ON으로)
---- playerID가 오른쪽(salaries)에 있으면 무조건 표시, 왼쪽(players)에 없으면 왼쪽 정보는 NULL로 채움.

--SELECT *
--FROM players AS p
--	RIGHT JOIN salaries AS s
--	ON p.playerID = s.playerID