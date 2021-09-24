USE BaseballData;

SET STATISTICS TIME ON
SET STATISTICS IO ON
SET STATISTICS PROFILE ON

-- NonClustered
--		1
--	2	3	4

-- Merge(����) ���� = Sort Merge(���� ����) ����
-- Merge ���ε� ������ �ٴ´� (One-To-Many == outer�� unique�ؾ� �� => PK, Unique)
-- ������ NonClustered �ε����� Random Access���� �ʰ� Clustered Scan �� ������ ������
-- Many to Many = true


SELECT *
FROM players AS p
	INNER JOIN salaries AS s
	ON p.playerID = s.playerID


-- NonClustered �ε����� ����Ѵ�.
-- Many to Many = false

SELECT *
FROM schools AS s
	INNER JOIN schoolsplayers AS p
	ON s.schoolID = p.schoolID;

-- ���
-- Merge

-- 1) ���� ������ Sort(����)�ϰ� Merge(����)�Ѵ�
--	-- �̹� ���ĵ� ���¶�� Sort�� ���� (Ư��, Clustered�� ������ ���ĵ� ���¶�� Best)
--	-- ������ �����Ͱ� �ʹ������� Bad -> Hash�� �������
-- 2) Random Access �� ��ȣ���� �ʴ´�. �ٸ� ����� ã�Ƴ����� �Ѵ�.
-- 3) Many to Many ���ٴ� One to Many ���ο� ȿ����
	-- Outer�� PK, UNIQUE