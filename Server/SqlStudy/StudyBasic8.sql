USE Northwind;

-- ���� �ε��� �÷� ����
-- Index(A, B, C)

SELECT *
INTO TestOrders
FROM Orders

DECLARE @i INT = 1;
DECLARE @emp INT;
SELECT @emp = MAX(EmployeeID) FROM Orders;

-- ���� ������ (830 * 1000)
WHILE (@i < 1000)
BEGIN
	INSERT INTO TestOrders(CustomerID, EmployeeID, OrderDate)
	SELECT CustomerID, @emp + @i, OrderDate
	FROM Orders
	SET @i = @i + 1
END

SELECT COUNT(*)
FROM TestOrders;

CREATE NONCLUSTERED INDEX idx_emp_ord
ON TestOrders(EmployeeID, OrderDate);

CREATE NONCLUSTERED INDEX idx_ord_emp
ON TestOrders(OrderDate, EmployeeID);

SET STATISTICS TIME ON
SET STATISTICS IO ON

-- ��
SELECT *
FROM TestOrders WITH(INDEX(idx_emp_ord))
WHERE EmployeeID = 1 AND OrderDate = '19970101' -- CONVERT(DATETIME, '19970101') �ص���

SELECT *
FROM TestOrders WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate = '19970101' -- CONVERT(DATETIME, '19970101') �ص���

-- ������ ���� ���� Ȯ��
SELECT *
FROM TestOrders
ORDER BY EmployeeID, OrderDate

SELECT *
FROM TestOrders
ORDER BY OrderDate, EmployeeID

-- ������ ã�´ٸ�?
SELECT *
FROM TestOrders WITH(INDEX(idx_emp_ord))
WHERE EmployeeID = 1 AND OrderDate BETWEEN '19970101' AND '19970103'

SELECT *
FROM TestOrders WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate BETWEEN '19970101' AND '19970103'

-- ������ �ٸ� ���� Ȯ��
SELECT *
FROM TestOrders
ORDER BY EmployeeID, OrderDate

SELECT *
FROM TestOrders
ORDER BY OrderDate, EmployeeID

-- [!] INDEX(a, b, c)�� �����Ǿ��� ��, ����(a)�� between ��� �� ����(b, c)�� �ε��� ����� �Ҵ´�.
-- �׷� �ε��� ������ �ٲ��ָ� �ɱ�? -> NO

-- BETWEEN ������ ���� �� -> IN-LIST ����� ���
SET STATISTICS PROFILE ON

-- ������ ��Ȳ(between ������� ���� ������ �ε����� ��������� ���)���� ������ �ö� �� ����
SELECT *
FROM TestOrders WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate IN ('19970101', '19970102', '19970103')

-- �׻� ������ �ö󰡴°� �ƴ�
SELECT *
FROM TestOrders WITH(INDEX(idx_emp_ord))
WHERE EmployeeID = 1 AND OrderDate IN ('19970101', '19970102', '19970103')

-- ���� �÷� �ε��� ���� �� (����, ����) ������ ���ɿ� ������ �� �� ����
-- BETWEEN, �ε�ȣ( >, <)�� ���࿡ ����, ������ �ε��� ����� ���
-- BETWEEN ������ ������ IN-LIST�� ��ü�ϸ� ���� ��쵵 �ִ�.
-- ���� =, ���� BETWEEN �� ���� ������ ����.