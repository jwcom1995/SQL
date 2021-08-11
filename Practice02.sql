--컬럼 값을 사용하여 계산식을 적용
SELECT EMP_NAME "사원명",
		(SALARY*12) "연봉",
		BONUS "보너스",
		(SALARY + (SALARY*BONUS))*12 "연봉총합"
FROM EMPLOYEE;

SELECT * FROM EMPLOYEE;

-- NVL() : 만약 현재 조회한 값이 NULL인 경우 별도로 설정한 값으로 변경한다.
SELECT EMP_NAME "사원명",
		(SALARY*12) "연봉",
		BONUS "보너스",
		(SALARY + (SALARY*NVL(BONUS,0)))*12 "연봉총합"
FROM EMPLOYEE;

--컬럼에 일반값 사용하기
--리터럴 : 일반 컬럼의 값처럼 원하는 값을 직접 적어 반복적으로 사용하는 표현
SELECT EMP_NAME, SALARY*12, '원' "단위"
FROM EMPLOYEE;

--DISTINCT
--만약 해당하는 값이 컬럼에 여러개 존재할 경우 중복을 제거하고 한개만조회(NULL도 포함)

SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

--실습1
--DEPARTMENT 테이블에서
--부서가 '해외영업2부'인 부서의 부서코드를 찾고,
--EMPLOYEE 테이블에서
--해당 부서의 사원들 중 급여를 200만원 보다 많이 받는 직원의
--사원, 사원명,급여를 조회하시오

SELECT EMP_ID "사번",EMP_NAME "사원명", SALARY "급여"
FROM EMPLOYEE
WHERE SALARY >= 2000000 AND 
DEPT_CODE=(SELECT DEPT_ID 
FROM DEPARTMENT
WHERE DEPT_TITLE ='해외영업2부');
								
--- 연산자 ---

-- 연결 연산자 '||'
-- 여러 컬럼의 결과나 값(리터럴)을 하나의 컬럼으로 묶을 때 사용하는 연산자
						
-- '사번'을 가진 사원의 이름은 'OOO'입니다.
SELECT EMP_ID || '을 가진 사원의 이름은' || EMP_NAME || '입니다.' AS "결과"
FROM EMPLOYEE;

SELECT EMP_ID || ',' || EMP_NAME || ',' || EMAIL AS "결과"
FROM EMPLOYEE;
									
-- 비교 연산자
-- < , > , <= , >= : 크기를 나타내는 부등호
-- = : 같다
-- !=, ^=, <> : 같지 않다


--EMPLOYEE 테이블에서 부서 코드가 'D9'이 아닌 직원들의 모든 정보를 조회
SELECT *
FROM EMPLOYEE
--WHERE DEPT_CODE != 'D9';
--WHERE DEPT_CODE ^= 'D9';
WHERE DEPT_CODE <> 'D9';

--EMPLOYEE 테이블에서
--급여가 350만원 이상 550만원 이하인
--직원의 사번, 사원명, 부서코드, 직급코드, 급여정보 를 조회

--1.
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_CODE 부서코드, JOB_CODE 직급코드, SALARY 급여정보
FROM EMPLOYEE
WHERE SALARY >=3500000 AND SALARY <=5500000
--ORDER BY SALARY ASC;  --오름차순
ORDER BY SALARY DESC;  --내림차순

--2. BETWEEN A AND B
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_CODE 부서코드, JOB_CODE 직급코드, SALARY 급여정보
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 5500000
ORDER BY SALARY ASC;

--EMPLOYEE 테이블에서
--급여가 350만원 미만 550만원 초과
--직원의 사번, 사원명, 부서코드, 직급코드, 급여정보 를 조회

--1.
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_CODE 부서코드, JOB_CODE 직급코드, SALARY 급여정보
FROM EMPLOYEE
WHERE SALARY <3500000 AND SALARY >5500000
ORDER BY SALARY ASC;

--2. NOT BETWEEN A AND B
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_CODE 부서코드, JOB_CODE 직급코드, SALARY 급여정보
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 3500000 AND 5500000
ORDER BY SALARY ASC;

-- LIKE : 입력한 숫자, 문자가 포함된 정보를 조회할 때 사용하는 연산자
-- '_' : 임의의 한 문자
-- '%' : 몇자리 문자든 관계 없이

--사원이름 가운데 '중'이 들어가는 사원 정보 조회하기
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_중_';

--EMPLOYEE 테이블에서
--주민등록번호 기준 여성인 사원의 정보만 조회
SELECT *
FROM EMPLOYEE
WHERE EMP_NO LIKE '______-2%';


--사원 중 이메일 아이디가 5글자를 초과하는 사원의 사원명, 사번, 이메일 정보 조회
SELECT EMP_NAME, EMP_ID, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '______%@%';

-- 사원 중 이메일 4번째가 '_'인 사원의 정보 조회
-- ESCAPE문자를 선언하여 뒤에 오는 문자를 특수 문자가아닌 일반 문자로 선언할 수 있다.
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '___#_%@%'ESCAPE '#';

-- IN 연산자
-- IN(값1, 값2, 값3, 값4, ...)
-- 괄호 안에 잇는 값 중 하나라도 일치하는 경우 해당 값을 조회

--부서코드가 D1이거나 D6인 부서 직원 정보를 조회
-- DEPT_CODE = 'D1' OR DEPT_CODE='D6'
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D1','D6');

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('D1','D6');


