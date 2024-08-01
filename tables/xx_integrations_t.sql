--
-- Table "XX_INTEGRATIONS_T"
--
CREATE TABLE "XX_TANGO"."XX_INTEGRATIONS_T" 
   (	"INTEGRATION_ID" NUMBER DEFAULT XX_TANGO.XX_INTEGRATIONS_S1.nextval, 
	"INT_NUM" NUMBER, 
	"NAME" VARCHAR2(50) COLLATE "USING_NLS_COMP", 
	"SHORT_NAME" VARCHAR2(30) COLLATE "USING_NLS_COMP", 
	"DESCRIPTION" VARCHAR2(100) COLLATE "USING_NLS_COMP", 
	"SOURCE_SYSTEM_ID" NUMBER, 
	"TARGET_SYSTEM_ID" NUMBER, 
	"ENABLE_FLAG" BOOLEAN NOT NULL ENABLE, 
	"OBJECT_VERSION_NUMBER" NUMBER NOT NULL ENABLE, 
	"LAST_UPDATE_DATE" TIMESTAMP (6) DEFAULT sysdate NOT NULL ENABLE, 
	"LAST_UPDATE_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP" NOT NULL ENABLE, 
	"CREATION_DATE" TIMESTAMP (6) DEFAULT sysdate NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(100) COLLATE "USING_NLS_COMP" NOT NULL ENABLE, 
	 CONSTRAINT "XX_INTEGRATIONS_PK1" PRIMARY KEY ("INTEGRATION_ID")
  USING INDEX  ENABLE, 
	 UNIQUE ("INT_NUM")
  USING INDEX  ENABLE, 
	 UNIQUE ("NAME")
  USING INDEX  ENABLE, 
	 UNIQUE ("SHORT_NAME")
  USING INDEX  ENABLE, 
	 UNIQUE ("DESCRIPTION")
  USING INDEX  ENABLE, 
	 CONSTRAINT "XX_INTEGRATIONS_FK1" FOREIGN KEY ("SOURCE_SYSTEM_ID")
	  REFERENCES "XX_TANGO"."XX_SYSTEMS_T" ("SYSTEM_ID") ENABLE, 
	 CONSTRAINT "XX_INTEGRATIONS_FK2" FOREIGN KEY ("TARGET_SYSTEM_ID")
	  REFERENCES "XX_TANGO"."XX_SYSTEMS_T" ("SYSTEM_ID") ENABLE
   )  DEFAULT COLLATION "USING_NLS_COMP"
/