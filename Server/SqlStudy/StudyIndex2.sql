USE BaseballData;

SET STATISTICS TIME ON
SET STATISTICS IO ON
SET STATISTICS PROFILE ON

-- NonClustered
--		1
--	2	3	4

-- Merge(병합) 조인 = Sort Merge(정렬 병합) 조인
-- Merge 조인도 조건이 붙는다 (One-To-Many == outer가 unique해야 함 => PK, Unique)
-- 일일히 NonClustered 인덱스를 Random Access하지 않고 Clustered Scan 후 정렬을 선택함
-- Many to Many = true


SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID


-- NonClustered 인덱스를 사용한다.
-- Many to Many = false

SELECT *
FROM schools AS s
	INNER JOIN schoolsplayers AS p
	ON s.schoolID = p.schoolID;

-- 결론
-- Merge

-- 1) 양쪽 집합을 Sort(정렬)하고 Merge(병합)한다
--	-- 이미 정렬된 상태라면 Sort는 생략 (특히, Clustered로 물리적 정렬된 상태라면 Best)
--	-- 정렬할 데이터가 너무많으면 Bad -> Hash를 사용하자
-- 2) Random Access 를 선호하지 않는다. 다른 방법을 찾아내려고 한다.
-- 3) Many to Many 보다는 One to Many 조인에 효과적
	-- Outer가 PK, UNIQUE