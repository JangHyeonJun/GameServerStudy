
	--SELECT nameFirst AS name, nameLast, birthYear, birthCountry, weight
	--FROM players
	--WHERE birthYear = 1974 OR [birthCountry] != 'USA') AND weight > 185 -- AND�� OR���� �켱������ ���� ��ȣ�� ���μ� �켱���� �������

	--SELECT *
	--FROM players
	--WHERE deathYear IS NULL -- NULL�� �񱳱����� �� �� ���� IS, NOT IS NULL �� ����ؾ� �Ѵ�.

	SELECT *
	FROM players
	WHERE birthCity LIKE 'New%'

	-- % ������ ���ڿ�
	-- _ ������ ���� 1��

--SELECT nameFirst AS name, nameLast, birthYear
--FROM players
--WHERE birthYear = 1866

-- FROM å�󿡼� SELECT ~�� ������ּ���