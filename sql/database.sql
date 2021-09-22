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

rem 팀원 : 이현수, 이홍주, 정일균, 최한승

GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO TEAM404 IDENTIFIED BY 1234;
ALTER USER TEAM404 DEFAULT TABLESPACE USERS;
ALTER USER TEAM404 TEMPORARY TABLESPACE TEMP;
CONNECT TEAM404/1234

DROP TABLE USERS;
CREATE TABLE USERS(
	UUID VARCHAR2(30),
	UPW VARCHAR2(15) not null,
	UAGE NUMBER(3) not null,
    USEX VARCHAR2(7) not null,
	UHEIGHT NUMBER(4) not null,
	UWEIGHT NUMBER(4) not null,
    UACT NUMBER(1) not null,
    constraint pk_users_uuid primary key (UUID),
    constraint fk_diet_act foreign key (UACT) references ACTIVITY(UACT)
	);

-- INSERT ALL 
-- 		INTO USERS VALUES ()
-- 		INTO USERS VALUES ()
-- SELECT * FROM DUAL;

DROP TABLE DIET;
CREATE TABLE DIET(
	UUID VARCHAR2(30),
	INSERT_DATE DATE,
	INSERT_TIME TIMESTAMP,
	MEAL VARCHAR2(30),
    CAL NUMBER(6) not null,
    CARBOH NUMBER(6) not null,
    PROTEIN NUMBER(6) not null,
    FAT NUMBER(6) not null,
    AMOUNT NUMBER(10) not null,
    FID VARCHAR2(30),
    constraint pk_diet primary key (UUID, INSERT_DATE, INSERT_TIME, MEAL),
    constraint fk_diet_uuid foreign key (UUID) references USERS(UUID),
    constraint fk_diet_fid foreign key (FID) references FOOD(FID)
	);
	
DROP TABLE FOOD;
CREATE TABLE FOOD(
	FID VARCHAR2(10),
	FNAME VARCHAR2(30) not null,
    FCAL NUMBER(6) not null,
    FCARBOH NUMBER(6) not null,
    FPROTEIN NUMBER(6) not null,
    FFAT NUMBER(6) not null,
	FAMOUNT NUMBER(10) not null,
    constraint pk_food_fid primary key (FID)
    );

DROP TABLE ACTIVITY;
CREATE TABLE ACTIVITY(
    UACT NUMBER(1) not null,
    VAL NUMBER(2) not null,
    constraint pk_activity_uact primary key (UACT)
    );

