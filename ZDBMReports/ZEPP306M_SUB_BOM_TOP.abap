*&---------------------------------------------------------------------*
*& Include ZEPP306_SUB_BOM_TOP                                         *
*&                                                                     *
*&---------------------------------------------------------------------*
PROGRAM  ZEPP306M_SUB_BOM MESSAGE-ID ZMBM.
*----------------------------------------------------------------------*
* TABLES
*----------------------------------------------------------------------*
TABLES : ZTBM_MODEL_VAL,
         ZSBM_MODEL_VALS,
         MARA,
         MARC,
         T001W,
         ZTBM_SUB_BOM_VEL.
*----------------------------------------------------------------------*
* INTERNAL TABLES
*----------------------------------------------------------------------*
DATA: BEGIN OF IT_UPGV OCCURS 0,
        WERKS    TYPE T001W-WERKS,
        MATNR    TYPE MARA-MATNR,
        MTART    TYPE MARA-MTART,
        SEQU     TYPE ZTBM_SUB_BOM_VEL-SEQU, "SEQUENCE
        Z_NATION TYPE ZTBM_SUB_BOM_VEL-Z_NATION, "NATION
        Z_CAR    TYPE ZTBM_SUB_BOM_VEL-Z_CAR, "MODEL TYPE
        Z_YEAR   TYPE ZTBM_SUB_BOM_VEL-Z_YEAR, "YEAR
        Z_BT     TYPE ZTBM_SUB_BOM_VEL-Z_BT, "B/T
        Z_TL     TYPE ZTBM_SUB_BOM_VEL-Z_TL, "T/L
        Z_EC     TYPE ZTBM_SUB_BOM_VEL-Z_EC, "E/C
        Z_FT     TYPE ZTBM_SUB_BOM_VEL-Z_FT, "F/T
        Z_TM     TYPE ZTBM_SUB_BOM_VEL-Z_TM, "T/M
        Z_ST     TYPE ZTBM_SUB_BOM_VEL-Z_ST, "S/T
        Z_COLOR  TYPE ZTBM_SUB_BOM_VEL-Z_COLOR, "COLOR
        ZCHK,
        MAKTX    TYPE MAKT-MAKTX,

      END   OF IT_UPGV.
DATA: IT_UPGV_CHK LIKE IT_UPGV OCCURS 0 WITH HEADER LINE.
DATA: IT_BOM_VEL TYPE ZTBM_SUB_BOM_VEL OCCURS 0 WITH HEADER LINE.
DATA: IT_BOM_DEL TYPE ZTBM_SUB_BOM_VEL OCCURS 0 WITH HEADER LINE.
DATA: IT_MODL_VAL TYPE ZTBM_MODEL_VAL OCCURS 0 WITH HEADER LINE.
DATA: IT_MODL TYPE ZTBM_MODEL_VAL OCCURS 0 WITH HEADER LINE.
DATA: IT_MODL_DEL TYPE ZTBM_MODEL_VAL OCCURS 0 WITH HEADER LINE.
DATA: BEGIN OF IT_FCODE OCCURS 0,
      FCODE LIKE RSMPE-FUNC,
      END   OF IT_FCODE.
*----------------------------------------------------------------------*
* TABLE CONTROLS
*----------------------------------------------------------------------*
CONTROLS T_9000 TYPE TABLEVIEW USING SCREEN 9000.
CONTROLS T_9100 TYPE TABLEVIEW USING SCREEN 9100.
*----------------------------------------------------------------------*
* DATA
*----------------------------------------------------------------------*
DATA: OK_CODE TYPE SY-UCOMM,
      OKCODE  TYPE SY-UCOMM,
      DELETE_MODE,
      CHANGE_MODE,
      CREATE_MODE,
      MODE_TITLE(50),
      ZMODE(10),
      ZCHK,
      WA_ZFIELD(10),
      WA_ZFDESC(40),
      WA_ZFIELD1(30),
      Z_FLAG,
      WA_ANS,
      WA_LINES TYPE I,
      WA_CURSOR_LINE TYPE I,
      WA_TEXT1(72),
      WA_TEXT2(72),
      WA_TITLE(72),
      WA_FIELD(30).
*----------------------------------------------------------------------*
* DECLARATION FOR SEARCH HELP
*----------------------------------------------------------------------*
DATA DYNPREAD LIKE DYNPREAD OCCURS 0 WITH HEADER LINE.
DATA: BEGIN OF VALUETAB OCCURS 0,
          VALUE(80).
DATA: END OF VALUETAB.

DATA: BEGIN OF FIELDS OCCURS 0.
        INCLUDE STRUCTURE HELP_VALUE.
DATA: END OF FIELDS.

DATA: BEGIN OF DYNPFIELDS  OCCURS 0.
        INCLUDE STRUCTURE DYNPREAD.
DATA: END OF DYNPFIELDS.

DATA  SELECT_INDEX LIKE SY-TABIX.

DATA: BEGIN OF SELECT_VALUES OCCURS 0.
        INCLUDE STRUCTURE HELP_VTAB.
DATA: END OF SELECT_VALUES.

DATA: BEGIN OF IT_IBSYMBOL OCCURS 0,
        ATWRT TYPE IBSYMBOL-ATWRT,
        ATNAM TYPE CABN-ATNAM,
      END OF IT_IBSYMBOL.
