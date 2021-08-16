-- 오라클 객체 --
--VIEW (뷰)--
--SELECT 를 실행한 결과 화면을 담는 객체
--조회한 SELECT 문 자체를 저장하여
--호출할 때 마다 해당 쿼리를 실행하여 결과를 보여주는 객체

--[사용방법]
--CREATE [OR REPLACE] VIEW 뷰 이용 ( [OR REPLACE] 이름이 같은 뷰가 있을경우 덮어씀)
--AS 서브쿼리(뷰에서 확인할 SELECT 쿼리)


CREATE OR REPLACE VIEW V_EMP
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE;

SELECT * FROM V_EMP;

--뷰의 정보 확인
SELECT * FROM USER_VIEWS;

--

CREATE OR REPLACE VIEW V_EMP(사번, 이름, 부서, 직급)
AS SELECT EMP_ID,EMP_NAME,DEPT_CODE, JOB_CODE FROM EMPLOYEE;

SELECT * FROM V_EMP;

--실습1
--사번, 이름,직급명,부서명, 근무지역을 조회하고
--그 결과를 V_RESULTTEST_EMP라는 뷰를 만들어
--뷰를 통해 그 결과를 조회
SELECT * FROM EMPLOYEE;
SELECT * FROM LOCATION;
SELECT * FROM JOB;
SELECT * FROM DEPARTMENT;
--1)서브쿼리 준비
SELECT EMP_ID,EMP_NAME,JOB_NAME,DEPT_TITLE,LOCAL_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
LEFT JOIN LOCATION ON(LOCATION_ID=LOCAL_CODE)
LEFT JOIN JOB USING (JOB_CODE)

--2) 뷰에 대입시켜 사용하기
CREATE OR REPLACE VIEW V_RESULTTEST_EMP(사번,이름,직급명,부서명,근무지역)
AS (SELECT EMP_ID,EMP_NAME,JOB_NAME,DEPT_TITLE,LOCAL_NAME
	FROM EMPLOYEE
	LEFT JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
	LEFT JOIN LOCATION ON(LOCATION_ID=LOCAL_CODE)
	LEFT JOIN JOB USING (JOB_CODE));
	
SELECT * FROM V_RESULTTEST_EMP;

--실습2. 만들어진 VIEW를 활용하여 사번이 '205'번인 직원 정보 조회
SELECT * FROM V_RESULTTEST_EMP
WHERE 사번=205;

--VIEW를 만들때 사용한 테이블의 값이 변경되면 VIEW의 값도 변경된다
UPDATE EMPLOYEE
SET EMP_NAME = '정중앙'
WHERE EMP_ID = '205';

--뷰 삭제
DROP VIEW V_RESULTTEST_EMP;

SELECT * FROM USER_VIEWS;

--뷰에는 연산 결과도 포함하여 저장 가능
--사번, 이름, 성별, 근무년수 조회
--1) 서브쿼리
SELECT EMP_ID, EMP_NAME,
		DECODE(SUBSTR(EMP_NO,8,1),1,'남성','여성'),
		EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE;

--2) 뷰 생성
CREATE OR REPLACE VIEW V_EMP(사번,이름,성별,근무년수)
AS (SELECT EMP_ID, EMP_NAME,
		DECODE(SUBSTR(EMP_NO,8,1),1,'남성','여성'),
		EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
	FROM EMPLOYEE);

SELECT * FROM V_EMP;

--뷰를 통해 데이터 삽입,수정,삭제
CREATE OR REPLACE VIEW V_JOB
AS
SELECT * FROM JOB;

SELECT * FROM V_JOB;


--삽입
INSERT INTO V_JOB VALUES('J8','인턴');

SELECT * FROM V_JOB;
SELECT * FROM JOB;

--수정
UPDATE V_JOB 
SET JOB_NAME='알바'
WHERE JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

--삭제
DELETE FROM V_JOB 
WHERE JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;


-- 뷰에서도 데이터추가, 수정, 삭제가 가능하지만
-- 불가능한 경우
-- 1. 뷰에 정의되지 않은 커럼을 수정할 경우
-- 2. 뷰에서 보이지 않는 컬럼 중 NOT NULL 제약조건을 가진 컬럼이 있을 경우
-- 3. 산술 연산이 적용된 컬럼
-- 4. JOIN을 통해 여러 테이블을 참조할 경우
-- 5. DISTINCT를 사용하여 실제 데이터의 내용이 명확하지 않은 경우
-- 6. 그룹함수나 GROUP BY 구문을 사용하여 조회한 쿼리일 경우

