USE Northwind;

-- Hash(�ؽ�) ����

DROP TABLE TestAccess
DROP TABLE TestEmployees
DROP TABLE TestOrderDetails
DROP TABLE TestOrders

SELECT * INTO TestOrders FROM Orders
SELECT * INTO TestCustomers FROM Customers

SELECT * FROM TestOrders	-- 830
SELECT * FROM TestCustomers	-- 91

-- NL (outer���̺�(TestOrders)�� �����͸� ��ȸ�ϸ� ���ǿ� �´� inner ���̺�(TestCustomerS)�� Ȯ���Ϸ������� �ε����� ����)
SELECT * 
FROM TestOrders AS o
	INNER JOIN TestCustomers AS c
	ON o.CustomerID = c.CustomerID
	OPTION (FORCE ORDER, LOOP JOIN)


-- Merge (outer, inner���̺� ��� sort��Ű��, ������ Ű�� ������� �����Ƿ� many to many = true�̴�. ��ȿ����)
SELECT * 
FROM TestOrders AS o
	INNER JOIN TestCustomers AS c
	ON o.CustomerID = c.CustomerID
	OPTION (FORCE ORDER, MERGE JOIN)

	

-- Hash
-- �����Ͱ� ���� ���� �ؽ����̺�� ����°��� ���� ȿ����. �ؽ����̺��� ����� ������ ũ�� ������
-- TestCustomer�� 91���� TestOrders 830���� ���� �����Ƿ� TestCustomer�� ���� �ؽ����̺� ����
SELECT * 
FROM TestOrders AS o
	INNER JOIN TestCustomers AS c
	ON o.CustomerID = c.CustomerID

-- ���
-- Hash ����
-- 1) ������ �ʿ����� �ʴ� -> �����Ͱ� �ʹ� ���Ƽ� Merger�� �δ㽺���� ��, �ؽð� ����� �� �� �ִ�.
-- 2) �ε��� ������ ������ ���� �ʴ´�
	-- NL/Merge�� ���� ������ ũ��.
	-- �׷��� HashTable�� ����� ����� �����ϸ� �ȵȴ�. (����󵵰� ������ �ᱹ Index�� �� ����.)
-- 3) Random Access ���ַ� ������� �ʴ´�.
-- 4) �����Ͱ� ���� ���� HashTable�� ����� ���� �����ϴ�.