--Sub Query--
--메인 쿼리 안에서 조건이나 하나의 검색을 위한
--또 다른 쿼리를 추가하는 기법

--단일 행 서브쿼리 : 결과 값이 1개 나오는 서브쿼리

--ex) 최소 급여 받는 사원의 정보를 조회
SELECT MIN(SALARY)
FROM EMPLOYEE;

SELECT *
FROM EMPLOYEE
WHERE SALARY=1380000;

SELECT *
FROM EMPLOYEE
WHERE SALARY=(SELECT MIN(SALARY) FROM EMPLOYEE);

--다중 행 서브쿼리 : 결과값이 여러줄 나오는 서브쿼리

--각 직급별 최소 급여를 받는 사원 정보 조회
SELECT MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;		--결과 7줄

SELECT *
FROM EMPLOYEE
WHERE SALARY IN (SELECT MIN(SALARY)
				FROM EMPLOYEE
				GROUP BY JOB_CODE);			--결과 8줄,중복되는 코드가 있음

-- 다중 행 다중 열 서브 쿼리
SELECT JOB_CODE , MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT * 
FROM EMPLOYEE
WHERE (JOB_CODE,SALARY) IN (SELECT JOB_CODE , MIN(SALARY)	
							FROM EMPLOYEE
							GROUP BY JOB_CODE);
	
--EX) 퇴사한 여직원과 같은 직급, 같은 부서에 근무하는 직원들의 정보를 조회
SELECT *
FROM EMPLOYEE
WHERE ENT_YN ='Y';

--단일행 서브쿼리
SELECT * FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE ENT_YN ='Y')
	AND JOB_CODE =(SELECT JOB_CODE FROM EMPLOYEE WHERE ENT_YN ='Y')
	AND EMP_NAME <> (SELECT EMP_NAME FROM EMPLOYEE WHERE ENT_YN ='Y');  

--다중 열
SELECT * FROM EMPLOYEE
WHERE (DEPT_CODE,JOB_CODE) = (SELECT DEPT_CODE,JOB_CODE FROM EMPLOYEE WHERE ENT_YN='Y')
	AND EMP_NAME != (SELECT EMP_NAME FROM EMPLOYEE WHERE ENT_YN='Y');
	

--서브쿼리의 사용 위치
--SELECT , FROM ,WHERE ,GROUP BY,HAVING ,ORDER BY,JOIN
--DML: INSERT, UPDATE, DELETE
--DDL: CREATE TABLE, CREATE VIEW

--FROM 위치에 사용되는 서브쿼리는
--테이블을 테이블 명으로 직접 조회하는 대신
--서브커리의 결과 (RESULT SET)을 활용하여 조회 가능
--FROM 구문의 서브쿼리를 Inline View(인라인 뷰)라고 부른다.

--인라인뷰를 활용한 데이터 조회
SELECT * FROM EMPLOYEE;

SELECT *
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
		FROM EMPLOYEE
		JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
		JOIN JOB USING(JOB_CODE));
		
	
--TOP-N 분석조회
--맛있는 음식 상위 5개
--인기제품 상위 5개
--가장 조건에 부합하는 내용을 순위화 하여 특정 순번까지 조회하는 방식

--ROWNUM : 데이터를 조회할 때 각 행의 번호를 매겨주는 함수
	-- 테이블이 선택됬을때 바로 번호가 매겨지기 시작함
SELECT ROWNUM,EMP_NAME,SALARY
FROM EMPLOYEE;

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM<6;

--급여 기준으로 가장 높은 급여를 받는 사원
--상위 5명 조회하여
--사번,사원명,급여정보를 출력

SELECT ROWNUM,EMP_ID, EMP_NAME, SALARY
FROM (SELECT * FROM EMPLOYEE ORDER BY SALARY DESC)
WHERE ROWNUM<6;

--ROWNUM 기준 6~10번째 사원 정보 조회
SELECT ROWNUM, EMP_ID, EMP_NAME
FROM EMPLOYEE
WHRE ROWNUM>5 AND ROWNUM < 11;      --ROWNUM은 반드시 1부터 비교 시작해야함

