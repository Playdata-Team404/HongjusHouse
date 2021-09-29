Rem Copyright (c) 1990 by Oracle Corporation
Rem NAME
REM    UTLSAMPL.SQL
Rem  FUNCTION
Rem  NOTES
Rem  MODIFIED
Rem	gdudey	   06/28/95 -  Modified for desktop seed database
Rem	glumpkin   10/21/92 -  Renamed from SQLBLD.SQL
Rem	blinden    07/27/92 -  Added primary and foreign keys to EMP and DEPT
Rem	rlim	   04/29/91 -	      change char to varchar2
Rem	mmoore	   04/08/91 -	      use unlimited tablespace priv
Rem	pritto	   04/04/91 -	      change SYSDATE to 13-JUL-87
Rem     Mendels	   12/07/90 - bug 30123;add to_date calls so language independent
Rem
rem
rem $Header: utlsampl.sql 7020100.1 94/09/23 22:14:24 cli Generic<base> $ sqlbld.sql
rem
SET TERMOUT OFF
SET ECHO OFF

rem CONGDON    Invoked in RDBMS at build time.	 29-DEC-1988
rem OATES:     Created: 16-Feb-83

'''
sqlplus "/as sysdba"
create user TEAM404 identified by 1234;
'''

rem 팀원 : 이현수, 이홍주, 정일균, 최한승

GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO TEAM404;
ALTER USER TEAM404 DEFAULT TABLESPACE USERS;
ALTER USER TEAM404 TEMPORARY TABLESPACE TEMP;
CONNECT TEAM404/1234

'''
activity table
uact : 활동량에 따른 구분명
val : 활동량에 따른 가중치
'''
DROP TABLE ACTIVITY;
CREATE TABLE ACTIVITY(
    UACT VARCHAR2(30) not null,
    VAL NUMBER(3,1) not null,
    constraint pk_activity_uact primary key (UACT)
    );

'''
food table
fid : 음식 코드
fname : 음식명
famount : 기준 중량
fcal ~ ffat : 칼로리 및 탄단지
'''
DROP TABLE FOOD;
CREATE TABLE FOOD(
	FID VARCHAR2(20),
	FNAME VARCHAR2(30) not null,
	FAMOUNT NUMBER(10) not null,
    FCAL NUMBER(8,1) not null,
    FCARBOH NUMBER(8,1) not null,
    FPROTEIN NUMBER(8,1) not null,
    FFAT NUMBER(8,1) not null,
    constraint pk_food_fid primary key (FID)
    );

'''
exercise table
eid : 운동 코드
ename : 운동 이름
error_name : 해당 운동에서 발생하는 잘못된 자세
'''
CREATE TABLE EXERCISE(
    EID NUMBER(2),
    ENAME VARCHAR2(30),
    ERROR_NAME VARCHAR2(30),
    constraint pk_exercise_fid primary key (FID)
)

'''
users table
uuid : 회원 아이디
upw : 회원 비밀번호
uage~urdc : 나이, 성별, 키 , 몸무게, 활동량, 적정 섭취 칼로리
'''

DROP TABLE USERS;
CREATE TABLE USERS(
	UUID VARCHAR2(30),
	UPW VARCHAR2(15) not null,
	UAGE NUMBER(3) not null,
    USEX VARCHAR2(7) not null,
	UHEIGHT NUMBER(4,1) not null,
	UWEIGHT NUMBER(4,1) not null,
    UACT VARCHAR2(30) not null,
    URDC NUMBER(5,1) not null,
    constraint pk_users_uuid primary key (UUID)
	);
    -- act 테이블에 데이터 생성 후 추가
    constraint fk_diet_act foreign key (UACT) references ACTIVITY(UACT)

'''
diet table
uuid : 회원 아이디
diet_date, diet_time,meal : 식단 섭취 날짜,시간, 종류(아침,점심,저녁,간식)
fid, fname: 음식 코드, 이름
amount ~ fat : 중량, 칼로리, 탄단지
'''
DROP TABLE DIET;
CREATE TABLE DIET(
    UUID VARCHAR2(30),
    DIET_DATE DATE,
    DIET_TIME TIMESTAMP,
    MEAL VARCHAR2(30),
    FID VARCHAR2(20),
    FNAME VARCHAR2(30) not null,
    AMOUNT NUMBER(10) not null,
    CAL NUMBER(8,1) not null,
    CARBOH NUMBER(8,1) not null,
    PROTEIN NUMBER(8,1) not null,
    FAT NUMBER(8,1) not null,
    constraint pk_diet primary key (UUID, INSERT_DATE, INSERT_TIME, MEAL),
    constraint fk_diet_uuid foreign key (UUID) references USERS(UUID),
    constraint fk_diet_fid foreign key (FID) references FOOD(FID)
	);

'''
train table
uuid : 회원 아이디
train_date : 운동 날짜
eid : 운동 명
error_name : 해당 운동에서 발생하는 에러 이름
error_count : 에러 횟수
'''
CREATE TABLE TRAIN(
    UUID VARCHAR2(30),
    TRAIN_DATE DATE,
    EID NUMBER(2),
    ERROR_NAME VARCHAR2(30),
    ERROR_COUNT NUMBER(2)
)
	
-- INSERT ALL 
-- 		INTO USERS VALUES ()
-- 		INTO USERS VALUES ()
-- SELECT * FROM DUAL;


'''

ACTIVITY
-
UACT PK VARCHAR2(30)
VAL NUMBER(3,1)

FOOD
-
FID PK VARCHAR2(20)
FNAME VARCHAR2(30)
FAMOUNT NUMBER(10)
FCAL NUMBER(8,1)
FCARBOH NUMBER(8,1)
FPROTEIN NUMBER(8,1)
FFAT NUMBER(8,1)

USERS
----
UUID PK VARCHAR2(30)
UPW VARCHAR2(15)
UAGE NUMBER(3)
USEX VARCHAR2(7)
UHEIGHT NUMBER(4,1)
UWEIGHT NUMBER(4,1)
UACT VARCHAR2(30) FK >- ACTIVITY.UACT
URDC NUMBER(5,1)

DIET
----
UUID PK VARCHAR2(30) FK >- USERS.UUID
DIET_DATE PK DATE
DIET_TIME PK TIMESTAMP
MEAL PK VARCHAR2(30)
FID VARCHAR2(20) FK >- FOOD.FID
FNAME VARCHAR2(30)
AMOUNT NUMBER(10)
CAL NUMBER(8,1)
CARBOH NUMBER(8,1)
PROTEIN NUMBER(8,1)
FAT NUMBER(8,1)

EXERCISE
----
EID PK NUMBER(2)
ENAME VARCHAR(30)
ERROR_NAME VARCHAR(30)

TRAIN
----
UUID PK VARCHAR2(30) FK >- USERS.UUID
TRAIN_DATE PK DATE
EID FK >- EXERCISE.EID NUMBER(2)
ERROR_COUNT NUMBER(2)
ERROR_NAME VARCHAR(30)
'''

