drop user HHYDE_FBOACE03_OLTP_TAB cascade;

create user HHYDE_FBOACE03_OLTP_TAB identified by pas$w0rD
       default tablespace USERS
       temporary tablespace TEMP
       quota UNLIMITED on USERS;

grant connect, resource to HHYDE_FBOACE03_OLTP_TAB;

--------------------------------------------------------
--  File created - Saturday-August-18-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Sequence AIRCRAFT_PK_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_PK_SEQ  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 124 CACHE 20 NOORDER  NOCYCLE  NOPARTITION ;
--------------------------------------------------------
--  DDL for Sequence AIRCRAFT_TYPE_PK_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE_PK_SEQ  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 57 CACHE 20 NOORDER  NOCYCLE  NOPARTITION ;
--------------------------------------------------------
--  DDL for Sequence AIRPORT_PK_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  HHYDE_FBOACE03_OLTP_TAB.AIRPORT_PK_SEQ  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 129 CACHE 20 NOORDER  NOCYCLE  NOPARTITION ;
--------------------------------------------------------
--  DDL for Sequence FLIGHT_PK_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  HHYDE_FBOACE03_OLTP_TAB.FLIGHT_PK_SEQ  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 141 CACHE 20 NOORDER  NOCYCLE  NOPARTITION ;
--------------------------------------------------------
--  DDL for Sequence PILOT_PK_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  HHYDE_FBOACE03_OLTP_TAB.PILOT_PK_SEQ  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 333 CACHE 20 NOORDER  NOCYCLE  NOPARTITION ;
--------------------------------------------------------
--  DDL for Table AIRCRAFT
--------------------------------------------------------

  CREATE TABLE HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT
   (	AIRCRAFT_TYPE_ID NUMBER,
	AIRCRAFT_ID NUMBER,
	SHORT_NAME VARCHAR2(8),
	LONG_NAME VARCHAR2(49),
	DESCRIPTION VARCHAR2(2000),
	NOTES VARCHAR2(2000)
   ) ;
--------------------------------------------------------
--  DDL for Table AIRCRAFT_TYPE
--------------------------------------------------------

  CREATE TABLE HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE
   (	AIRCRAFT_TYPE_ID NUMBER,
	SHORT_NAME VARCHAR2(8),
	LONG_NAME VARCHAR2(50),
	DESCRIPTION VARCHAR2(4000),
	NOTES VARCHAR2(4000)
   ) ;
--------------------------------------------------------
--  DDL for Table AIRPORT
--------------------------------------------------------

  CREATE TABLE HHYDE_FBOACE03_OLTP_TAB.AIRPORT
   (	AIRPORT_ID NUMBER,
	SHORT_NAME VARCHAR2(28 CHAR),
	IATA_CODE VARCHAR2(3 CHAR),
	DESCRIPTION VARCHAR2(4000 CHAR),
	PORT_TYPE VARCHAR2(20 CHAR) DEFAULT 'Large Airport'
   ) ;
--------------------------------------------------------
--  DDL for Table FLIGHT
--------------------------------------------------------

  CREATE TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT
   (	FLIGHT_ID NUMBER,
	AIRCRAFT_ID NUMBER,
	SHORT_NAME VARCHAR2(48),
	LONG_NAME VARCHAR2(49),
	DEPARTURE_DATE_TIME DATE,
	ARRIVAL_DATE_TIME DATE,
	NOTES VARCHAR2(2000),
	AIRPORT_ID_DEPARTURE NUMBER,
	AIRPORT_ID_DESTINATION NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table FLIGHT_CREW_MEMBER
--------------------------------------------------------

  CREATE TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER
   (	FLIGHT_ID NUMBER,
	PILOT_ID NUMBER,
	NOTES VARCHAR2(2000)
   ) ;
--------------------------------------------------------
--  DDL for Table PILOT
--------------------------------------------------------

  CREATE TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT
   (	PILOT_ID NUMBER,
	LAST_NAME VARCHAR2(20),
	FIRST_NAME VARCHAR2(20),
	MIDDLE_INITIAL VARCHAR2(1),
	NATIONAL_ID_NUMBER VARCHAR2(20),
	BIRTHDATE DATE,
	NOTES VARCHAR2(2000)
   ) ;
--------------------------------------------------------
--  DDL for Table PILOT_CERTIFICATION
--------------------------------------------------------

  CREATE TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION
   (	PILOT_ID NUMBER,
	AIRCRAFT_TYPE_ID NUMBER,
	CERTIFICATION_NUMBER VARCHAR2(20),
	VALID_FROM_DATE DATE,
	EXPIRATION_DATE DATE,
	NOTES VARCHAR2(2000)
   ) ;
--------------------------------------------------------
--  DDL for Table PILOT_RARE_THING
--------------------------------------------------------

  CREATE TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_RARE_THING
   (	PILOT_ID NUMBER,
	SHORT_NAME VARCHAR2(30),
	LONG_NAME VARCHAR2(50),
	NOTES VARCHAR2(4000)
   ) ;
--------------------------------------------------------
--  DDL for View VW_AIRCRAFT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID, AIRCRAFT_TYPE_ID, SHORT_NAME, NAME, LONG_NAME, DESCRIPTION, NOTES) AS
  select a.aircraft_id
     , a.aircraft_type_id
     , a.short_name
     , t.short_name || ' ' || a.short_name name
     , a.long_name
     , a.description
     , a.notes
  from aircraft a
  join aircraft_type t on t.aircraft_type_id = a.aircraft_type_id
 order by t.short_name, a.short_name;
--------------------------------------------------------
--  DDL for View VW_AIRCRAFT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID, SHORT_NAME, NAME, LONG_NAME, DESCRIPTION, NOTES) AS
  select aircraft_type_id
     , short_name
     , long_name name
     , long_name
     , description
     , notes
  from aircraft_type
 order by short_name;
--------------------------------------------------------
--  DDL for View VW_AIRPORT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID, NAME, SHORT_NAME, IATA_CODE, DESCRIPTION, PORT_TYPE) AS
  select AIRPORT_ID,
      iata_code || ': ' || short_name name,
      SHORT_NAME,
      IATA_CODE,
      DESCRIPTION,
      PORT_TYPE
      from hhyde_fboace03_oltp_tab.AIRPORT
      order by iata_code, short_name;
--------------------------------------------------------
--  DDL for View VW_FLIGHT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID, AIRCRAFT_ID, NAME, SHORT_NAME, LONG_NAME, AIRPORT_ID_DEPARTURE, DEPARTURE_AIRPORT, DEPARTURE_DATE_TIME, AIRPORT_ID_DESTINATION, DESTINATION_AIRPORT, ARRIVAL_DATE_TIME, NOTES) AS
  select f.flight_id
     , f.aircraft_id
     , a.name || ': ' || f.short_name || ' ' || to_char(f.departure_date_time, 'yyyy.mm.dd') name
     , f.short_name
     , f.long_name
     , f.airport_id_departure 
     , dp.iata_code departure_airport
     , f.departure_date_time
     , f.airport_id_destination         
     , dt.iata_code destination_airport
     , f.arrival_date_time
     , f.notes
  from flight f
  join vw_aircraft a on a.aircraft_id = f.aircraft_id
  left join airport  dp on f.airport_id_departure = dp.airport_id
  left join airport  dt on f.airport_id_destination = dt.airport_id
 order by departure_date_time, short_name;
--------------------------------------------------------
--  DDL for View VW_FLIGHT_CREW_MEMBER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID, PILOT_ID, NAME, NOTES) AS
  select m.flight_id
     , m.pilot_id
     , p.name  || ' is a member of the flight crew for ' || f.name name
     , m.notes
  from flight_crew_member m
  join vw_flight f on f.flight_id = m.flight_id
  join vw_pilot  p on p.pilot_id = m.pilot_id
 order by p.name, f.short_name desc;
--------------------------------------------------------
--  DDL for View VW_PILOT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID, NAME, LAST_NAME, FIRST_NAME, MIDDLE_INITIAL, NATIONAL_ID_NUMBER, BIRTHDATE, NOTES) AS
  with data as ( 
select p.pilot_id                                  
     , p.last_name || ', ' || p.first_name || ' ' ||  p.middle_initial || ': ' pilot_name    
     , p.last_name         
     , p.first_name        
     , p.middle_initial    
     , p.national_id_number
     , p.birthdate         
     , p.notes
     , c.aircraft_type
  from pilot p
  left join vw_pilot_certification c on c.pilot_id = p.pilot_id
)  
select pilot_id
     , pilot_name ||LISTAGG(nvl(aircraft_type, '[none]'),',')  WITHIN GROUP (ORDER BY  aircraft_type) as name
     , last_name         
     , first_name        
     , middle_initial    
     , national_id_number
     , birthdate         
     , notes
   from data
 group by pilot_name, last_name, pilot_id, first_name, middle_initial, national_id_number, birthdate, notes
 order by pilot_name, last_name, pilot_id, first_name, middle_initial, national_id_number, birthdate, notes;
--------------------------------------------------------
--  DDL for View VW_PILOT_CERTIFICATION
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID, AIRCRAFT_TYPE_ID, NAME, PILOT_NAME, AIRCRAFT_TYPE, CERTIFICATION_NUMBER, VALID_FROM_DATE, EXPIRATION_DATE, NOTES) AS
  select pc.pilot_id            
     , pc.aircraft_type_id
     , pt.name || ' is certified in Aircraft Type: ' || at.name name    
     , pt.name pilot_name 
     , at.short_name aircraft_type 
     , pc.certification_number
     , pc.valid_from_date     
     , pc.EXpiration_date     
     , pc.notes               
  from pilot_certification pc
  join vx_pilot pt on pt.pilot_id = pc.pilot_id
  join vw_aircraft_type at on at.aircraft_type_id = pc.aircraft_type_id
 order by pt.name, at.name;
--------------------------------------------------------
--  DDL for View VW_PILOT_RARE_THING
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_RARE_THING (PILOT_ID, SHORT_NAME, LONG_NAME, NOTES) AS
  select pilot_id --pilot_pilot_id
     , short_name
     , long_name
     , notes
  from HHYDE_FBOACE03_OLTP_TAB.pilot_rare_thing;
