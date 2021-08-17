--PL/SQL
--PROCEDUAL LANGUAGE EXTENSION TO SQL
--SQL에서 확장된 형태의 스크립트 언어
--변수, 조건, 반복, 예외

--구조
--선언부, 실행부, 예외처리
-- 선언부 : DECLARE, 변수 선언 부분
-- 실행부 : BEGIN, 제어문, 반복문, 함수 정의 등의 내용을 작성하는 부분
-- 예외처리부 : EXCEPTION, 예외 발생 시 처리할 내용을 작성하는 부분


-- 뷰 : SELECT 문을 저장해서 필요할 때마다 사용, 가상의 테이블
-- 프로시저 : PL/SQL 문을 저장해서 사용, 함수

-- 실행부를 사용해서 간단한 문장 출력
BEGIN
	DBMS_OUTPUT.PUT_LINE('Hello World');	
	DBMS_OUTPUT.PUT_LINE('Bye World');	
END;

SET SERVEROUTPUT ON;

--변수의 선언과 초기화, 출력
--[1] 일반변수
DECLARE
	vid NUMBER;
BEGIN
	SELECT EMP_ID
	INTO vid
	FROM EMPLOYEE
	WHERE EMP_NAME = '정중앙';	
	DBMS_OUTPUT.PUT_LINE('ID='||vid);
EXCEPTION
	WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO DATA!!');
END;


-- PL/SQL에서의 값 대입은 := 으로 행함
DECLARE
	v_empno NUMBER;
	v_empname VARCHAR2(10);
	test NUMBER(5) := 10*20;
BEGIN
	v_empno := 1001;
	v_empname := '강동희';
	DBMS_OUTPUT.PUT_LINE(v_empno||'   '||v_empname);
	DBMS_OUTPUT.PUT_LINE(test);
END;

--[2] 레퍼런스 변수
--(1) %TYPE : 한 컬럼의 자료형을 받아 올때 사용하는 자료형
DECLARE
	EMP_ID EMPLOYEE.EMP_ID%TYPE;
	EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
	DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE;
	SALARY EMPLOYEE.SALARY%TYPE;
BEGIN
	SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
	INTO EMP_ID,EMP_NAME,DEPT_CODE,SALARY
	FROM EMPLOYEE
	WHERE EMP_NAME='정중앙';
	DBMS_OUTPUT.PUT_LINE('EMP_ID: '|| EMP_ID);
	DBMS_OUTPUT.PUT_LINE('EMP_NAME: '||EMP_NAME);
	DBMS_OUTPUT.PUT_LINE('DEPT_CODE: '|| DEPT_CODE);
	DBMS_OUTPUT.PUT_LINE('SALARY: '|| TO_CHAR(SALARY,'L99,999,999'));
END;

SELECT * FROM EMPLOYEE;
--(2) %ROWTYPE : 한 테이블의 모든 컬럼의 자료형을 참조할 때 사용하는 타입

DECLARE
	myrow EMPLOYEE%ROWTYPE;
BEGIN
	SELECT *
	INTO myrow
	FROM EMPLOYEE
	WHERE EMP_NAME='정중앙';
	DBMS_OUTPUT.PUT_lINE(myrow.emp_id || ',' ||myrow.emp_name);
END;

--IF문--
--1. IF ~ THEN ~ END IF 문
BEGIN
	IF '이창진'='이창진' THEN DBMS_OUTPUT.PUT_LINE('같구나');
	END IF;
END;

--실습1.
--사번이 208인 사원의 사번, 이름, 급여, 보너스를 출력
--JOB_CODE가 J2인 사원은 '저희회사 대표님입니다.'를 추가로 출력

DECLARE
	EMP_ID EMPLOYEE.EMP_ID%TYPE;
	EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
	SALARY EMPLOYEE.SALARY%TYPE;
	BONUS EMPLOYEE.BONUS%TYPE;
	JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
BEGIN
	SELECT EMP_ID,EMP_NAME, SALARY,NVL(BONUS,0),JOB_CODE
	INTO EMP_ID,EMP_NAME, SALARY,BONUS,JOB_CODE
	FROM EMPLOYEE
	WHERE EMP_ID='202';
	DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP_ID);
	DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP_NAME);
	DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
	DBMS_OUTPUT.PUT_LINE('보너스 : ' || BONUS*100||'%');
	IF JOB_CODE = 'J2'
		THEN DBMS_OUTPUT.PUT_LINE('저희회사 대표님입니다.');
	END IF;
