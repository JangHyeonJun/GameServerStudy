USE Northwind;

SELECT *
FROM [Order Details]
ORDER BY [OrderID]

SELECT *
INTO TestOrderDetails
FROM [Order Details]

SELECT *
FROM TestOrderDetails

-- 복합 인덱스 추가
CREATE INDEX Index_TestOrderDetails
ON TestOrderDetails(OrderID, ProductID)

EXEC sp_helpindex 'TestOrderDetails'

-- (OrderID, ProductID) OrderID? ProductID?
-- INDEX SCAN -> (INDEX FULL SCAN) -> BAD
-- INDEX SEEK -> GOOD

-- 인덱스 적용 테스트 1 -> GOOD
SELECT *
FROM TestOrderDetails
WHERE OrderID = 10248 AND ProductID = 11


-- 인덱스 적용 테스트 2 (AND 순서는 크게 중요하지 않다) -> GOOD
SELECT *
FROM TestOrderDetails
WHERE ProductID = 11 AND OrderID = 10248 

-- 인덱스 적용 테스트 3 -> GOOD
SELECT *
FROM TestOrderDetails
WHERE OrderID = 10248 

-- 인덱스 적용 테스트 4 -> BAD
-- OrderID를 1번 ProdcutID를 2번으로 하여, 실질적으로 1번으로 정렬하고 이후에 2번으로 정렬하는 것
-- (1,2)로 인덱스가 걸려있을 경우에 (1)인덱스는 만들필요 없지만 (2)로 검색이 필요하다면 별도로 인덱스를 생성해주어야한다.
SELECT *
FROM TestOrderDetails
WHERE ProductID = 11


-- INDEX 정보
DBCC IND('Northwind', 'TestOrderDetails', 2);

--			  888
--	824 848 849 850 851 852

-- OrderID (key), ProductID (key)로 정렬된 것을 알 수 있다.
DBCC PAGE('Northwind', 1, 824, 3);

-- 인덱스 데이터는 추가/삭제/갱신이 계속 필요하다.
-- 데이터 50개를 강제로 넣어보자
-- 1번째)  10248 11
-- 마지막) 10387 24

DECLARE @i INT = 0
WHILE @i < 50
BEGIN
	INSERT INTO TestOrderDetails
	VALUES (10248, 100 + @i, 10, 1, 0)
	SET @i = @i + 1
END

DBCC IND('Northwind', 'TestOrderDetails', 2);

--			  888
--	824 [889] 848 849 850 851 852
--  824에 있는 데이터를 분할해서 889로 옮겼다
DBCC PAGE('Northwind', 1, 824, 3);
DBCC PAGE('Northwind', 1, 889, 3);

-- 페이지 여유 공간이 없다면 -> 페이지 분할(SPLIT) 발생

-- 가공 테스트
SELECT LastName
INTO TestEmployees
FROM Employees

SELECT * FROM TestEmployees

-- 인덱스 추가
CREATE INDEX Index_TestEmployees
ON TestEmployees(LastName);

-- INDEX SCAN -> BAD
SELECT *
FROM TestEmployees
WHERE SUBSTRING(LastName, 1, 2) = 'Bu'

-- INDEX SEEK
SELECT *
FROM TestEmployees
WHERE LastName LIKE 'Bu%'

-- 복합인덱스 (A, B)는 A->B 순서로검색
-- 인덱스 사용시 데이터 추가로 인해 페이지 여유 공간이 없으면 SPLIT
-- 키 가공시 주의하기


-- Clustered Index 해당 키를 기준으로 데이터 자체가 정렬되어 있음
-- Index Seek가 느린 경우가 없음

-- NonClustered의 경우 데이터가 Leaf Page에 없다.
-- 한번 더 타고 가야함
--	1) RID -> Heap Table (Bookmark Lookup)
--	2) Key -> Clustered

SELECT *
INTO TestOrders
FROM Orders

SELECT *
FROM TestOrders

CREATE NONCLUSTERED INDEX Orders_Index01 ON TestOrders(CustomerID);
-- 인덱스 번호
SELECT index_id name FROM sys.indexes WHERE object_id = object_id('TestOrders')

-- 인덱스 조회
DBCC IND('Northwind', 'TestOrders', 2)

--			1128
--	1088	1096	1097
-- Heap Table[ {page} {page} ]

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SET STATISTICS PROFILE ON;

-- 기본 탐색
SELECT *
FROM TestOrders
WHERE CustomerID = 'QUICK';

-- 인덱스 강제 사용
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK';

-- Orders_Index01 이 커버하는 인덱스는 CustomerID 뿐이기 때문에 ShipVia = 3은 8개만 적중했다
-- ShipVia가 무엇인지 알 수 없으므로 Lookup을 쓸데없이 많이하게 된 것
-- 인덱스를 활용했는데도 느린 경우, Index Seek 보다 Index Scan이 좋은 경우다.
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

DROP INDEX TestOrders.Orders_Index01;

-- 룩업을 줄이기 위한 몸부림
-- Covered Index, 활용하고 싶은 데이터를 모두 인덱스로 하는 것
CREATE NONCLUSTERED INDEX Orders_Index01 ON TestOrders(CustomerID, ShipVia);

-- 8번 룩업 시도하고 전부 맞았음
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- Q) 그럼 조건1 AND 조건2 면, INDEX(조건1, 조건2) 추가하면 장땡?
-- A) NO! 꼭 그렇지 않다. DML(Insert, Update, Delete)가 느려진다.


DROP INDEX TestOrders.Orders_Index01;

-- 룩업을 줄이기 위한 몸부림
-- CustomerID를 기준으로 NonClustered Index를 구성하지만 RID옆에 ShipVia를 힌트로 남기는 것.
--
--			1128
--	1088(data1(shipvia=2), data2(shipvia=3)...)	1096	1097 이런식

CREATE NONCLUSTERED INDEX Orders_Index01 ON TestOrders(CustomerID) INCLUDE (ShipVia);

-- 8번 룩업 8번 다 꽝 없음
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- 위처럼 해도 답이 없다면
-- Clustered Index 활용을 고려, 그러나 Clusterd Index는 테이블당 1개만 사용 가능하다.