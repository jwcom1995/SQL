-- 다중행 함수(Multiple Row Function)
-- 그룹함수 (Group Function)
-- SUM(), AVG(), MAX(), MIN(), COUNT()

--SUM() : 해당 컬럼들의 합계
SELECT SUM(SALARY) FROM EMPLOYEE;

--AVG() : 해당 컬럼들의 평균을 계산
SELECT AVG(SALARY) FROM EMPLOYEE;

--MAX() : 해당 컬럼들의 값 중 최대값
--MIN() : 해당 컬럼들의 값 중 최소값
SELECT MAX(SALARY), MIN(SALARY) FROM EMPLOYEE;

--실습1.
--EMPLOYEE 테이블에서 '해외영업1부'에 근무하는 모든 사원의
--평균급여, 가장 높은 급여, 가장 낮은 급여, 급여 합계 조회하기

SELECT AVG(SALARY) 평균급여, MAX(SALARY) 최대급여, MIN(SALARY) 최소급여, SUM(SALARY) 급여합계
FROM EMPLOYEE
WHERE DEPT_CODE ='D5';

--COUNT : 행의 개수
SELECT COUNT(*), COUNT(DEPT_CODE), COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

--BONUS가 NULL인 사원 조회
SELECT *
FROM EMPLOYEE
WHERE BONUS IS NULL;

--MANAGER_ID가 NULL이 아닌 사원 조회
SELECT *
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

--날짜 처리 함수
--SYSDATE : 현재 컴퓨터와 날짜를 반환하는 함수
SELECT SYSDATE FROM DUAL;

--두 날짜 사이의 개월 수--
--MONTHS_BETWEEN(날짜1, 날짜2)
SELECT HIRE_DATE "입사일", MONTHS_BETWEEN(SYSDATE,HIRE_DATE) "입사 후 개월 수"
FROM EMPLOYEE;

--ADD_MONTHS(날짜, 개월 수)
SELECT ADD_MONTHS(SYSDATE, 6) FROM DUAL;

--EXTRACT(YEAR|MONTH|DAY FROM 날짜 데이터) : 지정한 날짜로부터 날짜값을 추출
SELECT EXTRACT (YEAR FROM HIRE_DATE),
		EXTRACT(MONTH FROM HIRE_DATE),
		EXTRACT (DAY FROM HIRE_DATE)
FROM EMPLOYEE;

--형변환 함수--
--TO_DATE(), TO_CHAR(), TO_NUMBER()

--TO_CHAR()
--TO_CHAR를 이용해서 날짜 정보 변경
SELECT HIRE_DATE,
		TO_CHAR(HIRE_DATE, 'YYYY-MM-DD'),
		TO_CHAR(HIRE_DATE, 'YY-MON-DD')
FROM EMPLOYEE;

--숫자 정보 변경
-- 0 : 남은 자리는 0으로 표시
-- 9 : 남은 빈 칸은 표시하지 않는다.
-- L : 통화 기호
SELECT SALARY,
		TO_CHAR(SALARY, 'L999,999,999'),
		TO_CHAR(SALARY, '000,000,000'),
		TO_CHAR(SALARY, 'L999,999')
FROM EMPLOYEE;

--TO_DATE()--
SELECT 20210726, 
		TO_DATE(20210726, 'YYYYMMDD'),
		TO_DATE(20210726, 'YYYY/MM/DD')
FROM DUAL;

--DECODE() --
-- JAVA의 3항 연산자
-- DECODE(컬럼|데이터, 비교값1, 결과1, 비교값2, 결과2, .... , 기본값)

-- 현재 근무하는 직원들의 성별을 남, 여로 구분
SELECT EMP_NAME, EMP_NO,
		DECODE(SUBSTR(EMP_NO,8,1), '2', '여','1','남') 성별
FROM EMPLOYEE
ORDER BY 성별 DESC;

