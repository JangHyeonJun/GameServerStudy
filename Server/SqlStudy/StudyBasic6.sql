
USE GameDB;

SELECT *
FROM accounts;

-- TRAN ������� ������ �ڵ����� COMMIT
INSERT INTO accounts VALUES(1, 'kai', 100, GETUTCDATE())

DELETE accounts;

-- BEGIN TRAN;
-- COMMIT;
-- ROLLBACK;

-- ALL OR NOTHING

-- ����/���� ���ο� ���� COMMIT (= COMMIT�� �������� �ϰڴ�)
BEGIN TRAN
   INSERT INTO accounts VALUES(2, 'kai2', 200, GETUTCDATE())
ROLLBACK

BEGIN TRAN
   INSERT INTO accounts VALUES(2, 'kai2', 200, GETUTCDATE())
COMMIT

-- ����
BEGIN TRY
   BEGIN TRAN -- Ʈ������� ��ø�� �����ϴ�
   INSERT INTO accounts VALUES(1, 'kai', 100, GETUTCDATE())   
   INSERT INTO accounts VALUES(3, 'kai3', 300, GETUTCDATE())
   COMMIT
END TRY
BEGIN CATCH
   IF @@TRANCOUNT > 0 -- ���� Ȱ��ȭ�� Ʈ����� ���� ��ȯ
      ROLLBACK
   PRINT('ROLLBACK ��')
END CATCH

-- TRAN ��� �� ������
-- TRAN �ȿ��� ��! ���������� ����� �ֵ鸸 �־���Ѵ�. (���� ����)
-- ������ ������ ���� -> lock�� �ɰ� ���� -> writeLock(��ȣ��Ÿ ��), readLock (������)

BEGIN TRAN
   INSERT INTO accounts VALUES(2, 'kai2', 200, GETUTCDATE())

   -- ���⼭ �ٸ� sql�������� ���̺� �����ϰ� �Ǹ� COMMIT/ROLLBACK ������ ��� ����Ѵ�.
ROLLBACK

USE BaseballData;

-------------------- ����
--DECLARE @i AS INT = 10; --����̴� �ʼ��� �ƴϰ� �ٸ��Ŷ� ��ĥ�� �־ ����
--DECLARE @j AS INT;

--SET @j = 20;

---- ���� �ִ� ������ ���� ���� �̸�
--DECLARE @firstName AS NVARCHAR(15)
--DECLARE @lastName AS NVARCHAR(15)

--SET @firstName = (SELECT TOP 1 nameFirst
--               FROM players AS p
--                  INNER JOIN salaries AS s
--                  ON p.playerID = s.playerID
--               ORDER BY s.salary DESC)

---- SQL Server������ ����
--SELECT TOP 1 @firstName = p.nameFirst, @lastName = p.nameLast
--               FROM players AS p
--                  INNER JOIN salaries AS s
--                  ON p.playerID = s.playerID
--               ORDER BY s.salary DESC

--SELECT @firstName, @lastName


-------------------- ��ġ(batch), ��ġ�� �̿��� ������ ��ȿ���� ���� ����, �ϳ��� �������� �м��ǰ� ����Ǵ� ��ɾ� ����
--GO

--DECLARE @i AS INT = 10

--SELECT *
--FOM players -- ���� ��ġ�� ������ �־

--GO         -- ��ġ�� ���еǾ� ������ ������ �����
--SELECT *
--FROM salaries

-------------------- �帧 ����(batch)

---- IF

--GO
--DECLARE @i AS INT = 10

--IF @i = 10
--   PRINT('BINGO')
--ELSE
--   PRINT('NO')

--IF @i = 10
--BEGIN -- ������ ������ �������� ��� BEGIN/END�� �����ش�. (c����� �߰�ȣ ����)
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


----------------------- ���̺� ����

---- �ӽ÷� ����� ���̺��� ������ ���� �� �ִ�
---- DECLARE ��� -> tempdb ��� �ӽ� �����ͺ��̽��� �����ϰ� �˾Ƽ� ������

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

-- ������ �Լ�
-- ����� ���� ������ �������, �� ���� ����� �ؼ� ��Į��(���� ����)���� ����ϴ� �Լ�
-- GROUPING�̶� ���? SUM, COUNT, AVG �����Լ��� �׷�ȭ�� �÷��� SELECT ����

--SELECT *
--FROM salaries
--ORDER BY salary DESC