--------------------------------------------------------
--  DDL for View VX_PILOT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE VIEW HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID, NAME, LAST_NAME, FIRST_NAME, MIDDLE_INITIAL, NATIONAL_ID_NUMBER, BIRTHDATE, NOTES) AS
  select p.pilot_id                                  
     , p.last_name || ', ' || p.first_name || ' ' ||  p.middle_initial || ' ' || p.national_id_number name    
     , p.last_name         
     , p.first_name        
     , p.middle_initial    
     , p.national_id_number
     , p.birthdate         
     , p.notes
  from pilot p
 order by last_name, first_name, middle_initial, birthdate;
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (3,106,'N637GK','Three Seven Golf Kilo','Three Seven Golf Kilo','No notes at all');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (2,52,'N386KW','Eight Six Kilo Whiskey','Eight Six Kilo Whiskey','Eight Six Kilo Whiskey');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (2,53,'N492UL','Niner Two Uniform Lima','Niner Two Uniform Lima','No more notes');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,57,'N381JW','Eight One Julliette Whiskey',null,'Eight One Julliette Whiskey');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (7,108,'N682HK','Eight Two Hotel Kilo',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (38,109,'N206SW','Zero Six Sierra Whiskey','Zero Six Sierra Whiskey','Zero Six Sierra Whiskey');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (38,110,'N392KA','Niner Two Kilo Alpha','Niner Two Kilo Alpha',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (2,31,'N198FX','One Niner Eight Foxtrot Xray','One Niner Eight Foxtrot Xray',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (3,29,'N923NB','Niner Two Three November Bravo','Niner Two Three November Bravo',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (7,30,'N487GH','Four Eight Seven Golf Hotel',null,'Four Eight Seven Golf Hotel');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (6,33,'N824ZP','Eight Two Four Zulu Papa','xxx','YYY');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (6,34,'N684EB','Six Eight Four Echo Bravo',null,'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (7,28,'N343ANN','Three Four Three Alpha November','Three Four Three Alpha November','Twin turboprop');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (2,32,'N676UI','Six Seven Six Uniform India','Six Seven Six Uniform India',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (10,35,'N102VN','One Zero Two Victor November','One Zero Two Victor November',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (5,2,'N747ST','Seven Four Seven Sierra Tango',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (5,3,'N747AR','Seven Four Seven Alpha Romeo',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (5,4,'N777DK','777 Delta Kilo',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (5,5,'N737PO','737 Papa Oscar',null,'My toy');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (7,6,'N06BBJ','Zero Six Bravo Bravo Juliet','Zero Six Bravo Bravo Juliet','Note this');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (7,7,'N368ST','Three Six Eight Sierra Tango!!!','Three Six Eight Sierra Tango!!!',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (4,8,'NBB727','Bravo Bravo Seven Two Seven','Blah blah','Bravo Bravo Seven Two Seven');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,9,'N172QW','One Seven Two Quebec Yankee','One Seven Two Quebec Yankee',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,10,'N172GH','One Seven Two Golf Hotel','One Seven Two Golf Hotel','xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,11,'N172MP','One Seven Two Mike Papa','One Seven Two Mike Papa',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (4,12,'N64CIT','Six Four Charlie India Tango',null,'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (4,13,'N75CIT9','Seven Five Charlie India Tango Niner','ggg','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,14,'N182PB','One Eight Two Papa Bravo',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,15,'N0182AL','One Eight Two Alpha Lima',null,'One Eight Two Alpha Lima');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,16,'N0152SM','One Five Two Sierra Mike',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,17,'N0152NQ','One Five Two November Quebec',null,'One Five Two November Quebec');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (3,18,'N0210FH','Two One Zero Foxtrot Hotel',null,'Two One Zero Foxtrot Hotel');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,97,'N483KX','Eight Three Kilo XRay','Eight Three Kilo XRay',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (3,20,'N0210BU','Two One Zero Bravo Uniform','x',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (8,21,'N309MN','Three Zero Niner Mike November',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (8,22,'N467MN','Four Six Seven Mike November',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,23,'N284PW!','Two Eight Four Papa Whiskey',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (8,24,'N48VEL','Four Eight Victor Echo Lima',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (8,25,'N77VEL','Seven Seven Victor Echo Lima',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (4,26,'N444G4','Four Four Four Golf Four','Four Four Four Golf Four','XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (4,27,'N666G4','Six Six Six Golf Four','iii','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,43,'N693OA','Niner three Oscar Alpha','Indescribable!','Duly Noted');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (4,46,'N712RK','One Two Romeo Kilo','---','xxxx');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (4,47,'N386YJ','Eight Six Yankee Juliette','yyy','nnn');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (3,49,'N296MQ','Niner Six Mike Quebec',null,'Niner Six Mike Quebec');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (4,55,'N99999H','N99999H','BOGUS','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (34,103,'N130BA','Three Zero Bravo Alpha',null,'Three Zero Bravo Alpha');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (3,104,'N111AA','One One Alpha Alpha','Not two beta','Not three charlie');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (7,107,'N492GS','Niner Two Golf Sierra','Two Golf Sierra','Four Niner Two Golf Sierra');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,44,'N99999','Niner Niner Niner Niner ',null,'Lorem ipsum');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (7,45,'N682LS','Eight Two Lima Sierra','Eight Two Lima Sierra','Blah');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (5,59,'N195KX','Niner Five Kilo XRay','Once upon a time','Niner Five Kilo XRay');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (5,60,'N844LQ','Four Four Lima Quebec',null,'Four Four Lima Quebec');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (4,102,'N254GO','Five Four Golf Oscar',null,'Five Four Golf Oscar');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (39,112,'N849ZI','Four Niner Zulu India',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (3,50,'N751WG','Five One Whiskey Golf','Five One Whiskey Golf','No need for notes.');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (6,77,'N593LQ','Niner Three Lima Quebec',null,'Niner Three Lima Quebec');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (40,113,'N759LK','Five Niner Lima Kilo',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (3,48,'N682DT','Eight Two Delta Tango','Eight Two Delta Tango','Note this');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_TYPE_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (7,98,'N396KS','Niner Six Kilo Sierra','xxxxxxxxxx','Niner Six Kilo Sierra');
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (39,'STAR','Starship',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (38,'RSHP','Rocket Ship',null,'Lost in Space');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (9,'BALOON','Hot-Air Ballloon',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (10,'BLIMP','Blimp',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (2,'MESA','Multi-Engine Sea Airplane',null,'Multi-Engine Sea Airplane');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,'SELA','Single-Engine Land Airplane','Hello World',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (3,'MELA','Multi-Engine Land Airplane','Let''s fix this!',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (4,'SJET','Small Jet Airplane','Small turbojet Aeroplane','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (5,'CJET','Commercial Jet Airplane','Commercial-grade turbojet Aeroplane.','For example, Boeing 7xx series');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (6,'SESH','Single-Engine Sea Helicopter','X','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (7,'LBJ','Large Business Jet','Z',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (8,'HPSELA','High-Performance Single-Engine Land Airplane','High-Performance Single-Engine Land Airplane free form description','High-Performance Single-Engine Land Aeroplane');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (36,'PCHT','Parachute',null,'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (32,'NASASS','NASA Space Shuttle','Description','Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (40,'FBOAT','Flying Boat',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (33,'FGHT','Fighter Jet','Military fighter','Very fast and manueverable');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (34,'HMTA','Heavy Military Transport Airplane','Heavy Military Transport Airplane',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,LONG_NAME,DESCRIPTION,NOTES) values (35,'GLID','Glider',null,null);
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.AIRPORT
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (103,'Aragip','ARP','X','Small Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (101,'Seattle Tacoma Intl','SEA','Seattle Tacoma International Airport, Tacoma, Washington',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (128,'Maastricht Aachen Airport','MST','X','Large Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (10,'Dane County Regional','MSN','Dane County Regional Airport is a civil-military airport located six miles northeast of downtown Madison, the capital of Wisconsin.',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (8,'Boston Logan Airport','BOS','Boston Logan International Airport, Boston MA, Class B, Serving Massachussetts',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (2,'Van Nuys Airport','VNY','Van Nuys, California Class D - Busiest non-commercial airport in the USA','Medium Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (4,'San Carlos (Oracle) SQL ','SQL','San Carlos Class D (Redwood Shores, CA), home of Oracle Corporation','Small Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (1,'Burbank Bob Hope','BUR','Burbank, California commercial airport, Class C','Medium Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (3,'Sant Monica','SMO','Santa Monica Municipal airport, class D',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (7,'San Francisco INTL','SFO','San Francisco International, Class B.','Large Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (9,'New York City JFK','JFK','John F Kennedy Airport New York Class B - Serving the greater Manhattan area!','Large Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (5,'Paris Charles de Gaul','CDG','Charles de Gaul Airport, Paris, France Class Foreign, Gateway to Europe and the Far East','Large Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (102,'Edwards Air Force Base','EDW','One Flew over the Cuckoo''s Nest','Large Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (11,'Middleton Municipal','C29','Middleton Municipal Airport, also known as Morey Field, is a general aviation airport located five miles northwest of Middleton, a city in Dane County, Wisconsin.',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (127,'Bassel Al-Assad Internat''l','LTK',null,'Large Airport');
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.FLIGHT
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (30,2,'21030-CJET N747ST 2019-02-15:11:19','21030-CJET N747ST 2019-02-15:11:19',to_date('15-FEB-19','DD-MON-RR'),to_date('15-FEB-19','DD-MON-RR'),null,4,102);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (114,60,'CJET N844LQ: 2018.02.26 18:43:47','CJET N844LQ: 2018.02.26 18:43:47',to_date('26-FEB-18','DD-MON-RR'),to_date('26-FEB-18','DD-MON-RR'),null,4,1);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (115,33,'SESH N824ZP: 2018.02.26 18:47:04','SESH N824ZP: 2018.02.26 18:47:04',to_date('26-FEB-18','DD-MON-RR'),to_date('26-FEB-18','DD-MON-RR'),null,null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (121,59,'CJET N195KX: 2018.03.14 10:21:32','CJET N195KX: 2018.03.14 10:21:32',to_date('14-MAR-18','DD-MON-RR'),to_date('14-MAR-18','DD-MON-RR'),null,10,3);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (1,11,'71-SELA N172MP 2014-07-01:00:00','71-SELA N172MP 2014-07-01:00:00',to_date('01-JUL-14','DD-MON-RR'),to_date('01-JUL-14','DD-MON-RR'),null,null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (3,14,'213-SELA N182PB 2014-07-01:16:03','213-SELA N182PB 2014-07-01:16:03',to_date('01-JUL-14','DD-MON-RR'),to_date('01-JUL-14','DD-MON-RR'),'x',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (10,9,'7010-SELA N172QW 2014-07-03:07:51','7010-SELA N172QW 2014-07-03:07:51',to_date('03-JUL-14','DD-MON-RR'),to_date('03-JUL-14','DD-MON-RR'),'x',3,2);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (18,28,'12618-LBJ N343ANN 2014-08-07:10:40','12618-LBJ N343ANN 2014-08-07:10:40',to_date('07-AUG-14','DD-MON-RR'),to_date('07-AUG-14','DD-MON-RR'),'Here are some MORE MORE notes',7,9);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (4,10,'284-SELA N172GH 2014-07-01:16:03','284-SELA N172GH 2014-07-01:16:03',to_date('01-JUL-14','DD-MON-RR'),to_date('01-JUL-14','DD-MON-RR'),null,7,102);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (8,18,'568-MELA N0210FH 2019-07-02:14:40','568-MELA N0210FH 2019-07-02:14:40',to_date('02-JUL-19','DD-MON-RR'),to_date('02-JUL-19','DD-MON-RR'),'x',1,5);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (13,3,'9113-CJET N747AR 2018-08-05:12:13','9113-CJET N747AR 2018-08-05:12:13',to_date('05-AUG-18','DD-MON-RR'),to_date('05-AUG-18','DD-MON-RR'),null,3,4);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (5,12,'355-SJET N64CIT 2018-07-02:10:52','355-SJET N64CIT 2018-07-02:10:52',to_date('02-JUL-18','DD-MON-RR'),to_date('02-JUL-18','DD-MON-RR'),null,9,127);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (6,10,'426-SELA N172GH 2018-07-02:13:40','426-SELA N172GH 2018-07-02:13:40',to_date('02-JUL-18','DD-MON-RR'),to_date('02-JUL-28','DD-MON-RR'),'How many notes does it take',5,10);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (7,4,'497-CJET N777DK 2014-07-02:00:00','497-CJET N777DK 2014-07-02:00:00',to_date('02-JUL-18','DD-MON-RR'),to_date('02-JUL-18','DD-MON-RR'),null,4,9);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (11,21,'7711-HPSELA N309MN 2014-07-03:07:51','7711-HPSELA N309MN 2014-07-03:07:51',to_date('03-JUL-18','DD-MON-RR'),to_date('03-JUL-18','DD-MON-RR'),'x',3,5);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (12,4,'8412-CJET N777DK 2019-08-05:20:10','8412-CJET N777DK 2019-08-05:20:10',to_date('05-AUG-19','DD-MON-RR'),to_date('05-AUG-19','DD-MON-RR'),null,3,102);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (15,26,'10515-SJET N444G4 2014-08-05:12:20','10515-SJET N444G4 2014-08-05:12:20',to_date('05-AUG-14','DD-MON-RR'),to_date('05-AUG-14','DD-MON-RR'),null,1,8);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (17,20,'11917-MELA N0210BU 2014-08-07:10:37','11917-MELA N0210BU 2014-08-07:10:37',to_date('07-AUG-14','DD-MON-RR'),to_date('07-AUG-14','DD-MON-RR'),'Note this',3,11);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (2,7,'142-LBJ N368ST 2019-09-05:21:55','142-LBJ N368ST 2019-09-05:21:55',to_date('05-SEP-19','DD-MON-RR'),to_date('06-SEP-19','DD-MON-RR'),'xXX',1,102);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (9,18,'639-MELA N0210FH 2014-07-02:00:00','639-MELA N0210FH 2014-07-02:00:00',to_date('02-JUL-14','DD-MON-RR'),to_date('02-JUL-14','DD-MON-RR'),null,128,8);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (14,31,'9814-MESA N198FX 2014-08-05:12:19','9814-MESA N198FX 2014-08-05:12:19',to_date('05-AUG-14','DD-MON-RR'),to_date('05-AUG-14','DD-MON-RR'),null,null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (16,9,'11216-SELA N172QW 2014-08-07:08:37','11216-SELA N172QW 2014-08-07:08:37',to_date('07-AUG-14','DD-MON-RR'),to_date('07-AUG-14','DD-MON-RR'),null,7,102);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (96,60,'CJET N844LQ: 2018.02.25 13:38:02','CJET N844LQ: 2018.02.25 13:38:02',to_date('25-FEB-18','DD-MON-RR'),to_date('25-FEB-18','DD-MON-RR'),null,7,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (70,34,'49070-SESH N684EB 2019-02-19:06:34','49070-SESH N684EB 2019-02-19:06:34',to_date('27-FEB-19','DD-MON-RR'),to_date('19-FEB-19','DD-MON-RR'),'XYZ',9,102);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (71,2,'49771-CJET N747ST 2019-02-26:12:31','49771-CJET N747ST 2019-02-26:12:31',null,null,'xxx',1,2);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (95,11,'SELA N172MP: 2018.02.25 07:52:25','SELA N172MP: 2018.02.25 07:52:25',to_date('25-FEB-18','DD-MON-RR'),to_date('25-FEB-18','DD-MON-RR'),'X',101,2);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (97,33,'SESH N824ZP: 2018.02.25 15:02:12','SESH N824ZP: 2018.02.25 15:02:12',to_date('25-FEB-18','DD-MON-RR'),to_date('25-FEB-18','DD-MON-RR'),'xyz',9,2);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (118,102,'SJET N254GO: 2018.02.27 05:33:55','SJET N254GO: 2018.02.27 05:33:55',to_date('04-APR-19','DD-MON-RR'),to_date('05-APR-19','DD-MON-RR'),null,7,4);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (20,7,'14020-LBJ N368ST 2017-07-05:00:00','14020-LBJ N368ST 2017-07-05:00:00',to_date('05-JUL-19','DD-MON-RR'),to_date('05-JUL-19','DD-MON-RR'),null,103,2);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (91,59,'CJET N195KX: 2018.02.25 04:12:44','CJET N195KX: 2018.02.25 04:12:44',to_date('25-FEB-20','DD-MON-RR'),to_date('25-FEB-20','DD-MON-RR'),'x',2,7);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (94,59,'CJET N195KX: 2018.02.25 07:45:55','CJET N195KX: 2018.02.25 07:45:55',null,null,null,null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (111,2,'CJET N747ST: 2018.02.26 18:10:46','CJET N747ST: 2018.02.26 18:10:46',to_date('26-FEB-18','DD-MON-RR'),to_date('26-FEB-18','DD-MON-RR'),null,11,4);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (112,28,'LBJ N343ANN: 2018.02.26 18:34:36','LBJ N343ANN: 2018.02.26 18:34:36',to_date('26-FEB-19','DD-MON-RR'),to_date('26-FEB-19','DD-MON-RR'),null,10,2);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (113,7,'LBJ N368ST: 2018.02.26 18:42:03','LBJ N368ST: 2018.02.26 18:42:03',to_date('26-FEB-18','DD-MON-RR'),to_date('26-FEB-18','DD-MON-RR'),null,null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (19,22,'13319-HPSELA N467MN 2017-07-03:00:00','13319-HPSELA N467MN 2017-07-03:00:00',to_date('03-JUL-17','DD-MON-RR'),to_date('03-JUL-17','DD-MON-RR'),null,10,4);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (50,33,'35050-SESH N824ZP 2018-02-16:06:29','35050-SESH N824ZP 2018-02-16:06:29',to_date('16-FEB-18','DD-MON-RR'),to_date('16-FEB-18','DD-MON-RR'),null,null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (51,33,'35751-SESH N824ZP 2019-09-04:10:02','35751-SESH N824ZP 2019-09-04:10:02',to_date('04-SEP-19','DD-MON-RR'),to_date('04-SEP-19','DD-MON-RR'),null,null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (52,33,'36452-SESH N824ZP 2019-09-04:10:02','36452-SESH N824ZP 2019-09-04:10:02',to_date('04-SEP-18','DD-MON-RR'),to_date('04-SEP-18','DD-MON-RR'),'Notes here',9,11);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (117,6,'LBJ N06BBJ: 2018.02.27 04:53:05','LBJ N06BBJ: 2018.02.27 04:53:05',to_date('27-FEB-19','DD-MON-RR'),to_date('27-FEB-19','DD-MON-RR'),null,5,9);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID,AIRCRAFT_ID,SHORT_NAME,LONG_NAME,DEPARTURE_DATE_TIME,ARRIVAL_DATE_TIME,NOTES,AIRPORT_ID_DEPARTURE,AIRPORT_ID_DESTINATION) values (120,59,'CJET N195KX: 2018.02.28 01:51:15','CJET N195KX: 2018.02.28 01:51:15',to_date('28-FEB-18','DD-MON-RR'),to_date('28-FEB-18','DD-MON-RR'),'xyz',102,2);
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (2,157,'Y');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (16,224,'Randall, D: SELA');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (30,153,'No notes necessary');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (5,183,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (117,113,'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (12,253,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (12,12,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (10,192,'y');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (11,146,'zzzzzzzzzzzzzzzzzzz');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (121,12,'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (70,175,'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (117,315,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (95,315,'abc');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (15,125,'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (1,11,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (97,147,'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (13,14,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (6,215,'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (12,192,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (19,217,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (95,264,'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (12,17,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (13,192,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (2,264,'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (8,255,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (3,12,'ELA N0182PB: 2014.07.01 16:03:14');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (5,125,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (4,175,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (8,119,'Note this');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (4,145,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (14,14,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (1,12,'Flying around 2014.07.01');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (16,175,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (52,303,'xz');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (11,113,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (71,152,'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (112,118,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (9,152,'Notes?');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (8,152,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (51,152,'MELA N0210FH: 2014.07.02 14:40:0 need no...');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (15,165,'SJET');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (11,165,'SJET N444G4 etc.');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (9,171,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (52,195,'SESH N824ZP etc.');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (50,195,'2018.02.16:29:22');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (70,202,'SESH N684EB: 2018.02.19 06:34:29');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (52,202,'33:05');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (8,227,'Unnecessary');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (9,227,'What''s wrong?');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (5,283,'XXX');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (20,129,'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (12,242,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (11,240,'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (7,263,'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (16,187,'Duly noted.');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (91,133,'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (30,242,'adsf');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (5,115,'Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (71,201,'z');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (11,201,'y');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (9,12,'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (16,312,'Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (118,203,'abc');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (7,205,'ABC');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (91,152,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (18,214,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (120,178,'abc');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (4,215,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (50,187,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (18,187,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (9,153,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (70,183,'Note this');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (95,123,'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (3,192,'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (2,141,'XXY');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (4,267,'Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (10,145,'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (20,137,'Y');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (118,257,'_');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (4,312,'y');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (4,314,'zyx');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (120,251,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (17,12,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (112,227,'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (118,191,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (19,132,'Go');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (17,171,'No notes');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (7,242,'a');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (5,219,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (50,117,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (51,117,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (52,117,'Avery, Ashly: MESA, SJET, SESH, PCHT');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (51,175,'Go!');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (6,168,'No notes at all');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (15,129,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (13,12,'cjet');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (15,137,'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (20,285,'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (6,115,'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (5,126,'!');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (117,137,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (118,126,'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (52,12,'Yeager');
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (111,180,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NOTES) values (111,262,'ABC');
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.PILOT
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (263,'Spade','Sam','S','48386832',to_date('25-AUG-79','DD-MON-RR'),'Shovel');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (264,'Blow','Joe','S','6839520',to_date('27-OCT-87','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (315,'Chamberlain','Wilt','W','286583950',to_date('28-OCT-50','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (261,'Perera','Pri',null,'295838y693',to_date('01-APR-42','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (15,'Earhart','Amel','K','12345432',to_date('01-JAN-00','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (18,'Feldman','Wrongw','W','482829',to_date('01-APR-00','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (17,'Rubble','Barney',null,'xxx3',to_date('07-JUL-60','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (13,'Wright','Wilbur',null,'xxx2',to_date('06-JUN-80','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (11,'Hyde','Howard',null,'12345',to_date('28-NOV-99','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (14,'Kangaroo','Kaptan','M','9876543',to_date('03-MAR-30','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (12,'Yeager','Chuck','Z','5432',to_date('04-APR-20','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (16,'Flintstone','Fr',null,'xxx1',to_date('05-MAY-50','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (113,'Allan','Alver','H','758246790',to_date('22-MAY-14','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (114,'Alsop','Angelo','M','375549811',to_date('31-MAY-14','DD-MON-RR'),'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (115,'Anderson','Annabell','S','211120543',to_date('12-JUN-91','DD-MON-RR'),'ZZZZZZZZZZZZZZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (116,'Arnold','Arthur','P','170689463',to_date('06-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (117,'Avery','Ashly','A','500516837',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (118,'Bailey','Bee','H','187098948',to_date('09-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (119,'Baker','Benito','F','795677575',to_date('16-MAY-82','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (120,'Ball','Bernadette','T','886634651',to_date('28-MAY-82','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (121,'Bell','Cassandra','R','593117297',to_date('05-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (122,'Berry','Cathy','W','488613786',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (123,'Black','Celestina','M','319722084',to_date('30-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (124,'Blake','Chad','D','102425498',to_date('19-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (125,'Bond','Chun','A','905778425',to_date('20-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (126,'Bower','Dania','W','732351498',to_date('14-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (127,'Brown','Darlena','R','270075821',to_date('24-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (128,'Buckland','Deadra','G','843642828',to_date('17-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (129,'Burgess','Debbi','U','407405522',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (130,'Butler','Deeann','N','111090997',to_date('27-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (131,'Cameron','Demetria','E','977969757',to_date('07-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (132,'Campbell','Denisse','X','420173944',to_date('15-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (133,'Carr','Douglas','B','730561736',to_date('02-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (134,'Chapman','Dudley','P','760473161',to_date('16-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (135,'Churchill','Edgardo','P','128956416',to_date('04-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (136,'Clarkson','Elmer','F','236096449',to_date('12-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (137,'Clarkson','Elma','Z','915157976',to_date('04-MAY-87','DD-MON-RR'),'XXXXXXXXXXX');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (138,'Coleman','Elroy','H','987814097',to_date('17-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (139,'Cornish','Eulah','O','509757783',to_date('08-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (140,'Davidson','Francesco','E','456312623',to_date('29-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (141,'Davies','Gabriel','D','219689919',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (142,'Dickens','Gabriela','S','152022456',to_date('03-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (143,'Dowd','Garfield','K','165756819',to_date('22-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (144,'Duncan','Gaylene','J','515393844',to_date('30-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (145,'Dyer','Gertrude','F','348708112',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (146,'Edmunds','Gertude','X','535200035',to_date('03-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (147,'Ellison','Helen','W','774614811',to_date('08-JUN-81','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (148,'Ferguson','Ila','U','841998573',to_date('02-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (149,'Fisher','Irma','F','739591208',to_date('30-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (150,'Forsyth','Isiah','E','163527225',to_date('14-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (151,'Fraser','Jacinta','E','278517673',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (152,'Gibson','Jamal','P','383051417',to_date('12-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (153,'Gill','Jaye','L','990685730',to_date('15-JUN-77','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (154,'Glover','Jeanna','Y','638898502',to_date('21-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (155,'Graham','Jerrold','G','259525848',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (156,'Grant','Joel','E','272209817',to_date('28-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (157,'Gray','Joye','R','481746731',to_date('10-JUN-81','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (158,'Greene','Julee','D','965886228',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (159,'Hamilton','Julieann','L','402343590',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (160,'Hardacre','Karol','Q','894621472',to_date('14-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (161,'Harris','Kathy','C','628072951',to_date('07-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (162,'Hart','Kiara','L','961115429',to_date('13-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (163,'Hemmings','Kris','F','676034645',to_date('07-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (164,'Henderson','Latarsha','I','855995952',to_date('16-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (165,'Hill','Lavonne','P','196321215',to_date('06-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (166,'Hodges','Leoma','L','988779129',to_date('19-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (167,'Howard','Lettie','M','888733988',to_date('14-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (168,'Hudson','Lien','Q','374973232',to_date('19-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (169,'Hughes','Lilian','Z','662478263',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (170,'Hunter','Lourdes','R','313953854',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (171,'Ince','Madalyn','X','594800415',to_date('23-MAY-83','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (172,'Jackson','Magdalene','J','429227247',to_date('24-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (173,'James','Marita','K','517595388',to_date('11-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (174,'Johnston','Mauro','L','558531112',to_date('19-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (175,'Jones','Maxine','O','341246333',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (176,'Kelly','Meagan','D','609515912',to_date('05-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (177,'Kerr','Melony','G','920529111',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (178,'King','Michelina','Z','357519521',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (179,'Knox','Michelina','E','173883777',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (180,'Lambert','Milda','U','196124606',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (181,'Langdon','Mitchel','Z','233365580',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (182,'Lawrence','Nadia','V','732733206',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (183,'Lee','Nancy','Q','981165130',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (184,'Lewis','Nilda','T','889689525',to_date('27-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (185,'Lyman','Petra','B','119031905',to_date('13-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (186,'MacDonald','Precious','R','790613394',to_date('09-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (187,'Mackay','Rachal','Z','287317356',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (188,'Mackenzie','Rachelle','T','690151856',to_date('26-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (189,'MacLeod','Ramon','K','173008436',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (190,'Manning','Ranae','U','264123490',to_date('28-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (191,'Marshall','Raye','T','426053711',to_date('21-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (192,'Martine','Raymond','A','361412463',to_date('10-JUN-88','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (193,'Mathis','Rochel','G','271225146',to_date('08-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (194,'May','Rochell','C','888214412',to_date('29-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (195,'McDonald','Rona','L','354933752',to_date('06-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (196,'McLean','Salley','J','680024959',to_date('18-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (197,'McGrath','Shannan','B','229041951',to_date('06-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (198,'Metcalfe','Sheilah','T','597074604',to_date('14-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (199,'Miller','Sherice','S','423385749',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (200,'Mills','Shila','V','667462427',to_date('08-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (201,'Mitchell','Silvana','R','449195691',to_date('03-JUN-14','DD-MON-RR'),'Note this!');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (202,'Morgan','Stephen','E','776096712',to_date('12-JUN-14','DD-MON-RR'),'Are there any notes?');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (203,'Morrison','Tandy','S','355843134',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (204,'Murray','Terica','K','791390440',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (205,'Nash','Tommy','I','486054418',to_date('27-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (206,'Newman','Tracey','M','192996750',to_date('06-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (207,'Nolan','Vashti','P','501351447',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (208,'North','Velia','X','582868492',to_date('15-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (209,'Ogden','Venetta','G','521625879',to_date('16-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (210,'Oliver','Xochitl','V','845914811',to_date('06-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (211,'Paige','Yesenia','C','924004026',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (212,'Parr','Benjam','P','356862125',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (213,'Parsons','Bla','P','240550168',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (214,'Paterson','Bor','D','773449691',to_date('31-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (215,'Payne','Brand','S','437778437',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (216,'Peake','Bri','U','296126987',to_date('19-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (217,'Peters','Camer','B','366148955',to_date('12-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (218,'Piper','Ca','L','769404582',to_date('12-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (219,'Poole','Charles','Q','922203371',to_date('09-MAY-14','DD-MON-RR'),'Any more?');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (220,'Powell','Christi','B','122212560',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (221,'Pullman','Christoph','C','826695580',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (222,'Quinn','Col','U','982022095',to_date('18-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (223,'Rampling','Conn','H','934002016',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (224,'Randall','D','B','652386464',to_date('09-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (225,'Rees','Dav','S','346567020',to_date('11-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (226,'Reid','Domin','U','733337570',to_date('14-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (227,'Roberts','Dyl','K','368081596',to_date('14-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (228,'Robertson','Edwa','N','365759391',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (229,'Ross','Er','C','746175809',to_date('11-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (230,'Russell','Ev','L','686288613',to_date('05-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (231,'Rutherford','Fra','F','730284313',to_date('04-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (232,'Sanderson','Gav','T','940495960',to_date('16-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (233,'Scott','Gord','M','970099661',to_date('05-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (234,'Sharp','adelei','E','856480238',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (235,'Short','Martin','N','798045496',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (236,'Simpson','Ma','Q','325571164',to_date('29-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (237,'Skinner','Meg','X','109324243',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (238,'Slater','Melan','Q','630834965',to_date('05-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (239,'Smith','Michel','D','259182697',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (240,'Springer','Mol','A','301920300',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (241,'Stewart','Natal','J','529461587',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (242,'Sutherland','Nico','O','843652044',to_date('22-MAY-80','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (243,'Taylor','Oliv','P','261260185',to_date('08-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (244,'Terry','Penelo','D','958847716',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (245,'Thomson','Pip','P','907787248',to_date('17-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (246,'Tucker','Rach','I','238043745',to_date('24-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (247,'Turner','Rebec','A','108532215',to_date('16-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (248,'Underwood','Ro','B','149838818',to_date('08-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (249,'Vance','Ru','Q','423653571',to_date('08-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (250,'Vaughan','Sal','M','816678610',to_date('12-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (251,'Walker','Samant','J','846995219',to_date('29-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (252,'Wallace','Sar','Y','735551296',to_date('19-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (253,'Walsh','Son','J','178436030',to_date('04-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (254,'Watson','Soph','V','774777425',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (255,'Welch','Ja','Z','556835334',to_date('07-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (256,'White','Jam','H','959087218',to_date('15-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (257,'Wilkins','Jas','W','255392469',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (258,'Wilson','J','G','162546932',to_date('07-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (259,'Wright','Jo','W','994373889',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (260,'Young','Jonathan','N','133967479',to_date('21-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (265,'Racer','Speed','Z','49858394',to_date('28-OCT-53','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (283,'Seminole','Sam','S','29583892',to_date('26-OCT-47','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (284,'Jones','Quincy','R','48673',to_date('28-SEP-25','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (266,'Speed','Breakneck','Z','45983865',to_date('28-OCT-81','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (307,'Earp','Wyatt','A','4SJ485874',to_date('29-OCT-50','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (308,'Johnson','Maureen','J','684930',to_date('27-AUG-55','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (309,'Garland','Beverly','G','29483982',to_date('28-OCT-28','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (310,'Chiguidere','Webster','D','39598394',to_date('29-OCT-66','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (312,'Clouseau','Johnny Cat','I','7654456',to_date('28-AUG-14','DD-MON-RR'),'Prowl');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (262,'Hack','Jeffery','S','29465932',to_date('27-FEB-71','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (267,'Loquatious','Larry','L','496730',to_date('29-OCT-97','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (314,'Chavez','Hugo','Z','49286256',to_date('31-DEC-61','DD-MON-RR'),'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (285,'Germania','Jerry','G','3957325',to_date('28-OCT-09','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (303,'Wonder','Stevie',null,'485874',to_date('23-JUL-45','DD-MON-RR'),null);
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (117,4,'DJ48FJ58H5',to_date('29-JAN-16','DD-MON-RR'),to_date('26-JAN-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (119,3,'FDKJ48FJ38T4',to_date('01-DEC-17','DD-MON-RR'),to_date('23-DEC-19','DD-MON-RR'),'No notes needed');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (227,3,'FJ4UFR492',to_date('01-DEC-17','DD-MON-RR'),to_date('23-DEC-19','DD-MON-RR'),'Stinkin');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (135,4,'FK48FN4I8',to_date('04-OCT-17','DD-MON-RR'),to_date('29-MAR-20','DD-MON-RR'),'No notes this time');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (137,4,'DK348F438TR',to_date('30-NOV-15','DD-MON-RR'),to_date('11-FEB-27','DD-MON-RR'),'DUPLICATE');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (256,4,'DK48FJ385N38',to_date('16-FEB-17','DD-MON-RR'),to_date('14-FEB-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (152,4,'DJ48F4',to_date('28-OCT-15','DD-MON-RR'),to_date('11-APR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (170,3,'38CDN48',to_date('29-OCT-14','DD-MON-RR'),to_date('17-JUN-22','DD-MON-RR'),'Hunter, Lourdes: MELA 2022');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (252,1,'DJ48583DF',to_date('25-OCT-14','DD-MON-RR'),to_date('18-MAR-21','DD-MON-RR'),'Note this');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (152,5,'DJ38757RN3',to_date('28-SEP-15','DD-MON-RR'),to_date('13-MAY-21','DD-MON-RR'),'Commercial');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (154,4,'DJ385UFNB43',to_date('27-SEP-16','DD-MON-RR'),to_date('13-APR-21','DD-MON-RR'),'Glover, Jeanna: SJET');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (157,7,'DSJ485HF',to_date('28-OCT-16','DD-MON-RR'),to_date('10-MAR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (153,7,'43IF84UT',to_date('29-OCT-15','DD-MON-RR'),to_date('20-AUG-22','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (263,9,'FDJ386U3',to_date('22-AUG-15','DD-MON-RR'),to_date('24-AUG-22','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (263,5,'DJ4U8FN4U8',to_date('28-SEP-15','DD-MON-RR'),to_date('07-APR-20','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (264,1,'DJ48N4UGF',to_date('28-OCT-15','DD-MON-RR'),to_date('19-SEP-26','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (115,1,'1234567890ABCD',to_date('31-DEC-18','DD-MON-RR'),to_date('01-JAN-19','DD-MON-RR'),'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (119,2,'DK4KJM3',to_date('29-OCT-15','DD-MON-RR'),to_date('16-MAY-19','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (146,8,'z0z0z0z0z0z01',to_date('31-DEC-18','DD-MON-RR'),to_date('01-JAN-19','DD-MON-RR'),'z0z0z0z0z0z01');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (310,3,'DKJ43865HJ384',to_date('29-OCT-16','DD-MON-RR'),to_date('12-MAR-21','DD-MON-RR'),'ZZZZZZZZZZZZZZZZZZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (315,7,'DKEK4JU6843',to_date('29-OCT-15','DD-MON-RR'),to_date('21-JUL-20','DD-MON-RR'),'Y');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (315,1,'DKDEKJ4UG',to_date('29-OCT-16','DD-MON-RR'),to_date('19-SEP-20','DD-MON-RR'),'ABC');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (312,38,'DJ438THJ3',to_date('29-OCT-16','DD-MON-RR'),to_date('23-AUG-21','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (128,38,'DK4ITMJ43',to_date('29-NOV-16','DD-MON-RR'),to_date('05-MAR-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (265,4,'DN3875329K',to_date('29-SEP-16','DD-MON-RR'),to_date('20-JUL-21','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (242,5,'J1XTGW28',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (240,8,'G2JW36FW',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (235,8,'LL5J74NB',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (219,4,'BWQJHYXV',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),'No notes');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (190,3,'DJ48FN4843',to_date('25-SEP-16','DD-MON-RR'),to_date('19-JUL-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (145,1,'0Y00CYGL',to_date('04-JUL-13','DD-MON-RR'),to_date('02-JUL-15','DD-MON-RR'),'Dyer, Gertrude: SELA, MESA');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (189,2,'WKX0IGM9',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (128,2,'JH1QBJV2',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (192,1,'925QGK0S',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),'xy');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (215,1,'8VMM24QG',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (125,4,'7NSIB45U',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (219,5,'DKJ4856UDN43',to_date('28-SEP-15','DD-MON-RR'),to_date('13-APR-20','DD-MON-RR'),'Hey');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (214,7,'RP60ESRR',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (224,1,'QMTQKQ5E',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (233,6,'TGXHWWBW',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (213,6,'HCO0B2XS',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (125,3,'DK4TJ598G',to_date('31-DEC-17','DD-MON-RR'),to_date('01-JAN-19','DD-MON-RR'),'XYZXYZXYZXYZXYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (212,10,'38FN459N65I',to_date('06-AUG-01','DD-MON-RR'),to_date('04-MAR-17','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (117,2,'VBVI1PTN',to_date('08-AUG-13','DD-MON-RR'),to_date('06-AUG-15','DD-MON-RR'),'Avery, Ashly: MESA, SJET, SESH');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (14,2,'DHJ38F5H',to_date('02-FEB-02','DD-MON-RR'),to_date('01-FEB-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (14,5,'ZRHGM532',to_date('02-JUL-13','DD-MON-RR'),to_date('30-JUN-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (129,7,'J6TDW6TJ',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (227,7,'189756Q6',to_date('03-JUN-13','DD-MON-RR'),to_date('01-APR-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (255,3,'OA5P97MM',to_date('22-JUL-13','DD-MON-RR'),to_date('02-JAN-16','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (206,7,'DJ48583',to_date('04-OCT-17','DD-MON-RR'),to_date('24-SEP-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (127,2,'CNDKYE50',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),'Brown, Darlena: MESA');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (184,4,'EK48TH48',to_date('19-OCT-16','DD-MON-RR'),to_date('18-OCT-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (175,1,'Y73Y5KHF',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (145,2,'2A6QYK49',to_date('04-JUL-13','DD-MON-RR'),to_date('02-JUL-15','DD-MON-RR'),'Notes');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (17,5,'MELOPXBK',to_date('02-JUL-13','DD-MON-RR'),to_date('30-JUN-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (117,6,'PY9IOECP',to_date('08-AUG-13','DD-MON-RR'),to_date('06-AUG-15','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (205,5,'DK43I8FJ485W',to_date('05-FEB-16','DD-MON-RR'),to_date('21-JUL-20','DD-MON-RR'),'A+');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (113,6,'FDK49FM4',to_date('04-OCT-15','DD-MON-RR'),to_date('10-MAR-00','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (113,7,'XYXYXYXYX',to_date('01-JAN-18','DD-MON-RR'),to_date('31-DEC-20','DD-MON-RR'),'What?');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (113,3,'YYYYYYY',to_date('02-FEB-02','DD-MON-RR'),to_date('28-NOV-60','DD-MON-RR'),'Hey');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (113,8,'DJ38587D3',to_date('20-AUG-16','DD-MON-RR'),to_date('05-NOV-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (264,7,'DJ43856UNF43',to_date('29-OCT-16','DD-MON-RR'),to_date('14-MAR-21','DD-MON-RR'),'XXXXXXXXX');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (192,5,'D374575EM',to_date('28-OCT-16','DD-MON-RR'),to_date('17-SEP-20','DD-MON-RR'),'yz');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (152,3,'DK498GJ4',to_date('21-SEP-15','DD-MON-RR'),to_date('11-FEB-22','DD-MON-RR'),'Multi-Engine Land Airplane');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (152,6,'43KF84NT',to_date('17-SEP-16','DD-MON-RR'),to_date('18-JUL-23','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (165,4,'DJ48TU4H',to_date('26-SEP-16','DD-MON-RR'),to_date('21-SEP-22','DD-MON-RR'),'Noting to see or hear');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (165,8,'DJ48TYU437F',to_date('27-AUG-15','DD-MON-RR'),to_date('13-MAY-20','DD-MON-RR'),'No notes at all');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (264,6,'DK485U4HJ4D',to_date('25-OCT-17','DD-MON-RR'),to_date('21-AUG-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (202,6,'DZXZXZXZ0',to_date('27-SEP-15','DD-MON-RR'),to_date('21-JUL-22','DD-MON-RR'),'Notes? What notes? We don'' need no stinkin'' notes!!!');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (202,8,'DJ38FN48',to_date('28-SEP-16','DD-MON-RR'),to_date('22-JUL-21','DD-MON-RR'),'What notes? No notes at all');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (202,9,'DFKJ48N4',to_date('22-AUG-16','DD-MON-RR'),to_date('16-AUG-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (122,3,'3IF84HJ',to_date('25-SEP-17','DD-MON-RR'),to_date('11-MAR-21','DD-MON-RR'),'Duly noted.');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (284,6,'DK4856U74DK',to_date('29-OCT-16','DD-MON-RR'),to_date('17-APR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (283,4,'SKJ4385HJW',to_date('29-OCT-16','DD-MON-RR'),to_date('14-MAY-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (123,1,'DK45I8G',to_date('29-OCT-16','DD-MON-RR'),to_date('29-OCT-23','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (310,36,'DJ43JGTN3',to_date('29-NOV-16','DD-MON-RR'),to_date('04-APR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (129,4,'DJ4385UJR4',to_date('29-OCT-16','DD-MON-RR'),to_date('19-DEC-21','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (134,7,'DJ48GH4',to_date('29-OCT-17','DD-MON-RR'),to_date('04-APR-24','DD-MON-RR'),'2024');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (147,6,'EIFHJ3UT845',to_date('05-APR-17','DD-MON-RR'),to_date('07-JUL-22','DD-MON-RR'),'2022');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (118,4,'DK385JF3',to_date('29-OCT-15','DD-MON-RR'),to_date('09-MAR-21','DD-MON-RR'),'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (253,39,'DKRJ48TJ',to_date('28-OCT-16','DD-MON-RR'),to_date('18-SEP-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (132,8,'RI59FJ48FN396H',to_date('04-JUL-16','DD-MON-RR'),to_date('02-JUL-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (12,3,'USPSUFUH',to_date('16-FEB-17','DD-MON-RR'),to_date('14-FEB-19','DD-MON-RR'),'MELA');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (203,4,'4587GH47',to_date('27-AUG-15','DD-MON-RR'),to_date('10-APR-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (203,7,'48FH487F',to_date('27-OCT-14','DD-MON-RR'),to_date('12-APR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (203,8,'92J68B',to_date('26-SEP-14','DD-MON-RR'),to_date('16-MAR-24','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (203,10,'62M5M2',to_date('23-JUL-06','DD-MON-RR'),to_date('15-SEP-28','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (251,5,'F3RQB8BK',to_date('19-FEB-17','DD-MON-RR'),to_date('17-FEB-19','DD-MON-RR'),'Barely passed exam');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (133,5,'48FJ47',to_date('20-SEP-16','DD-MON-RR'),to_date('09-MAR-22','DD-MON-RR'),'What happened?');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (13,7,'4398FJ48',to_date('24-SEP-16','DD-MON-RR'),to_date('14-JUN-21','DD-MON-RR'),'HeyHeyHeyHeyHey');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (210,5,'438FJ48F',to_date('27-OCT-16','DD-MON-RR'),to_date('11-APR-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (307,32,'DJ48TH438',to_date('29-OCT-16','DD-MON-RR'),to_date('12-MAR-20','DD-MON-RR'),'Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (254,7,'Y6Y6Y6Y6Y6Y',to_date('28-OCT-15','DD-MON-RR'),to_date('18-MAY-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (171,1,'3JD843HF',to_date('28-NOV-17','DD-MON-RR'),to_date('12-MAY-21','DD-MON-RR'),'N');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (187,1,'3SKJ38CN3',to_date('28-SEP-15','DD-MON-RR'),to_date('13-MAY-22','DD-MON-RR'),'Mackay, Rachal: SELA, SESH, LBJ');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (257,1,'DJ387D387687D',to_date('29-OCT-15','DD-MON-RR'),to_date('15-APR-21','DD-MON-RR'),'Wilkins, Jas: SELA, SJET');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (308,4,'DK4865UF',to_date('29-NOV-14','DD-MON-RR'),to_date('04-APR-21','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (115,6,'J4865URE',to_date('30-OCT-16','DD-MON-RR'),to_date('05-FEB-20','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (115,4,'DJ48TNH4',to_date('30-NOV-16','DD-MON-RR'),to_date('03-MAR-24','DD-MON-RR'),'Y');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (114,4,'DKJ48N43I',to_date('29-OCT-17','DD-MON-RR'),to_date('07-MAR-22','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (309,4,'DSK498TJ32',to_date('30-OCT-15','DD-MON-RR'),to_date('10-MAR-21','DD-MON-RR'),'Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (230,36,'DJ38T5N3',to_date('29-OCT-15','DD-MON-RR'),to_date('03-FEB-23','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (310,32,'SK3985N3',to_date('29-OCT-17','DD-MON-RR'),to_date('03-MAR-22','DD-MON-RR'),'Zx');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (312,1,'1111111111111111',to_date('01-JAN-18','DD-MON-RR'),to_date('31-DEC-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (246,1,'DJ4JGJ4',to_date('29-OCT-16','DD-MON-RR'),to_date('12-APR-20','DD-MON-RR'),'202020202020202');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (115,7,'DFK435J3',to_date('30-OCT-16','DD-MON-RR'),to_date('03-MAR-21','DD-MON-RR'),'ZZZZZZZZZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (152,1,'DJ48N4',to_date('30-NOV-16','DD-MON-RR'),to_date('03-MAR-19','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (131,34,'DKJ48T5J43',to_date('29-OCT-16','DD-MON-RR'),to_date('09-MAR-19','DD-MON-RR'),'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (162,7,'DK348TN3',to_date('29-OCT-16','DD-MON-RR'),to_date('14-MAR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (241,39,'SK3IRN3D',to_date('29-OCT-16','DD-MON-RR'),to_date('20-SEP-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (168,1,'FDJ3845UG',to_date('28-OCT-16','DD-MON-RR'),to_date('03-MAR-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (220,1,'38DFN48',to_date('28-SEP-16','DD-MON-RR'),to_date('07-MAY-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (187,6,'49FJK498F',to_date('29-OCT-16','DD-MON-RR'),to_date('06-APR-22','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (187,7,'DK438FJ48',to_date('25-JUL-15','DD-MON-RR'),to_date('15-MAY-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (153,5,'4858GJK',to_date('21-SEP-16','DD-MON-RR'),to_date('15-AUG-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (168,4,'395TJ48',to_date('05-SEP-16','DD-MON-RR'),to_date('09-OCT-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (137,7,'348TJ4985',to_date('27-SEP-15','DD-MON-RR'),to_date('13-MAY-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (262,9,'438FRN48',to_date('28-OCT-13','DD-MON-RR'),to_date('11-APR-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (201,5,'DK48GJ4',to_date('28-OCT-15','DD-MON-RR'),to_date('11-APR-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (201,8,'FJ48T583UF',to_date('28-OCT-15','DD-MON-RR'),to_date('12-MAR-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (15,3,'48DN38F4',to_date('11-NOV-11','DD-MON-RR'),to_date('19-JAN-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (222,3,'QC123456',to_date('28-NOV-10','DD-MON-RR'),to_date('28-NOV-21','DD-MON-RR'),'No notes required.');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (141,7,'DJ4875YFN3',to_date('28-OCT-13','DD-MON-RR'),to_date('05-MAR-26','DD-MON-RR'),'XXY');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (267,1,'DJ4T72BT8',to_date('28-OCT-15','DD-MON-RR'),to_date('17-APR-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (124,6,'DK4985JD',to_date('28-NOV-16','DD-MON-RR'),to_date('21-NOV-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (124,7,'SDKJDJ48UGN4',to_date('28-FEB-17','DD-MON-RR'),to_date('26-FEB-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (124,4,'DKJ4JJ43',to_date('28-FEB-17','DD-MON-RR'),to_date('26-FEB-19','DD-MON-RR'),'No notes');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (118,7,'DKJ4JTJ',to_date('29-OCT-16','DD-MON-RR'),to_date('03-APR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (314,1,'43KFIU48UT3',to_date('29-OCT-16','DD-MON-RR'),to_date('17-SEP-24','DD-MON-RR'),'abc');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (129,40,'DKJDJ486T3',to_date('28-OCT-16','DD-MON-RR'),to_date('18-AUG-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (228,3,'FK48GFJ48GJ687',to_date('07-JUL-16','DD-MON-RR'),to_date('05-JUL-18','DD-MON-RR'),'Nots Robertson, Edwa: MELA');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (180,5,'DJ48EJ38G',to_date('16-FEB-17','DD-MON-RR'),to_date('14-FEB-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (155,7,'c',to_date('16-FEB-17','DD-MON-RR'),to_date('14-FEB-19','DD-MON-RR'),'DFK485UN5');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (171,3,'FDJ48FN48',to_date('16-JUN-16','DD-MON-RR'),to_date('26-MAY-20','DD-MON-RR'),'M');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (191,4,'FKJ484H385H32',to_date('22-FEB-17','DD-MON-RR'),to_date('15-APR-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (183,4,'SK28RHJ4',to_date('28-OCT-18','DD-MON-RR'),to_date('13-JAN-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (217,8,'DJ48GNJ48',to_date('28-NOV-17','DD-MON-RR'),to_date('25-MAY-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (147,7,'DJ484583N4IU',to_date('27-NOV-16','DD-MON-RR'),to_date('12-MAY-19','DD-MON-RR'),'2019');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (178,5,'DJ438VN48',to_date('16-FEB-17','DD-MON-RR'),to_date('14-FEB-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (153,3,'38FJ48T',to_date('25-SEP-16','DD-MON-RR'),to_date('14-JUL-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (175,6,'48FH482',to_date('25-SEP-17','DD-MON-RR'),to_date('27-FEB-22','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (257,4,'4948FJ3S',to_date('27-OCT-15','DD-MON-RR'),to_date('26-AUG-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (121,2,'CXXXXX99999',to_date('31-DEC-17','DD-MON-RR'),to_date('01-JAN-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (223,7,'XXXXX11111',to_date('29-OCT-16','DD-MON-RR'),to_date('06-MAY-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (122,2,'X9X9X9X9X9X9X9',to_date('29-OCT-15','DD-MON-RR'),to_date('06-MAY-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (12,5,'DK438FN3',to_date('24-AUG-16','DD-MON-RR'),to_date('15-JUN-20','DD-MON-RR'),'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (119,4,'D484GN',to_date('25-SEP-15','DD-MON-RR'),to_date('15-MAR-21','DD-MON-RR'),'Take note');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (171,6,'XJ43U5UE',to_date('27-AUG-15','DD-MON-RR'),to_date('21-JUL-21','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (285,10,'DJ48765Y3',to_date('29-OCT-13','DD-MON-RR'),to_date('17-MAR-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (285,7,'DJ4U85687EJD',to_date('29-NOV-17','DD-MON-RR'),to_date('03-FEB-28','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (156,7,'SK4385G',to_date('29-OCT-15','DD-MON-RR'),to_date('11-MAR-21','DD-MON-RR'),'Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (115,3,'DEKJ4765UGH',to_date('09-FEB-17','DD-MON-RR'),to_date('20-AUG-20','DD-MON-RR'),'Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (303,6,'DK4585F2',to_date('28-NOV-16','DD-MON-RR'),to_date('05-APR-27','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (126,4,'SDJ38RN33D',to_date('27-SEP-16','DD-MON-RR'),to_date('10-APR-21','DD-MON-RR'),'L');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (124,39,'XKJEJ4IGJ4',to_date('29-OCT-17','DD-MON-RR'),to_date('09-MAR-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (124,35,'DSK4K45IGF',to_date('28-SEP-15','DD-MON-RR'),to_date('10-APR-20','DD-MON-RR'),'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (262,39,'DL4K6K465T',to_date('30-NOV-17','DD-MON-RR'),to_date('04-FEB-19','DD-MON-RR'),'Fly!');
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (262,5,'DSK3MJTJ45',to_date('29-OCT-16','DD-MON-RR'),to_date('09-MAR-22','DD-MON-RR'),null);
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.PILOT_RARE_THING
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_RARE_THING (PILOT_ID,SHORT_NAME,LONG_NAME,NOTES) values (113,'My thing2','My rare thing2',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.PILOT_RARE_THING (PILOT_ID,SHORT_NAME,LONG_NAME,NOTES) values (203,'Name short','name Long','what?');
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (35,10,'N102VN','BLIMP N102VN','One Zero Two Victor November','One Zero Two Victor November',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (59,5,'N195KX','CJET N195KX','Niner Five Kilo XRay','Once upon a time','Niner Five Kilo XRay');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (5,5,'N737PO','CJET N737PO','737 Papa Oscar',null,'My toy');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (3,5,'N747AR','CJET N747AR','Seven Four Seven Alpha Romeo',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (2,5,'N747ST','CJET N747ST','Seven Four Seven Sierra Tango',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (4,5,'N777DK','CJET N777DK','777 Delta Kilo',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (60,5,'N844LQ','CJET N844LQ','Four Four Lima Quebec',null,'Four Four Lima Quebec');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (113,40,'N759LK','FBOAT N759LK','Five Niner Lima Kilo',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (103,34,'N130BA','HMTA N130BA','Three Zero Bravo Alpha',null,'Three Zero Bravo Alpha');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (21,8,'N309MN','HPSELA N309MN','Three Zero Niner Mike November',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (22,8,'N467MN','HPSELA N467MN','Four Six Seven Mike November',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (24,8,'N48VEL','HPSELA N48VEL','Four Eight Victor Echo Lima',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (25,8,'N77VEL','HPSELA N77VEL','Seven Seven Victor Echo Lima',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (6,7,'N06BBJ','LBJ N06BBJ','Zero Six Bravo Bravo Juliet','Zero Six Bravo Bravo Juliet','Note this');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (28,7,'N343ANN','LBJ N343ANN','Three Four Three Alpha November','Three Four Three Alpha November','Twin turboprop');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (7,7,'N368ST','LBJ N368ST','Three Six Eight Sierra Tango!!!','Three Six Eight Sierra Tango!!!',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (98,7,'N396KS','LBJ N396KS','Niner Six Kilo Sierra','xxxxxxxxxx','Niner Six Kilo Sierra');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (30,7,'N487GH','LBJ N487GH','Four Eight Seven Golf Hotel',null,'Four Eight Seven Golf Hotel');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (107,7,'N492GS','LBJ N492GS','Niner Two Golf Sierra','Two Golf Sierra','Four Niner Two Golf Sierra');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (108,7,'N682HK','LBJ N682HK','Eight Two Hotel Kilo',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (45,7,'N682LS','LBJ N682LS','Eight Two Lima Sierra','Eight Two Lima Sierra','Blah');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (20,3,'N0210BU','MELA N0210BU','Two One Zero Bravo Uniform','x',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (18,3,'N0210FH','MELA N0210FH','Two One Zero Foxtrot Hotel',null,'Two One Zero Foxtrot Hotel');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (104,3,'N111AA','MELA N111AA','One One Alpha Alpha','Not two beta','Not three charlie');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (49,3,'N296MQ','MELA N296MQ','Niner Six Mike Quebec',null,'Niner Six Mike Quebec');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (106,3,'N637GK','MELA N637GK','Three Seven Golf Kilo','Three Seven Golf Kilo','No notes at all');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (48,3,'N682DT','MELA N682DT','Eight Two Delta Tango','Eight Two Delta Tango','Note this');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (50,3,'N751WG','MELA N751WG','Five One Whiskey Golf','Five One Whiskey Golf','No need for notes.');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (29,3,'N923NB','MELA N923NB','Niner Two Three November Bravo','Niner Two Three November Bravo',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (31,2,'N198FX','MESA N198FX','One Niner Eight Foxtrot Xray','One Niner Eight Foxtrot Xray',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (52,2,'N386KW','MESA N386KW','Eight Six Kilo Whiskey','Eight Six Kilo Whiskey','Eight Six Kilo Whiskey');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (53,2,'N492UL','MESA N492UL','Niner Two Uniform Lima','Niner Two Uniform Lima','No more notes');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (32,2,'N676UI','MESA N676UI','Six Seven Six Uniform India','Six Seven Six Uniform India',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (109,38,'N206SW','RSHP N206SW','Zero Six Sierra Whiskey','Zero Six Sierra Whiskey','Zero Six Sierra Whiskey');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (110,38,'N392KA','RSHP N392KA','Niner Two Kilo Alpha','Niner Two Kilo Alpha',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (17,1,'N0152NQ','SELA N0152NQ','One Five Two November Quebec',null,'One Five Two November Quebec');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (16,1,'N0152SM','SELA N0152SM','One Five Two Sierra Mike',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (15,1,'N0182AL','SELA N0182AL','One Eight Two Alpha Lima',null,'One Eight Two Alpha Lima');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (10,1,'N172GH','SELA N172GH','One Seven Two Golf Hotel','One Seven Two Golf Hotel','xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (11,1,'N172MP','SELA N172MP','One Seven Two Mike Papa','One Seven Two Mike Papa',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (9,1,'N172QW','SELA N172QW','One Seven Two Quebec Yankee','One Seven Two Quebec Yankee',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (14,1,'N182PB','SELA N182PB','One Eight Two Papa Bravo',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (23,1,'N284PW!','SELA N284PW!','Two Eight Four Papa Whiskey',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (57,1,'N381JW','SELA N381JW','Eight One Julliette Whiskey',null,'Eight One Julliette Whiskey');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (97,1,'N483KX','SELA N483KX','Eight Three Kilo XRay','Eight Three Kilo XRay',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (43,1,'N693OA','SELA N693OA','Niner three Oscar Alpha','Indescribable!','Duly Noted');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (44,1,'N99999','SELA N99999','Niner Niner Niner Niner ',null,'Lorem ipsum');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (77,6,'N593LQ','SESH N593LQ','Niner Three Lima Quebec',null,'Niner Three Lima Quebec');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (34,6,'N684EB','SESH N684EB','Six Eight Four Echo Bravo',null,'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (33,6,'N824ZP','SESH N824ZP','Eight Two Four Zulu Papa','xxx','YYY');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (102,4,'N254GO','SJET N254GO','Five Four Golf Oscar',null,'Five Four Golf Oscar');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (47,4,'N386YJ','SJET N386YJ','Eight Six Yankee Juliette','yyy','nnn');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (26,4,'N444G4','SJET N444G4','Four Four Four Golf Four','Four Four Four Golf Four','XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (12,4,'N64CIT','SJET N64CIT','Six Four Charlie India Tango',null,'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (27,4,'N666G4','SJET N666G4','Six Six Six Golf Four','iii','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (46,4,'N712RK','SJET N712RK','One Two Romeo Kilo','---','xxxx');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (13,4,'N75CIT9','SJET N75CIT9','Seven Five Charlie India Tango Niner','ggg','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (55,4,'N99999H','SJET N99999H','N99999H','BOGUS','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (8,4,'NBB727','SJET NBB727','Bravo Bravo Seven Two Seven','Blah blah','Bravo Bravo Seven Two Seven');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT (AIRCRAFT_ID,AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (112,39,'N849ZI','STAR N849ZI','Four Niner Zulu India',null,null);
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (9,'BALOON','Hot-Air Ballloon','Hot-Air Ballloon',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (10,'BLIMP','Blimp','Blimp',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (5,'CJET','Commercial Jet Airplane','Commercial Jet Airplane','Commercial-grade turbojet Aeroplane.','For example, Boeing 7xx series');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (40,'FBOAT','Flying Boat','Flying Boat',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (33,'FGHT','Fighter Jet','Fighter Jet','Military fighter','Very fast and manueverable');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (35,'GLID','Glider','Glider',null,null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (34,'HMTA','Heavy Military Transport Airplane','Heavy Military Transport Airplane','Heavy Military Transport Airplane',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (8,'HPSELA','High-Performance Single-Engine Land Airplane','High-Performance Single-Engine Land Airplane','High-Performance Single-Engine Land Airplane free form description','High-Performance Single-Engine Land Aeroplane');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (7,'LBJ','Large Business Jet','Large Business Jet','Z',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (3,'MELA','Multi-Engine Land Airplane','Multi-Engine Land Airplane','Let''s fix this!',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (2,'MESA','Multi-Engine Sea Airplane','Multi-Engine Sea Airplane',null,'Multi-Engine Sea Airplane');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (32,'NASASS','NASA Space Shuttle','NASA Space Shuttle','Description','Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (36,'PCHT','Parachute','Parachute',null,'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (38,'RSHP','Rocket Ship','Rocket Ship',null,'Lost in Space');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (1,'SELA','Single-Engine Land Airplane','Single-Engine Land Airplane','Hello World',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (6,'SESH','Single-Engine Sea Helicopter','Single-Engine Sea Helicopter','X','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (4,'SJET','Small Jet Airplane','Small Jet Airplane','Small turbojet Aeroplane','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID,SHORT_NAME,NAME,LONG_NAME,DESCRIPTION,NOTES) values (39,'STAR','Starship','Starship',null,null);
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (103,'ARP: Aragip','Aragip','ARP','X','Small Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (8,'BOS: Boston Logan Airport','Boston Logan Airport','BOS','Boston Logan International Airport, Boston MA, Class B, Serving Massachussetts',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (1,'BUR: Burbank Bob Hope','Burbank Bob Hope','BUR','Burbank, California commercial airport, Class C','Medium Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (11,'C29: Middleton Municipal','Middleton Municipal','C29','Middleton Municipal Airport, also known as Morey Field, is a general aviation airport located five miles northwest of Middleton, a city in Dane County, Wisconsin.',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (5,'CDG: Paris Charles de Gaul','Paris Charles de Gaul','CDG','Charles de Gaul Airport, Paris, France Class Foreign, Gateway to Europe and the Far East','Large Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (102,'EDW: Edwards Air Force Base','Edwards Air Force Base','EDW','One Flew over the Cuckoo''s Nest','Large Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (9,'JFK: New York City JFK','New York City JFK','JFK','John F Kennedy Airport New York Class B - Serving the greater Manhattan area!','Large Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (127,'LTK: Bassel Al-Assad Internat''l','Bassel Al-Assad Internat''l','LTK',null,'Large Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (10,'MSN: Dane County Regional','Dane County Regional','MSN','Dane County Regional Airport is a civil-military airport located six miles northeast of downtown Madison, the capital of Wisconsin.',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (128,'MST: Maastricht Aachen Airport','Maastricht Aachen Airport','MST','X','Large Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (101,'SEA: Seattle Tacoma Intl','Seattle Tacoma Intl','SEA','Seattle Tacoma International Airport, Tacoma, Washington',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (7,'SFO: San Francisco INTL','San Francisco INTL','SFO','San Francisco International, Class B.','Large Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (3,'SMO: Sant Monica','Sant Monica','SMO','Santa Monica Municipal airport, class D',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (4,'SQL: San Carlos (Oracle) SQL ','San Carlos (Oracle) SQL ','SQL','San Carlos Class D (Redwood Shores, CA), home of Oracle Corporation','Small Airport');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_AIRPORT (AIRPORT_ID,NAME,SHORT_NAME,IATA_CODE,DESCRIPTION,PORT_TYPE) values (2,'VNY: Van Nuys Airport','Van Nuys Airport','VNY','Van Nuys, California Class D - Busiest non-commercial airport in the USA','Medium Airport');
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (1,11,'SELA N172MP: 71-SELA N172MP 2014-07-01:00:00 2014.07.01','71-SELA N172MP 2014-07-01:00:00','71-SELA N172MP 2014-07-01:00:00',null,null,to_date('01-JUL-14','DD-MON-RR'),null,null,to_date('01-JUL-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (3,14,'SELA N182PB: 213-SELA N182PB 2014-07-01:16:03 2014.07.01','213-SELA N182PB 2014-07-01:16:03','213-SELA N182PB 2014-07-01:16:03',null,null,to_date('01-JUL-14','DD-MON-RR'),null,null,to_date('01-JUL-14','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (4,10,'SELA N172GH: 284-SELA N172GH 2014-07-01:16:03 2014.07.01','284-SELA N172GH 2014-07-01:16:03','284-SELA N172GH 2014-07-01:16:03',7,'SFO',to_date('01-JUL-14','DD-MON-RR'),102,'EDW',to_date('01-JUL-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (9,18,'MELA N0210FH: 639-MELA N0210FH 2014-07-02:00:00 2014.07.02','639-MELA N0210FH 2014-07-02:00:00','639-MELA N0210FH 2014-07-02:00:00',128,'MST',to_date('02-JUL-14','DD-MON-RR'),8,'BOS',to_date('02-JUL-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (10,9,'SELA N172QW: 7010-SELA N172QW 2014-07-03:07:51 2014.07.03','7010-SELA N172QW 2014-07-03:07:51','7010-SELA N172QW 2014-07-03:07:51',3,'SMO',to_date('03-JUL-14','DD-MON-RR'),2,'VNY',to_date('03-JUL-14','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (15,26,'SJET N444G4: 10515-SJET N444G4 2014-08-05:12:20 2014.08.05','10515-SJET N444G4 2014-08-05:12:20','10515-SJET N444G4 2014-08-05:12:20',1,'BUR',to_date('05-AUG-14','DD-MON-RR'),8,'BOS',to_date('05-AUG-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (14,31,'MESA N198FX: 9814-MESA N198FX 2014-08-05:12:19 2014.08.05','9814-MESA N198FX 2014-08-05:12:19','9814-MESA N198FX 2014-08-05:12:19',null,null,to_date('05-AUG-14','DD-MON-RR'),null,null,to_date('05-AUG-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (16,9,'SELA N172QW: 11216-SELA N172QW 2014-08-07:08:37 2014.08.07','11216-SELA N172QW 2014-08-07:08:37','11216-SELA N172QW 2014-08-07:08:37',7,'SFO',to_date('07-AUG-14','DD-MON-RR'),102,'EDW',to_date('07-AUG-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (17,20,'MELA N0210BU: 11917-MELA N0210BU 2014-08-07:10:37 2014.08.07','11917-MELA N0210BU 2014-08-07:10:37','11917-MELA N0210BU 2014-08-07:10:37',3,'SMO',to_date('07-AUG-14','DD-MON-RR'),11,'C29',to_date('07-AUG-14','DD-MON-RR'),'Note this');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (18,28,'LBJ N343ANN: 12618-LBJ N343ANN 2014-08-07:10:40 2014.08.07','12618-LBJ N343ANN 2014-08-07:10:40','12618-LBJ N343ANN 2014-08-07:10:40',7,'SFO',to_date('07-AUG-14','DD-MON-RR'),9,'JFK',to_date('07-AUG-14','DD-MON-RR'),'Here are some MORE MORE notes');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (19,22,'HPSELA N467MN: 13319-HPSELA N467MN 2017-07-03:00:00 2017.07.03','13319-HPSELA N467MN 2017-07-03:00:00','13319-HPSELA N467MN 2017-07-03:00:00',10,'MSN',to_date('03-JUL-17','DD-MON-RR'),4,'SQL',to_date('03-JUL-17','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (50,33,'SESH N824ZP: 35050-SESH N824ZP 2018-02-16:06:29 2018.02.16','35050-SESH N824ZP 2018-02-16:06:29','35050-SESH N824ZP 2018-02-16:06:29',null,null,to_date('16-FEB-18','DD-MON-RR'),null,null,to_date('16-FEB-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (95,11,'SELA N172MP: SELA N172MP: 2018.02.25 07:52:25 2018.02.25','SELA N172MP: 2018.02.25 07:52:25','SELA N172MP: 2018.02.25 07:52:25',101,'SEA',to_date('25-FEB-18','DD-MON-RR'),2,'VNY',to_date('25-FEB-18','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (96,60,'CJET N844LQ: CJET N844LQ: 2018.02.25 13:38:02 2018.02.25','CJET N844LQ: 2018.02.25 13:38:02','CJET N844LQ: 2018.02.25 13:38:02',7,'SFO',to_date('25-FEB-18','DD-MON-RR'),null,null,to_date('25-FEB-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (97,33,'SESH N824ZP: SESH N824ZP: 2018.02.25 15:02:12 2018.02.25','SESH N824ZP: 2018.02.25 15:02:12','SESH N824ZP: 2018.02.25 15:02:12',9,'JFK',to_date('25-FEB-18','DD-MON-RR'),2,'VNY',to_date('25-FEB-18','DD-MON-RR'),'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (111,2,'CJET N747ST: CJET N747ST: 2018.02.26 18:10:46 2018.02.26','CJET N747ST: 2018.02.26 18:10:46','CJET N747ST: 2018.02.26 18:10:46',11,'C29',to_date('26-FEB-18','DD-MON-RR'),4,'SQL',to_date('26-FEB-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (113,7,'LBJ N368ST: LBJ N368ST: 2018.02.26 18:42:03 2018.02.26','LBJ N368ST: 2018.02.26 18:42:03','LBJ N368ST: 2018.02.26 18:42:03',null,null,to_date('26-FEB-18','DD-MON-RR'),null,null,to_date('26-FEB-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (114,60,'CJET N844LQ: CJET N844LQ: 2018.02.26 18:43:47 2018.02.26','CJET N844LQ: 2018.02.26 18:43:47','CJET N844LQ: 2018.02.26 18:43:47',4,'SQL',to_date('26-FEB-18','DD-MON-RR'),1,'BUR',to_date('26-FEB-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (115,33,'SESH N824ZP: SESH N824ZP: 2018.02.26 18:47:04 2018.02.26','SESH N824ZP: 2018.02.26 18:47:04','SESH N824ZP: 2018.02.26 18:47:04',null,null,to_date('26-FEB-18','DD-MON-RR'),null,null,to_date('26-FEB-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (120,59,'CJET N195KX: CJET N195KX: 2018.02.28 01:51:15 2018.02.28','CJET N195KX: 2018.02.28 01:51:15','CJET N195KX: 2018.02.28 01:51:15',102,'EDW',to_date('28-FEB-18','DD-MON-RR'),2,'VNY',to_date('28-FEB-18','DD-MON-RR'),'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (121,59,'CJET N195KX: CJET N195KX: 2018.03.14 10:21:32 2018.03.14','CJET N195KX: 2018.03.14 10:21:32','CJET N195KX: 2018.03.14 10:21:32',10,'MSN',to_date('14-MAR-18','DD-MON-RR'),3,'SMO',to_date('14-MAR-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (7,4,'CJET N777DK: 497-CJET N777DK 2014-07-02:00:00 2018.07.02','497-CJET N777DK 2014-07-02:00:00','497-CJET N777DK 2014-07-02:00:00',4,'SQL',to_date('02-JUL-18','DD-MON-RR'),9,'JFK',to_date('02-JUL-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (5,12,'SJET N64CIT: 355-SJET N64CIT 2018-07-02:10:52 2018.07.02','355-SJET N64CIT 2018-07-02:10:52','355-SJET N64CIT 2018-07-02:10:52',9,'JFK',to_date('02-JUL-18','DD-MON-RR'),127,'LTK',to_date('02-JUL-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (6,10,'SELA N172GH: 426-SELA N172GH 2018-07-02:13:40 2018.07.02','426-SELA N172GH 2018-07-02:13:40','426-SELA N172GH 2018-07-02:13:40',5,'CDG',to_date('02-JUL-18','DD-MON-RR'),10,'MSN',to_date('02-JUL-28','DD-MON-RR'),'How many notes does it take');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (11,21,'HPSELA N309MN: 7711-HPSELA N309MN 2014-07-03:07:51 2018.07.03','7711-HPSELA N309MN 2014-07-03:07:51','7711-HPSELA N309MN 2014-07-03:07:51',3,'SMO',to_date('03-JUL-18','DD-MON-RR'),5,'CDG',to_date('03-JUL-18','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (13,3,'CJET N747AR: 9113-CJET N747AR 2018-08-05:12:13 2018.08.05','9113-CJET N747AR 2018-08-05:12:13','9113-CJET N747AR 2018-08-05:12:13',3,'SMO',to_date('05-AUG-18','DD-MON-RR'),4,'SQL',to_date('05-AUG-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (52,33,'SESH N824ZP: 36452-SESH N824ZP 2019-09-04:10:02 2018.09.04','36452-SESH N824ZP 2019-09-04:10:02','36452-SESH N824ZP 2019-09-04:10:02',9,'JFK',to_date('04-SEP-18','DD-MON-RR'),11,'C29',to_date('04-SEP-18','DD-MON-RR'),'Notes here');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (30,2,'CJET N747ST: 21030-CJET N747ST 2019-02-15:11:19 2019.02.15','21030-CJET N747ST 2019-02-15:11:19','21030-CJET N747ST 2019-02-15:11:19',4,'SQL',to_date('15-FEB-19','DD-MON-RR'),102,'EDW',to_date('15-FEB-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (112,28,'LBJ N343ANN: LBJ N343ANN: 2018.02.26 18:34:36 2019.02.26','LBJ N343ANN: 2018.02.26 18:34:36','LBJ N343ANN: 2018.02.26 18:34:36',10,'MSN',to_date('26-FEB-19','DD-MON-RR'),2,'VNY',to_date('26-FEB-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (117,6,'LBJ N06BBJ: LBJ N06BBJ: 2018.02.27 04:53:05 2019.02.27','LBJ N06BBJ: 2018.02.27 04:53:05','LBJ N06BBJ: 2018.02.27 04:53:05',5,'CDG',to_date('27-FEB-19','DD-MON-RR'),9,'JFK',to_date('27-FEB-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (70,34,'SESH N684EB: 49070-SESH N684EB 2019-02-19:06:34 2019.02.27','49070-SESH N684EB 2019-02-19:06:34','49070-SESH N684EB 2019-02-19:06:34',9,'JFK',to_date('27-FEB-19','DD-MON-RR'),102,'EDW',to_date('19-FEB-19','DD-MON-RR'),'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (118,102,'SJET N254GO: SJET N254GO: 2018.02.27 05:33:55 2019.04.04','SJET N254GO: 2018.02.27 05:33:55','SJET N254GO: 2018.02.27 05:33:55',7,'SFO',to_date('04-APR-19','DD-MON-RR'),4,'SQL',to_date('05-APR-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (8,18,'MELA N0210FH: 568-MELA N0210FH 2019-07-02:14:40 2019.07.02','568-MELA N0210FH 2019-07-02:14:40','568-MELA N0210FH 2019-07-02:14:40',1,'BUR',to_date('02-JUL-19','DD-MON-RR'),5,'CDG',to_date('02-JUL-19','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (20,7,'LBJ N368ST: 14020-LBJ N368ST 2017-07-05:00:00 2019.07.05','14020-LBJ N368ST 2017-07-05:00:00','14020-LBJ N368ST 2017-07-05:00:00',103,'ARP',to_date('05-JUL-19','DD-MON-RR'),2,'VNY',to_date('05-JUL-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (12,4,'CJET N777DK: 8412-CJET N777DK 2019-08-05:20:10 2019.08.05','8412-CJET N777DK 2019-08-05:20:10','8412-CJET N777DK 2019-08-05:20:10',3,'SMO',to_date('05-AUG-19','DD-MON-RR'),102,'EDW',to_date('05-AUG-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (51,33,'SESH N824ZP: 35751-SESH N824ZP 2019-09-04:10:02 2019.09.04','35751-SESH N824ZP 2019-09-04:10:02','35751-SESH N824ZP 2019-09-04:10:02',null,null,to_date('04-SEP-19','DD-MON-RR'),null,null,to_date('04-SEP-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (2,7,'LBJ N368ST: 142-LBJ N368ST 2019-09-05:21:55 2019.09.05','142-LBJ N368ST 2019-09-05:21:55','142-LBJ N368ST 2019-09-05:21:55',1,'BUR',to_date('05-SEP-19','DD-MON-RR'),102,'EDW',to_date('06-SEP-19','DD-MON-RR'),'xXX');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (91,59,'CJET N195KX: CJET N195KX: 2018.02.25 04:12:44 2020.02.25','CJET N195KX: 2018.02.25 04:12:44','CJET N195KX: 2018.02.25 04:12:44',2,'VNY',to_date('25-FEB-20','DD-MON-RR'),7,'SFO',to_date('25-FEB-20','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (71,2,'CJET N747ST: 49771-CJET N747ST 2019-02-26:12:31 ','49771-CJET N747ST 2019-02-26:12:31','49771-CJET N747ST 2019-02-26:12:31',1,'BUR',null,2,'VNY',null,'xxx');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT (FLIGHT_ID,AIRCRAFT_ID,NAME,SHORT_NAME,LONG_NAME,AIRPORT_ID_DEPARTURE,DEPARTURE_AIRPORT,DEPARTURE_DATE_TIME,AIRPORT_ID_DESTINATION,DESTINATION_AIRPORT,ARRIVAL_DATE_TIME,NOTES) values (94,59,'CJET N195KX: CJET N195KX: 2018.02.25 07:45:55 ','CJET N195KX: 2018.02.25 07:45:55','CJET N195KX: 2018.02.25 07:45:55',null,null,null,null,null,null,null);
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (117,113,'Allan, Alver H: HPSELA,LBJ,MELA,SESH is a member of the flight crew for LBJ N06BBJ: LBJ N06BBJ: 2018.02.27 04:53:05 2019.02.27','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (11,113,'Allan, Alver H: HPSELA,LBJ,MELA,SESH is a member of the flight crew for HPSELA N309MN: 7711-HPSELA N309MN 2014-07-03:07:51 2018.07.03',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (6,115,'Anderson, Annabell S: LBJ,MELA,SELA,SESH,SJET is a member of the flight crew for SELA N172GH: 426-SELA N172GH 2018-07-02:13:40 2018.07.02','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (5,115,'Anderson, Annabell S: LBJ,MELA,SELA,SESH,SJET is a member of the flight crew for SJET N64CIT: 355-SJET N64CIT 2018-07-02:10:52 2018.07.02','Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (52,117,'Avery, Ashly A: MESA,SESH,SJET is a member of the flight crew for SESH N824ZP: 36452-SESH N824ZP 2019-09-04:10:02 2018.09.04','Avery, Ashly: MESA, SJET, SESH, PCHT');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (51,117,'Avery, Ashly A: MESA,SESH,SJET is a member of the flight crew for SESH N824ZP: 35751-SESH N824ZP 2019-09-04:10:02 2019.09.04',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (50,117,'Avery, Ashly A: MESA,SESH,SJET is a member of the flight crew for SESH N824ZP: 35050-SESH N824ZP 2018-02-16:06:29 2018.02.16',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (112,118,'Bailey, Bee H: LBJ,SJET is a member of the flight crew for LBJ N343ANN: LBJ N343ANN: 2018.02.26 18:34:36 2019.02.26',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (8,119,'Baker, Benito F: MELA,MESA,SJET is a member of the flight crew for MELA N0210FH: 568-MELA N0210FH 2019-07-02:14:40 2019.07.02','Note this');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (95,123,'Black, Celestina M: SELA is a member of the flight crew for SELA N172MP: SELA N172MP: 2018.02.25 07:52:25 2018.02.25','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (95,264,'Blow, Joe S: LBJ,SELA,SESH is a member of the flight crew for SELA N172MP: SELA N172MP: 2018.02.25 07:52:25 2018.02.25','xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (2,264,'Blow, Joe S: LBJ,SELA,SESH is a member of the flight crew for LBJ N368ST: 142-LBJ N368ST 2019-09-05:21:55 2019.09.05','XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (5,125,'Bond, Chun A: MELA,SJET is a member of the flight crew for SJET N64CIT: 355-SJET N64CIT 2018-07-02:10:52 2018.07.02',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (15,125,'Bond, Chun A: MELA,SJET is a member of the flight crew for SJET N444G4: 10515-SJET N444G4 2014-08-05:12:20 2014.08.05','xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (118,126,'Bower, Dania W: SJET is a member of the flight crew for SJET N254GO: SJET N254GO: 2018.02.27 05:33:55 2019.04.04','xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (5,126,'Bower, Dania W: SJET is a member of the flight crew for SJET N64CIT: 355-SJET N64CIT 2018-07-02:10:52 2018.07.02','!');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (20,129,'Burgess, Debbi U: FBOAT,LBJ,SJET is a member of the flight crew for LBJ N368ST: 14020-LBJ N368ST 2017-07-05:00:00 2019.07.05','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (15,129,'Burgess, Debbi U: FBOAT,LBJ,SJET is a member of the flight crew for SJET N444G4: 10515-SJET N444G4 2014-08-05:12:20 2014.08.05',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (19,132,'Campbell, Denisse X: HPSELA is a member of the flight crew for HPSELA N467MN: 13319-HPSELA N467MN 2017-07-03:00:00 2017.07.03','Go');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (91,133,'Carr, Douglas B: CJET is a member of the flight crew for CJET N195KX: CJET N195KX: 2018.02.25 04:12:44 2020.02.25','x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (95,315,'Chamberlain, Wilt W: LBJ,SELA is a member of the flight crew for SELA N172MP: SELA N172MP: 2018.02.25 07:52:25 2018.02.25','abc');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (117,315,'Chamberlain, Wilt W: LBJ,SELA is a member of the flight crew for LBJ N06BBJ: LBJ N06BBJ: 2018.02.27 04:53:05 2019.02.27',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (4,314,'Chavez, Hugo Z: SELA is a member of the flight crew for SELA N172GH: 284-SELA N172GH 2014-07-01:16:03 2014.07.01','zyx');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (117,137,'Clarkson, Elma Z: LBJ,SJET is a member of the flight crew for LBJ N06BBJ: LBJ N06BBJ: 2018.02.27 04:53:05 2019.02.27',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (20,137,'Clarkson, Elma Z: LBJ,SJET is a member of the flight crew for LBJ N368ST: 14020-LBJ N368ST 2017-07-05:00:00 2019.07.05','Y');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (15,137,'Clarkson, Elma Z: LBJ,SJET is a member of the flight crew for SJET N444G4: 10515-SJET N444G4 2014-08-05:12:20 2014.08.05','xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (4,312,'Clouseau, Johnny Cat I: RSHP,SELA is a member of the flight crew for SELA N172GH: 284-SELA N172GH 2014-07-01:16:03 2014.07.01','y');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (16,312,'Clouseau, Johnny Cat I: RSHP,SELA is a member of the flight crew for SELA N172QW: 11216-SELA N172QW 2014-08-07:08:37 2014.08.07','Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (2,141,'Davies, Gabriel D: LBJ is a member of the flight crew for LBJ N368ST: 142-LBJ N368ST 2019-09-05:21:55 2019.09.05','XXY');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (10,145,'Dyer, Gertrude F: MESA,SELA is a member of the flight crew for SELA N172QW: 7010-SELA N172QW 2014-07-03:07:51 2014.07.03','x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (4,145,'Dyer, Gertrude F: MESA,SELA is a member of the flight crew for SELA N172GH: 284-SELA N172GH 2014-07-01:16:03 2014.07.01',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (11,146,'Edmunds, Gertude X: HPSELA is a member of the flight crew for HPSELA N309MN: 7711-HPSELA N309MN 2014-07-03:07:51 2018.07.03','zzzzzzzzzzzzzzzzzzz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (97,147,'Ellison, Helen W: LBJ,SESH is a member of the flight crew for SESH N824ZP: SESH N824ZP: 2018.02.25 15:02:12 2018.02.25','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (20,285,'Germania, Jerry G: BLIMP,LBJ is a member of the flight crew for LBJ N368ST: 14020-LBJ N368ST 2017-07-05:00:00 2019.07.05','XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (91,152,'Gibson, Jamal P: CJET,MELA,SELA,SESH,SJET is a member of the flight crew for CJET N195KX: CJET N195KX: 2018.02.25 04:12:44 2020.02.25',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (9,152,'Gibson, Jamal P: CJET,MELA,SELA,SESH,SJET is a member of the flight crew for MELA N0210FH: 639-MELA N0210FH 2014-07-02:00:00 2014.07.02','Notes?');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (8,152,'Gibson, Jamal P: CJET,MELA,SELA,SESH,SJET is a member of the flight crew for MELA N0210FH: 568-MELA N0210FH 2019-07-02:14:40 2019.07.02',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (71,152,'Gibson, Jamal P: CJET,MELA,SELA,SESH,SJET is a member of the flight crew for CJET N747ST: 49771-CJET N747ST 2019-02-26:12:31 ','x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (51,152,'Gibson, Jamal P: CJET,MELA,SELA,SESH,SJET is a member of the flight crew for SESH N824ZP: 35751-SESH N824ZP 2019-09-04:10:02 2019.09.04','MELA N0210FH: 2014.07.02 14:40:0 need no...');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (9,153,'Gill, Jaye L: CJET,LBJ,MELA is a member of the flight crew for MELA N0210FH: 639-MELA N0210FH 2014-07-02:00:00 2014.07.02',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (30,153,'Gill, Jaye L: CJET,LBJ,MELA is a member of the flight crew for CJET N747ST: 21030-CJET N747ST 2019-02-15:11:19 2019.02.15','No notes necessary');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (2,157,'Gray, Joye R: LBJ is a member of the flight crew for LBJ N368ST: 142-LBJ N368ST 2019-09-05:21:55 2019.09.05','Y');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (111,262,'Hack, Jeffery S: BALOON,CJET,STAR is a member of the flight crew for CJET N747ST: CJET N747ST: 2018.02.26 18:10:46 2018.02.26','ABC');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (11,165,'Hill, Lavonne P: HPSELA,SJET is a member of the flight crew for HPSELA N309MN: 7711-HPSELA N309MN 2014-07-03:07:51 2018.07.03','SJET N444G4 etc.');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (15,165,'Hill, Lavonne P: HPSELA,SJET is a member of the flight crew for SJET N444G4: 10515-SJET N444G4 2014-08-05:12:20 2014.08.05','SJET');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (6,168,'Hudson, Lien Q: SELA,SJET is a member of the flight crew for SELA N172GH: 426-SELA N172GH 2018-07-02:13:40 2018.07.02','No notes at all');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (1,11,'Hyde, Howard : [none] is a member of the flight crew for SELA N172MP: 71-SELA N172MP 2014-07-01:00:00 2014.07.01',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (9,171,'Ince, Madalyn X: MELA,SELA,SESH is a member of the flight crew for MELA N0210FH: 639-MELA N0210FH 2014-07-02:00:00 2014.07.02',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (17,171,'Ince, Madalyn X: MELA,SELA,SESH is a member of the flight crew for MELA N0210BU: 11917-MELA N0210BU 2014-08-07:10:37 2014.08.07','No notes');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (70,175,'Jones, Maxine O: SELA,SESH is a member of the flight crew for SESH N684EB: 49070-SESH N684EB 2019-02-19:06:34 2019.02.27','xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (51,175,'Jones, Maxine O: SELA,SESH is a member of the flight crew for SESH N824ZP: 35751-SESH N824ZP 2019-09-04:10:02 2019.09.04','Go!');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (4,175,'Jones, Maxine O: SELA,SESH is a member of the flight crew for SELA N172GH: 284-SELA N172GH 2014-07-01:16:03 2014.07.01',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (16,175,'Jones, Maxine O: SELA,SESH is a member of the flight crew for SELA N172QW: 11216-SELA N172QW 2014-08-07:08:37 2014.08.07',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (14,14,'Kangaroo, Kaptan M: CJET,MESA is a member of the flight crew for MESA N198FX: 9814-MESA N198FX 2014-08-05:12:19 2014.08.05',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (13,14,'Kangaroo, Kaptan M: CJET,MESA is a member of the flight crew for CJET N747AR: 9113-CJET N747AR 2018-08-05:12:13 2018.08.05',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (120,178,'King, Michelina Z: CJET is a member of the flight crew for CJET N195KX: CJET N195KX: 2018.02.28 01:51:15 2018.02.28','abc');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (111,180,'Lambert, Milda U: CJET is a member of the flight crew for CJET N747ST: CJET N747ST: 2018.02.26 18:10:46 2018.02.26',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (70,183,'Lee, Nancy Q: SJET is a member of the flight crew for SESH N684EB: 49070-SESH N684EB 2019-02-19:06:34 2019.02.27','Note this');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (5,183,'Lee, Nancy Q: SJET is a member of the flight crew for SJET N64CIT: 355-SJET N64CIT 2018-07-02:10:52 2018.07.02',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (4,267,'Loquatious, Larry L: SELA is a member of the flight crew for SELA N172GH: 284-SELA N172GH 2014-07-01:16:03 2014.07.01','Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (50,187,'Mackay, Rachal Z: LBJ,SELA,SESH is a member of the flight crew for SESH N824ZP: 35050-SESH N824ZP 2018-02-16:06:29 2018.02.16',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (18,187,'Mackay, Rachal Z: LBJ,SELA,SESH is a member of the flight crew for LBJ N343ANN: 12618-LBJ N343ANN 2014-08-07:10:40 2014.08.07',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (16,187,'Mackay, Rachal Z: LBJ,SELA,SESH is a member of the flight crew for SELA N172QW: 11216-SELA N172QW 2014-08-07:08:37 2014.08.07','Duly noted.');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (118,191,'Marshall, Raye T: SJET is a member of the flight crew for SJET N254GO: SJET N254GO: 2018.02.27 05:33:55 2019.04.04',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (13,192,'Martine, Raymond A: CJET,SELA is a member of the flight crew for CJET N747AR: 9113-CJET N747AR 2018-08-05:12:13 2018.08.05',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (12,192,'Martine, Raymond A: CJET,SELA is a member of the flight crew for CJET N777DK: 8412-CJET N777DK 2019-08-05:20:10 2019.08.05',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (10,192,'Martine, Raymond A: CJET,SELA is a member of the flight crew for SELA N172QW: 7010-SELA N172QW 2014-07-03:07:51 2014.07.03','y');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (3,192,'Martine, Raymond A: CJET,SELA is a member of the flight crew for SELA N182PB: 213-SELA N182PB 2014-07-01:16:03 2014.07.01','x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (52,195,'McDonald, Rona L: [none] is a member of the flight crew for SESH N824ZP: 36452-SESH N824ZP 2019-09-04:10:02 2018.09.04','SESH N824ZP etc.');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (50,195,'McDonald, Rona L: [none] is a member of the flight crew for SESH N824ZP: 35050-SESH N824ZP 2018-02-16:06:29 2018.02.16','2018.02.16:29:22');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (11,201,'Mitchell, Silvana R: CJET,HPSELA is a member of the flight crew for HPSELA N309MN: 7711-HPSELA N309MN 2014-07-03:07:51 2018.07.03','y');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (71,201,'Mitchell, Silvana R: CJET,HPSELA is a member of the flight crew for CJET N747ST: 49771-CJET N747ST 2019-02-26:12:31 ','z');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (70,202,'Morgan, Stephen E: BALOON,HPSELA,SESH is a member of the flight crew for SESH N684EB: 49070-SESH N684EB 2019-02-19:06:34 2019.02.27','SESH N684EB: 2018.02.19 06:34:29');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (52,202,'Morgan, Stephen E: BALOON,HPSELA,SESH is a member of the flight crew for SESH N824ZP: 36452-SESH N824ZP 2019-09-04:10:02 2018.09.04','33:05');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (118,203,'Morrison, Tandy S: BLIMP,HPSELA,LBJ,SJET is a member of the flight crew for SJET N254GO: SJET N254GO: 2018.02.27 05:33:55 2019.04.04','abc');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (7,205,'Nash, Tommy I: CJET is a member of the flight crew for CJET N777DK: 497-CJET N777DK 2014-07-02:00:00 2018.07.02','ABC');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (18,214,'Paterson, Bor D: LBJ is a member of the flight crew for LBJ N343ANN: 12618-LBJ N343ANN 2014-08-07:10:40 2014.08.07',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (6,215,'Payne, Brand S: SELA is a member of the flight crew for SELA N172GH: 426-SELA N172GH 2018-07-02:13:40 2018.07.02','X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (4,215,'Payne, Brand S: SELA is a member of the flight crew for SELA N172GH: 284-SELA N172GH 2014-07-01:16:03 2014.07.01',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (19,217,'Peters, Camer B: HPSELA is a member of the flight crew for HPSELA N467MN: 13319-HPSELA N467MN 2017-07-03:00:00 2017.07.03',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (5,219,'Poole, Charles Q: CJET,SJET is a member of the flight crew for SJET N64CIT: 355-SJET N64CIT 2018-07-02:10:52 2018.07.02',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (16,224,'Randall, D B: SELA is a member of the flight crew for SELA N172QW: 11216-SELA N172QW 2014-08-07:08:37 2014.08.07','Randall, D: SELA');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (112,227,'Roberts, Dyl K: LBJ,MELA is a member of the flight crew for LBJ N343ANN: LBJ N343ANN: 2018.02.26 18:34:36 2019.02.26','xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (9,227,'Roberts, Dyl K: LBJ,MELA is a member of the flight crew for MELA N0210FH: 639-MELA N0210FH 2014-07-02:00:00 2014.07.02','What''s wrong?');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (8,227,'Roberts, Dyl K: LBJ,MELA is a member of the flight crew for MELA N0210FH: 568-MELA N0210FH 2019-07-02:14:40 2019.07.02','Unnecessary');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (12,17,'Rubble, Barney : CJET is a member of the flight crew for CJET N777DK: 8412-CJET N777DK 2019-08-05:20:10 2019.08.05',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (5,283,'Seminole, Sam S: SJET is a member of the flight crew for SJET N64CIT: 355-SJET N64CIT 2018-07-02:10:52 2018.07.02','XXX');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (7,263,'Spade, Sam S: BALOON,CJET is a member of the flight crew for CJET N777DK: 497-CJET N777DK 2014-07-02:00:00 2018.07.02','XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (11,240,'Springer, Mol A: HPSELA is a member of the flight crew for HPSELA N309MN: 7711-HPSELA N309MN 2014-07-03:07:51 2018.07.03','x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (12,242,'Sutherland, Nico O: CJET is a member of the flight crew for CJET N777DK: 8412-CJET N777DK 2019-08-05:20:10 2019.08.05',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (7,242,'Sutherland, Nico O: CJET is a member of the flight crew for CJET N777DK: 497-CJET N777DK 2014-07-02:00:00 2018.07.02','a');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (30,242,'Sutherland, Nico O: CJET is a member of the flight crew for CJET N747ST: 21030-CJET N747ST 2019-02-15:11:19 2019.02.15','adsf');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (120,251,'Walker, Samant J: CJET is a member of the flight crew for CJET N195KX: CJET N195KX: 2018.02.28 01:51:15 2018.02.28',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (12,253,'Walsh, Son J: STAR is a member of the flight crew for CJET N777DK: 8412-CJET N777DK 2019-08-05:20:10 2019.08.05',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (8,255,'Welch, Ja Z: MELA is a member of the flight crew for MELA N0210FH: 568-MELA N0210FH 2019-07-02:14:40 2019.07.02',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (118,257,'Wilkins, Jas W: SELA,SJET is a member of the flight crew for SJET N254GO: SJET N254GO: 2018.02.27 05:33:55 2019.04.04','_');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (52,303,'Wonder, Stevie : SESH is a member of the flight crew for SESH N824ZP: 36452-SESH N824ZP 2019-09-04:10:02 2018.09.04','xz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (121,12,'Yeager, Chuck Z: CJET,MELA is a member of the flight crew for CJET N195KX: CJET N195KX: 2018.03.14 10:21:32 2018.03.14','xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (13,12,'Yeager, Chuck Z: CJET,MELA is a member of the flight crew for CJET N747AR: 9113-CJET N747AR 2018-08-05:12:13 2018.08.05','cjet');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (12,12,'Yeager, Chuck Z: CJET,MELA is a member of the flight crew for CJET N777DK: 8412-CJET N777DK 2019-08-05:20:10 2019.08.05',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (1,12,'Yeager, Chuck Z: CJET,MELA is a member of the flight crew for SELA N172MP: 71-SELA N172MP 2014-07-01:00:00 2014.07.01','Flying around 2014.07.01');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (9,12,'Yeager, Chuck Z: CJET,MELA is a member of the flight crew for MELA N0210FH: 639-MELA N0210FH 2014-07-02:00:00 2014.07.02','x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (52,12,'Yeager, Chuck Z: CJET,MELA is a member of the flight crew for SESH N824ZP: 36452-SESH N824ZP 2019-09-04:10:02 2018.09.04','Yeager');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (3,12,'Yeager, Chuck Z: CJET,MELA is a member of the flight crew for SELA N182PB: 213-SELA N182PB 2014-07-01:16:03 2014.07.01','ELA N0182PB: 2014.07.01 16:03:14');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_FLIGHT_CREW_MEMBER (FLIGHT_ID,PILOT_ID,NAME,NOTES) values (17,12,'Yeager, Chuck Z: CJET,MELA is a member of the flight crew for MELA N0210BU: 11917-MELA N0210BU 2014-08-07:10:37 2014.08.07',null);
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (113,'Allan, Alver H: HPSELA,LBJ,MELA,SESH','Allan','Alver','H','758246790',to_date('22-MAY-14','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (114,'Alsop, Angelo M: SJET','Alsop','Angelo','M','375549811',to_date('31-MAY-14','DD-MON-RR'),'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (115,'Anderson, Annabell S: LBJ,MELA,SELA,SESH,SJET','Anderson','Annabell','S','211120543',to_date('12-JUN-91','DD-MON-RR'),'ZZZZZZZZZZZZZZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (116,'Arnold, Arthur P: [none]','Arnold','Arthur','P','170689463',to_date('06-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (117,'Avery, Ashly A: MESA,SESH,SJET','Avery','Ashly','A','500516837',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (118,'Bailey, Bee H: LBJ,SJET','Bailey','Bee','H','187098948',to_date('09-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (119,'Baker, Benito F: MELA,MESA,SJET','Baker','Benito','F','795677575',to_date('16-MAY-82','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (120,'Ball, Bernadette T: [none]','Ball','Bernadette','T','886634651',to_date('28-MAY-82','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (121,'Bell, Cassandra R: MESA','Bell','Cassandra','R','593117297',to_date('05-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (122,'Berry, Cathy W: MELA,MESA','Berry','Cathy','W','488613786',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (123,'Black, Celestina M: SELA','Black','Celestina','M','319722084',to_date('30-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (124,'Blake, Chad D: GLID,LBJ,SESH,SJET,STAR','Blake','Chad','D','102425498',to_date('19-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (264,'Blow, Joe S: LBJ,SELA,SESH','Blow','Joe','S','6839520',to_date('27-OCT-87','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (125,'Bond, Chun A: MELA,SJET','Bond','Chun','A','905778425',to_date('20-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (126,'Bower, Dania W: SJET','Bower','Dania','W','732351498',to_date('14-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (127,'Brown, Darlena R: MESA','Brown','Darlena','R','270075821',to_date('24-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (128,'Buckland, Deadra G: MESA,RSHP','Buckland','Deadra','G','843642828',to_date('17-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (129,'Burgess, Debbi U: FBOAT,LBJ,SJET','Burgess','Debbi','U','407405522',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (130,'Butler, Deeann N: [none]','Butler','Deeann','N','111090997',to_date('27-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (131,'Cameron, Demetria E: HMTA','Cameron','Demetria','E','977969757',to_date('07-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (132,'Campbell, Denisse X: HPSELA','Campbell','Denisse','X','420173944',to_date('15-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (133,'Carr, Douglas B: CJET','Carr','Douglas','B','730561736',to_date('02-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (315,'Chamberlain, Wilt W: LBJ,SELA','Chamberlain','Wilt','W','286583950',to_date('28-OCT-50','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (134,'Chapman, Dudley P: LBJ','Chapman','Dudley','P','760473161',to_date('16-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (314,'Chavez, Hugo Z: SELA','Chavez','Hugo','Z','49286256',to_date('31-DEC-61','DD-MON-RR'),'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (310,'Chiguidere, Webster D: MELA,NASASS,PCHT','Chiguidere','Webster','D','39598394',to_date('29-OCT-66','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (135,'Churchill, Edgardo P: SJET','Churchill','Edgardo','P','128956416',to_date('04-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (137,'Clarkson, Elma Z: LBJ,SJET','Clarkson','Elma','Z','915157976',to_date('04-MAY-87','DD-MON-RR'),'XXXXXXXXXXX');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (136,'Clarkson, Elmer F: [none]','Clarkson','Elmer','F','236096449',to_date('12-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (312,'Clouseau, Johnny Cat I: RSHP,SELA','Clouseau','Johnny Cat','I','7654456',to_date('28-AUG-14','DD-MON-RR'),'Prowl');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (138,'Coleman, Elroy H: [none]','Coleman','Elroy','H','987814097',to_date('17-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (139,'Cornish, Eulah O: [none]','Cornish','Eulah','O','509757783',to_date('08-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (140,'Davidson, Francesco E: [none]','Davidson','Francesco','E','456312623',to_date('29-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (141,'Davies, Gabriel D: LBJ','Davies','Gabriel','D','219689919',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (142,'Dickens, Gabriela S: [none]','Dickens','Gabriela','S','152022456',to_date('03-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (143,'Dowd, Garfield K: [none]','Dowd','Garfield','K','165756819',to_date('22-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (144,'Duncan, Gaylene J: [none]','Duncan','Gaylene','J','515393844',to_date('30-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (145,'Dyer, Gertrude F: MESA,SELA','Dyer','Gertrude','F','348708112',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (15,'Earhart, Amel K: MELA','Earhart','Amel','K','12345432',to_date('01-JAN-00','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (307,'Earp, Wyatt A: NASASS','Earp','Wyatt','A','4SJ485874',to_date('29-OCT-50','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (146,'Edmunds, Gertude X: HPSELA','Edmunds','Gertude','X','535200035',to_date('03-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (147,'Ellison, Helen W: LBJ,SESH','Ellison','Helen','W','774614811',to_date('08-JUN-81','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (18,'Feldman, Wrongw W: [none]','Feldman','Wrongw','W','482829',to_date('01-APR-00','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (148,'Ferguson, Ila U: [none]','Ferguson','Ila','U','841998573',to_date('02-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (149,'Fisher, Irma F: [none]','Fisher','Irma','F','739591208',to_date('30-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (16,'Flintstone, Fr : [none]','Flintstone','Fr',null,'xxx1',to_date('05-MAY-50','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (150,'Forsyth, Isiah E: [none]','Forsyth','Isiah','E','163527225',to_date('14-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (151,'Fraser, Jacinta E: [none]','Fraser','Jacinta','E','278517673',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (309,'Garland, Beverly G: SJET','Garland','Beverly','G','29483982',to_date('28-OCT-28','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (285,'Germania, Jerry G: BLIMP,LBJ','Germania','Jerry','G','3957325',to_date('28-OCT-09','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (152,'Gibson, Jamal P: CJET,MELA,SELA,SESH,SJET','Gibson','Jamal','P','383051417',to_date('12-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (153,'Gill, Jaye L: CJET,LBJ,MELA','Gill','Jaye','L','990685730',to_date('15-JUN-77','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (154,'Glover, Jeanna Y: SJET','Glover','Jeanna','Y','638898502',to_date('21-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (155,'Graham, Jerrold G: LBJ','Graham','Jerrold','G','259525848',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (156,'Grant, Joel E: LBJ','Grant','Joel','E','272209817',to_date('28-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (157,'Gray, Joye R: LBJ','Gray','Joye','R','481746731',to_date('10-JUN-81','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (158,'Greene, Julee D: [none]','Greene','Julee','D','965886228',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (262,'Hack, Jeffery S: BALOON,CJET,STAR','Hack','Jeffery','S','29465932',to_date('27-FEB-71','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (159,'Hamilton, Julieann L: [none]','Hamilton','Julieann','L','402343590',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (160,'Hardacre, Karol Q: [none]','Hardacre','Karol','Q','894621472',to_date('14-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (161,'Harris, Kathy C: [none]','Harris','Kathy','C','628072951',to_date('07-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (162,'Hart, Kiara L: LBJ','Hart','Kiara','L','961115429',to_date('13-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (163,'Hemmings, Kris F: [none]','Hemmings','Kris','F','676034645',to_date('07-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (164,'Henderson, Latarsha I: [none]','Henderson','Latarsha','I','855995952',to_date('16-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (165,'Hill, Lavonne P: HPSELA,SJET','Hill','Lavonne','P','196321215',to_date('06-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (166,'Hodges, Leoma L: [none]','Hodges','Leoma','L','988779129',to_date('19-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (167,'Howard, Lettie M: [none]','Howard','Lettie','M','888733988',to_date('14-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (168,'Hudson, Lien Q: SELA,SJET','Hudson','Lien','Q','374973232',to_date('19-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (169,'Hughes, Lilian Z: [none]','Hughes','Lilian','Z','662478263',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (170,'Hunter, Lourdes R: MELA','Hunter','Lourdes','R','313953854',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (11,'Hyde, Howard : [none]','Hyde','Howard',null,'12345',to_date('28-NOV-99','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (171,'Ince, Madalyn X: MELA,SELA,SESH','Ince','Madalyn','X','594800415',to_date('23-MAY-83','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (172,'Jackson, Magdalene J: [none]','Jackson','Magdalene','J','429227247',to_date('24-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (173,'James, Marita K: [none]','James','Marita','K','517595388',to_date('11-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (308,'Johnson, Maureen J: SJET','Johnson','Maureen','J','684930',to_date('27-AUG-55','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (174,'Johnston, Mauro L: [none]','Johnston','Mauro','L','558531112',to_date('19-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (175,'Jones, Maxine O: SELA,SESH','Jones','Maxine','O','341246333',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (284,'Jones, Quincy R: SESH','Jones','Quincy','R','48673',to_date('28-SEP-25','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (14,'Kangaroo, Kaptan M: CJET,MESA','Kangaroo','Kaptan','M','9876543',to_date('03-MAR-30','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (176,'Kelly, Meagan D: [none]','Kelly','Meagan','D','609515912',to_date('05-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (177,'Kerr, Melony G: [none]','Kerr','Melony','G','920529111',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (178,'King, Michelina Z: CJET','King','Michelina','Z','357519521',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (179,'Knox, Michelina E: [none]','Knox','Michelina','E','173883777',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (180,'Lambert, Milda U: CJET','Lambert','Milda','U','196124606',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (181,'Langdon, Mitchel Z: [none]','Langdon','Mitchel','Z','233365580',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (182,'Lawrence, Nadia V: [none]','Lawrence','Nadia','V','732733206',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (183,'Lee, Nancy Q: SJET','Lee','Nancy','Q','981165130',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (184,'Lewis, Nilda T: SJET','Lewis','Nilda','T','889689525',to_date('27-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (267,'Loquatious, Larry L: SELA','Loquatious','Larry','L','496730',to_date('29-OCT-97','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (185,'Lyman, Petra B: [none]','Lyman','Petra','B','119031905',to_date('13-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (186,'MacDonald, Precious R: [none]','MacDonald','Precious','R','790613394',to_date('09-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (189,'MacLeod, Ramon K: MESA','MacLeod','Ramon','K','173008436',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (187,'Mackay, Rachal Z: LBJ,SELA,SESH','Mackay','Rachal','Z','287317356',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (188,'Mackenzie, Rachelle T: [none]','Mackenzie','Rachelle','T','690151856',to_date('26-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (190,'Manning, Ranae U: MELA','Manning','Ranae','U','264123490',to_date('28-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (191,'Marshall, Raye T: SJET','Marshall','Raye','T','426053711',to_date('21-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (192,'Martine, Raymond A: CJET,SELA','Martine','Raymond','A','361412463',to_date('10-JUN-88','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (193,'Mathis, Rochel G: [none]','Mathis','Rochel','G','271225146',to_date('08-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (194,'May, Rochell C: [none]','May','Rochell','C','888214412',to_date('29-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (195,'McDonald, Rona L: [none]','McDonald','Rona','L','354933752',to_date('06-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (197,'McGrath, Shannan B: [none]','McGrath','Shannan','B','229041951',to_date('06-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (196,'McLean, Salley J: [none]','McLean','Salley','J','680024959',to_date('18-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (198,'Metcalfe, Sheilah T: [none]','Metcalfe','Sheilah','T','597074604',to_date('14-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (199,'Miller, Sherice S: [none]','Miller','Sherice','S','423385749',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (200,'Mills, Shila V: [none]','Mills','Shila','V','667462427',to_date('08-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (201,'Mitchell, Silvana R: CJET,HPSELA','Mitchell','Silvana','R','449195691',to_date('03-JUN-14','DD-MON-RR'),'Note this!');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (202,'Morgan, Stephen E: BALOON,HPSELA,SESH','Morgan','Stephen','E','776096712',to_date('12-JUN-14','DD-MON-RR'),'Are there any notes?');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (203,'Morrison, Tandy S: BLIMP,HPSELA,LBJ,SJET','Morrison','Tandy','S','355843134',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (204,'Murray, Terica K: [none]','Murray','Terica','K','791390440',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (205,'Nash, Tommy I: CJET','Nash','Tommy','I','486054418',to_date('27-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (206,'Newman, Tracey M: LBJ','Newman','Tracey','M','192996750',to_date('06-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (207,'Nolan, Vashti P: [none]','Nolan','Vashti','P','501351447',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (208,'North, Velia X: [none]','North','Velia','X','582868492',to_date('15-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (209,'Ogden, Venetta G: [none]','Ogden','Venetta','G','521625879',to_date('16-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (210,'Oliver, Xochitl V: CJET','Oliver','Xochitl','V','845914811',to_date('06-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (211,'Paige, Yesenia C: [none]','Paige','Yesenia','C','924004026',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (212,'Parr, Benjam P: BLIMP','Parr','Benjam','P','356862125',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (213,'Parsons, Bla P: SESH','Parsons','Bla','P','240550168',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (214,'Paterson, Bor D: LBJ','Paterson','Bor','D','773449691',to_date('31-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (215,'Payne, Brand S: SELA','Payne','Brand','S','437778437',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (216,'Peake, Bri U: [none]','Peake','Bri','U','296126987',to_date('19-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (261,'Perera, Pri : [none]','Perera','Pri',null,'295838y693',to_date('01-APR-42','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (217,'Peters, Camer B: HPSELA','Peters','Camer','B','366148955',to_date('12-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (218,'Piper, Ca L: [none]','Piper','Ca','L','769404582',to_date('12-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (219,'Poole, Charles Q: CJET,SJET','Poole','Charles','Q','922203371',to_date('09-MAY-14','DD-MON-RR'),'Any more?');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (220,'Powell, Christi B: SELA','Powell','Christi','B','122212560',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (221,'Pullman, Christoph C: [none]','Pullman','Christoph','C','826695580',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (222,'Quinn, Col U: MELA','Quinn','Col','U','982022095',to_date('18-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (265,'Racer, Speed Z: SJET','Racer','Speed','Z','49858394',to_date('28-OCT-53','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (223,'Rampling, Conn H: LBJ','Rampling','Conn','H','934002016',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (224,'Randall, D B: SELA','Randall','D','B','652386464',to_date('09-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (225,'Rees, Dav S: [none]','Rees','Dav','S','346567020',to_date('11-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (226,'Reid, Domin U: [none]','Reid','Domin','U','733337570',to_date('14-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (227,'Roberts, Dyl K: LBJ,MELA','Roberts','Dyl','K','368081596',to_date('14-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (228,'Robertson, Edwa N: MELA','Robertson','Edwa','N','365759391',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (229,'Ross, Er C: [none]','Ross','Er','C','746175809',to_date('11-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (17,'Rubble, Barney : CJET','Rubble','Barney',null,'xxx3',to_date('07-JUL-60','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (230,'Russell, Ev L: PCHT','Russell','Ev','L','686288613',to_date('05-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (231,'Rutherford, Fra F: [none]','Rutherford','Fra','F','730284313',to_date('04-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (232,'Sanderson, Gav T: [none]','Sanderson','Gav','T','940495960',to_date('16-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (233,'Scott, Gord M: SESH','Scott','Gord','M','970099661',to_date('05-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (283,'Seminole, Sam S: SJET','Seminole','Sam','S','29583892',to_date('26-OCT-47','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (234,'Sharp, adelei E: [none]','Sharp','adelei','E','856480238',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (235,'Short, Martin N: HPSELA','Short','Martin','N','798045496',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (236,'Simpson, Ma Q: [none]','Simpson','Ma','Q','325571164',to_date('29-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (237,'Skinner, Meg X: [none]','Skinner','Meg','X','109324243',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (238,'Slater, Melan Q: [none]','Slater','Melan','Q','630834965',to_date('05-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (239,'Smith, Michel D: [none]','Smith','Michel','D','259182697',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (263,'Spade, Sam S: BALOON,CJET','Spade','Sam','S','48386832',to_date('25-AUG-79','DD-MON-RR'),'Shovel');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (266,'Speed, Breakneck Z: [none]','Speed','Breakneck','Z','45983865',to_date('28-OCT-81','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (240,'Springer, Mol A: HPSELA','Springer','Mol','A','301920300',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (241,'Stewart, Natal J: STAR','Stewart','Natal','J','529461587',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (242,'Sutherland, Nico O: CJET','Sutherland','Nico','O','843652044',to_date('22-MAY-80','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (243,'Taylor, Oliv P: [none]','Taylor','Oliv','P','261260185',to_date('08-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (244,'Terry, Penelo D: [none]','Terry','Penelo','D','958847716',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (245,'Thomson, Pip P: [none]','Thomson','Pip','P','907787248',to_date('17-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (246,'Tucker, Rach I: SELA','Tucker','Rach','I','238043745',to_date('24-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (247,'Turner, Rebec A: [none]','Turner','Rebec','A','108532215',to_date('16-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (248,'Underwood, Ro B: [none]','Underwood','Ro','B','149838818',to_date('08-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (249,'Vance, Ru Q: [none]','Vance','Ru','Q','423653571',to_date('08-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (250,'Vaughan, Sal M: [none]','Vaughan','Sal','M','816678610',to_date('12-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (251,'Walker, Samant J: CJET','Walker','Samant','J','846995219',to_date('29-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (252,'Wallace, Sar Y: SELA','Wallace','Sar','Y','735551296',to_date('19-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (253,'Walsh, Son J: STAR','Walsh','Son','J','178436030',to_date('04-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (254,'Watson, Soph V: LBJ','Watson','Soph','V','774777425',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (255,'Welch, Ja Z: MELA','Welch','Ja','Z','556835334',to_date('07-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (256,'White, Jam H: SJET','White','Jam','H','959087218',to_date('15-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (257,'Wilkins, Jas W: SELA,SJET','Wilkins','Jas','W','255392469',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (258,'Wilson, J G: [none]','Wilson','J','G','162546932',to_date('07-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (303,'Wonder, Stevie : SESH','Wonder','Stevie',null,'485874',to_date('23-JUL-45','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (259,'Wright, Jo W: [none]','Wright','Jo','W','994373889',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (13,'Wright, Wilbur : LBJ','Wright','Wilbur',null,'xxx2',to_date('06-JUN-80','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (12,'Yeager, Chuck Z: CJET,MELA','Yeager','Chuck','Z','5432',to_date('04-APR-20','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (260,'Young, Jonathan N: [none]','Young','Jonathan','N','133967479',to_date('21-MAY-14','DD-MON-RR'),null);
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (113,8,'Allan, Alver H 758246790 is certified in Aircraft Type: High-Performance Single-Engine Land Airplane','Allan, Alver H 758246790','HPSELA','DJ38587D3',to_date('20-AUG-16','DD-MON-RR'),to_date('05-NOV-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (113,7,'Allan, Alver H 758246790 is certified in Aircraft Type: Large Business Jet','Allan, Alver H 758246790','LBJ','XYXYXYXYX',to_date('01-JAN-18','DD-MON-RR'),to_date('31-DEC-20','DD-MON-RR'),'What?');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (113,3,'Allan, Alver H 758246790 is certified in Aircraft Type: Multi-Engine Land Airplane','Allan, Alver H 758246790','MELA','YYYYYYY',to_date('02-FEB-02','DD-MON-RR'),to_date('28-NOV-60','DD-MON-RR'),'Hey');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (113,6,'Allan, Alver H 758246790 is certified in Aircraft Type: Single-Engine Sea Helicopter','Allan, Alver H 758246790','SESH','FDK49FM4',to_date('04-OCT-15','DD-MON-RR'),to_date('10-MAR-00','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (114,4,'Alsop, Angelo M 375549811 is certified in Aircraft Type: Small Jet Airplane','Alsop, Angelo M 375549811','SJET','DKJ48N43I',to_date('29-OCT-17','DD-MON-RR'),to_date('07-MAR-22','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (115,7,'Anderson, Annabell S 211120543 is certified in Aircraft Type: Large Business Jet','Anderson, Annabell S 211120543','LBJ','DFK435J3',to_date('30-OCT-16','DD-MON-RR'),to_date('03-MAR-21','DD-MON-RR'),'ZZZZZZZZZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (115,3,'Anderson, Annabell S 211120543 is certified in Aircraft Type: Multi-Engine Land Airplane','Anderson, Annabell S 211120543','MELA','DEKJ4765UGH',to_date('09-FEB-17','DD-MON-RR'),to_date('20-AUG-20','DD-MON-RR'),'Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (115,1,'Anderson, Annabell S 211120543 is certified in Aircraft Type: Single-Engine Land Airplane','Anderson, Annabell S 211120543','SELA','1234567890ABCD',to_date('31-DEC-18','DD-MON-RR'),to_date('01-JAN-19','DD-MON-RR'),'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (115,6,'Anderson, Annabell S 211120543 is certified in Aircraft Type: Single-Engine Sea Helicopter','Anderson, Annabell S 211120543','SESH','J4865URE',to_date('30-OCT-16','DD-MON-RR'),to_date('05-FEB-20','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (115,4,'Anderson, Annabell S 211120543 is certified in Aircraft Type: Small Jet Airplane','Anderson, Annabell S 211120543','SJET','DJ48TNH4',to_date('30-NOV-16','DD-MON-RR'),to_date('03-MAR-24','DD-MON-RR'),'Y');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (117,2,'Avery, Ashly A 500516837 is certified in Aircraft Type: Multi-Engine Sea Airplane','Avery, Ashly A 500516837','MESA','VBVI1PTN',to_date('08-AUG-13','DD-MON-RR'),to_date('06-AUG-15','DD-MON-RR'),'Avery, Ashly: MESA, SJET, SESH');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (117,6,'Avery, Ashly A 500516837 is certified in Aircraft Type: Single-Engine Sea Helicopter','Avery, Ashly A 500516837','SESH','PY9IOECP',to_date('08-AUG-13','DD-MON-RR'),to_date('06-AUG-15','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (117,4,'Avery, Ashly A 500516837 is certified in Aircraft Type: Small Jet Airplane','Avery, Ashly A 500516837','SJET','DJ48FJ58H5',to_date('29-JAN-16','DD-MON-RR'),to_date('26-JAN-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (118,7,'Bailey, Bee H 187098948 is certified in Aircraft Type: Large Business Jet','Bailey, Bee H 187098948','LBJ','DKJ4JTJ',to_date('29-OCT-16','DD-MON-RR'),to_date('03-APR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (118,4,'Bailey, Bee H 187098948 is certified in Aircraft Type: Small Jet Airplane','Bailey, Bee H 187098948','SJET','DK385JF3',to_date('29-OCT-15','DD-MON-RR'),to_date('09-MAR-21','DD-MON-RR'),'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (119,3,'Baker, Benito F 795677575 is certified in Aircraft Type: Multi-Engine Land Airplane','Baker, Benito F 795677575','MELA','FDKJ48FJ38T4',to_date('01-DEC-17','DD-MON-RR'),to_date('23-DEC-19','DD-MON-RR'),'No notes needed');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (119,2,'Baker, Benito F 795677575 is certified in Aircraft Type: Multi-Engine Sea Airplane','Baker, Benito F 795677575','MESA','DK4KJM3',to_date('29-OCT-15','DD-MON-RR'),to_date('16-MAY-19','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (119,4,'Baker, Benito F 795677575 is certified in Aircraft Type: Small Jet Airplane','Baker, Benito F 795677575','SJET','D484GN',to_date('25-SEP-15','DD-MON-RR'),to_date('15-MAR-21','DD-MON-RR'),'Take note');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (121,2,'Bell, Cassandra R 593117297 is certified in Aircraft Type: Multi-Engine Sea Airplane','Bell, Cassandra R 593117297','MESA','CXXXXX99999',to_date('31-DEC-17','DD-MON-RR'),to_date('01-JAN-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (122,3,'Berry, Cathy W 488613786 is certified in Aircraft Type: Multi-Engine Land Airplane','Berry, Cathy W 488613786','MELA','3IF84HJ',to_date('25-SEP-17','DD-MON-RR'),to_date('11-MAR-21','DD-MON-RR'),'Duly noted.');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (122,2,'Berry, Cathy W 488613786 is certified in Aircraft Type: Multi-Engine Sea Airplane','Berry, Cathy W 488613786','MESA','X9X9X9X9X9X9X9',to_date('29-OCT-15','DD-MON-RR'),to_date('06-MAY-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (123,1,'Black, Celestina M 319722084 is certified in Aircraft Type: Single-Engine Land Airplane','Black, Celestina M 319722084','SELA','DK45I8G',to_date('29-OCT-16','DD-MON-RR'),to_date('29-OCT-23','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (124,35,'Blake, Chad D 102425498 is certified in Aircraft Type: Glider','Blake, Chad D 102425498','GLID','DSK4K45IGF',to_date('28-SEP-15','DD-MON-RR'),to_date('10-APR-20','DD-MON-RR'),'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (124,7,'Blake, Chad D 102425498 is certified in Aircraft Type: Large Business Jet','Blake, Chad D 102425498','LBJ','SDKJDJ48UGN4',to_date('28-FEB-17','DD-MON-RR'),to_date('26-FEB-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (124,6,'Blake, Chad D 102425498 is certified in Aircraft Type: Single-Engine Sea Helicopter','Blake, Chad D 102425498','SESH','DK4985JD',to_date('28-NOV-16','DD-MON-RR'),to_date('21-NOV-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (124,4,'Blake, Chad D 102425498 is certified in Aircraft Type: Small Jet Airplane','Blake, Chad D 102425498','SJET','DKJ4JJ43',to_date('28-FEB-17','DD-MON-RR'),to_date('26-FEB-19','DD-MON-RR'),'No notes');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (124,39,'Blake, Chad D 102425498 is certified in Aircraft Type: Starship','Blake, Chad D 102425498','STAR','XKJEJ4IGJ4',to_date('29-OCT-17','DD-MON-RR'),to_date('09-MAR-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (264,7,'Blow, Joe S 6839520 is certified in Aircraft Type: Large Business Jet','Blow, Joe S 6839520','LBJ','DJ43856UNF43',to_date('29-OCT-16','DD-MON-RR'),to_date('14-MAR-21','DD-MON-RR'),'XXXXXXXXX');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (264,1,'Blow, Joe S 6839520 is certified in Aircraft Type: Single-Engine Land Airplane','Blow, Joe S 6839520','SELA','DJ48N4UGF',to_date('28-OCT-15','DD-MON-RR'),to_date('19-SEP-26','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (264,6,'Blow, Joe S 6839520 is certified in Aircraft Type: Single-Engine Sea Helicopter','Blow, Joe S 6839520','SESH','DK485U4HJ4D',to_date('25-OCT-17','DD-MON-RR'),to_date('21-AUG-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (125,3,'Bond, Chun A 905778425 is certified in Aircraft Type: Multi-Engine Land Airplane','Bond, Chun A 905778425','MELA','DK4TJ598G',to_date('31-DEC-17','DD-MON-RR'),to_date('01-JAN-19','DD-MON-RR'),'XYZXYZXYZXYZXYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (125,4,'Bond, Chun A 905778425 is certified in Aircraft Type: Small Jet Airplane','Bond, Chun A 905778425','SJET','7NSIB45U',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (126,4,'Bower, Dania W 732351498 is certified in Aircraft Type: Small Jet Airplane','Bower, Dania W 732351498','SJET','SDJ38RN33D',to_date('27-SEP-16','DD-MON-RR'),to_date('10-APR-21','DD-MON-RR'),'L');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (127,2,'Brown, Darlena R 270075821 is certified in Aircraft Type: Multi-Engine Sea Airplane','Brown, Darlena R 270075821','MESA','CNDKYE50',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),'Brown, Darlena: MESA');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (128,2,'Buckland, Deadra G 843642828 is certified in Aircraft Type: Multi-Engine Sea Airplane','Buckland, Deadra G 843642828','MESA','JH1QBJV2',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (128,38,'Buckland, Deadra G 843642828 is certified in Aircraft Type: Rocket Ship','Buckland, Deadra G 843642828','RSHP','DK4ITMJ43',to_date('29-NOV-16','DD-MON-RR'),to_date('05-MAR-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (129,40,'Burgess, Debbi U 407405522 is certified in Aircraft Type: Flying Boat','Burgess, Debbi U 407405522','FBOAT','DKJDJ486T3',to_date('28-OCT-16','DD-MON-RR'),to_date('18-AUG-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (129,7,'Burgess, Debbi U 407405522 is certified in Aircraft Type: Large Business Jet','Burgess, Debbi U 407405522','LBJ','J6TDW6TJ',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (129,4,'Burgess, Debbi U 407405522 is certified in Aircraft Type: Small Jet Airplane','Burgess, Debbi U 407405522','SJET','DJ4385UJR4',to_date('29-OCT-16','DD-MON-RR'),to_date('19-DEC-21','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (131,34,'Cameron, Demetria E 977969757 is certified in Aircraft Type: Heavy Military Transport Airplane','Cameron, Demetria E 977969757','HMTA','DKJ48T5J43',to_date('29-OCT-16','DD-MON-RR'),to_date('09-MAR-19','DD-MON-RR'),'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (132,8,'Campbell, Denisse X 420173944 is certified in Aircraft Type: High-Performance Single-Engine Land Airplane','Campbell, Denisse X 420173944','HPSELA','RI59FJ48FN396H',to_date('04-JUL-16','DD-MON-RR'),to_date('02-JUL-18','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (133,5,'Carr, Douglas B 730561736 is certified in Aircraft Type: Commercial Jet Airplane','Carr, Douglas B 730561736','CJET','48FJ47',to_date('20-SEP-16','DD-MON-RR'),to_date('09-MAR-22','DD-MON-RR'),'What happened?');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (315,7,'Chamberlain, Wilt W 286583950 is certified in Aircraft Type: Large Business Jet','Chamberlain, Wilt W 286583950','LBJ','DKEK4JU6843',to_date('29-OCT-15','DD-MON-RR'),to_date('21-JUL-20','DD-MON-RR'),'Y');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (315,1,'Chamberlain, Wilt W 286583950 is certified in Aircraft Type: Single-Engine Land Airplane','Chamberlain, Wilt W 286583950','SELA','DKDEKJ4UG',to_date('29-OCT-16','DD-MON-RR'),to_date('19-SEP-20','DD-MON-RR'),'ABC');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (134,7,'Chapman, Dudley P 760473161 is certified in Aircraft Type: Large Business Jet','Chapman, Dudley P 760473161','LBJ','DJ48GH4',to_date('29-OCT-17','DD-MON-RR'),to_date('04-APR-24','DD-MON-RR'),'2024');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (314,1,'Chavez, Hugo Z 49286256 is certified in Aircraft Type: Single-Engine Land Airplane','Chavez, Hugo Z 49286256','SELA','43KFIU48UT3',to_date('29-OCT-16','DD-MON-RR'),to_date('17-SEP-24','DD-MON-RR'),'abc');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (310,3,'Chiguidere, Webster D 39598394 is certified in Aircraft Type: Multi-Engine Land Airplane','Chiguidere, Webster D 39598394','MELA','DKJ43865HJ384',to_date('29-OCT-16','DD-MON-RR'),to_date('12-MAR-21','DD-MON-RR'),'ZZZZZZZZZZZZZZZZZZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (310,32,'Chiguidere, Webster D 39598394 is certified in Aircraft Type: NASA Space Shuttle','Chiguidere, Webster D 39598394','NASASS','SK3985N3',to_date('29-OCT-17','DD-MON-RR'),to_date('03-MAR-22','DD-MON-RR'),'Zx');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (310,36,'Chiguidere, Webster D 39598394 is certified in Aircraft Type: Parachute','Chiguidere, Webster D 39598394','PCHT','DJ43JGTN3',to_date('29-NOV-16','DD-MON-RR'),to_date('04-APR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (135,4,'Churchill, Edgardo P 128956416 is certified in Aircraft Type: Small Jet Airplane','Churchill, Edgardo P 128956416','SJET','FK48FN4I8',to_date('04-OCT-17','DD-MON-RR'),to_date('29-MAR-20','DD-MON-RR'),'No notes this time');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (137,7,'Clarkson, Elma Z 915157976 is certified in Aircraft Type: Large Business Jet','Clarkson, Elma Z 915157976','LBJ','348TJ4985',to_date('27-SEP-15','DD-MON-RR'),to_date('13-MAY-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (137,4,'Clarkson, Elma Z 915157976 is certified in Aircraft Type: Small Jet Airplane','Clarkson, Elma Z 915157976','SJET','DK348F438TR',to_date('30-NOV-15','DD-MON-RR'),to_date('11-FEB-27','DD-MON-RR'),'DUPLICATE');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (312,38,'Clouseau, Johnny Cat I 7654456 is certified in Aircraft Type: Rocket Ship','Clouseau, Johnny Cat I 7654456','RSHP','DJ438THJ3',to_date('29-OCT-16','DD-MON-RR'),to_date('23-AUG-21','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (312,1,'Clouseau, Johnny Cat I 7654456 is certified in Aircraft Type: Single-Engine Land Airplane','Clouseau, Johnny Cat I 7654456','SELA','1111111111111111',to_date('01-JAN-18','DD-MON-RR'),to_date('31-DEC-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (141,7,'Davies, Gabriel D 219689919 is certified in Aircraft Type: Large Business Jet','Davies, Gabriel D 219689919','LBJ','DJ4875YFN3',to_date('28-OCT-13','DD-MON-RR'),to_date('05-MAR-26','DD-MON-RR'),'XXY');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (145,2,'Dyer, Gertrude F 348708112 is certified in Aircraft Type: Multi-Engine Sea Airplane','Dyer, Gertrude F 348708112','MESA','2A6QYK49',to_date('04-JUL-13','DD-MON-RR'),to_date('02-JUL-15','DD-MON-RR'),'Notes');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (145,1,'Dyer, Gertrude F 348708112 is certified in Aircraft Type: Single-Engine Land Airplane','Dyer, Gertrude F 348708112','SELA','0Y00CYGL',to_date('04-JUL-13','DD-MON-RR'),to_date('02-JUL-15','DD-MON-RR'),'Dyer, Gertrude: SELA, MESA');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (15,3,'Earhart, Amel K 12345432 is certified in Aircraft Type: Multi-Engine Land Airplane','Earhart, Amel K 12345432','MELA','48DN38F4',to_date('11-NOV-11','DD-MON-RR'),to_date('19-JAN-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (307,32,'Earp, Wyatt A 4SJ485874 is certified in Aircraft Type: NASA Space Shuttle','Earp, Wyatt A 4SJ485874','NASASS','DJ48TH438',to_date('29-OCT-16','DD-MON-RR'),to_date('12-MAR-20','DD-MON-RR'),'Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (146,8,'Edmunds, Gertude X 535200035 is certified in Aircraft Type: High-Performance Single-Engine Land Airplane','Edmunds, Gertude X 535200035','HPSELA','z0z0z0z0z0z01',to_date('31-DEC-18','DD-MON-RR'),to_date('01-JAN-19','DD-MON-RR'),'z0z0z0z0z0z01');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (147,7,'Ellison, Helen W 774614811 is certified in Aircraft Type: Large Business Jet','Ellison, Helen W 774614811','LBJ','DJ484583N4IU',to_date('27-NOV-16','DD-MON-RR'),to_date('12-MAY-19','DD-MON-RR'),'2019');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (147,6,'Ellison, Helen W 774614811 is certified in Aircraft Type: Single-Engine Sea Helicopter','Ellison, Helen W 774614811','SESH','EIFHJ3UT845',to_date('05-APR-17','DD-MON-RR'),to_date('07-JUL-22','DD-MON-RR'),'2022');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (309,4,'Garland, Beverly G 29483982 is certified in Aircraft Type: Small Jet Airplane','Garland, Beverly G 29483982','SJET','DSK498TJ32',to_date('30-OCT-15','DD-MON-RR'),to_date('10-MAR-21','DD-MON-RR'),'Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (285,10,'Germania, Jerry G 3957325 is certified in Aircraft Type: Blimp','Germania, Jerry G 3957325','BLIMP','DJ48765Y3',to_date('29-OCT-13','DD-MON-RR'),to_date('17-MAR-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (285,7,'Germania, Jerry G 3957325 is certified in Aircraft Type: Large Business Jet','Germania, Jerry G 3957325','LBJ','DJ4U85687EJD',to_date('29-NOV-17','DD-MON-RR'),to_date('03-FEB-28','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (152,5,'Gibson, Jamal P 383051417 is certified in Aircraft Type: Commercial Jet Airplane','Gibson, Jamal P 383051417','CJET','DJ38757RN3',to_date('28-SEP-15','DD-MON-RR'),to_date('13-MAY-21','DD-MON-RR'),'Commercial');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (152,3,'Gibson, Jamal P 383051417 is certified in Aircraft Type: Multi-Engine Land Airplane','Gibson, Jamal P 383051417','MELA','DK498GJ4',to_date('21-SEP-15','DD-MON-RR'),to_date('11-FEB-22','DD-MON-RR'),'Multi-Engine Land Airplane');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (152,1,'Gibson, Jamal P 383051417 is certified in Aircraft Type: Single-Engine Land Airplane','Gibson, Jamal P 383051417','SELA','DJ48N4',to_date('30-NOV-16','DD-MON-RR'),to_date('03-MAR-19','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (152,6,'Gibson, Jamal P 383051417 is certified in Aircraft Type: Single-Engine Sea Helicopter','Gibson, Jamal P 383051417','SESH','43KF84NT',to_date('17-SEP-16','DD-MON-RR'),to_date('18-JUL-23','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (152,4,'Gibson, Jamal P 383051417 is certified in Aircraft Type: Small Jet Airplane','Gibson, Jamal P 383051417','SJET','DJ48F4',to_date('28-OCT-15','DD-MON-RR'),to_date('11-APR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (153,5,'Gill, Jaye L 990685730 is certified in Aircraft Type: Commercial Jet Airplane','Gill, Jaye L 990685730','CJET','4858GJK',to_date('21-SEP-16','DD-MON-RR'),to_date('15-AUG-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (153,7,'Gill, Jaye L 990685730 is certified in Aircraft Type: Large Business Jet','Gill, Jaye L 990685730','LBJ','43IF84UT',to_date('29-OCT-15','DD-MON-RR'),to_date('20-AUG-22','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (153,3,'Gill, Jaye L 990685730 is certified in Aircraft Type: Multi-Engine Land Airplane','Gill, Jaye L 990685730','MELA','38FJ48T',to_date('25-SEP-16','DD-MON-RR'),to_date('14-JUL-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (154,4,'Glover, Jeanna Y 638898502 is certified in Aircraft Type: Small Jet Airplane','Glover, Jeanna Y 638898502','SJET','DJ385UFNB43',to_date('27-SEP-16','DD-MON-RR'),to_date('13-APR-21','DD-MON-RR'),'Glover, Jeanna: SJET');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (155,7,'Graham, Jerrold G 259525848 is certified in Aircraft Type: Large Business Jet','Graham, Jerrold G 259525848','LBJ','c',to_date('16-FEB-17','DD-MON-RR'),to_date('14-FEB-19','DD-MON-RR'),'DFK485UN5');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (156,7,'Grant, Joel E 272209817 is certified in Aircraft Type: Large Business Jet','Grant, Joel E 272209817','LBJ','SK4385G',to_date('29-OCT-15','DD-MON-RR'),to_date('11-MAR-21','DD-MON-RR'),'Z');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (157,7,'Gray, Joye R 481746731 is certified in Aircraft Type: Large Business Jet','Gray, Joye R 481746731','LBJ','DSJ485HF',to_date('28-OCT-16','DD-MON-RR'),to_date('10-MAR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (262,5,'Hack, Jeffery S 29465932 is certified in Aircraft Type: Commercial Jet Airplane','Hack, Jeffery S 29465932','CJET','DSK3MJTJ45',to_date('29-OCT-16','DD-MON-RR'),to_date('09-MAR-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (262,9,'Hack, Jeffery S 29465932 is certified in Aircraft Type: Hot-Air Ballloon','Hack, Jeffery S 29465932','BALOON','438FRN48',to_date('28-OCT-13','DD-MON-RR'),to_date('11-APR-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (262,39,'Hack, Jeffery S 29465932 is certified in Aircraft Type: Starship','Hack, Jeffery S 29465932','STAR','DL4K6K465T',to_date('30-NOV-17','DD-MON-RR'),to_date('04-FEB-19','DD-MON-RR'),'Fly!');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (162,7,'Hart, Kiara L 961115429 is certified in Aircraft Type: Large Business Jet','Hart, Kiara L 961115429','LBJ','DK348TN3',to_date('29-OCT-16','DD-MON-RR'),to_date('14-MAR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (165,8,'Hill, Lavonne P 196321215 is certified in Aircraft Type: High-Performance Single-Engine Land Airplane','Hill, Lavonne P 196321215','HPSELA','DJ48TYU437F',to_date('27-AUG-15','DD-MON-RR'),to_date('13-MAY-20','DD-MON-RR'),'No notes at all');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (165,4,'Hill, Lavonne P 196321215 is certified in Aircraft Type: Small Jet Airplane','Hill, Lavonne P 196321215','SJET','DJ48TU4H',to_date('26-SEP-16','DD-MON-RR'),to_date('21-SEP-22','DD-MON-RR'),'Noting to see or hear');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (168,1,'Hudson, Lien Q 374973232 is certified in Aircraft Type: Single-Engine Land Airplane','Hudson, Lien Q 374973232','SELA','FDJ3845UG',to_date('28-OCT-16','DD-MON-RR'),to_date('03-MAR-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (168,4,'Hudson, Lien Q 374973232 is certified in Aircraft Type: Small Jet Airplane','Hudson, Lien Q 374973232','SJET','395TJ48',to_date('05-SEP-16','DD-MON-RR'),to_date('09-OCT-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (170,3,'Hunter, Lourdes R 313953854 is certified in Aircraft Type: Multi-Engine Land Airplane','Hunter, Lourdes R 313953854','MELA','38CDN48',to_date('29-OCT-14','DD-MON-RR'),to_date('17-JUN-22','DD-MON-RR'),'Hunter, Lourdes: MELA 2022');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (171,3,'Ince, Madalyn X 594800415 is certified in Aircraft Type: Multi-Engine Land Airplane','Ince, Madalyn X 594800415','MELA','FDJ48FN48',to_date('16-JUN-16','DD-MON-RR'),to_date('26-MAY-20','DD-MON-RR'),'M');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (171,1,'Ince, Madalyn X 594800415 is certified in Aircraft Type: Single-Engine Land Airplane','Ince, Madalyn X 594800415','SELA','3JD843HF',to_date('28-NOV-17','DD-MON-RR'),to_date('12-MAY-21','DD-MON-RR'),'N');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (171,6,'Ince, Madalyn X 594800415 is certified in Aircraft Type: Single-Engine Sea Helicopter','Ince, Madalyn X 594800415','SESH','XJ43U5UE',to_date('27-AUG-15','DD-MON-RR'),to_date('21-JUL-21','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (308,4,'Johnson, Maureen J 684930 is certified in Aircraft Type: Small Jet Airplane','Johnson, Maureen J 684930','SJET','DK4865UF',to_date('29-NOV-14','DD-MON-RR'),to_date('04-APR-21','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (175,1,'Jones, Maxine O 341246333 is certified in Aircraft Type: Single-Engine Land Airplane','Jones, Maxine O 341246333','SELA','Y73Y5KHF',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (175,6,'Jones, Maxine O 341246333 is certified in Aircraft Type: Single-Engine Sea Helicopter','Jones, Maxine O 341246333','SESH','48FH482',to_date('25-SEP-17','DD-MON-RR'),to_date('27-FEB-22','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (284,6,'Jones, Quincy R 48673 is certified in Aircraft Type: Single-Engine Sea Helicopter','Jones, Quincy R 48673','SESH','DK4856U74DK',to_date('29-OCT-16','DD-MON-RR'),to_date('17-APR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (14,5,'Kangaroo, Kaptan M 9876543 is certified in Aircraft Type: Commercial Jet Airplane','Kangaroo, Kaptan M 9876543','CJET','ZRHGM532',to_date('02-JUL-13','DD-MON-RR'),to_date('30-JUN-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (14,2,'Kangaroo, Kaptan M 9876543 is certified in Aircraft Type: Multi-Engine Sea Airplane','Kangaroo, Kaptan M 9876543','MESA','DHJ38F5H',to_date('02-FEB-02','DD-MON-RR'),to_date('01-FEB-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (178,5,'King, Michelina Z 357519521 is certified in Aircraft Type: Commercial Jet Airplane','King, Michelina Z 357519521','CJET','DJ438VN48',to_date('16-FEB-17','DD-MON-RR'),to_date('14-FEB-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (180,5,'Lambert, Milda U 196124606 is certified in Aircraft Type: Commercial Jet Airplane','Lambert, Milda U 196124606','CJET','DJ48EJ38G',to_date('16-FEB-17','DD-MON-RR'),to_date('14-FEB-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (183,4,'Lee, Nancy Q 981165130 is certified in Aircraft Type: Small Jet Airplane','Lee, Nancy Q 981165130','SJET','SK28RHJ4',to_date('28-OCT-18','DD-MON-RR'),to_date('13-JAN-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (184,4,'Lewis, Nilda T 889689525 is certified in Aircraft Type: Small Jet Airplane','Lewis, Nilda T 889689525','SJET','EK48TH48',to_date('19-OCT-16','DD-MON-RR'),to_date('18-OCT-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (267,1,'Loquatious, Larry L 496730 is certified in Aircraft Type: Single-Engine Land Airplane','Loquatious, Larry L 496730','SELA','DJ4T72BT8',to_date('28-OCT-15','DD-MON-RR'),to_date('17-APR-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (189,2,'MacLeod, Ramon K 173008436 is certified in Aircraft Type: Multi-Engine Sea Airplane','MacLeod, Ramon K 173008436','MESA','WKX0IGM9',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (187,7,'Mackay, Rachal Z 287317356 is certified in Aircraft Type: Large Business Jet','Mackay, Rachal Z 287317356','LBJ','DK438FJ48',to_date('25-JUL-15','DD-MON-RR'),to_date('15-MAY-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (187,1,'Mackay, Rachal Z 287317356 is certified in Aircraft Type: Single-Engine Land Airplane','Mackay, Rachal Z 287317356','SELA','3SKJ38CN3',to_date('28-SEP-15','DD-MON-RR'),to_date('13-MAY-22','DD-MON-RR'),'Mackay, Rachal: SELA, SESH, LBJ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (187,6,'Mackay, Rachal Z 287317356 is certified in Aircraft Type: Single-Engine Sea Helicopter','Mackay, Rachal Z 287317356','SESH','49FJK498F',to_date('29-OCT-16','DD-MON-RR'),to_date('06-APR-22','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (190,3,'Manning, Ranae U 264123490 is certified in Aircraft Type: Multi-Engine Land Airplane','Manning, Ranae U 264123490','MELA','DJ48FN4843',to_date('25-SEP-16','DD-MON-RR'),to_date('19-JUL-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (191,4,'Marshall, Raye T 426053711 is certified in Aircraft Type: Small Jet Airplane','Marshall, Raye T 426053711','SJET','FKJ484H385H32',to_date('22-FEB-17','DD-MON-RR'),to_date('15-APR-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (192,5,'Martine, Raymond A 361412463 is certified in Aircraft Type: Commercial Jet Airplane','Martine, Raymond A 361412463','CJET','D374575EM',to_date('28-OCT-16','DD-MON-RR'),to_date('17-SEP-20','DD-MON-RR'),'yz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (192,1,'Martine, Raymond A 361412463 is certified in Aircraft Type: Single-Engine Land Airplane','Martine, Raymond A 361412463','SELA','925QGK0S',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),'xy');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (201,5,'Mitchell, Silvana R 449195691 is certified in Aircraft Type: Commercial Jet Airplane','Mitchell, Silvana R 449195691','CJET','DK48GJ4',to_date('28-OCT-15','DD-MON-RR'),to_date('11-APR-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (201,8,'Mitchell, Silvana R 449195691 is certified in Aircraft Type: High-Performance Single-Engine Land Airplane','Mitchell, Silvana R 449195691','HPSELA','FJ48T583UF',to_date('28-OCT-15','DD-MON-RR'),to_date('12-MAR-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (202,8,'Morgan, Stephen E 776096712 is certified in Aircraft Type: High-Performance Single-Engine Land Airplane','Morgan, Stephen E 776096712','HPSELA','DJ38FN48',to_date('28-SEP-16','DD-MON-RR'),to_date('22-JUL-21','DD-MON-RR'),'What notes? No notes at all');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (202,9,'Morgan, Stephen E 776096712 is certified in Aircraft Type: Hot-Air Ballloon','Morgan, Stephen E 776096712','BALOON','DFKJ48N4',to_date('22-AUG-16','DD-MON-RR'),to_date('16-AUG-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (202,6,'Morgan, Stephen E 776096712 is certified in Aircraft Type: Single-Engine Sea Helicopter','Morgan, Stephen E 776096712','SESH','DZXZXZXZ0',to_date('27-SEP-15','DD-MON-RR'),to_date('21-JUL-22','DD-MON-RR'),'Notes? What notes? We don'' need no stinkin'' notes!!!');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (203,10,'Morrison, Tandy S 355843134 is certified in Aircraft Type: Blimp','Morrison, Tandy S 355843134','BLIMP','62M5M2',to_date('23-JUL-06','DD-MON-RR'),to_date('15-SEP-28','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (203,8,'Morrison, Tandy S 355843134 is certified in Aircraft Type: High-Performance Single-Engine Land Airplane','Morrison, Tandy S 355843134','HPSELA','92J68B',to_date('26-SEP-14','DD-MON-RR'),to_date('16-MAR-24','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (203,7,'Morrison, Tandy S 355843134 is certified in Aircraft Type: Large Business Jet','Morrison, Tandy S 355843134','LBJ','48FH487F',to_date('27-OCT-14','DD-MON-RR'),to_date('12-APR-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (203,4,'Morrison, Tandy S 355843134 is certified in Aircraft Type: Small Jet Airplane','Morrison, Tandy S 355843134','SJET','4587GH47',to_date('27-AUG-15','DD-MON-RR'),to_date('10-APR-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (205,5,'Nash, Tommy I 486054418 is certified in Aircraft Type: Commercial Jet Airplane','Nash, Tommy I 486054418','CJET','DK43I8FJ485W',to_date('05-FEB-16','DD-MON-RR'),to_date('21-JUL-20','DD-MON-RR'),'A+');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (206,7,'Newman, Tracey M 192996750 is certified in Aircraft Type: Large Business Jet','Newman, Tracey M 192996750','LBJ','DJ48583',to_date('04-OCT-17','DD-MON-RR'),to_date('24-SEP-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (210,5,'Oliver, Xochitl V 845914811 is certified in Aircraft Type: Commercial Jet Airplane','Oliver, Xochitl V 845914811','CJET','438FJ48F',to_date('27-OCT-16','DD-MON-RR'),to_date('11-APR-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (212,10,'Parr, Benjam P 356862125 is certified in Aircraft Type: Blimp','Parr, Benjam P 356862125','BLIMP','38FN459N65I',to_date('06-AUG-01','DD-MON-RR'),to_date('04-MAR-17','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (213,6,'Parsons, Bla P 240550168 is certified in Aircraft Type: Single-Engine Sea Helicopter','Parsons, Bla P 240550168','SESH','HCO0B2XS',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (214,7,'Paterson, Bor D 773449691 is certified in Aircraft Type: Large Business Jet','Paterson, Bor D 773449691','LBJ','RP60ESRR',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (215,1,'Payne, Brand S 437778437 is certified in Aircraft Type: Single-Engine Land Airplane','Payne, Brand S 437778437','SELA','8VMM24QG',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (217,8,'Peters, Camer B 366148955 is certified in Aircraft Type: High-Performance Single-Engine Land Airplane','Peters, Camer B 366148955','HPSELA','DJ48GNJ48',to_date('28-NOV-17','DD-MON-RR'),to_date('25-MAY-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (219,5,'Poole, Charles Q 922203371 is certified in Aircraft Type: Commercial Jet Airplane','Poole, Charles Q 922203371','CJET','DKJ4856UDN43',to_date('28-SEP-15','DD-MON-RR'),to_date('13-APR-20','DD-MON-RR'),'Hey');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (219,4,'Poole, Charles Q 922203371 is certified in Aircraft Type: Small Jet Airplane','Poole, Charles Q 922203371','SJET','BWQJHYXV',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),'No notes');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (220,1,'Powell, Christi B 122212560 is certified in Aircraft Type: Single-Engine Land Airplane','Powell, Christi B 122212560','SELA','38DFN48',to_date('28-SEP-16','DD-MON-RR'),to_date('07-MAY-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (222,3,'Quinn, Col U 982022095 is certified in Aircraft Type: Multi-Engine Land Airplane','Quinn, Col U 982022095','MELA','QC123456',to_date('28-NOV-10','DD-MON-RR'),to_date('28-NOV-21','DD-MON-RR'),'No notes required.');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (265,4,'Racer, Speed Z 49858394 is certified in Aircraft Type: Small Jet Airplane','Racer, Speed Z 49858394','SJET','DN3875329K',to_date('29-SEP-16','DD-MON-RR'),to_date('20-JUL-21','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (223,7,'Rampling, Conn H 934002016 is certified in Aircraft Type: Large Business Jet','Rampling, Conn H 934002016','LBJ','XXXXX11111',to_date('29-OCT-16','DD-MON-RR'),to_date('06-MAY-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (224,1,'Randall, D B 652386464 is certified in Aircraft Type: Single-Engine Land Airplane','Randall, D B 652386464','SELA','QMTQKQ5E',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (227,7,'Roberts, Dyl K 368081596 is certified in Aircraft Type: Large Business Jet','Roberts, Dyl K 368081596','LBJ','189756Q6',to_date('03-JUN-13','DD-MON-RR'),to_date('01-APR-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (227,3,'Roberts, Dyl K 368081596 is certified in Aircraft Type: Multi-Engine Land Airplane','Roberts, Dyl K 368081596','MELA','FJ4UFR492',to_date('01-DEC-17','DD-MON-RR'),to_date('23-DEC-19','DD-MON-RR'),'Stinkin');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (228,3,'Robertson, Edwa N 365759391 is certified in Aircraft Type: Multi-Engine Land Airplane','Robertson, Edwa N 365759391','MELA','FK48GFJ48GJ687',to_date('07-JUL-16','DD-MON-RR'),to_date('05-JUL-18','DD-MON-RR'),'Nots Robertson, Edwa: MELA');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (17,5,'Rubble, Barney  xxx3 is certified in Aircraft Type: Commercial Jet Airplane','Rubble, Barney  xxx3','CJET','MELOPXBK',to_date('02-JUL-13','DD-MON-RR'),to_date('30-JUN-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (230,36,'Russell, Ev L 686288613 is certified in Aircraft Type: Parachute','Russell, Ev L 686288613','PCHT','DJ38T5N3',to_date('29-OCT-15','DD-MON-RR'),to_date('03-FEB-23','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (233,6,'Scott, Gord M 970099661 is certified in Aircraft Type: Single-Engine Sea Helicopter','Scott, Gord M 970099661','SESH','TGXHWWBW',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (283,4,'Seminole, Sam S 29583892 is certified in Aircraft Type: Small Jet Airplane','Seminole, Sam S 29583892','SJET','SKJ4385HJW',to_date('29-OCT-16','DD-MON-RR'),to_date('14-MAY-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (235,8,'Short, Martin N 798045496 is certified in Aircraft Type: High-Performance Single-Engine Land Airplane','Short, Martin N 798045496','HPSELA','LL5J74NB',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (263,5,'Spade, Sam S 48386832 is certified in Aircraft Type: Commercial Jet Airplane','Spade, Sam S 48386832','CJET','DJ4U8FN4U8',to_date('28-SEP-15','DD-MON-RR'),to_date('07-APR-20','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (263,9,'Spade, Sam S 48386832 is certified in Aircraft Type: Hot-Air Ballloon','Spade, Sam S 48386832','BALOON','FDJ386U3',to_date('22-AUG-15','DD-MON-RR'),to_date('24-AUG-22','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (240,8,'Springer, Mol A 301920300 is certified in Aircraft Type: High-Performance Single-Engine Land Airplane','Springer, Mol A 301920300','HPSELA','G2JW36FW',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (241,39,'Stewart, Natal J 529461587 is certified in Aircraft Type: Starship','Stewart, Natal J 529461587','STAR','SK3IRN3D',to_date('29-OCT-16','DD-MON-RR'),to_date('20-SEP-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (242,5,'Sutherland, Nico O 843652044 is certified in Aircraft Type: Commercial Jet Airplane','Sutherland, Nico O 843652044','CJET','J1XTGW28',to_date('03-JUL-13','DD-MON-RR'),to_date('01-JUL-15','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (246,1,'Tucker, Rach I 238043745 is certified in Aircraft Type: Single-Engine Land Airplane','Tucker, Rach I 238043745','SELA','DJ4JGJ4',to_date('29-OCT-16','DD-MON-RR'),to_date('12-APR-20','DD-MON-RR'),'202020202020202');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (251,5,'Walker, Samant J 846995219 is certified in Aircraft Type: Commercial Jet Airplane','Walker, Samant J 846995219','CJET','F3RQB8BK',to_date('19-FEB-17','DD-MON-RR'),to_date('17-FEB-19','DD-MON-RR'),'Barely passed exam');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (252,1,'Wallace, Sar Y 735551296 is certified in Aircraft Type: Single-Engine Land Airplane','Wallace, Sar Y 735551296','SELA','DJ48583DF',to_date('25-OCT-14','DD-MON-RR'),to_date('18-MAR-21','DD-MON-RR'),'Note this');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (253,39,'Walsh, Son J 178436030 is certified in Aircraft Type: Starship','Walsh, Son J 178436030','STAR','DKRJ48TJ',to_date('28-OCT-16','DD-MON-RR'),to_date('18-SEP-20','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (254,7,'Watson, Soph V 774777425 is certified in Aircraft Type: Large Business Jet','Watson, Soph V 774777425','LBJ','Y6Y6Y6Y6Y6Y',to_date('28-OCT-15','DD-MON-RR'),to_date('18-MAY-21','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (255,3,'Welch, Ja Z 556835334 is certified in Aircraft Type: Multi-Engine Land Airplane','Welch, Ja Z 556835334','MELA','OA5P97MM',to_date('22-JUL-13','DD-MON-RR'),to_date('02-JAN-16','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (256,4,'White, Jam H 959087218 is certified in Aircraft Type: Small Jet Airplane','White, Jam H 959087218','SJET','DK48FJ385N38',to_date('16-FEB-17','DD-MON-RR'),to_date('14-FEB-19','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (257,1,'Wilkins, Jas W 255392469 is certified in Aircraft Type: Single-Engine Land Airplane','Wilkins, Jas W 255392469','SELA','DJ387D387687D',to_date('29-OCT-15','DD-MON-RR'),to_date('15-APR-21','DD-MON-RR'),'Wilkins, Jas: SELA, SJET');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (257,4,'Wilkins, Jas W 255392469 is certified in Aircraft Type: Small Jet Airplane','Wilkins, Jas W 255392469','SJET','4948FJ3S',to_date('27-OCT-15','DD-MON-RR'),to_date('26-AUG-22','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (303,6,'Wonder, Stevie  485874 is certified in Aircraft Type: Single-Engine Sea Helicopter','Wonder, Stevie  485874','SESH','DK4585F2',to_date('28-NOV-16','DD-MON-RR'),to_date('05-APR-27','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (13,7,'Wright, Wilbur  xxx2 is certified in Aircraft Type: Large Business Jet','Wright, Wilbur  xxx2','LBJ','4398FJ48',to_date('24-SEP-16','DD-MON-RR'),to_date('14-JUN-21','DD-MON-RR'),'HeyHeyHeyHeyHey');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (12,5,'Yeager, Chuck Z 5432 is certified in Aircraft Type: Commercial Jet Airplane','Yeager, Chuck Z 5432','CJET','DK438FN3',to_date('24-AUG-16','DD-MON-RR'),to_date('15-JUN-20','DD-MON-RR'),'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_CERTIFICATION (PILOT_ID,AIRCRAFT_TYPE_ID,NAME,PILOT_NAME,AIRCRAFT_TYPE,CERTIFICATION_NUMBER,VALID_FROM_DATE,EXPIRATION_DATE,NOTES) values (12,3,'Yeager, Chuck Z 5432 is certified in Aircraft Type: Multi-Engine Land Airplane','Yeager, Chuck Z 5432','MELA','USPSUFUH',to_date('16-FEB-17','DD-MON-RR'),to_date('14-FEB-19','DD-MON-RR'),'MELA');
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_RARE_THING
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_RARE_THING (PILOT_ID,SHORT_NAME,LONG_NAME,NOTES) values (113,'My thing2','My rare thing2',null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VW_PILOT_RARE_THING (PILOT_ID,SHORT_NAME,LONG_NAME,NOTES) values (203,'Name short','name Long','what?');
REM INSERTING into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT
SET DEFINE OFF;
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (113,'Allan, Alver H 758246790','Allan','Alver','H','758246790',to_date('22-MAY-14','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (114,'Alsop, Angelo M 375549811','Alsop','Angelo','M','375549811',to_date('31-MAY-14','DD-MON-RR'),'XYZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (115,'Anderson, Annabell S 211120543','Anderson','Annabell','S','211120543',to_date('12-JUN-91','DD-MON-RR'),'ZZZZZZZZZZZZZZ');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (116,'Arnold, Arthur P 170689463','Arnold','Arthur','P','170689463',to_date('06-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (117,'Avery, Ashly A 500516837','Avery','Ashly','A','500516837',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (118,'Bailey, Bee H 187098948','Bailey','Bee','H','187098948',to_date('09-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (119,'Baker, Benito F 795677575','Baker','Benito','F','795677575',to_date('16-MAY-82','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (120,'Ball, Bernadette T 886634651','Ball','Bernadette','T','886634651',to_date('28-MAY-82','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (121,'Bell, Cassandra R 593117297','Bell','Cassandra','R','593117297',to_date('05-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (122,'Berry, Cathy W 488613786','Berry','Cathy','W','488613786',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (123,'Black, Celestina M 319722084','Black','Celestina','M','319722084',to_date('30-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (124,'Blake, Chad D 102425498','Blake','Chad','D','102425498',to_date('19-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (264,'Blow, Joe S 6839520','Blow','Joe','S','6839520',to_date('27-OCT-87','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (125,'Bond, Chun A 905778425','Bond','Chun','A','905778425',to_date('20-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (126,'Bower, Dania W 732351498','Bower','Dania','W','732351498',to_date('14-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (127,'Brown, Darlena R 270075821','Brown','Darlena','R','270075821',to_date('24-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (128,'Buckland, Deadra G 843642828','Buckland','Deadra','G','843642828',to_date('17-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (129,'Burgess, Debbi U 407405522','Burgess','Debbi','U','407405522',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (130,'Butler, Deeann N 111090997','Butler','Deeann','N','111090997',to_date('27-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (131,'Cameron, Demetria E 977969757','Cameron','Demetria','E','977969757',to_date('07-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (132,'Campbell, Denisse X 420173944','Campbell','Denisse','X','420173944',to_date('15-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (133,'Carr, Douglas B 730561736','Carr','Douglas','B','730561736',to_date('02-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (315,'Chamberlain, Wilt W 286583950','Chamberlain','Wilt','W','286583950',to_date('28-OCT-50','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (134,'Chapman, Dudley P 760473161','Chapman','Dudley','P','760473161',to_date('16-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (314,'Chavez, Hugo Z 49286256','Chavez','Hugo','Z','49286256',to_date('31-DEC-61','DD-MON-RR'),'xyz');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (310,'Chiguidere, Webster D 39598394','Chiguidere','Webster','D','39598394',to_date('29-OCT-66','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (135,'Churchill, Edgardo P 128956416','Churchill','Edgardo','P','128956416',to_date('04-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (137,'Clarkson, Elma Z 915157976','Clarkson','Elma','Z','915157976',to_date('04-MAY-87','DD-MON-RR'),'XXXXXXXXXXX');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (136,'Clarkson, Elmer F 236096449','Clarkson','Elmer','F','236096449',to_date('12-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (312,'Clouseau, Johnny Cat I 7654456','Clouseau','Johnny Cat','I','7654456',to_date('28-AUG-14','DD-MON-RR'),'Prowl');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (138,'Coleman, Elroy H 987814097','Coleman','Elroy','H','987814097',to_date('17-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (139,'Cornish, Eulah O 509757783','Cornish','Eulah','O','509757783',to_date('08-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (140,'Davidson, Francesco E 456312623','Davidson','Francesco','E','456312623',to_date('29-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (141,'Davies, Gabriel D 219689919','Davies','Gabriel','D','219689919',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (142,'Dickens, Gabriela S 152022456','Dickens','Gabriela','S','152022456',to_date('03-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (143,'Dowd, Garfield K 165756819','Dowd','Garfield','K','165756819',to_date('22-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (144,'Duncan, Gaylene J 515393844','Duncan','Gaylene','J','515393844',to_date('30-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (145,'Dyer, Gertrude F 348708112','Dyer','Gertrude','F','348708112',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (15,'Earhart, Amel K 12345432','Earhart','Amel','K','12345432',to_date('01-JAN-00','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (307,'Earp, Wyatt A 4SJ485874','Earp','Wyatt','A','4SJ485874',to_date('29-OCT-50','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (146,'Edmunds, Gertude X 535200035','Edmunds','Gertude','X','535200035',to_date('03-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (147,'Ellison, Helen W 774614811','Ellison','Helen','W','774614811',to_date('08-JUN-81','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (18,'Feldman, Wrongw W 482829','Feldman','Wrongw','W','482829',to_date('01-APR-00','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (148,'Ferguson, Ila U 841998573','Ferguson','Ila','U','841998573',to_date('02-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (149,'Fisher, Irma F 739591208','Fisher','Irma','F','739591208',to_date('30-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (16,'Flintstone, Fr  xxx1','Flintstone','Fr',null,'xxx1',to_date('05-MAY-50','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (150,'Forsyth, Isiah E 163527225','Forsyth','Isiah','E','163527225',to_date('14-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (151,'Fraser, Jacinta E 278517673','Fraser','Jacinta','E','278517673',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (309,'Garland, Beverly G 29483982','Garland','Beverly','G','29483982',to_date('28-OCT-28','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (285,'Germania, Jerry G 3957325','Germania','Jerry','G','3957325',to_date('28-OCT-09','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (152,'Gibson, Jamal P 383051417','Gibson','Jamal','P','383051417',to_date('12-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (153,'Gill, Jaye L 990685730','Gill','Jaye','L','990685730',to_date('15-JUN-77','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (154,'Glover, Jeanna Y 638898502','Glover','Jeanna','Y','638898502',to_date('21-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (155,'Graham, Jerrold G 259525848','Graham','Jerrold','G','259525848',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (156,'Grant, Joel E 272209817','Grant','Joel','E','272209817',to_date('28-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (157,'Gray, Joye R 481746731','Gray','Joye','R','481746731',to_date('10-JUN-81','DD-MON-RR'),'X');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (158,'Greene, Julee D 965886228','Greene','Julee','D','965886228',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (262,'Hack, Jeffery S 29465932','Hack','Jeffery','S','29465932',to_date('27-FEB-71','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (159,'Hamilton, Julieann L 402343590','Hamilton','Julieann','L','402343590',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (160,'Hardacre, Karol Q 894621472','Hardacre','Karol','Q','894621472',to_date('14-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (161,'Harris, Kathy C 628072951','Harris','Kathy','C','628072951',to_date('07-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (162,'Hart, Kiara L 961115429','Hart','Kiara','L','961115429',to_date('13-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (163,'Hemmings, Kris F 676034645','Hemmings','Kris','F','676034645',to_date('07-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (164,'Henderson, Latarsha I 855995952','Henderson','Latarsha','I','855995952',to_date('16-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (165,'Hill, Lavonne P 196321215','Hill','Lavonne','P','196321215',to_date('06-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (166,'Hodges, Leoma L 988779129','Hodges','Leoma','L','988779129',to_date('19-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (167,'Howard, Lettie M 888733988','Howard','Lettie','M','888733988',to_date('14-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (168,'Hudson, Lien Q 374973232','Hudson','Lien','Q','374973232',to_date('19-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (169,'Hughes, Lilian Z 662478263','Hughes','Lilian','Z','662478263',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (170,'Hunter, Lourdes R 313953854','Hunter','Lourdes','R','313953854',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (11,'Hyde, Howard  12345','Hyde','Howard',null,'12345',to_date('28-NOV-99','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (171,'Ince, Madalyn X 594800415','Ince','Madalyn','X','594800415',to_date('23-MAY-83','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (172,'Jackson, Magdalene J 429227247','Jackson','Magdalene','J','429227247',to_date('24-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (173,'James, Marita K 517595388','James','Marita','K','517595388',to_date('11-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (308,'Johnson, Maureen J 684930','Johnson','Maureen','J','684930',to_date('27-AUG-55','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (174,'Johnston, Mauro L 558531112','Johnston','Mauro','L','558531112',to_date('19-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (175,'Jones, Maxine O 341246333','Jones','Maxine','O','341246333',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (284,'Jones, Quincy R 48673','Jones','Quincy','R','48673',to_date('28-SEP-25','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (14,'Kangaroo, Kaptan M 9876543','Kangaroo','Kaptan','M','9876543',to_date('03-MAR-30','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (176,'Kelly, Meagan D 609515912','Kelly','Meagan','D','609515912',to_date('05-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (177,'Kerr, Melony G 920529111','Kerr','Melony','G','920529111',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (178,'King, Michelina Z 357519521','King','Michelina','Z','357519521',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (179,'Knox, Michelina E 173883777','Knox','Michelina','E','173883777',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (180,'Lambert, Milda U 196124606','Lambert','Milda','U','196124606',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (181,'Langdon, Mitchel Z 233365580','Langdon','Mitchel','Z','233365580',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (182,'Lawrence, Nadia V 732733206','Lawrence','Nadia','V','732733206',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (183,'Lee, Nancy Q 981165130','Lee','Nancy','Q','981165130',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (184,'Lewis, Nilda T 889689525','Lewis','Nilda','T','889689525',to_date('27-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (267,'Loquatious, Larry L 496730','Loquatious','Larry','L','496730',to_date('29-OCT-97','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (185,'Lyman, Petra B 119031905','Lyman','Petra','B','119031905',to_date('13-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (186,'MacDonald, Precious R 790613394','MacDonald','Precious','R','790613394',to_date('09-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (189,'MacLeod, Ramon K 173008436','MacLeod','Ramon','K','173008436',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (187,'Mackay, Rachal Z 287317356','Mackay','Rachal','Z','287317356',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (188,'Mackenzie, Rachelle T 690151856','Mackenzie','Rachelle','T','690151856',to_date('26-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (190,'Manning, Ranae U 264123490','Manning','Ranae','U','264123490',to_date('28-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (191,'Marshall, Raye T 426053711','Marshall','Raye','T','426053711',to_date('21-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (192,'Martine, Raymond A 361412463','Martine','Raymond','A','361412463',to_date('10-JUN-88','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (193,'Mathis, Rochel G 271225146','Mathis','Rochel','G','271225146',to_date('08-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (194,'May, Rochell C 888214412','May','Rochell','C','888214412',to_date('29-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (195,'McDonald, Rona L 354933752','McDonald','Rona','L','354933752',to_date('06-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (197,'McGrath, Shannan B 229041951','McGrath','Shannan','B','229041951',to_date('06-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (196,'McLean, Salley J 680024959','McLean','Salley','J','680024959',to_date('18-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (198,'Metcalfe, Sheilah T 597074604','Metcalfe','Sheilah','T','597074604',to_date('14-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (199,'Miller, Sherice S 423385749','Miller','Sherice','S','423385749',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (200,'Mills, Shila V 667462427','Mills','Shila','V','667462427',to_date('08-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (201,'Mitchell, Silvana R 449195691','Mitchell','Silvana','R','449195691',to_date('03-JUN-14','DD-MON-RR'),'Note this!');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (202,'Morgan, Stephen E 776096712','Morgan','Stephen','E','776096712',to_date('12-JUN-14','DD-MON-RR'),'Are there any notes?');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (203,'Morrison, Tandy S 355843134','Morrison','Tandy','S','355843134',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (204,'Murray, Terica K 791390440','Murray','Terica','K','791390440',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (205,'Nash, Tommy I 486054418','Nash','Tommy','I','486054418',to_date('27-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (206,'Newman, Tracey M 192996750','Newman','Tracey','M','192996750',to_date('06-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (207,'Nolan, Vashti P 501351447','Nolan','Vashti','P','501351447',to_date('09-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (208,'North, Velia X 582868492','North','Velia','X','582868492',to_date('15-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (209,'Ogden, Venetta G 521625879','Ogden','Venetta','G','521625879',to_date('16-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (210,'Oliver, Xochitl V 845914811','Oliver','Xochitl','V','845914811',to_date('06-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (211,'Paige, Yesenia C 924004026','Paige','Yesenia','C','924004026',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (212,'Parr, Benjam P 356862125','Parr','Benjam','P','356862125',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (213,'Parsons, Bla P 240550168','Parsons','Bla','P','240550168',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (214,'Paterson, Bor D 773449691','Paterson','Bor','D','773449691',to_date('31-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (215,'Payne, Brand S 437778437','Payne','Brand','S','437778437',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (216,'Peake, Bri U 296126987','Peake','Bri','U','296126987',to_date('19-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (261,'Perera, Pri  295838y693','Perera','Pri',null,'295838y693',to_date('01-APR-42','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (217,'Peters, Camer B 366148955','Peters','Camer','B','366148955',to_date('12-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (218,'Piper, Ca L 769404582','Piper','Ca','L','769404582',to_date('12-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (219,'Poole, Charles Q 922203371','Poole','Charles','Q','922203371',to_date('09-MAY-14','DD-MON-RR'),'Any more?');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (220,'Powell, Christi B 122212560','Powell','Christi','B','122212560',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (221,'Pullman, Christoph C 826695580','Pullman','Christoph','C','826695580',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (222,'Quinn, Col U 982022095','Quinn','Col','U','982022095',to_date('18-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (265,'Racer, Speed Z 49858394','Racer','Speed','Z','49858394',to_date('28-OCT-53','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (223,'Rampling, Conn H 934002016','Rampling','Conn','H','934002016',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (224,'Randall, D B 652386464','Randall','D','B','652386464',to_date('09-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (225,'Rees, Dav S 346567020','Rees','Dav','S','346567020',to_date('11-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (226,'Reid, Domin U 733337570','Reid','Domin','U','733337570',to_date('14-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (227,'Roberts, Dyl K 368081596','Roberts','Dyl','K','368081596',to_date('14-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (228,'Robertson, Edwa N 365759391','Robertson','Edwa','N','365759391',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (229,'Ross, Er C 746175809','Ross','Er','C','746175809',to_date('11-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (17,'Rubble, Barney  xxx3','Rubble','Barney',null,'xxx3',to_date('07-JUL-60','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (230,'Russell, Ev L 686288613','Russell','Ev','L','686288613',to_date('05-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (231,'Rutherford, Fra F 730284313','Rutherford','Fra','F','730284313',to_date('04-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (232,'Sanderson, Gav T 940495960','Sanderson','Gav','T','940495960',to_date('16-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (233,'Scott, Gord M 970099661','Scott','Gord','M','970099661',to_date('05-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (283,'Seminole, Sam S 29583892','Seminole','Sam','S','29583892',to_date('26-OCT-47','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (234,'Sharp, adelei E 856480238','Sharp','adelei','E','856480238',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (235,'Short, Martin N 798045496','Short','Martin','N','798045496',to_date('23-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (236,'Simpson, Ma Q 325571164','Simpson','Ma','Q','325571164',to_date('29-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (237,'Skinner, Meg X 109324243','Skinner','Meg','X','109324243',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (238,'Slater, Melan Q 630834965','Slater','Melan','Q','630834965',to_date('05-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (239,'Smith, Michel D 259182697','Smith','Michel','D','259182697',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (263,'Spade, Sam S 48386832','Spade','Sam','S','48386832',to_date('25-AUG-79','DD-MON-RR'),'Shovel');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (266,'Speed, Breakneck Z 45983865','Speed','Breakneck','Z','45983865',to_date('28-OCT-81','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (240,'Springer, Mol A 301920300','Springer','Mol','A','301920300',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (241,'Stewart, Natal J 529461587','Stewart','Natal','J','529461587',to_date('20-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (242,'Sutherland, Nico O 843652044','Sutherland','Nico','O','843652044',to_date('22-MAY-80','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (243,'Taylor, Oliv P 261260185','Taylor','Oliv','P','261260185',to_date('08-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (244,'Terry, Penelo D 958847716','Terry','Penelo','D','958847716',to_date('25-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (245,'Thomson, Pip P 907787248','Thomson','Pip','P','907787248',to_date('17-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (246,'Tucker, Rach I 238043745','Tucker','Rach','I','238043745',to_date('24-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (247,'Turner, Rebec A 108532215','Turner','Rebec','A','108532215',to_date('16-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (248,'Underwood, Ro B 149838818','Underwood','Ro','B','149838818',to_date('08-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (249,'Vance, Ru Q 423653571','Vance','Ru','Q','423653571',to_date('08-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (250,'Vaughan, Sal M 816678610','Vaughan','Sal','M','816678610',to_date('12-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (251,'Walker, Samant J 846995219','Walker','Samant','J','846995219',to_date('29-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (252,'Wallace, Sar Y 735551296','Wallace','Sar','Y','735551296',to_date('19-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (253,'Walsh, Son J 178436030','Walsh','Son','J','178436030',to_date('04-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (254,'Watson, Soph V 774777425','Watson','Soph','V','774777425',to_date('10-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (255,'Welch, Ja Z 556835334','Welch','Ja','Z','556835334',to_date('07-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (256,'White, Jam H 959087218','White','Jam','H','959087218',to_date('15-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (257,'Wilkins, Jas W 255392469','Wilkins','Jas','W','255392469',to_date('11-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (258,'Wilson, J G 162546932','Wilson','J','G','162546932',to_date('07-JUN-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (303,'Wonder, Stevie  485874','Wonder','Stevie',null,'485874',to_date('23-JUL-45','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (259,'Wright, Jo W 994373889','Wright','Jo','W','994373889',to_date('10-MAY-14','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (13,'Wright, Wilbur  xxx2','Wright','Wilbur',null,'xxx2',to_date('06-JUN-80','DD-MON-RR'),null);
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (12,'Yeager, Chuck Z 5432','Yeager','Chuck','Z','5432',to_date('04-APR-20','DD-MON-RR'),'x');
Insert into HHYDE_FBOACE03_OLTP_TAB.VX_PILOT (PILOT_ID,NAME,LAST_NAME,FIRST_NAME,MIDDLE_INITIAL,NATIONAL_ID_NUMBER,BIRTHDATE,NOTES) values (260,'Young, Jonathan N 133967479','Young','Jonathan','N','133967479',to_date('21-MAY-14','DD-MON-RR'),null);
--------------------------------------------------------
--  DDL for Index AIRCRAFT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_PK ON HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_ID)
  ;
--------------------------------------------------------
--  DDL for Index AIRCRAFT_SHORT_NAME_UX
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_SHORT_NAME_UX ON HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (UPPER(TRIM(SHORT_NAME)))
  ;
--------------------------------------------------------
--  DDL for Index AIRCRTYP_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.AIRCRTYP_PK ON HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID)
  ;
--------------------------------------------------------
--  DDL for Index AIRPORT_IATA_CODE_UK
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.AIRPORT_IATA_CODE_UK ON HHYDE_FBOACE03_OLTP_TAB.AIRPORT (IATA_CODE)
  ;
--------------------------------------------------------
--  DDL for Index AIRPORT_IATA_CODE_UX
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.AIRPORT_IATA_CODE_UX ON HHYDE_FBOACE03_OLTP_TAB.AIRPORT (UPPER(IATA_CODE))
  ;
--------------------------------------------------------
--  DDL for Index AIRPORT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.AIRPORT_PK ON HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID)
  ;
--------------------------------------------------------
--  DDL for Index AIRPORT_SHORT_NAME_UK
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.AIRPORT_SHORT_NAME_UK ON HHYDE_FBOACE03_OLTP_TAB.AIRPORT (SHORT_NAME)
  ;
--------------------------------------------------------
--  DDL for Index AIRPORT_SHORT_NAME_UX
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.AIRPORT_SHORT_NAME_UX ON HHYDE_FBOACE03_OLTP_TAB.AIRPORT (UPPER(SHORT_NAME))
  ;
--------------------------------------------------------
--  DDL for Index FLCRWMMB_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.FLCRWMMB_PK ON HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER (FLIGHT_ID, PILOT_ID)
  ;
--------------------------------------------------------
--  DDL for Index FLIGHT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.FLIGHT_PK ON HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID)
  ;
--------------------------------------------------------
--  DDL for Index FLIGHT_SHORT_NAME_UX
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.FLIGHT_SHORT_NAME_UX ON HHYDE_FBOACE03_OLTP_TAB.FLIGHT (UPPER(TRIM(SHORT_NAME)))
  ;
--------------------------------------------------------
--  DDL for Index PILOT_NATLIDNUM_IX
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.PILOT_NATLIDNUM_IX ON HHYDE_FBOACE03_OLTP_TAB.PILOT (NATIONAL_ID_NUMBER)
  ;
--------------------------------------------------------
--  DDL for Index PILOT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.PILOT_PK ON HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID)
  ;
--------------------------------------------------------
--  DDL for Index PILTCERT_CERT_NUM_UX
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.PILTCERT_CERT_NUM_UX ON HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (CERTIFICATION_NUMBER)
  ;
--------------------------------------------------------
--  DDL for Index PILTCERT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.PILTCERT_PK ON HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION (PILOT_ID, AIRCRAFT_TYPE_ID)
  ;
--------------------------------------------------------
--  DDL for Index PLTRTHNG_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.PLTRTHNG_PK ON HHYDE_FBOACE03_OLTP_TAB.PILOT_RARE_THING (PILOT_ID)
  ;
--------------------------------------------------------
--  DDL for Index PLTRTHNG_UK
--------------------------------------------------------

  CREATE UNIQUE INDEX HHYDE_FBOACE03_OLTP_TAB.PLTRTHNG_UK ON HHYDE_FBOACE03_OLTP_TAB.PILOT_RARE_THING (SHORT_NAME)
  ;
--------------------------------------------------------
--  Constraints for Table AIRCRAFT
--------------------------------------------------------

  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT MODIFY (AIRCRAFT_TYPE_ID NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT MODIFY (AIRCRAFT_ID NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT MODIFY (SHORT_NAME NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT MODIFY (LONG_NAME NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT ADD CONSTRAINT AIRCRAFT_PK PRIMARY KEY (AIRCRAFT_ID)
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table AIRCRAFT_TYPE
--------------------------------------------------------

  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE MODIFY (AIRCRAFT_TYPE_ID NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE MODIFY (SHORT_NAME NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE MODIFY (LONG_NAME NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE ADD CONSTRAINT AIRCRTYP_PK PRIMARY KEY (AIRCRAFT_TYPE_ID)
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table AIRPORT
--------------------------------------------------------

  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRPORT MODIFY (AIRPORT_ID NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRPORT MODIFY (SHORT_NAME NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRPORT MODIFY (IATA_CODE NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRPORT ADD CONSTRAINT AIRPORT_PK PRIMARY KEY (AIRPORT_ID)
  USING INDEX  ENABLE;
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRPORT ADD CONSTRAINT AIRPORT_SHORT_NAME_UK UNIQUE (SHORT_NAME)
  USING INDEX  ENABLE;
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRPORT ADD CONSTRAINT AIRPORT_IATA_CODE_UK UNIQUE (IATA_CODE)
  USING INDEX  ENABLE;
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRPORT ADD CONSTRAINT AIRPORT_PORT_TYPE_CK CHECK (port_type in
                   ( 'Heliport'
                   , 'Small Airport'
                   , 'Closed'
                   , 'Seaplane Base'
                   , 'Balloonport'
                   , 'Medium Airport'
                   , 'Large Airport'
                   )) ENABLE;
--------------------------------------------------------
--  Constraints for Table FLIGHT
--------------------------------------------------------

  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT MODIFY (FLIGHT_ID NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT MODIFY (AIRCRAFT_ID NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT MODIFY (SHORT_NAME NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT ADD CONSTRAINT FLIGHT_PK PRIMARY KEY (FLIGHT_ID)
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table FLIGHT_CREW_MEMBER
--------------------------------------------------------

  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER MODIFY (FLIGHT_ID NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER MODIFY (PILOT_ID NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER ADD CONSTRAINT FLCRWMMB_PK PRIMARY KEY (FLIGHT_ID, PILOT_ID)
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table PILOT
--------------------------------------------------------

  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT MODIFY (PILOT_ID NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT MODIFY (LAST_NAME NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT MODIFY (FIRST_NAME NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT MODIFY (NATIONAL_ID_NUMBER NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT MODIFY (BIRTHDATE NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT ADD CONSTRAINT PILOT_PK PRIMARY KEY (PILOT_ID)
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table PILOT_CERTIFICATION
--------------------------------------------------------

  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION MODIFY (PILOT_ID NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION MODIFY (AIRCRAFT_TYPE_ID NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION MODIFY (CERTIFICATION_NUMBER NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION MODIFY (VALID_FROM_DATE NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION MODIFY (EXPIRATION_DATE NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION ADD CONSTRAINT PILTCERT_PK PRIMARY KEY (PILOT_ID, AIRCRAFT_TYPE_ID)
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table PILOT_RARE_THING
--------------------------------------------------------

  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_RARE_THING MODIFY (PILOT_ID NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_RARE_THING MODIFY (SHORT_NAME NOT NULL ENABLE);
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_RARE_THING ADD CONSTRAINT PLTRTHNG_PK PRIMARY KEY (PILOT_ID)
  USING INDEX  ENABLE;
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_RARE_THING ADD CONSTRAINT PLTRTHNG_UK UNIQUE (SHORT_NAME)
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table AIRCRAFT
--------------------------------------------------------

  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT ADD CONSTRAINT AIRCRAFT_AIRCRTYP_FK FOREIGN KEY (AIRCRAFT_TYPE_ID)
	  REFERENCES HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID) ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table FLIGHT
--------------------------------------------------------

  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT ADD CONSTRAINT FLIGHT_AIRCRAFT_FK FOREIGN KEY (AIRCRAFT_ID)
	  REFERENCES HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT (AIRCRAFT_ID) ENABLE;
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT ADD CONSTRAINT FLIGHT_AIRPORT_DEPART_FK FOREIGN KEY (AIRPORT_ID_DEPARTURE)
	  REFERENCES HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID) ENABLE;
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT ADD CONSTRAINT FLIGHT_AIRPORT_DSTNTN_FK FOREIGN KEY (AIRPORT_ID_DESTINATION)
	  REFERENCES HHYDE_FBOACE03_OLTP_TAB.AIRPORT (AIRPORT_ID) ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table FLIGHT_CREW_MEMBER
--------------------------------------------------------

  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER ADD CONSTRAINT FLCRWMMB_FLIGHT_FK FOREIGN KEY (FLIGHT_ID)
	  REFERENCES HHYDE_FBOACE03_OLTP_TAB.FLIGHT (FLIGHT_ID) ENABLE;
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.FLIGHT_CREW_MEMBER ADD CONSTRAINT FLCRWMMB_PILOT_FK FOREIGN KEY (PILOT_ID)
	  REFERENCES HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID) ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PILOT_CERTIFICATION
--------------------------------------------------------

  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION ADD CONSTRAINT PILTCERT_AIRCRTYP_FK FOREIGN KEY (AIRCRAFT_TYPE_ID)
	  REFERENCES HHYDE_FBOACE03_OLTP_TAB.AIRCRAFT_TYPE (AIRCRAFT_TYPE_ID) ENABLE;
  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_CERTIFICATION ADD CONSTRAINT PILTCERT_PILOT_FK FOREIGN KEY (PILOT_ID)
	  REFERENCES HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID) ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PILOT_RARE_THING
--------------------------------------------------------

  ALTER TABLE HHYDE_FBOACE03_OLTP_TAB.PILOT_RARE_THING ADD CONSTRAINT PLTRTHNG_PILOT_FK FOREIGN KEY (PILOT_ID)
	  REFERENCES HHYDE_FBOACE03_OLTP_TAB.PILOT (PILOT_ID) ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_FLCRWMMB_BE4_IUX_ROW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER HHYDE_FBOACE03_OLTP_TAB.TRG_FLCRWMMB_BE4_IUX_ROW
before insert or update on flight_crew_member
for each row
declare
  v_validation number := 0;
begin
  select count(*) into v_validation
    from pilot_certification c
    join aircraft_type t on t.aircraft_type_id = c.aircraft_type_id
    join aircraft      a on a.aircraft_type_id = t.aircraft_type_id
    join flight        f on f.aircraft_id = a.aircraft_id
   where f.flight_id = :new.flight_id
     and c.pilot_id  = :new.pilot_id;
  if v_validation = 0 then
    RAISE_APPLICATION_ERROR (-20010, 'Unqualified Pilot / Inappropriate Aircraft (type).');
  end if;
end trg_flcrwmmb_be4_iux_row;
/
ALTER TRIGGER HHYDE_FBOACE03_OLTP_TAB.TRG_FLCRWMMB_BE4_IUX_ROW ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_FLIGHT_BE4_IXX_ROW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER HHYDE_FBOACE03_OLTP_TAB.TRG_FLIGHT_BE4_IXX_ROW
before insert on flight
for each row
declare
  v_aircraft_name aircraft.long_name%type;
begin
  if :new.aircraft_id is not null and :new.short_name is null then
    select name into v_aircraft_name
      from vw_aircraft
     where aircraft_id = :new.aircraft_id;
    :new.short_name :=  v_aircraft_name || ': ' || to_char(sysdate, 'yyyy.mm.dd hh24:mi:ss');
  end if;
  if :new.long_name is null then :new.long_name := :new.short_name; end if;
  if :new.departure_date_time is null and :new.arrival_date_time is null then
    :new.departure_date_time := sysdate;
    :new.arrival_date_time := sysdate + (2/24);
  end if;
end trg_flight_be4_ixx_row;
/
ALTER TRIGGER HHYDE_FBOACE03_OLTP_TAB.TRG_FLIGHT_BE4_IXX_ROW ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_PILOT_BE4_IXX_ROW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER HHYDE_FBOACE03_OLTP_TAB.TRG_PILOT_BE4_IXX_ROW
before insert on pilot
for each row
begin
  null;
end trg_pilot_be4_ixx_row;
/
ALTER TRIGGER HHYDE_FBOACE03_OLTP_TAB.TRG_PILOT_BE4_IXX_ROW ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_PILTCERT_BE4_IXX
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER HHYDE_FBOACE03_OLTP_TAB.TRG_PILTCERT_BE4_IXX
before insert on pilot_certification
for each row
begin
  null;
  if :new.certification_number is null then
--  select dbms_random.string('X', 8) from dual;
    select dbms_random.string('X', 8) into :new.certification_number from dual;
  end if;
  if :new.valid_from_date is null and :new.EXpiration_date is null then
    :new.valid_from_date := sysdate - 364;
    :new.EXpiration_date := sysdate + 364;
  end if;
end trg_piltcert_be4_ixx;
/
ALTER TRIGGER HHYDE_FBOACE03_OLTP_TAB.TRG_PILTCERT_BE4_IXX ENABLE;


