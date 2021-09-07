USE Northwind;

-- 복합 인덱스 컬럼 순서
-- Index(A, B, C)

SELECT *
INTO TestOrders
FROM Orders

DECLARE @i INT = 1;
DECLARE @emp INT;
SELECT @emp = MAX(EmployeeID) FROM Orders;

-- 더미 데이터 (830 * 1000)
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

-- 비교
SELECT *
FROM TestOrders WITH(INDEX(idx_emp_ord))
WHERE EmployeeID = 1 AND OrderDate = '19970101' -- CONVERT(DATETIME, '19970101') 해도됨

SELECT *
FROM TestOrders WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate = '19970101' -- CONVERT(DATETIME, '19970101') 해도됨

-- 성능이 같은 이유 확인
SELECT *
FROM TestOrders
ORDER BY EmployeeID, OrderDate

SELECT *
FROM TestOrders
ORDER BY OrderDate, EmployeeID

-- 범위로 찾는다면?
SELECT *
FROM TestOrders WITH(INDEX(idx_emp_ord))
WHERE EmployeeID = 1 AND OrderDate BETWEEN '19970101' AND '19970103'

SELECT *
FROM TestOrders WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate BETWEEN '19970101' AND '19970103'

-- 성능이 다른 이유 확인
SELECT *
FROM TestOrders
ORDER BY EmployeeID, OrderDate

SELECT *
FROM TestOrders
ORDER BY OrderDate, EmployeeID

-- [!] INDEX(a, b, c)로 구성되었을 때, 선행(a)에 between 사용 시 후행(b, c)는 인덱스 기능을 잃는다.
-- 그럼 인덱스 순서만 바꿔주면 될까? -> NO

-- BETWEEN 범위가 작을 때 -> IN-LIST 사용을 고려
SET STATISTICS PROFILE ON

-- 안좋은 상황(between 사용으로 인해 후행의 인덱스가 쓸모없어진 경우)에서 성능이 올라갈 수 있음
SELECT *
FROM TestOrders WITH(INDEX(idx_ord_emp))
WHERE EmployeeID = 1 AND OrderDate IN ('19970101', '19970102', '19970103')

-- 항상 성능이 올라가는건 아님
SELECT *
FROM TestOrders WITH(INDEX(idx_emp_ord))
WHERE EmployeeID = 1 AND OrderDate IN ('19970101', '19970102', '19970103')

-- 복합 컬럼 인덱스 만들 시 (선행, 후행) 순서가 성능에 영향을 줄 수 있음
-- BETWEEN, 부등호( >, <)가 선행에 들어가면, 후행은 인덱스 기능을 상실
-- BETWEEN 범위가 적으면 IN-LIST로 대체하면 좋은 경우도 있다.
-- 선행 =, 후행 BETWEEN 일 때는 문제가 없다.