--실습2
--EMPLOYEE 테이블에서 모든 직원의 사번, 사원명, 부서코드, 직급코드, 근무여부, 관리자 여부를 조회
--관리자 여부는 MANAGER_ID가 있으면 사원, 없으면 관리자

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE,
		DECODE(ENT_YN,'Y','퇴사자','근무자') 근무여부,
		DECODE(MANAGER_ID,NULL,'관리자','사원') 관리자
		--DECODE(NVL(MANAGER_ID,0),0,'관리자','사원')
FROM EMPLOYEE;


--CASE 문--
--자바의 IF, SWITCH 처럼 사용할 수 있는 함수
--CASE
-- WHEN (조건식1) THEN 결과값
-- WHEN (조건식2) THEN 결과2
-- ELSE 결과값3
-- END

SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_CODE 부서코드, JOB_CODE 직급코드,
 		CASE
 		 WHEN ENT_YN = 'Y' THEN '퇴사자'
 		 ELSE '근무자'
 		END "근무 여부",
 		CASE
 		 WHEN MANAGER_ID IS NULL THEN '관리자'
 		 ELSE '사원'
 		END "관리자 여부"
 FROM EMPLOYEE;

--숫자 데이터 함수--
--ABS() : 절대값 표현
SELECT ABS(10), ABS(-10)
FROM DUAL;

--MOD() : 나버지를 반환하는 함수
SELECT MOD(10,3) , MOD(10,2)
FROM DUAL;

--ROUOND() : 지정한 숫자를 반올림
SELECT ROUND(123.456,0),
		ROUND(123.456,1),		
		ROUND(123.456,2),
		ROUND(123.456,-2)
FROM DUAL;

--CEIL() : 소수점 첫째 자리에서 올림
--FLOOR() : 소수점 이하 자리의 숫자 버림
SELECT CEIL(123.456),
		FLOOR(123.456)
FROM DUAL;

--TRUNC() : 지정한 위치까지 숫자를 버리는 함수
SELECT TRUNC(123.456,0),
		TRUNC(123.456,1),
		TRUNC(123.456,2)
FROM DUAL;

--실습3
--EMPLOYEE 테이블에서 입사한 달의 숫자가 홀수 달인 직원의
--사번, 사원명, 입사일을 조회

SELECT EMP_ID 사번, EMP_NAME 사원명, HIRE_DATE 입사일
FROM EMPLOYEE
WHERE MOD(SUBSTR(HIRE_DATE,5,1),2)=1;

--날짜--
-- SYSDATE:
-- SYSTIMESTAMP: 좀더 정확한 시간
SELECT SYSDATE, SYSTIMESTAMP
FROM DUAL;

--NEXT_DAY(날짜, 요일) : 앞으로 다가올 가장 가까운 요일을 반환
SELECT NEXT_DAY(SYSDATE, '토요일')
		NEXT_DAY(SYSDATE, '토')
		NEXT_DAY(SYSDATE, 7)
FROM DUAL;
--1:일요일 ~ 7:토요일

--LAST_DAY():주어진 날짜의 마지막 날을 조회
SELECT LAST_DAY(SYSDATE)
FROM DUAL;

--날짜값끼리 연산 가능(+,-), 최근 날짜일수록 큰 값으로 판단
SELECT (SYSDATE - 10) 날짜1,
		TRUNC(SYSDATE- TO_DATE('20/07/26')) 날짜2
FROM DUAL;

--실습4
--EMPLOYEE 테이블에서 근무 년수가 20년 이상인 사원들의
--사번, 사원명, 부서코드, 입사일을 조회

SELECT EMP_ID 사번,EMP_NAME 사원명, DEPT_CODE 부서코드, HIRE_DATE 입사일
FROM EMPLOYEE
--WHERE TRUNC(SYSDATE-HIRE_DATE)/365 >= 20; 
WHERE MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12 >=20; 