SELECT ROWNUM, A.*
FROM (SELECT EMP_ID, EMP_NAME, SALARY
	FROM EMPLOYEE	
	ORDER BY SALARY DESC) A
WHERE ROWNUM<6;

--실습1.
--급여평균이 3위 안에 드는 부서의
--부서코드, 부서명, 급여평균을 조회
SELECT ROWNUM,A.DEPT_CODE,DEPT_TITLE,A.급여평균
FROM (SELECT DEPT_CODE,TRUNC(AVG(SALARY),-3) "급여평균" 
	FROM EMPLOYEE
	GROUP BY DEPT_CODE
	ORDER BY 2 DESC) A
JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
WHERE ROWNUM <4;


--RANK() 함수 DENSE_RANK() 함수
--RANK() : 동일한 순번이 있을 경우 이후의 순번은 이전 동일한 순번의 개수만큼 건너뛴다.(1,2,2,4,5,6)

SELECT EMP_NAME, SALARY,
		RANK() OVER (ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

--DENSE_RANK() : 동일한 순번이 있을경우 이후 순번에 영향을 미치지 않는 함수 (1,2,2,3,4,5,6)
SELECT EMP_NAME, SALARY,
		DENSE_RANK() OVER (ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

SELECT *
FROM(
	SELECT EMP_NAME, SALARY,
		DENSE_RANK() OVER (ORDER BY SALARY DESC) 순위
	FROM EMPLOYEE
	)
WHERE 순위 < 4;

--상호 여관 쿼리 : 상관쿼리
--일반적으로 서브쿼리는 서브쿼리대로, 메인쿼리는 서브쿼리의 결과만을 받아서 실행
--메인쿼리가 사용하는 컬러값, 계산식 등을 서브쿼리에 적용하여 서브쿼리 실행 시 메인쿼리 값도 함께 사용

--사원의 직급에 따른 급여 평균보다 많이 받는 사원 정보 조회
SELECT JOB_CODE, TRUNC(AVG(SALARY),-3)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_ID,EMP_NAME,JOB_CODE,SALARY
FROM EMPLOYEE E 
WHERE SALARY> (
				SELECT AVG(SALARY)
				FROM EMPLOYEE E2
				WHERE E.JOB_CODE = E2.JOB_CODE
				);

SELECT * FROM EMPLOYEE;			
--스칼라 서브쿼리
-- 단일 행 + 상관쿼리
-- SELECT, WHERE ,ORDER BY 절에 사용되며
-- SELECT 절에 많이 쓰인다.
-- SELECT LIST라고도 한다.

--모든 사원이 사번,사원명,관리자 사번,관리자명을 조회
--관리자가 없을 경우 '없음'이라고 표시
--SELECT문에 서브쿼리를 사용하는 형식으로 구현

SELECT EMP_ID, EMP_NAME, MANAGER_ID,
		(SELECT EMP_NAME FROM EMPLOYEE E2 WHERE E.MANAGER_ID = E2.EMP_ID) 관리자이름
FROM EMPLOYEE E
ORDER BY 3,1;			

SELECT * FROM JOB;
--자신이 속한 직급의 평균보다 많이 받는 사원의
--이름, 직급명,급여를 조회
SELECT EMP_NAME,JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE=J.JOB_CODE)
WHERE SALARY>(
				SELECT TRUNC(AVG(SALARY),-3) 급여
				FROM EMPLOYEE E2
				WHERE E.JOB_CODE =E2.JOB_CODE
				);
				
SELECT * FROM JOB;

--CREATE--
/*
 * CREATE : 데이터 베이스의 객체를 생성하는 DDL
 * [사용형식]
 * CREATE 객체형태 개체명 (관련내용)
 * 
 * --테이블 생성
 * CREATE TALBE TB_TEST(
 * 		컬럼 자료형(길이) 제약조건
 * );
 * 
 * 제약조건: 테이블에 데이터를 저장할 때 지켜야하는 규칙
 *	NOT NULL - NULL값을 허용하지 않는다 (필수 입력 사항) 
 *	UNIQUE - 중복 값을 허용하지 않는다.
 *	CHECK - 지정한 입력사항 외에는 받지 못하게 하는 조건
 *	PRIMARY KEY - 반드시 입력되어야 하고 중복 불가능(NOT NULL + UNIQUE)
 *				- 테이블 내에서 해당 행을 인식할 수 있는 고유의 값
 *  FOREIGN KEY - 다른 테이블에서 지정된 값을 연결 지어서 참조로 가져오는 데이터에 지정하는 제약조건
 *  
 */

CREATE TABLE MEMBER(
	MEMBER_NO NUMBER,			--회원번호
	MEMBER_ID VARCHAR2(20),   	--회원 아이디
	MEMBER_PW VARCHAR2(20),		--회원 비밀번호
	MEMBER_NAME VARCHAR2(20)	--회원 이름
);

SELECT * FROM MEMBER;
--테이블의 각 컬럼 주석 달기
--COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용'
COMMENT ON COLUMN MEMBER.MEMBER_NO IS '회원 번호';
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PW IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';

--현재 접속한 사용자 계정이 보유한 테이블 목록
SELECT * FROM USER_TABLES;

--현재 사용자 계정이 보유한 테이블 목록의 컬럼
SELECT *
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME = 'MEMBER';

--데이터사전 : 데이터베이스에서 사용자 정보등의 설정을 관리하는 테이블
SELECT *
FROM ALL_COL_COMMENTS
WHERE TABLE_NAME= 'MEMBER';

--제약조건(CONSTRAINTS)
--테이블을 생성할 때 각 컬럼에 값을 기록하는것에 대한 제약사항을 설정.
--이러한 제약조건을 통해 저장되는 값이 아무런 문제가 되지 않는다 라는 무결성을 보장할 수 있다.

--사용자 계정의 제약조건 확인
SELECT * FROM USER_CONSTRAINTS;

--테이블 별 컬럼 제약 조건 확인
SELECT * FROM USER_CONS_COLUMNS;

--제약조건
--NOT NULL
--'널 값을 허용하지 않는다.'
-- 해당 컬럼에 반드시 값을 기록해야 하는 경우
-- 데이터 삽입/수정/삭제 시에 NULL값을 허용하지 않도록 컬럼 작성시 함께 선언

DROP TABLE USER_NOCONS;

CREATE TABLE USER_NOCONS(
	USER_NO NUMBER,
	USER_ID VARCHAR2(20),
	USER_PW VARCHAR2(20),
	USER_NAME VARCHAR2(20),
	GENDER VARCHAR2(3),
	PHONE VARCHAR2(14),
	EMAIL VARCHAR2(30)
);

SELECT * FROM USER_NOCONS;

--테이블에 값 추가하기
--DML: INSERT
INSERT INTO USER_NOCONS
VALUES(1,'USER01','PASS01','이창진','남','010-1234-5678','LEE123@KH.OR.KR');

INSERT INTO USER_NOCONS
VALUES(2,NULL,NULL,NULL,'남',NULL,NULL);

SELECT * FROM USER_NOCONS;

CREATE TABLE USER_NOT_NULL(
	USER_NO NUMBER NOT NULL,
	USER_ID VARCHAR2(20) NOT NULL,
	USER_PW VARCHAR2(20) NOT NULL,
	USER_NAME VARCHAR2(20) NOT NULL,
	GENDER VARCHAR2(3),
	PHONE VARCHAR2(15),
	EMAIL VARCHAR2(30)
);

SELECT * FROM USER_NOT_NULL;

INSERT INTO USER_NOT_NULL
VALUES(1,'USER01','PASS01','이창진','남','010-1234-5678','LEE123@KH.OR.KR');

INSERT INTO USER_NOT_NULL
VALUES(2,NULL,NULL,NULL,'남',NULL,NULL);  --NOT NULL로 설정한 컬럼은 NULL값이 들어가지 않음

SELECT * FROM USER_NOT_NULL;

INSERT INTO USER_NOT_NULL
VALUES(2,'USER2','PASS2','김창진','남',NULL,NULL);  --NOT NULL 설정하지 않은 컬럼은 NULL값 가능

--UNIQUE 제약조건--
--중복을 허용하지 않는 제약조건
--컬럼에 값을 입력/수정할 때 중복을 확인하여
--중복 값이 있을 경우 값 추가/수정이 불가능 하다.

INSERT INTO USER_NOT_NULL
VALUES(1,'USER01','PASS01','이창진','남','010-1234-5678','LEE123@KH.OR.KR');

SELECT * FROM USER_NOT_NULL;  -- 중복데이터가 들어감

CREATE TABLE USER_UNIQUE(
	USER_NO NUMBER,
	USER_ID VARCHAR2(20) UNIQUE,
	USER_PW VARCHAR2(20),
	USER_NAME VARCHAR2(15)
);

INSERT INTO USER_UNIQUE
VALUES(1,'USER01','PASS01','이창진');

SELECT * FROM USER_UNIQUE;

INSERT INTO USER_UNIQUE
VALUES(1,'USER01','PASS01','이창진'); --USER_ID 값이 중복되므로 오류 발생

INSERT INTO USER_UNIQUE
VALUES(1,'ADMIN01','PASS01','이창진'); --다른 데이터는 같지만 USER_ID값이 다르므로 정상실행

SELECT *
FROM USER_CONSTRAINTS C1, USER_CONS_COLUMNS C2
WHERE C1.CONSTRAINT_NAME = C2.CONSTRAINT_NAME
	AND C1.TABLE_NAME ='USER_UNIQUE';

--CONSTRAINT_TYPE
--U : UNIQUE
--C : CHECK (NOT NULL)
--P : PRIAMARY KEY
--R : FOREIGN KEY (REFERENCE)

CREATE TABLE USER_UNIQUE2(
	USER_NO NUMBER,
	--USER_ID VARCHAR2(20) UNIQUE,  --컬럼레벨 제약조건
	USER_ID VARCHAR2(20),
	USER_PW VARCHAR2(20),
	USER_NAME VARCHAR2(15),
	UNIQUE(USER_ID)		--테이블 레벨 제약조건 : 컬럼을 선언하는 곳이 아닌 별도로 제약조건을 선언할 경우 테이블레벨 제약조건이라고 한다.
);

INSERT INTO USER_UNIQUE2
VALUES(1,'USER01','PASS01','이창진');

INSERT INTO USER_UNIQUE2
VALUES(1,'USER01','PASS01','이창진');  --UNIQUE 제약조건이 위배(중복 허용 X)

SELECT * FROM USER_UNIQUE2;


--UNIQUE 제약조건을 여러개 컬럼에 적용하기
-- D1	200
-- D1	201
-- D2 	200
-- D2	201
-- 두 개 이상의 컬럼을 제약조건으로 묶을 경우
-- 반드시 테이블 레벨에서 제약조건을 선언

CREATE TABLE USER_UNIQUE3(
	USER_NO NUMBER,
	USER_ID VARCHAR2(20),
	USER_PW VARCHAR2(20),
	USER_NAME VARCHAR2(15),
	UNIQUE(USER_NO, USER_ID)
);

INSERT INTO USER_UNIQUE3 VALUES(1,'USER01','PASS01','홍길동');
INSERT INTO USER_UNIQUE3 VALUES(1,'USER02','PASS02','고길동'); --UNIQUE 제약조건이 USER_NO와 USER_ID 둘다 고려해야되기 때문에 오류없이 실행
INSERT INTO USER_UNIQUE3 VALUES(2,'USER01','PASS03','박길동'); --위와 같은 이유로 정상 실행
INSERT INTO USER_UNIQUE3 VALUES(2,'USER02','PASS02','이길동'); 

SELECT * FROM USER_UNIQUE3;