--SELECT playerID, MAX(Salary)
--FROM salaries
--GROUP BY playerID
--ORDER BY MAX(salary) DESC

---- ~OVER([PARTTION] [ORDER BY] [ROWS])

---- ��ü �����͸� ���� ������ �����ϰ� ���� ǥ��
--SELECT *,
--   ROW_NUMBER() OVER (ORDER BY salary DESC),   -- �� ��ȣ
--   RANK() OVER (ORDER BY salary DESC),         -- ��ŷ (���� ���� ó��)
--   DENSE_RANK() OVER (ORDER BY salary DESC),   -- ��ŷ (���� ���� ó�� ����� �� �ٸ�)
--   NTILE(100) OVER (ORDER BY salary DESC)      -- 100�� �Է������Ƿ� �����
--FROM salaries   

---- playerID �� ������ ���� ����
--SELECT *,
--   RANK() OVER (PARTITION BY playerID ORDER BY salary DESC)
--FROM salaries
--ORDER BY playerID

---- LAG(�ٷ� ����), LEAD(�ٷ� ����)
--SELECT *,
--   RANK() OVER (PARTITION BY playerID ORDER BY salary DESC),
--   LAG(salary) OVER (PARTITION BY playerID ORDER BY salary DESC) AS prevSalary,
--   LEAD(salary) OVER (PARTITION BY playerID ORDER BY salary DESC) AS nextSalary
--FROM salaries
--ORDER BY playerID

---- FIRST_VALUE, LAST_VALUE
---- FRAME : FIRST~CURRENT ������ �Ҷ� ó�� row���� ���� row���� �������� ���ȴ�.(����Ʈ = ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
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

---- DB ���� ���캸��
--EXEC sp_helpdb 'Northwind'

---- �ӽ� ���̺� ����� (�ε��� �׽�Ʈ��)
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

---- (�ܿ� �ʿ� ����) FILLFACTOR (���� ������ ���� 1%�� ���)
---- PAD_INDEX (FILLFACTOR �߰� ������ ����)
---- ������ �ſ� ��ȿ�������� ���� �׽�Ʈ �ϱ� ����
--CREATE INDEX Test_Index ON Test(LastName)
--WITH (FILLFACTOR = 1, PAD_INDEX = ON)

--GO

---- �ε��� ��ȣ ã��
--SELECT index_id, name
--FROM sys.indexes
--WHERE object_id = object_id('Test')

---- 2�� �ε��� ���� ���캸��

--DBCC IND('Northwind', 'Test', 2)

---- IndexLevel�� Root(2) -> Branch(1) -> Leaf(0) �� ���ִ�. �ڷᱸ�� Ʈ�� �����ϱ�
---- IndexLevel�̶� PagePID�� ���� Ȯ���غ��� �Ʒ��� ���� Ʈ�������� �����ȴ�

----                        849(Leverling)
----               872(Dodsworth)            848(Levering)
----   832(Buchanan..)            840(Dodsworth..)            841(Leverling..)

---- Table [ {page] {page} {page} {page} {page} ]
---- Callahan�� ã������. 849���� C�� L���� �����Ƿ� ����, 872���� D���� �����Ƿ� ����, 832 RID�� ������ ���� �ε��� ������ ���� �������� ã�Ƽ� Ȯ���Ѵ�.
---- �������� ���� ã�ƺ���
---- HEAP RID([������ �ּ�(4)][����ID(2)][���Թ�ȣ(2)] ������ ROW �ĺ���. ���̺��� ���� ����) 8����Ʈ, ���� �ε��� ������ �ִ� �������� ��ġ
--DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 832/*��������ȣ*/, 3/*��¿ɼ�, ���� �����ŷ� ����*/);
--DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 840/*��������ȣ*/, 3/*��¿ɼ�, ���� �����ŷ� ����*/);
--DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 841/*��������ȣ*/, 3/*��¿ɼ�, ���� �����ŷ� ����*/);


--DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 872/*��������ȣ*/, 3/*��¿ɼ�, ���� �����ŷ� ����*/);
--DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 848/*��������ȣ*/, 3/*��¿ɼ�, ���� �����ŷ� ����*/);
--DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 849/*��������ȣ*/, 3/*��¿ɼ�, ���� �����ŷ� ����*/);

---- Random Access (�� �� �б� ���� �� �������� ����)
---- Bookmark Lookup (RID�� ���� �࿡ ����)