--뷰에 정의되어 있지 않은 컬럼 수정할 경우
CREATE OR REPLACE VIEW V_JOB 
AS SELECT JOB_CODE FROM JOB;

SELECT * FROM V_JOB;
SELECT * FROM JOB;

--ORA-00913: too many values
INSERT INTO V_JOB
VALUES('J8','인턴');

--ORA-00904: "JOB_NAME": invalid identifier
UPDATE V_JOB 
SET JOB_NAME='이턴'
WHERE JOB_CODE='J7';

--산술 표현일 경우
CREATE OR REPLACE VIEW V_EMP_SAL
AS
SELECT EMP_ID, EMP_NAME, SALARY,
		(SALARY + SALARY*NVL(BONUS,0))*12 연봉
FROM EMPLOYEE;

SELECT * FROM V_EMP_SAL;

--ORA-01733: virtual column not allowed here
INSERT INTO V_EMP_SAL 
VALUES(999,'박창진',3000000,40000000);

--JOIN을 통해 VIEW의 정보를 수정하는 경우
CREATE OR REPLACE VIEW V_JOIN_EMP
AS
SELECT EMP_ID, EMP_NAME ,DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID);

SELECT * FROM V_JOIN_EMP;

--ORA-01776: cannot modify more than one base table through a join view
INSERT INTO V_JOIN_EMP
VALUES (911,'박창진','기술지원부');

--ORA-01779: cannot modify a column which maps to a non key-preserved table
UPDATE V_JOIN_EMP
SET DEPT_TITLE = '기술지원부'
WHERE EMP_ID=218;

--DISTINCT을 사용하는 경우
CREATE OR REPLACE VIEW V_DEPT_EMP
AS
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;

--ORA-01732: data manipulation operation not legal on this view
INSERT INTO V_DEPT_EMP 
VALUES('D0');

--그룹함수 ,GROUP BY
CREATE OR REPLACE VIEW V_GROUP_DEPT(부서,합계,평균)
AS
SELECT DEPT_CODE, SUM(SALARY) 합계, TRUNC(AVG(SALARY),-4) 평균  --그룹함수 사용한 RESULT SET을 VIEW로 참조할시 무조건 별칭선언
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT * FROM V_GROUP_DEPT;

--ORA-01733: virtual column not allowed here
INSERT INTO V_GROUP_DEPT
VALUES('D10',5000000,50000000);

--ORA-01732: data manipulation operation not legal on this view
UPDATE V_GROUP_DEPT 
SET 부서 = 'D10'
WHERE 부서 = 'D5';

--ORA-01732: data manipulation operation not legal on this view
DELETE FROM V_GROUP_DEPT 
WHERE 부서 = 'D6';

--VIEW 생성시 설정 가능한 옵션
--OR REPLACE : 기존에 동일한 이름의 뷰가 있을 경우 덮어 씌우고, 없을 경우 새로 만듬
--FORCE / NOFORCE : 서브쿼레이 사용된 테이블이 존재하지 않아도 뷰를 강제로 생성
--WITH CHECK/ READ ONLY 
-- CHECK : 옵션을 설정한 컬럼의 값을 바꾸지 못하게 하는 설정
-- READ ONLY : 뷰에 사용된 어떠한 컬럼도 뷰를 통해 변경하지 못하게 막는 설정

--FORCE : 존재하지 않는 테이블이라도 뷰를 강제로 생성

CREATE OR REPLACE FORCE VIEW V_EMP
AS
SELECT T_CODE,T_NAME,T_CONTENT
FROM TEST_TABLE; 

SELECT * FROM V_EMP;

SELECT * FROM USER_VIEWS;

--NOFORCE : 만약 생성하려는 뷰의 테이블이 존재하지 않는다면 뷰를 생성하지 않겠다.
CREATE OR REPLACE NOFORCE VIEW V_EMP
AS 
SELECT T_CODE, T_NAME
FROM TEST_TABLE;

--WITH CHECK : 뷰에 존재하는 컬럼을 추가하거나 수정하지 못하게 막는 뷰의 옵션
--제한적으로 테이블의 정보를 제공하기 위해 VIEW를 생성하는 옵션
-- ** DELETE 는 가능
CREATE OR REPLACE VIEW V_EMP 
AS
SELECT * FROM EMPLOYEE
WITH CHECK OPTION;

