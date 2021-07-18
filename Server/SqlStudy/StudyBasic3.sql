USE BaseballData;

--SELECT *,
--	CASE birthMonth
--		WHEN 1 THEN N'겨울'
--		WHEN 2 THEN N'겨울'
--		WHEN 3 THEN N'봄'
--		WHEN 4 THEN N'봄'
--		WHEN 5 THEN N'봄'
--		WHEN 6 THEN N'여름'
--		WHEN 7 THEN N'여름'
--		WHEN 8 THEN N'여름'
--		WHEN 9 THEN N'가을'
--		WHEN 10 THEN N'가을'
--		WHEN 11 THEN N'가을'
--		WHEN 12 THEN N'겨울'
--		ELSE N'모름' -- ELSE를 작성하지 않으면 NULL이 들어감
--	END As birthSeason
--FROM players;

--SELECT *,
--	CASE 
--		WHEN birthMonth <= 2 THEN N'겨울'
--		WHEN birthMonth <= 5 THEN N'봄'
--		WHEN birthMonth <= 8 THEN N'여름'
--		WHEN birthMonth <= 11 THEN N'가을'
--		ELSE N'겨울'
--	END As birthSeason
--FROM players;

-- COUNT
--SUM
--AVG
--MIN
--MAX

--SELECT COUNT(*)
--FROM players;

--SELECT COUNT(birthYear) -- 집계 함수에서 NULL은 카운팅 되지 않는다.
--FROM players;

--SELECT DISTINCT birthCity
--FROM players;

--SELECT DISTINCT birthYear, birthMonth, birthDay -- 3가지 모두 달라야 다른 것으로 취급
--FROM players
--ORDER BY birthYear

---- 집계함수(DISTINCT 집합)
--SELECT COUNT(DISTINCT birthCity)
--FROM players;

-- 선수들의 평균 weight 
-- 단, weight == NULL 이면 weight = 0
--SELECT AVG(CASE WHEN weight IS NULL THEN 0 ELSE weight END) -- NULL 일 경우도 집계함수에 0으로 취급해서 계산하도록 하는 구문
--FROM players

--SELECT SUM(weight) / COUNT(weight)
--FROM players

--SELECT MIN(weight), MAX(weight) -- 문자열에도 사용 가능
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

---- 2004년도에 가장 많은 홈런을 날린 팀 5개는?
--SELECT TOP 5 teamID, COUNT(teamID) AS playerCount, SUM(HR) AS homeRuns
--FROM batting
--WHERE yearID = 2004
--GROUP BY teamID
--ORDER BY homeRuns DESC

---- 2004년도에 200홈런 이상을 날린 팀의 목록
--SELECT TOP 10 teamID, COUNT(teamID) AS playerCount, SUM(HR) AS homeRuns
--FROM batting
--WHERE yearID = 2004
--GROUP BY teamID
--HAVING SUM(HR) >= 200 --Grouping 다음에 추가 조건을 거는 것
--ORDER BY homeRuns DESC


---- 실제 구문 실행 순서
-- FROM			책상에서
-- WHERE		공을
-- GROUP BY		색상별로 분류해서
-- HAVING		분류한 다음에 빨간색은 제외하고
-- SELECT		가지고 와서
-- ORDER BY		크기별로 나열해주세요

 --한 해동안 가장 많은 홈런을 날린 팀은?
--SELECT teamID, yearID, SUM(HR) AS homeRuns
--FROM batting
--GROUP BY teamID, yearID
--ORDER BY homeRuns DESC

-- BOS 2004
-- BOS 2005