--날짜 정보를 특정 형식으로 변경하여 조회하기
--TO_CHAR()
SELECT TO_CHAR(SYSDATE,'PM HH:MI:SS'),
		TO_CHAR(SYSDATE, 'AM HH24:MI:SS'),
		TO_CHAR(SYSDATE, 'MON DY, YYYY'),
		TO_CHAR(SYSDATE, 'YYYY-fmMM-dd DAY'),  --fm은 07일경우 7만 표기
		TO_CHAR(SYSDATE, 'YYYY-MM-dd DAY'),
		TO_CHAR(SYSDATE, 'YEAR, Q') || '분기',	--Q는 분기
		TO_CHAR(SYSDATE, 'YEAR, Q"분기"')
FROM DUAL;

--년도
-- Y / R
SELECT TO_CHAR(TO_DATE('190325','YYMMDD'),'YYYY') "결과1",
		TO_CHAR(TO_DATE('190325','RRMMDD'),'RRRR') "결과2",
		TO_CHAR(TO_DATE('800325','YYMMDD'),'YYYY') "결과3",
		TO_CHAR(TO_DATE('800325','RRMMDD'),'RRRR') "결과4"
FROM DUAL;

--YY:
--80 --> 2080
--RR: 반세기 기준
--00~50 --> 2000년대
--51~99 --> 1900년대

--TO_NUMBER() : 주어진 값을 숫자로 변경하는 함수
SELECT '123'+'456'
FROM DUAL;

SELECT '123'+'456ABC'
FROM DUAL;

SELECT TO_NUMBER('123456'),'123456'
FROM DUAL;

--ORDER BY
--SELECT를 통해 조회한 행의 결과들을 특정 기준에 맞춰 정렬
SELECT EMP_ID, EMP_NAME 이름,SALARY, DEPT_CODE
FROM EMPLOYEE
--ORDER BY EMP_ID;
--ORDER BY 이름;				--기본 정렬 기준은 ASC
--ORDER BY DEPT_CODE DESC, EMP_ID;  -- DEPT_CODE가 같을경우 EMP_ID로 정렬
ORDER BY 3 DESC; -- 컬럼의 번호로 정렬 가능


--SELECT문의 실행 순서
/*
*	5: SELECT 컬럼명 AS 별칭, 계산식, 함수식
*	1: FROM 테이블명
*	2: WHERE 조건
*	3: GROUP BY 그룹을 묶을 컬럼
*	4: HAVING 그룹에 대한 조건식, 함수식
*	6: ORDER BY 컬럼|별칭|컬럼의 순서 [ASC|DESC][,컬럼명 ..]*
*/

--GROUP BY --
-- 특정 컬럼이나 계산식을 하나의 그룹으로 묶어서 한테이블 내에서
-- 소그룹 별로 조회하고자 할때 선언하는 구문이다.
-- 부서별 평균

--전체 급여 평균
SELECT TRUNC(AVG(SALARY), -3)
FROM EMPLOYEE;
--D1평균
SELECT TRUNC(AVG(SALARY), -3)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';
--D6평균
SELECT TRUNC(AVG(SALARY), -3)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';
--그룹별
SELECT DEPT_CODE, TRUNC(AVG(SALARY), -3) 급여평균
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT JOB_CODE, AVG(SALARY)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL 
GROUP BY JOB_CODE
ORDER BY 1;

-- 실습 --
-- EMPLOYEE 테이블에서
-- 부서 별 총인원, 급여 합계, 급여 평균, 최대 급여, 최소급여를 조회
-- 조회한 다음 부서코드를 기준으로 오름차순 정렬

SELECT DEPT_CODE 부서,COUNT(*) 총인원, SUM(SALARY) 급여합계, TRUNC(AVG(SALARY),-3) 급여평균, 
			MAX(SALARY) 최대급여, MIN(SALARY) 최소급여
FROM EMPLOYEE
GROUP BY DEPT_CODE 
ORDER BY DEPT_CODE;

--실습 --
--EMPLOYEE 테이블에서 직급 코드별 보너스를 받는 사원의 수를 조회
-- 직급 코드 순으로 내림차순 정렬하여 직급코드, 보너스 받는 사원수를 조회

SELECT JOB_CODE "직급코드", COUNT(BONUS) "보너스 받는 사원수"
FROM EMPLOYEE
GROUP BY JOB_CODE 
ORDER BY 직급코드 DESC;