END;

--2. IF ~ THEN ~ ELSE ~ END IF;
-- 201인 사원의 사번, 이름, 부서명, 직급명, 소속을 출력
-- 소속은 J1= 대표, 그 외에는 일반직원으로 출력 되게

DECLARE
	EMP_ID EMPLOYEE.EMP_ID%TYPE;
	EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
	DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
	JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
	JOB_NAME JOB.JOB_NAME%TYPE;
	EMP_TEAM VARCHAR2(20);
BEGIN
	SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME, DEPT_TITLE
	INTO EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME, DEPT_TITLE
	FROM EMPLOYEE
	LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	JOIN JOB USING(JOB_CODE)
	WHERE EMP_ID=202;
	IF JOB_CODE = 'J2' THEN EMP_TEAM:='대표';
	ELSE EMP_TEAM := '일반사원';
	END IF;
	DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP_ID);
	DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP_NAME);
	DBMS_OUTPUT.PUT_LINE('부서명 : ' || DEPT_TITLE);
	DBMS_OUTPUT.PUT_LINE('직급명 : ' || JOB_NAME);
	DBMS_OUTPUT.PUT_LINE('소속 : '|| EMP_TEAM);
END;

--3. IF ~ THEN ~ ELSIF ~ ELSE ~ END IF;
--J2인 경우 소속을 임원진이라고 출력
DECLARE
	EMP_ID EMPLOYEE.EMP_ID%TYPE;
	EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
	DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
	JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
	JOB_NAME JOB.JOB_NAME%TYPE;
	EMP_TEAM VARCHAR2(20);
BEGIN
	SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME, DEPT_TITLE
	INTO EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME, DEPT_TITLE
	FROM EMPLOYEE
	LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	JOIN JOB USING(JOB_CODE)
	WHERE EMP_ID=202;
	IF JOB_CODE = 'J1' THEN EMP_TEAM:='대표';
	ELSIF JOB_CODE = 'J2' THEN EMP_TEAM:='임원진';
	ELSE EMP_TEAM := '일반사원';
	END IF;
	DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP_ID);
	DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP_NAME);
	DBMS_OUTPUT.PUT_LINE('부서명 : ' || DEPT_TITLE);
	DBMS_OUTPUT.PUT_LINE('직급명 : ' || JOB_NAME);
	DBMS_OUTPUT.PUT_LINE('소속 : '|| EMP_TEAM);
END;

--임의로 점수를 정해서 SCORE라는 변수에 저장하고
--90점 이상이면 'A'
--75점 이상이면 'B'
--60점 이상이면 'C'
--그 이하는 'F'로 채점하여
--'입력하신 점수는 00점이며 , X 학점입니다.' 출력

DECLARE
	SCORE NUMBER;
	GRADE VARCHAR2(5);
BEGIN
	SELECT round(DBMS_RANDOM.VALUE(1,100)) 
	INTO SCORE
	FROM DUAL;
	IF SCORE >=90 THEN GRADE := 'A';
	ELSIF SCORE >= 75 THEN GRADE := 'B';
	ELSIF SCORE >= 60 THEN GRADE := 'C';
	ELSE GRADE := 'F';
	END IF;
	DBMS_OUTPUT.PUT_LINE('입력하신 점수는 '|| SCORE||'점 이며, '||GRADE||'학점입니다.');
END;

--4. CASE 문
--CASE ~ END CASE;

DECLARE
	NO NUMBER;
