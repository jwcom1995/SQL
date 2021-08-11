--한줄주석
/*여러줄 주석*/

--현재 계정이 가진 모든 테이블 확인
SELECT * FROM TABS;

--특젱 테이블 정보 확인
SELECT * FROM JOB;

--SELECT문 : 조회용 SQL문장
--[사용법]
--SELECT *(조회용 컬럼): 조회하고자 하는 내용
--FROM 테이블명 		: 조회하고자 하는 테이블 명
--[WHERE 조건]		: 특정 조건
--[ORDER BY 컬럼]		: 정렬
--;

-- EMPLOYEE 테이블의 모든 행과 모근 컬럼 조회
SELECT * 
FROM EMPLOYEE ;

-- EMPLOYEE 테이블에서 사원의 id, 사원명, 연락처
SELECT EMP_ID, EMP_NAME, PHONE
FROM EMPLOYEE ;

--실습--
-- EMPLOYEE 테이블에서
-- 모든 사원의 ID, 자원명, 이메일, 연락처, 부서번호 (DEPT_CODE), 직급코드(JOB_CODE)를 조회
SELECT EMP_ID, EMP_NAME, EMAIL, PHONE, DEPT_CODE,JOB_CODE
FROM EMPLOYEE ;

--WHERE
--테이블에서 조건을 만족하는 값을 가진 행을 따로 선택하여 조회하는 조건절
--여러개의 조건을 선택할 수 있다
--AND | OR 

--EMPLOYEE 테이블에서 부서코드가 'D6'인 사원 정보 모두 조회하기
SELECT * 
FROM EMPLOYEE 
WHERE DEPT_CODE ='D5';

--실습2
-- EMPLOYEE 테이블에서
-- 직급이 'J1' 인 사원의 사번, 사원명, 직급코드, 부서코드를 조회하기
SELECT EMP_NO, EMP_NAME, JOB_CODE, DEPT_CODE
FROM EMPLOYEE 
WHERE JOB_CODE ='J1';

--실습3
--EMPLOYEE 테이블에서 급여가 300만원 이상인
--사원의 아이디, 사원명, 직급코드, 급여를 조회하기
SELECT EMP_ID, EMP_NAME, JOB_CODE,SALARY
FROM EMPLOYEE
WHERE SALARY >=3000000;

--부서코드가 'D6' 이면서, 이름이 '유재식'인 사원의 모든 정보 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE ='D6' 
	AND EMP_NAME = '유재식';

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE ='D5' 
	OR EMP_NAME = '유재식';


--컬럼명에 별칭 달기
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE;

--1. AS(alias)
SELECT EMP_ID AS "사원번호",
		EMP_NAME AS "사원명"
FROM EMPLOYEE;

--2. AS 생략 
SELECT EMP_ID "사원번호",
		EMP_NAME 사원명
FROM EMPLOYEE;

-- 별칭명에 띄어쓰기,특수문자 가 들어갈 경우 ""을 사용해줘야 한다. (생략불가능)

--실습4
--EMPLOYEE 테이블에서 사원번호가 205번인 사원의
--사원명, 이메일, 급여, 입사일자를 조회 (단, 조회하는 컬럼명에 별칭 부여)
SELECT EMP_NAME 사원명, EMAIL 이메일, SALARY 급여, HIRE_DATE 입사일자
FROM EMPLOYEE
WHERE EMP_ID = 205;

--실습5
--EMPLOYEE 테이블에서 부서가 D2이거나 D1인
--사원들의 사원명, 입사명, 연락처를 조회 (단, 조회하는 컬럼명에 별칭 부여)
SELECT EMP_NAME 사원명, HIRE_DATE 입사일, PHONE 연락처
FROM EMPLOYEE
WHERE DEPT_CODE ='D2' OR DEPT_CODE ='D1';