
USE GameDB;

SELECT *
FROM accounts;

-- TRAN 명시하지 않으면 자동으로 COMMIT
INSERT INTO accounts VALUES(1, 'kai', 100, GETUTCDATE())

DELETE accounts;

-- BEGIN TRAN;
-- COMMIT;
-- ROLLBACK;

-- ALL OR NOTHING

-- 성공/실패 여부에 따라 COMMIT (= COMMIT을 수동으로 하겠다)
BEGIN TRAN
   INSERT INTO accounts VALUES(2, 'kai2', 200, GETUTCDATE())
ROLLBACK

BEGIN TRAN
   INSERT INTO accounts VALUES(2, 'kai2', 200, GETUTCDATE())
COMMIT

-- 응용
BEGIN TRY
   BEGIN TRAN -- 트랜잭션은 중첩이 가능하다
   INSERT INTO accounts VALUES(1, 'kai', 100, GETUTCDATE())   
   INSERT INTO accounts VALUES(3, 'kai3', 300, GETUTCDATE())
   COMMIT
END TRY
BEGIN CATCH
   IF @@TRANCOUNT > 0 -- 현재 활성화된 트랜잭션 수를 반환
      ROLLBACK
   PRINT('ROLLBACK 됨')
END CATCH

-- TRAN 사용 시 주의점
-- TRAN 안에는 꼭! 원자적으로 실행될 애들만 넣어야한다. (성능 문제)
-- 원자적 수정을 위해 -> lock을 걸고 실행 -> writeLock(상호배타 락), readLock (공유락)

BEGIN TRAN
   INSERT INTO accounts VALUES(2, 'kai2', 200, GETUTCDATE())

   -- 여기서 다른 sql쿼리에서 테이블에 접근하게 되면 COMMIT/ROLLBACK 전까지 계속 대기한다.
ROLLBACK

USE BaseballData;

-------------------- 변수
--DECLARE @i AS INT = 10; --골뱅이는 필수는 아니고 다른거랑 겹칠수 있어서 넣음
--DECLARE @j AS INT;

--SET @j = 20;

---- 역대 최대 연봉을 받은 선수 이름
--DECLARE @firstName AS NVARCHAR(15)
--DECLARE @lastName AS NVARCHAR(15)

--SET @firstName = (SELECT TOP 1 nameFirst
--               FROM players AS p
--                  INNER JOIN salaries AS s
--                  ON p.playerID = s.playerID
--               ORDER BY s.salary DESC)

---- SQL Server에서만 지원
--SELECT TOP 1 @firstName = p.nameFirst, @lastName = p.nameLast
--               FROM players AS p
--                  INNER JOIN salaries AS s
--                  ON p.playerID = s.playerID
--               ORDER BY s.salary DESC

--SELECT @firstName, @lastName


-------------------- 배치(batch), 배치를 이용해 변수의 유효범위 설정 가능, 하나의 묶음으로 분석되고 실행되는 명령어 집합
--GO

--DECLARE @i AS INT = 10

--SELECT *
--FOM players -- 이전 배치에 에러가 있어도

--GO         -- 배치로 구분되어 있으면 별도로 실행됨
--SELECT *
--FROM salaries

-------------------- 흐름 제어(batch)

---- IF

--GO
--DECLARE @i AS INT = 10

--IF @i = 10
--   PRINT('BINGO')
--ELSE
--   PRINT('NO')

--IF @i = 10
--BEGIN -- 실행할 문장이 여러개일 경우 BEGIN/END로 묶어준다. (c언어의 중괄호 같이)
--   PRINT('BINGO')
--   PRINT('BINGO')
--END
--ELSE
--   PRINT('NO')

---- WHILE

--GO

--DECLARE @i AS INT = 0;
--WHILE @i <= 10
--BEGIN
--   SET @i = @i + 1
--   IF @i = 3 CONTINUE
--   IF @i = 6 BREAK 
--   PRINT @i
--END


----------------------- 테이블 변수

---- 임시로 사용할 테이블을 변수로 만들 수 있다
---- DECLARE 사용 -> tempdb 라는 임시 데이터베이스에 저장하고 알아서 제거함

--GO

--DECLARE @test TABLE
--(
--   name VARCHAR(50) NOT NULL,
--   salary INT NOT NULL
--)

--INSERT @test
--SELECT p.nameFirst + ' ' + p.nameLast, s.salary
--FROM players AS p
--   INNER JOIN salaries AS s
--   ON p.playerID = s.playerID

--SELECT *
--FROM @test

-- 윈도우 함수
-- 행들의 서브 집합을 대상으로, 행 별로 계산을 해서 스칼라(단일 고정)값을 출력하는 함수
-- GROUPING이랑 비슷? SUM, COUNT, AVG 집계함수와 그룹화된 컬럼만 SELECT 가능

--SELECT *
--FROM salaries
--ORDER BY salary DESC

--SELECT playerID, MAX(Salary)
--FROM salaries
--GROUP BY playerID
--ORDER BY MAX(salary) DESC

---- ~OVER([PARTTION] [ORDER BY] [ROWS])