BEGIN
	NO := 2;
	CASE NO
		WHEN 1 THEN
			DBMS_OUTPUT.PUT_LINE('1 입니다.');
		WHEN 2 THEN
			DBMS_OUTPUT.PUT_LINE('2 입니다.');
		WHEN 3 THEN
			DBMS_OUTPUT.PUT_LINE('3 입니다.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('1,2,3이 아닙니다.');
	END CASE;		
END;


--반복문
DECLARE
	E EMPLOYEE%ROWTYPE;
BEGIN
	SELECT *
	INTO E
	FROM EMPLOYEE;
	DBMS_OUTPUT.PUT_LINE(E.EMP_ID);
END;

--LOOP, FOR, WHILE

--LOOP
-- 1~5 까지의 숫자를 LOOP로 반복하며 출력
DECLARE
	N NUMBER := 1;
BEGIN
	LOOP
		DBMS_OUTPUT.PUT_LINE(N);
		N := N+1;
		EXIT WHEN N = 10;
	END LOOP;
END;

--FOR--
--카운트용 변수는 사종 선언, 자동으로 1씩 증가
--REVERSE 1씩 감소
/*
 * FOR 카운터 변수 IN [REVERSE] 시작값 ... 종료값 LOOP
 * 		반복할 내용;
 * END LOOP;
 */

BEGIN
	FOR N IN 1..5 LOOP
		DBMS_OUTPUT.PUT_LINE(N);
	END LOOP;
END;
--반대로 실행
BEGIN
	FOR N IN REVERSE 1..5 LOOP
		DBMS_OUTPUT.PUT_LINE(N);
	END LOOP;
END;

--FOR 문을 통한 INSERT 사용
CREATE TABLE TB_TEST_FOR(
	NO NUMBER,
	TEST_DATE DATE
);

SELECT * FROM TB_TEST_FOR;

BEGIN
	FOR N IN 1..10 LOOP
		INSERT INTO TB_TEST_FOR VALUES(N,SYSDATE+N);
	END LOOP;
END;

--문제
--PL/SQL의 FOR 반복문을 이용하여 EMPLOYEE 테이블의
--200~210 사번을 가지는 사원들의
--아이디, 사원명, 이메일 출력

DECLARE
	EMP_ID EMPLOYEE.EMP_ID%TYPE;
	EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
	EMAIL EMPLOYEE.EMAIL%TYPE;
BEGIN
	FOR N IN 202..210 LOOP  --200,201 데이터가 없어서 대체
		SELECT EMP_ID, EMP_NAME, EMAIL
		INTO EMP_ID, EMP_NAME, EMAIL
		FROM EMPLOYEE
		WHERE EMP_ID=N;
		DBMS_OUTPUT.PUT_LINE('아이디 : '||EMP_ID||', 사원명 : '||EMP_NAME||', 이메일 :'||EMAIL);
	END LOOP;
END;


--WHILE
DECLARE
	N NUMBER := 5;
BEGIN
	WHILE N>0 LOOP
		DBMS_OUTPUT.PUT_LINE(N);
		N := N -1;
	END LOOP;
END;


--EXCEPTION--

BEGIN
	UPDATE EMPLOYEE
	SET EMP_ID = '201'
	WHERE EMP_ID = '202';
END;

/*
 * 오라클에서 제공하는 예외 별칭들
 *  NO_DATA_FOUND : SELECT한 결과가 하나도 없을 경우
 *  CASE_NOT_FOUND : CASE 구문 중 일치하는 결과가 하나도 없는 경우
 * 					ELSE로 그이외의 내용에 대한 처리를 하지 않았을 경우
 *  LOGIN_DENIED : 잘못된 아이디나 비밀번호를 입력했을 경우
 *  INVALID_NUMBER : 문자데이터를 숫자로 변경할 때 , 변경할 수 없는 문자인 경우
 *  DUP_VAL_ON_INDEX : UNIQUE 제약조건을 위배했을 경우
 */

BEGIN
	UPDATE EMPLOYEE
	SET EMP_ID ='202'
	WHERE EMP_ID='200';
EXCEPTION
	WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사원');
END;

--PL/SQL 객체들 --
--프로시져: PL/SQL 을 미리 저장해 놓았다가 프로시저명으로 호출하여 함수처럼 동작시키는 객체

Insert into EMPLOYEE (EMP_ID,EMP_NAME,EMP_NO,EMAIL,PHONE,DEPT_CODE,JOB_CODE,SAL_LEVEL,SALARY,BONUS,MANAGER_ID,HIRE_DATE,ENT_DATE,ENT_YN) values ('200','선동일','621230-1985634','sun_di@or.kr','01099546325','D9','J1','S1',8000000,0.3,null,to_date('90/02/06','RR/MM/DD'),null,'N');
Insert into EMPLOYEE (EMP_ID,EMP_NAME,EMP_NO,EMAIL,PHONE,DEPT_CODE,JOB_CODE,SAL_LEVEL,SALARY,BONUS,MANAGER_ID,HIRE_DATE,ENT_DATE,ENT_YN) values ('201','송종기','631106-1548654','song_jk@or.kr','01045686656','D9','J2','S1',6000000,null,'200',to_date('01/09/01','RR/MM/DD'),null,'N');