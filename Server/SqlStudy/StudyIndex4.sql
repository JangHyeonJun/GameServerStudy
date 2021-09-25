USE BaseballData;

-- Sorting 을 줄이기.
-- 평균적으로 정렬은 O(NLogN), DB는 보통 데이터가 매우 많다.
-- 용량이 너무 커서 가용 메모리로 커버가 안되면 디스크까지 찾아간다. (sorting이 매우 느려진다.)

-- Sorting이 일어날 때
-- 1) SORT MERGE JOIN
-- 2) ORDER BY
-- 3) GROUP BY
-- 4) DISTINCT
-- 5) UNION
-- 6) RANKING WINDOWS FUNCTION
-- 7) MIN MAX

-- 원인
-- 1) SORT MERGE JOIN : 알고리즘 특성상 Merge 전에 Sort를 진행한다.
-- 2) ORDER BY : ORDER BY 순서로 정렬을 해야 하므로
SELECT *
FROM players
ORDER BY college

-- 3) GROUP BY : 집계를 하기 위해 
SELECT college, COUNT(college)
FROM players
WHERE college LIKE 'C%'
GROUP BY college

-- 4) DISTINCT : 중복 제거를 위해
SELECT DISTINCT college
FROM players
WHERE college LIKE 'C%'

-- 5) UNION : 중복 제거를 위해
SELECT college
FROM players
WHERE college LIKE 'B%'
UNION
SELECT college
FROM players
WHERE college LIKE 'C%'

-- 6) 순위 윈도우 함수 : 집계를 하기 위해
SELECT ROW_NUMBER() OVER (ORDER BY college)
FROM players


-------------------------------------------------------

-- Index를 잘 활용하면 굳이 sorting 하지 않아도 된다.
-- 예시 1)
SELECT *
FROM batting
ORDER BY playerID, yearId
-- 예시 2)
SELECT playerID, COUNT(playerID)
FROM players
WHERE playerID LIKE 'C%'
GROUP BY playerID
-- 예시 3)
SELECT ROW_NUMBER() OVER (ORDER BY playerId)
FROM players

-- 두 테이블의 결과가 절대 중복되지 않는다면 UNION 대신에 UNION ALL을 사용하여 굳이 sorting을 하지 않도록 한다.
-- DISTINCT 도 마찬가지로 중복되지 않으면 사용하지 않는다.
SELECT college
FROM players
WHERE college LIKE 'B%'
UNION ALL
SELECT college
FROM players
WHERE college LIKE 'C%'