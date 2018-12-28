\encoding UTF8
---------------------------- ESERCIZO 7 ----------------------------
-- da sistemare
SELECT IE.ID
FROM INSEROGATO IE
	JOIN CORSOSTUDI CS ON CS.ID = IE.ID_CORSOSTUDI
WHERE CS.ID = 4 AND
	CS.ABBREVIAZIONE NOT LIKE '2%'...