--연산자의 우선순위
--0. ( )
--1. 산술연산자(+,-,*,/)
--2. 연결연산자
--3. 비교연산자
--4. IS NULL/ IS NOT NULL, LIKE, IN/NOT IN
--5. BETWEEN A AND BEFORE 
--6. NOT
--7. AND
--8. OR

--------------------------------------------------------------

-- 함수 (Function) --
--문자 관련 함수

--LENGTH / LENGTHB
--LENGTHB는 파이트 크기를 알려줌

SELECT LENGTH ('hello'),
		LENGTHB('hello')
FROM EMPLOYEE;

SELECT LENGTH ('홍길동'),
		LENGTHB('홍길동')
FROM DUAL;

-- INSTR : 주어진 값에서 원하는 문자가 몇번째인지 찾아 반환하는 함수
SELECT  INSTR('ABCD','A'),
INSTR('ABCD','C'),
INSTR('ABCD','Z')
FROM DUAL;

-- SUBSTR : 주어진 문자열에서 특정 부분만 꺼내어 오는 함수
SELECT 'Hello World',SUBSTR('Hello World',1,5),
		SUBSTR('Hello World',7)
FROM DUAL;



--실습 2.
--EMPLOYEE 테이블에서
--사원들의 이름과, 이메일을 조회
--이메일은 아이디 부분만 조회하기
--조회 결과 --
-- 이창진 lee_cj

SELECT EMP_NAME 이름, SUBSTR(EMAIL,1,INSTR(EMAIL ,'@')-1) 이메일아이디
FROM EMPLOYEE;

--LPAD / RPAD
--빈칸을 지정한 문자로 채우는 함수
SELECT LPAD(EMAIL ,20,'#')
FROM EMPLOYEE;

SELECT RPAD(EMAIL ,20,'-')
FROM EMPLOYEE;

-- LTRIM/ RTRIM
-- 컬럼 값이나, 특정 값으로 부터 특정 문자를 찾아 지워주는 함수
-- 찾을 문자를 지정하지 않으면 빈칸을 지운다.
SELECT LTRIM('          Hello')
FROM DUAL;

SELECT RTRIM('Hello         ')
FROM DUAL;

SELECT LTRIM('012345','0'),
		LTRIM('1111234','1'),
		LTRIM('54321','1')
FROM DUAL;

-- TRIM
-- 주어진 문자열에서 양끝을 기준으로 특정 문자를 지워주는 함수

SELECT TRIM('1' FROM '12345154321')
FROM DUAL;

SELECT TRIM(LEADING'1' FROM '12345154321')	--LTRIM 과 같은결과
FROM DUAL;

SELECT TRIM(TRAILING'1' FROM '12345154321')	--RTRIM 과 같은결과
FROM DUAL;

SELECT TRIM(BOTH'1' FROM '12345154321')		--TRIM과 같은결과
FROM DUAL;


-- LOWER/ UPPER/ INITCAP

SELECT LOWER('NICE TO MEET YOU'), 
		UPPER('nice to meet you'),
		INITCAP('nice to meet you') 
FROM DUAL;

-- CONCAT : 여러 문자열을 하나의 문자열로 합치는 함수
SELECT CONCAT('오라클',' 너무 재밌어요 : ')
FROM DUAL;

SELECT '오라클'||' 너무 재밌어요 : '
FROM DUAL;


--REPLACE : 주어진 문자열에서 특정 문자를 변경할 때 사용하는 함수
SELECT REPLACE ('HELLO WORLD','HELLO','BYE')
FROM DUAL;

--실습3
--EMPLOYEE 테이블에서
--사원의 주민번호를 확인하여
--생년 월일 생일을 각각 조회하시오.
--이름		| 생년	| 생월	|생일
--홍기롣		|95년	|04월	|08일

SELECT EMP_NAME 이름, SUBSTR(EMP_NO,1,2)||'년' "생년",
SUBSTR(EMP_NO,3,2)||'월' "생월",SUBSTR(EMP_NO,5,2)||'일' "생일"
FROM EMPLOYEE;

--SUBSTR을 활용하면 날짜 데이터도 자를 수 있다.

SELECT EMP_NAME 이름, SUBSTR(HIRE_DATE ,1,2)||'년' "입사년도",
SUBSTR(HIRE_DATE ,4,2)||'월' "입사월",SUBSTR(HIRE_DATE ,7,2)||'일' "입사일"
FROM EMPLOYEE;

--실습4
--EMPLOYEE 테이블에서
--모든 사원의 사번, 사원명, 이메일, 주민번호를 조회
--이때 , 이메일 '@' 전까지 , 주민번호는 7번째 자리 이후 '*' 처리하자.

SELECT EMP_ID 사번, EMP_NAME 사원명, 
		SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1) 이메일,
		RPAD(SUBSTR(EMP_NO,1,8),14,'*') 주민번호
FROM EMPLOYEE
ORDER BY 2;

--실습5
--EMPLOYEE 테이블에서 현재 근무하는
--여성 사원의 사번, 사원명, 직급코드, 퇴사여부를 조회,
--ENT_YN : 현재 근무 여부 파악하는 컬럼(퇴사여부, 퇴사했으면 'Y')
--WHERE 절에서도 함수 사용 가능

SELECT EMP_ID 사번, EMP_NAME 사원명, JOB_CODE 직급코드, ENT_YN 퇴사여부
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)=2 AND ENT_YN='N'; 

SELECT * FROM EMPLOYEE;

--단일행 함수 (Single Row Function)

-- 다중행 함수(Multiple Row Function)
-- 그룹함수 (Group Function)
-- SUM(), AVG(), MAX(), MIN(), COUNT()
