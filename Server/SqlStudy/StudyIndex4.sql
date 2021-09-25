USE BaseballData;

-- Sorting �� ���̱�.
-- ��������� ������ O(NLogN), DB�� ���� �����Ͱ� �ſ� ����.
-- �뷮�� �ʹ� Ŀ�� ���� �޸𸮷� Ŀ���� �ȵǸ� ��ũ���� ã�ư���. (sorting�� �ſ� ��������.)

-- Sorting�� �Ͼ ��
-- 1) SORT MERGE JOIN
-- 2) ORDER BY
-- 3) GROUP BY
-- 4) DISTINCT
-- 5) UNION
-- 6) RANKING WINDOWS FUNCTION
-- 7) MIN MAX

-- ����
-- 1) SORT MERGE JOIN : �˰��� Ư���� Merge ���� Sort�� �����Ѵ�.
-- 2) ORDER BY : ORDER BY ������ ������ �ؾ� �ϹǷ�
SELECT *
FROM players
ORDER BY college

-- 3) GROUP BY : ���踦 �ϱ� ���� 
SELECT college, COUNT(college)
FROM players
WHERE college LIKE 'C%'
GROUP BY college

-- 4) DISTINCT : �ߺ� ���Ÿ� ����
SELECT DISTINCT college
FROM players
WHERE college LIKE 'C%'

-- 5) UNION : �ߺ� ���Ÿ� ����
SELECT college
FROM players
WHERE college LIKE 'B%'
UNION
SELECT college
FROM players
WHERE college LIKE 'C%'

-- 6) ���� ������ �Լ� : ���踦 �ϱ� ����
SELECT ROW_NUMBER() OVER (ORDER BY college)
FROM players


-------------------------------------------------------

-- Index�� �� Ȱ���ϸ� ���� sorting ���� �ʾƵ� �ȴ�.
-- ���� 1)
SELECT *
FROM batting
ORDER BY playerID, yearId
-- ���� 2)
SELECT playerID, COUNT(playerID)
FROM players
WHERE playerID LIKE 'C%'
GROUP BY playerID
-- ���� 3)
SELECT ROW_NUMBER() OVER (ORDER BY playerId)
FROM players

-- �� ���̺��� ����� ���� �ߺ����� �ʴ´ٸ� UNION ��ſ� UNION ALL�� ����Ͽ� ���� sorting�� ���� �ʵ��� �Ѵ�.
-- DISTINCT �� ���������� �ߺ����� ������ ������� �ʴ´�.
SELECT college
FROM players
WHERE college LIKE 'B%'
UNION ALL
SELECT college
FROM players
WHERE college LIKE 'C%'