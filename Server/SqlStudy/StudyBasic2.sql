USE BaseballData; -- 어떤 테이블을 다룰건지 명시.

--SELECT TOP 1 PERCENT *
--FROM players
--WHERE birthYear IS NOT NULL
--ORDER BY birthYear DESC, birthMonth DESC, birthDay DESC; -- null에 대해서는 정렬에 대한 표준이 다름, null을 제거하는 편이 좋다.

--SELECT 2021 - birthYear AS koreanAge
--FROM players
--WHERE deathYear IS NULL AND birthYear IS NOT NULL AND (2021 - birthYear) <= 80
--ORDER BY koreanAge

-- sql구문의 순서와 실제 실행 순서는 다르다.
-- FROM
-- WHERE
-- SELECT
-- ORDER BY

--SELECT 2021 - NULL, 2021 * NULL, 2021 + NULL

--SELECT 3.0/2, 3/2 --, 3/0 error

--SELECT ROUND(3.141592, 3);
--SELECT POWER(2, 4);
--SELECT COS(0)

--SELECT 'Hello World' AS Output
--SELECT '안녕하세요', N'안녕하세요'

--SELECT 'Hello' + 'World'
--SELECT CONCAT('Hello', 'World')
--SELECT SUBSTRING('20210717', 1, 4) AS Year, SUBSTRING('20210717', 5, 2) As Month, SUBSTRING('20210717', 7, 2) AS Day
--SELECT TRIM('      HelloWorld')

--SELECT nameFirst + ' ' + nameLast AS fullName
--FROM players
--WHERE nameFirst IS NOT NULL AND nameLast IS NOT NULL

-- DATE 연/월/일
-- TIME 시/분/초
-- DATETIME 연/월/일/시/분/초


--SELECT CAST('20200425 05:03:21' AS DATETIME)
-- YYYYMMDD
-- YYYYMMDD hh:mm:ss::nnn
-- YYYY-MM-DDThh:mm

--SELECT GETDATE();
--SELECT CURRENT_TIMESTAMP;

--USE [BaseballData]
--GO

--INSERT INTO [dbo].[DateTimeTest]
--           ([time])
--     VALUES
--           (CURRENT_TIMESTAMP),
--		   (CAST('20200425 05:03:21' AS DATETIME)),
--		   ('20200425 05:03:21' )
--GO

--SELECT *
--FROM DateTimeTest
--WHERE time >= '20210101' --(CAST('20210101' AS DATETIME))

--SELECT GETDATE();
--SELECT GETUTCDATE(); -- GMT (Greenwich Mean Time), 지역에 상관없는 공통 시간 UTC 시간을 활용한다.

--SELECT DATEADD(YEAR, 1, '20200426')
--SELECT DATEADD(DAY, 5, '20200426') -- 실제로 달력에 있는 날인지 고려해준다.
--SELECT DATEADD(SECOND, -123123, '20200426')

--SELECT DATEDIFF(DAY, '20200826', '20200503')

--SELECT DATEPART(DAY, '20200826')
--SELECT YEAR('20200826')
--SELECT MONTH('20200826')
--SELECT DAY('20200826')