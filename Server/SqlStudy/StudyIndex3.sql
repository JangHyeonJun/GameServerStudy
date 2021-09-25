USE Northwind;

-- Hash(해시) 조인

DROP TABLE TestAccess
DROP TABLE TestEmployees
DROP TABLE TestOrderDetails
DROP TABLE TestOrders

SELECT * INTO TestOrders FROM Orders
SELECT * INTO TestCustomers FROM Customers

SELECT * FROM TestOrders	-- 830
SELECT * FROM TestCustomers	-- 91

-- NL (outer테이블(TestOrders)에 데이터를 순회하며 조건에 맞는 inner 테이블(TestCustomerS)을 확인하려했으나 인덱스가 없다)
SELECT * 
FROM TestOrders AS o
	INNER JOIN TestCustomers AS c
	ON o.CustomerID = c.CustomerID
	OPTION (FORCE ORDER, LOOP JOIN)


-- Merge (outer, inner테이블 모두 sort시키고, 유일한 키가 보장되지 않으므로 many to many = true이다. 비효율적)
SELECT * 
FROM TestOrders AS o
	INNER JOIN TestCustomers AS c
	ON o.CustomerID = c.CustomerID
	OPTION (FORCE ORDER, MERGE JOIN)

	

-- Hash
-- 데이터가 작은 쪽을 해시테이블로 만드는것이 보통 효율적. 해시테이블을 만드는 비용또한 크기 떄문에
-- TestCustomer가 91개로 TestOrders 830개의 비해 작으므로 TestCustomer를 토대로 해시테이블 생성
SELECT * 
FROM TestOrders AS o
	INNER JOIN TestCustomers AS c
	ON o.CustomerID = c.CustomerID

-- 결론
-- Hash 조인
-- 1) 정렬이 필요하지 않다 -> 데이터가 너무 많아서 Merger가 부담스러울 때, 해시가 대안이 될 수 있다.
-- 2) 인덱스 유무에 영향을 받지 않는다
	-- NL/Merge에 비해 장점이 크다.
	-- 그러나 HashTable을 만드는 비용을 무시하면 안된다. (수행빈도가 많으면 결국 Index가 더 좋다.)
-- 3) Random Access 위주로 수행되지 않는다.
-- 4) 데이터가 적은 쪽을 HashTable로 만드는 것이 유리하다.