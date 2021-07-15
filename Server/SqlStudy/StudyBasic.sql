
	--SELECT nameFirst AS name, nameLast, birthYear, birthCountry, weight
	--FROM players
	--WHERE birthYear = 1974 OR [birthCountry] != 'USA') AND weight > 185 -- AND가 OR보다 우선순위가 높음 괄호로 감싸서 우선순위 명시하자

	--SELECT *
	--FROM players
	--WHERE deathYear IS NULL -- NULL은 비교구문을 쓸 수 없다 IS, NOT IS NULL 을 사용해야 한다.

	SELECT *
	FROM players
	WHERE birthCity LIKE 'New%'

	-- % 임의의 문자열
	-- _ 임의의 문자 1개

--SELECT nameFirst AS name, nameLast, birthYear
--FROM players
--WHERE birthYear = 1866

-- FROM 책상에서 SELECT ~을 갖고와주세요