USE BaseballData; -- � ���̺��� �ٷ���� ���.

--SELECT TOP 1 PERCENT *
--FROM players
--WHERE birthYear IS NOT NULL
--ORDER BY birthYear DESC, birthMonth DESC, birthDay DESC; -- null�� ���ؼ��� ���Ŀ� ���� ǥ���� �ٸ�, null�� �����ϴ� ���� ����.

--SELECT 2021 - birthYear AS koreanAge
--FROM players
--WHERE deathYear IS NULL AND birthYear IS NOT NULL AND (2021 - birthYear) <= 80
--ORDER BY koreanAge

-- sql������ ������ ���� ���� ������ �ٸ���.
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
--SELECT '�ȳ��ϼ���', N'�ȳ��ϼ���'

--SELECT 'Hello' + 'World'
--SELECT CONCAT('Hello', 'World')
--SELECT SUBSTRING('20210717', 1, 4) AS Year, SUBSTRING('20210717', 5, 2) As Month, SUBSTRING('20210717', 7, 2) AS Day
--SELECT TRIM('      HelloWorld')

--SELECT nameFirst + ' ' + nameLast AS fullName
--FROM players
--WHERE nameFirst IS NOT NULL AND nameLast IS NOT NULL

-- DATE ��/��/��
-- TIME ��/��/��
-- DATETIME ��/��/��/��/��/��


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
--SELECT GETUTCDATE(); -- GMT (Greenwich Mean Time), ������ ������� ���� �ð� UTC �ð��� Ȱ���Ѵ�.

--SELECT DATEADD(YEAR, 1, '20200426')
--SELECT DATEADD(DAY, 5, '20200426') -- ������ �޷¿� �ִ� ������ ������ش�.
--SELECT DATEADD(SECOND, -123123, '20200426')

--SELECT DATEDIFF(DAY, '20200826', '20200503')

--SELECT DATEPART(DAY, '20200826')
--SELECT YEAR('20200826')
--SELECT MONTH('20200826')
--SELECT DAY('20200826')