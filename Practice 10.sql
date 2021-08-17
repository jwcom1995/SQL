--프로시져
/*
 * CREATE [OR REPLACE] PROCEDURE 프로시져명(매개변수1 [IN/OUT/IN OUT] 자료형, 매개변수2 [MODE], 자료형 ...)
 * IS --> DECLARE(선언부)
 * 		변수 선언;
 * BEGIN
 * 		실행할 문장;
 * END;
 *  
 *  [호출 방식]
 *  EXECUTE 프로시져명(전달값, 전달값, ..);
 *  EXEC 프로시져명(전달값, 전달값, ..);
 *  
 */

--직원 정보를 모두 삭제하는 프로시저 구현

CREATE TABLE EMP_TMP
AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMP_TMP;
SELECT COUNT(*) FROM EMP_TMP;
--프로시져 생성

CREATE OR REPLACE PROCEDURE DEL_ALL_EMP() IS
BEGIN 
	DELETE FROM EMP_TMP;
	COMMIT;
END;

BEGIN
	KH.DEL_ALL_EMP;
END;

EXECUTE DEL_ALL_EMP();

DROP PROCEDURE DEL_ALL_EMP();

--FUNCTION--
--MAX, MIN, SUM COUNT
CREATE OR REPLACE FUNCTION BONUS_CALC(V_EMP_ID IN EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS
	V_SAL EMPLOYEE.SALARY%TYPE;
	V_BONUS EMPLOYEE.BONUS%TYPE;
	RESULT NUMBER;
BEGIN
	SELECT SALARY, NVL(BONUS,0)
	INTO V_SAL,V_BONUS
	FROM EMPLOYEE
	WHERE EMP_ID = V_EMP_ID;
	RESULT := V_SAL*V_BONUS;
	RETURN RESULT;
END;

SELECT EMP_NAME, SALARY, BONUS, BONUS_CALC(EMP_ID)
FROM EMPLOYEE
WHERE BONUS_CALC(EMP_ID)>10000;