---- 전체 데이터를 연봉 순서로 나열하고 순위 표기
--SELECT *,
--   ROW_NUMBER() OVER (ORDER BY salary DESC),   -- 행 번호
--   RANK() OVER (ORDER BY salary DESC),         -- 랭킹 (공동 순위 처리)
--   DENSE_RANK() OVER (ORDER BY salary DESC),   -- 랭킹 (공동 순위 처리 방식이 좀 다름)
--   NTILE(100) OVER (ORDER BY salary DESC)      -- 100을 입력했으므로 백분율
--FROM salaries   

---- playerID 별 순위를 따로 나열
--SELECT *,
--   RANK() OVER (PARTITION BY playerID ORDER BY salary DESC)
--FROM salaries
--ORDER BY playerID

---- LAG(바로 이전), LEAD(바로 다음)
--SELECT *,
--   RANK() OVER (PARTITION BY playerID ORDER BY salary DESC),
--   LAG(salary) OVER (PARTITION BY playerID ORDER BY salary DESC) AS prevSalary,
--   LEAD(salary) OVER (PARTITION BY playerID ORDER BY salary DESC) AS nextSalary
--FROM salaries
--ORDER BY playerID

---- FIRST_VALUE, LAST_VALUE
---- FRAME : FIRST~CURRENT 연산을 할때 처음 row부터 현재 row까지 범위에서 계산된다.(디폴트 = ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
--SELECT *,
--   RANK() OVER (PARTITION BY playerID ORDER BY salary DESC),
--   FIRST_VALUE(salary) OVER (PARTITION BY playerID 
--                        ORDER BY salary DESC
--                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS best,
--   LAST_VALUE(salary) OVER (PARTITION BY playerID 
--                        ORDER BY salary DESC
--                        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS worst
--FROM salaries
--ORDER BY playerID

--USE Northwind;

---- DB 정보 살펴보기
--EXEC sp_helpdb 'Northwind'

---- 임시 테이블 만들기 (인덱스 테스트용)
--CREATE TABLE Test
--(
--   EmployeeID   INT NOT NULL,
--   LastName   NVARCHAR(20) NULL,
--   FirstName   NVARCHAR(20) NULL,
--   HireDate   DATETIME NULL
--);

--GO
--INSERT INTO Test
--SELECT EmployeeID, LastName, FirstName, HireDate
--FROM Employees;

--SELECT *
--FROM Test;

---- (외울 필요 없음) FILLFACTOR (리프 페이지 공간 1%만 사용)
---- PAD_INDEX (FILLFACTOR 중간 페이지 적용)
---- 공간을 매우 비효율적으로 만들어서 테스트 하기 위해
--CREATE INDEX Test_Index ON Test(LastName)
--WITH (FILLFACTOR = 1, PAD_INDEX = ON)

--GO

---- 인덱스 번호 찾기
--SELECT index_id, name
--FROM sys.indexes
--WHERE object_id = object_id('Test')

---- 2번 인덱스 정보 살펴보기

--DBCC IND('Northwind', 'Test', 2)

---- IndexLevel은 Root(2) -> Branch(1) -> Leaf(0) 로 돼있다. 자료구조 트리 생각하기
---- IndexLevel이랑 PagePID를 통해 확인해보면 아래와 같이 트리구조가 형성된다

----                        849(Leverling)
----               872(Dodsworth)            848(Levering)
----   832(Buchanan..)            840(Dodsworth..)            841(Leverling..)

---- Table [ {page] {page} {page} {page} {page} ]
---- Callahan을 찾기위해. 849에서 C가 L보다 작으므로 왼쪽, 872에서 D보다 작으므로 왼쪽, 832 RID를 가지고 실제 인덱스 정보를 가진 페이지를 찾아서 확인한다.
---- 페이지별 정보 찾아보기
---- HEAP RID([페이지 주소(4)][파일ID(2)][슬롯번호(2)] 조합한 ROW 식별자. 테이블에서 정보 추출) 8바이트, 실제 인덱스 정보가 있는 페이지의 위치
--DBCC PAGE('Northwind', 1/*파일번호*/, 832/*페이지번호*/, 3/*출력옵션, 보기 좋은거로 설정*/);
--DBCC PAGE('Northwind', 1/*파일번호*/, 840/*페이지번호*/, 3/*출력옵션, 보기 좋은거로 설정*/);
--DBCC PAGE('Northwind', 1/*파일번호*/, 841/*페이지번호*/, 3/*출력옵션, 보기 좋은거로 설정*/);


--DBCC PAGE('Northwind', 1/*파일번호*/, 872/*페이지번호*/, 3/*출력옵션, 보기 좋은거로 설정*/);
--DBCC PAGE('Northwind', 1/*파일번호*/, 848/*페이지번호*/, 3/*출력옵션, 보기 좋은거로 설정*/);
--DBCC PAGE('Northwind', 1/*파일번호*/, 849/*페이지번호*/, 3/*출력옵션, 보기 좋은거로 설정*/);

---- Random Access (한 건 읽기 위해 한 페이지씩 접근)
---- Bookmark Lookup (RID를 통해 행에 접근)