SELECT * FROM V_EMP;

INSERT INTO V_EMP
VALUES(888, '박창진','101010-1234567','park@kh.or.kr','01012344321','D1','J7','S1',00000000,0.1,200,SYSDATE,NULL,DEFAULT);

SELECT * FROM V_EMP;

--DELETE 는 가능
DELETE FROM V_EMP WHERE EMP_ID='900';

--WITH READ ONLY: 데이터 입력, 수정, 삭제 모두 막는 옵션
CREATE OR REPLACE VIEW V_EMP 
AS
SELECT * FROM EMPLOYEE
WITH READ ONLY;

--ROLE
--GRANT CONNECT, RESOURCE TO KH;

--SEQUENCE : 시퀀스 --
--1,2,3,4,5, .. 의 형식으로
--숫자 데이터를 자동으로 카운트하는 객체

/*
 * CREATE SEQUENCE 시퀀스명
 * [INCREMENT BY 숫자] : 다음 값에 대한 증감 수치, 생략시에는 1씩 증가
 * 		INCREMENT BY 5 : 5씩 증가 
 *		INCREMENT BY -5: 5씩 감소
 * [START WITH 숫자] : 시작값, 생략시 1부터
 * [MAXVALUE 숫자 | NOMAXVALUE ] : 최대값 설정
 * [MINVALUE 숫자 | NOMINVALUE ] : 최소값 설정
 * [CYCLE | NOCYCLE ] : 값의 순환 여부(1~100 ... 1~100)
 * [CACHE 크기 | NOCACHE] : 값을 미리 구해놓고 다음 값을 반영할 때 활용하는 설정
 * --   기본값 20BYTE 
 *
 */	

CREATE SEQUENCE SEQ_EMPID
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

--NEXTVAL
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;

--현재 시퀀스 확인
SELECT SEQ_EMPID.CURRVAL FROM DUAL;

--시퀀스 설정 변경하기
ALTER SEQUENCE SEQ_EMPID
--START WITH 320 --스타트 넘버는 변경 불가능
INCREMENT BY 10
MAXVALUE 400
NOCYCLE
NOCACHE;

--DML에서 많이 사용
SELECT SEQ_EMPID.NEXTVAL FROM DUAL;

--시퀀스 삭제하기
DROP SEQUENCE SEQ_EMPID;

--시퀀스를 활용하여 데이터 추가
CREATE SEQUENCE SEQ_EID
START WITH 300
MAXVALUE 10000
NOCYCLE
NOCACHE;

--데이터 추가
INSERT INTO EMPLOYEE
VALUES(SEQ_EID.NEXTVAL, '김대원','121212-1234567','kim_dw@kh.or.kr','01012344321','D1','J7','S1',00000000,0.1,200,SYSDATE,NULL,DEFAULT);

SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '김대원';

INSERT INTO EMPLOYEE
VALUES(SEQ_EID.NEXTVAL, '서창윤','121212-1112222','seo_cy@kh.or.kr','01012344321','D1','J7','S1',00000000,0.1,200,SYSDATE,NULL,DEFAULT);

SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '서창윤';  --값을 넣다가 오류가 발생해도 시퀀스는 작동하여 값이 바뀜

--CYCLE / CACHE
--CYCLE : 시퀀스의 값이 최소값 OR 최대값에 도달 했을 때 다시 반대의 값부터 시작하는 옵션
CREATE SEQUENCE SEQ_CYCLE
START WITH 200
INCREMENT BY 10
MAXVALUE 230
MINVALUE 15
CYCLE
NOCACHE;

SELECT SEQ_CYCLE.NEXTVAL FROM DUAL;

--CACHE / NOCACHE
--CACHE : 컴퓨터가 다음 값에 대한 연슨들을 그때 그때 수행하지 않고
--	   	  미리 계산해 놓는것
--NOCACHE : 컴퓨터가 수행할 값을 그때 그때 처리하는 것

CREATE SEQUENCE SEQ_CACHE
START WITH 100
CACHE 20
NOCYCLE;

SELECT SEQ_CACHE.NEXTVAL FROM DUAL;

SELECT * FROM USER_SEQUENCES;

