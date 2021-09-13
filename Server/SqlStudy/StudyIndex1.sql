USE BaseballData;

-- 조인 원리
	-- 1) Nested Loop (NL) 조인
	-- 2) Merge(병합) 조인
	-- 3) Hash(해시) 조인

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
-- 테이블 스캔은 아쉬운 동작이지만, 조회할 데이터가 5개 뿐이므로 5개만 찾고 멈출 수 있는 NL 동작을 자동으로 선택.
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
-- sql에서 자동으로 players, salaries 스캔 순서를 바꿔준다. players 테이블에서 playerID를 찾는게 더 효율적이므로.
SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID
	OPTION(LOOP JOIN)


-- salaries 의 인덱스는 year, team, lg, player 순으로 인덱스가 걸려있으므로 playerID를 사용하면 매우 느려진다.	
SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID
	OPTION(FORCE ORDER, LOOP JOIN)


-- Nested Loop 특징
-- 먼저 Access한 (Outer)테이블의 row를 반복문으로 돌며 -> (Inner)테이블에 random access
-- (Inner)테이블에 인덱스가 없으면 안좋다.
-- 부분범위 처리에 좋다. (e.g. SELECT TOP 5)