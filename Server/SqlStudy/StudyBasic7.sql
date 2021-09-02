USE Northwind;

SELECT *
FROM [Order Details]
ORDER BY [OrderID]

SELECT *
INTO TestOrderDetails
FROM [Order Details]

SELECT *
FROM TestOrderDetails

-- ���� �ε��� �߰�
CREATE INDEX Index_TestOrderDetails
ON TestOrderDetails(OrderID, ProductID)

EXEC sp_helpindex 'TestOrderDetails'

-- (OrderID, ProductID) OrderID? ProductID?
-- INDEX SCAN -> (INDEX FULL SCAN) -> BAD
-- INDEX SEEK -> GOOD

-- �ε��� ���� �׽�Ʈ 1 -> GOOD
SELECT *
FROM TestOrderDetails
WHERE OrderID = 10248 AND ProductID = 11


-- �ε��� ���� �׽�Ʈ 2 (AND ������ ũ�� �߿����� �ʴ�) -> GOOD
SELECT *
FROM TestOrderDetails
WHERE ProductID = 11 AND OrderID = 10248 

-- �ε��� ���� �׽�Ʈ 3 -> GOOD
SELECT *
FROM TestOrderDetails
WHERE OrderID = 10248 

-- �ε��� ���� �׽�Ʈ 4 -> BAD
-- OrderID�� 1�� ProdcutID�� 2������ �Ͽ�, ���������� 1������ �����ϰ� ���Ŀ� 2������ �����ϴ� ��
-- (1,2)�� �ε����� �ɷ����� ��쿡 (1)�ε����� �����ʿ� ������ (2)�� �˻��� �ʿ��ϴٸ� ������ �ε����� �������־���Ѵ�.
SELECT *
FROM TestOrderDetails
WHERE ProductID = 11


-- INDEX ����
DBCC IND('Northwind', 'TestOrderDetails', 2);

--			  888
--	824 848 849 850 851 852

-- OrderID (key), ProductID (key)�� ���ĵ� ���� �� �� �ִ�.
DBCC PAGE('Northwind', 1, 824, 3);

-- �ε��� �����ʹ� �߰�/����/������ ��� �ʿ��ϴ�.
-- ������ 50���� ������ �־��
-- 1��°)  10248 11
-- ������) 10387 24

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
--  824�� �ִ� �����͸� �����ؼ� 889�� �Ű��
DBCC PAGE('Northwind', 1, 824, 3);
DBCC PAGE('Northwind', 1, 889, 3);

-- ������ ���� ������ ���ٸ� -> ������ ����(SPLIT) �߻�

-- ���� �׽�Ʈ
SELECT LastName
INTO TestEmployees
FROM Employees

SELECT * FROM TestEmployees

-- �ε��� �߰�
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

-- �����ε��� (A, B)�� A->B �����ΰ˻�
-- �ε��� ���� ������ �߰��� ���� ������ ���� ������ ������ SPLIT
-- Ű ������ �����ϱ�


-- Clustered Index �ش� Ű�� �������� ������ ��ü�� ���ĵǾ� ����
-- Index Seek�� ���� ��찡 ����

-- NonClustered�� ��� �����Ͱ� Leaf Page�� ����.
-- �ѹ� �� Ÿ�� ������
--	1) RID -> Heap Table (Bookmark Lookup)
--	2) Key -> Clustered

SELECT *
INTO TestOrders
FROM Orders

SELECT *
FROM TestOrders

CREATE NONCLUSTERED INDEX Orders_Index01 ON TestOrders(CustomerID);
-- �ε��� ��ȣ
SELECT index_id name FROM sys.indexes WHERE object_id = object_id('TestOrders')

-- �ε��� ��ȸ
DBCC IND('Northwind', 'TestOrders', 2)

--			1128
--	1088	1096	1097
-- Heap Table[ {page} {page} ]

SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SET STATISTICS PROFILE ON;

-- �⺻ Ž��
SELECT *
FROM TestOrders
WHERE CustomerID = 'QUICK';

-- �ε��� ���� ���
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK';

-- Orders_Index01 �� Ŀ���ϴ� �ε����� CustomerID ���̱� ������ ShipVia = 3�� 8���� �����ߴ�
-- ShipVia�� �������� �� �� �����Ƿ� Lookup�� �������� �����ϰ� �� ��
-- �ε����� Ȱ���ߴµ��� ���� ���, Index Seek ���� Index Scan�� ���� ����.
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

DROP INDEX TestOrders.Orders_Index01;

-- ����� ���̱� ���� ���θ�
-- Covered Index, Ȱ���ϰ� ���� �����͸� ��� �ε����� �ϴ� ��
CREATE NONCLUSTERED INDEX Orders_Index01 ON TestOrders(CustomerID, ShipVia);

-- 8�� ��� �õ��ϰ� ���� �¾���
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- Q) �׷� ����1 AND ����2 ��, INDEX(����1, ����2) �߰��ϸ� �嶯?
-- A) NO! �� �׷��� �ʴ�. DML(Insert, Update, Delete)�� ��������.


DROP INDEX TestOrders.Orders_Index01;

-- ����� ���̱� ���� ���θ�
-- CustomerID�� �������� NonClustered Index�� ���������� RID���� ShipVia�� ��Ʈ�� ����� ��.
--
--			1128
--	1088(data1(shipvia=2), data2(shipvia=3)...)	1096	1097 �̷���

CREATE NONCLUSTERED INDEX Orders_Index01 ON TestOrders(CustomerID) INCLUDE (ShipVia);

-- 8�� ��� 8�� �� �� ����
SELECT *
FROM TestOrders WITH(INDEX(Orders_Index01))
WHERE CustomerID = 'QUICK' AND ShipVia = 3;

-- ��ó�� �ص� ���� ���ٸ�
-- Clustered Index Ȱ���� ���, �׷��� Clusterd Index�� ���̺�� 1���� ��� �����ϴ�.