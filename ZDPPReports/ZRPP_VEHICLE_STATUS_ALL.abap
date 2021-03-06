************************************************************************
* Program Name      : ZRPP_VEHICLE_STATUS_ALL
* Author            : Furong Wang
* Creation Date     : 04/17/2009
* Specifications By :
* Development Request No :
* Addl Documentation:
* Description       : Send production actual and plan data to HMC
* Modification Logs
* Date       Developer    RequestNo    Description
*
*********************************************************************

REPORT  ZRPP_VEHICLE_STATUS_ALL NO STANDARD PAGE HEADING
                     LINE-SIZE 132
                     LINE-COUNT 64(1)
                     MESSAGE-ID ZMPP.

TABLES: AUSP.
DATA : L_MSGTXT(100),
       L_RESULT(1),
       W_ERROR(1).

CONSTANTS: C_DEST(10) VALUE 'WMPP01'.   "Interface Destination.

*DATA: BEGIN OF IT_DATA OCCURS 0.
*        INCLUDE STRUCTURE ZSPP_PDTN_STATUS.
*DATA: END OF IT_DATA.

DATA: BEGIN OF IT_OUTPUT OCCURS 0,
VEHICLE(10),
COL001(30), COL002(30), COL003(30), COL004(30), COL005(30),
COL006(30), COL007(30), COL008(30), COL009(30), COL010(30),
COL011(30), COL012(30), COL013(30), COL014(30), COL015(30),
COL016(30), COL017(30), COL018(30), COL019(30), COL020(30),
COL021(30), COL022(30), COL023(30), COL024(30), COL025(30),
COL026(30), COL027(30), COL028(30), COL029(30), COL030(30),
COL031(30), COL032(30), COL033(30), COL034(30), COL035(30),
COL036(30), COL037(30), COL038(30), COL039(30), COL040(30),

COL041(30), COL042(30), COL043(30), COL044(30), COL045(30),
COL046(30), COL047(30), COL048(30), COL049(30), COL050(30),
COL051(30), COL052(30), COL053(30), COL054(30), COL055(30),
COL056(30), COL057(30), COL058(30), COL059(30), COL060(30),
COL061(30), COL062(30), COL063(30), COL064(30), COL065(30),
COL066(30), COL067(30), COL068(30), COL069(30), COL070(30),
COL071(30), COL072(30), COL073(30), COL074(30), COL075(30),
COL076(30), COL077(30), COL078(30), COL079(30), COL080(30),

COL081(30), COL082(30), COL083(30), COL084(30), COL085(30),
COL086(30), COL087(30), COL088(30), COL089(30), COL090(30),
COL091(30), COL092(30), COL093(30), COL094(30), COL095(30),
COL096(30), COL097(30), COL098(30), COL099(30), COL100(30),

COL101(30), COL102(30), COL103(30), COL104(30), COL105(30),
COL106(30), COL107(30), COL108(30), COL109(30), COL110(30),
COL111(30), COL112(30), COL113(30), COL114(30), COL115(30),
COL116(30), COL117(30), COL118(30), COL119(30), COL120(30),
COL121(30), COL122(30), COL123(30), COL124(30), COL125(30),
COL126(30), COL127(30), COL128(30), COL129(30), COL130(30),
COL131(30), COL132(30), COL133(30), COL134(30), COL135(30),
COL136(30), COL137(30), COL138(30), COL139(30), COL140(30),

COL141(30), COL142(30), COL143(30), COL144(30), COL145(30),
COL146(30), COL147(30), COL148(30), COL149(30), COL150(30),
COL151(30), COL152(30), COL153(30), COL154(30), COL155(30),
COL156(30), COL157(30), COL158(30), COL159(30), COL160(30),
COL161(30), COL162(30), COL163(30), COL164(30), COL165(30),
COL166(30), COL167(30), COL168(30), COL169(30), COL170(30),
COL171(30), COL172(30), COL173(30), COL174(30), COL175(30),
COL176(30), COL177(30), COL178(30), COL179(30), COL180(30),

COL181(30), COL182(30), COL183(30), COL184(30), COL185(30),
COL186(30), COL187(30), COL188(30), COL189(30), COL190(30),
COL191(30), COL192(30), COL193(30), COL194(30), COL195(30),
COL196(30), COL197(30), COL198(30), COL199(30), COL200(30),
DATE(8),
END OF IT_OUTPUT.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME.
PARAMETERS: P_OPT1 RADIOBUTTON GROUP GRP1,
            P_OPT2 RADIOBUTTON GROUP GRP1.
SELECTION-SCREEN SKIP 1.
SELECT-OPTIONS: S_OBJEK FOR AUSP-OBJEK.
*SELECTION-SCREEN SKIP 1.
PARAMETERS: P_YEAR(4) TYPE N OBLIGATORY.
PARAMETERS: P_MTH(2) TYPE N.
SELECTION-SCREEN END OF BLOCK B1.

START-OF-SELECTION.
  PERFORM GET_DATA.
  IF W_ERROR IS INITIAL.
    PERFORM SEND_DATA.
  ENDIF.

END-OF-SELECTION.

*---------------------------------------------------------------------*
*       FORM GET_DATA                                                 *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM GET_DATA.
  DATA: L_SUBRC    TYPE SY-SUBRC ,
        L_ATNAM    TYPE CABN-ATNAM,
        L_ATWRT    TYPE AUSP-ATWRT,
        L_NAME     TYPE CABN-ATNAM,  "SHOP. Date
        L_NAME1    TYPE CABN-ATNAM,
        L_ATFLV_FROM  TYPE AUSP-ATFLV,  "SHOP. Date
        L_ATFLV_TO TYPE AUSP-ATFLV,
        L_TEMP(06),
        L_DATUM    TYPE SY-DATUM,
        L_NUM(08)  TYPE N,
        L_EXRP(02) TYPE N,
        L_WONO LIKE AUSP-ATWRT,
        L_WONO_ZWOSUM LIKE ZTPP_WOSUM-WO_SER,
        L_NATION LIKE ZTPP_WOSUM-NATION,
        L_DEALER LIKE ZTPP_WOSUM-DEALER,
        L_EXCL LIKE ZTPP_WOSUM-EXTC,
        L_INCL LIKE ZTPP_WOSUM-INTC,
        L_DATE_C(8),
         L_DATE   TYPE SY-DATUM.

  DATA: BEGIN OF LT_OBJEK OCCURS 0,
          OBJEK    LIKE AUSP-OBJEK,
          ATWRT    LIKE AUSP-ATWRT,
        END OF LT_OBJEK.
*  DATA:     LT_CABN LIKE TABLE OF CABN WITH HEADER LINE.

  DATA: BEGIN OF LT_CABN OCCURS 0,
         ATINN  LIKE CABN-ATINN,
         ATNAM LIKE CABN-ATNAM,
         ATBEZ LIKE CABNT-ATBEZ,
       END OF LT_CABN.

  DATA: BEGIN OF LT_ZTPPVR OCCURS 0,
        P_MODEL LIKE ZTPPVR-P_MODEL,
        P_BODY_SERIAL LIKE ZTPPVR-P_BODY_SERIAL,
        END OF LT_ZTPPVR.
  DATA: L_VALS LIKE TABLE OF ZSPP_VIN_VALUE WITH HEADER LINE.
  DATA: L_CN(3) TYPE N,
        L_FIELD(20),
        L_OBJEK LIKE MARA-MATNR,
        L_BLANK(1).

  FIELD-SYMBOLS <FS>.

*CONSTANTS:
*C_TAB TYPE C VALUE CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
*
  CLEAR: W_ERROR.

*  IF P_OPT1 = 'X'.
*    SELECT DISTINCT P_MODEL P_BODY_SERIAL
*       INTO TABLE LT_ZTPPVR
*       FROM ZTPPVR
*       WHERE FLAG = 'LT'
*         AND K04PDAT = P_DATUM.
*    LOOP AT LT_ZTPPVR.
*      CONCATENATE LT_ZTPPVR-P_MODEL LT_ZTPPVR-P_BODY_SERIAL
*                INTO LT_OBJEK-OBJEK.
*      APPEND LT_OBJEK.
*      CLEAR: LT_OBJEK.
*    ENDLOOP.
*  ELSE.

  SELECT A~ATINN ATNAM ATBEZ INTO TABLE LT_CABN
    FROM CABN AS A
    INNER JOIN CABNT AS B
    ON A~ATINN = B~ATINN
     AND A~ADZHL = B~ADZHL
    WHERE ATNAM LIKE 'P_%'
      AND ATKLA = 'VM'.

  L_NAME = 'P_RP01_SHOP_DATE'.

  IF P_OPT1 = 'X'.
    CONCATENATE P_YEAR '0101' INTO L_DATE_C.
    L_DATE = L_DATE_C.
    L_ATFLV_FROM = L_NUM = L_DATE.
    CONCATENATE P_YEAR '1231' INTO L_DATE_C.
    L_DATE = L_DATE_C.
    L_ATFLV_TO = L_NUM = L_DATE.
  ELSE.
    IF P_MTH IS INITIAL.
      MESSAGE I000 WITH 'Please input MONTH'.
      W_ERROR = 'X'.
      EXIT.

    ENDIF.
    CONCATENATE P_YEAR P_MTH '01' INTO L_DATE_C.
    L_DATE = L_DATE_C.
    L_ATFLV_FROM = L_NUM = L_DATE.
    CALL FUNCTION 'MM_LAST_DAY_OF_MONTHS'
      EXPORTING
        DAY_IN                  = L_DATE
     IMPORTING
       LAST_DAY_OF_MONTH       = L_DATE
*   EXCEPTIONS
*     DAY_IN_NO_DATE          = 1
*     OTHERS                  = 2
              .
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    L_ATFLV_TO = L_NUM = L_DATE.

  ENDIF.
*  CONCATENATE P_YEAR '0831' INTO L_DATE_C.
*  L_DATE = L_DATE_C.
*  L_ATFLV_FROM = L_NUM = L_DATE.
*  CONCATENATE P_YEAR '0831' INTO L_DATE_C.
*  L_DATE = L_DATE_C.
*  L_ATFLV_TO = L_NUM = L_DATE.

  SELECT DISTINCT OBJEK
    INTO TABLE LT_OBJEK
    FROM AUSP AS AU
      INNER JOIN CABN AS CA ON AU~ATINN = CA~ATINN
    WHERE KLART = '002'
          AND AU~ATFLV BETWEEN L_ATFLV_FROM AND L_ATFLV_TO
          AND CA~ATNAM = L_NAME.


  IF NOT S_OBJEK[] IS INITIAL.
    LOOP AT LT_OBJEK.
      IF  LT_OBJEK-OBJEK IN S_OBJEK.
        CONTINUE.
      ELSE.
        DELETE  LT_OBJEK.
      ENDIF.
    ENDLOOP.
  ENDIF.


*    L_ATFLV = L_NUM = P_DATUM.
*    REFRESH LT_OBJEK.
*    L_NAME = 'P_STATUS'.
*
*    SELECT DISTINCT OBJEK
*       INTO TABLE LT_OBJEK
*       FROM AUSP AS AU
*         INNER JOIN CABN AS CA ON AU~ATINN = CA~ATINN
*       WHERE KLART = '002'
*             AND ( AU~ATWRT <> 'V05' AND AU~ATWRT <> 'V07' )
*             AND CA~ATNAM = L_NAME.
*
*    L_NAME = 'P_RP25_SHOP_DATE'.
*    L_NAME1 = 'P_RP27_SHOP_DATE'.
*
*    SELECT DISTINCT OBJEK
*      APPENDING TABLE LT_OBJEK
*      FROM AUSP AS AU
*        INNER JOIN CABN AS CA ON AU~ATINN = CA~ATINN
*      WHERE KLART = '002' AND
*            AU~ATFLV = L_ATFLV AND
*            ( CA~ATNAM = L_NAME OR CA~ATNAM = L_NAME ).
*  ENDIF.
  SORT LT_OBJEK BY OBJEK.

  IF LT_OBJEK[] IS INITIAL.
    MESSAGE I000 WITH 'No Data'.
    W_ERROR = 'X'.
    EXIT.
  ENDIF.

  IT_OUTPUT-VEHICLE = 'Vehicle No'.
  CLEAR: L_CN.
  LOOP AT LT_CABN.
    L_CN = L_CN + 1.
    CONCATENATE 'IT_OUTPUT-COL' L_CN INTO L_FIELD.
    ASSIGN (L_FIELD) TO <FS>.
    IF SY-SUBRC = 0.
      MOVE LT_CABN-ATBEZ TO <FS>.
    ENDIF.
    L_VALS-ATNAM = LT_CABN-ATNAM.
    APPEND L_VALS.
  ENDLOOP.
  APPEND IT_OUTPUT.
  CLEAR: IT_OUTPUT.

  LOOP AT LT_OBJEK.
    CLEAR: L_CN.
    IT_OUTPUT-VEHICLE = LT_OBJEK-OBJEK.
    L_OBJEK = LT_OBJEK-OBJEK.

    CALL FUNCTION 'Z_FPP_HANDLING_MASTER'
         EXPORTING
              OBJECT       = L_OBJEK
              CTYPE        = '002'
         TABLES
              VAL_TABLE    = L_VALS
         EXCEPTIONS
              NO_DATA      = 1
              ERROR_MODE   = 2
              ERROR_OBJECT = 3
              ERROR_VALUE  = 4
              OTHERS       = 5.

    LOOP AT L_VALS.
      L_CN = L_CN + 1.
      CONCATENATE 'IT_OUTPUT-COL' L_CN INTO L_FIELD.
      ASSIGN (L_FIELD) TO <FS>.
      IF SY-SUBRC = 0.
        MOVE   L_VALS-ATWRT TO <FS>.
      ENDIF.
    ENDLOOP.

    IT_OUTPUT-DATE = SY-DATUM.

    APPEND IT_OUTPUT.
    CLEAR: IT_OUTPUT.
    LOOP AT L_VALS.
      CLEAR: L_VALS-ATWRT.
      MODIFY L_VALS.
    ENDLOOP.
*      ENDIF.
*    ENDIF.
  ENDLOOP.
ENDFORM.

*call function ''.

FORM SEND_DATA.
  DATA: DSN(60),
       L_DATE(6),
               L_REMARKS(6000)..
  CONSTANTS: C_TAB TYPE X VALUE '09'.
  L_DATE = SY-DATUM+2(6).

  IF P_OPT1 = 'X'.
    CONCATENATE  '/usr/sap/EDI_SAP/'
                'Vehicle_Master' P_YEAR
                '.txt'
                INTO DSN.
  ELSE.
    CONCATENATE  '/usr/sap/EDI_SAP/'
                'Vehicle_Master' P_YEAR P_MTH
                '.txt'
                INTO DSN.
  ENDIF.
  OPEN DATASET DSN IN TEXT MODE FOR OUTPUT.

* Transfer the data to File.
  LOOP AT IT_OUTPUT.
    CLEAR: L_REMARKS.
    CONCATENATE IT_OUTPUT-VEHICLE IT_OUTPUT-COL001 IT_OUTPUT-COL002
    IT_OUTPUT-COL003 IT_OUTPUT-COL004 IT_OUTPUT-COL005
      IT_OUTPUT-COL006 IT_OUTPUT-COL007 IT_OUTPUT-COL008
        IT_OUTPUT-COL009 IT_OUTPUT-COL010 IT_OUTPUT-COL011
          IT_OUTPUT-COL012 IT_OUTPUT-COL013 IT_OUTPUT-COL014
            IT_OUTPUT-COL015 IT_OUTPUT-COL016 IT_OUTPUT-COL017
 IT_OUTPUT-COL018 IT_OUTPUT-COL019 IT_OUTPUT-COL020
 IT_OUTPUT-COL021 IT_OUTPUT-COL022 IT_OUTPUT-COL023
IT_OUTPUT-COL024 IT_OUTPUT-COL025 IT_OUTPUT-COL026
IT_OUTPUT-COL027 IT_OUTPUT-COL028 IT_OUTPUT-COL029

    IT_OUTPUT-COL030 IT_OUTPUT-COL031 IT_OUTPUT-COL032
      IT_OUTPUT-COL033 IT_OUTPUT-COL034 IT_OUTPUT-COL035
        IT_OUTPUT-COL036 IT_OUTPUT-COL037 IT_OUTPUT-COL038
          IT_OUTPUT-COL039 IT_OUTPUT-COL040 IT_OUTPUT-COL041
            IT_OUTPUT-COL015 IT_OUTPUT-COL016 IT_OUTPUT-COL017
 IT_OUTPUT-COL042 IT_OUTPUT-COL043 IT_OUTPUT-COL044
 IT_OUTPUT-COL045 IT_OUTPUT-COL046 IT_OUTPUT-COL047
IT_OUTPUT-COL048 IT_OUTPUT-COL049 IT_OUTPUT-COL050
IT_OUTPUT-COL051 IT_OUTPUT-COL052 IT_OUTPUT-COL053

IT_OUTPUT-COL054 IT_OUTPUT-COL055
      IT_OUTPUT-COL056 IT_OUTPUT-COL057 IT_OUTPUT-COL058
        IT_OUTPUT-COL059 IT_OUTPUT-COL060 IT_OUTPUT-COL061
          IT_OUTPUT-COL062 IT_OUTPUT-COL063 IT_OUTPUT-COL064
            IT_OUTPUT-COL065 IT_OUTPUT-COL066 IT_OUTPUT-COL067
 IT_OUTPUT-COL068 IT_OUTPUT-COL069 IT_OUTPUT-COL070
 IT_OUTPUT-COL071 IT_OUTPUT-COL072 IT_OUTPUT-COL073
IT_OUTPUT-COL074 IT_OUTPUT-COL075 IT_OUTPUT-COL076
IT_OUTPUT-COL077 IT_OUTPUT-COL078 IT_OUTPUT-COL079

    IT_OUTPUT-COL080 IT_OUTPUT-COL081 IT_OUTPUT-COL082
      IT_OUTPUT-COL083 IT_OUTPUT-COL084 IT_OUTPUT-COL085
        IT_OUTPUT-COL086 IT_OUTPUT-COL087 IT_OUTPUT-COL088
          IT_OUTPUT-COL089 IT_OUTPUT-COL090 IT_OUTPUT-COL091
 IT_OUTPUT-COL092 IT_OUTPUT-COL093 IT_OUTPUT-COL094
 IT_OUTPUT-COL095 IT_OUTPUT-COL096 IT_OUTPUT-COL097
IT_OUTPUT-COL098 IT_OUTPUT-COL099 IT_OUTPUT-COL100
    INTO L_REMARKS
    SEPARATED BY C_TAB.

    CONCATENATE L_REMARKS IT_OUTPUT-COL101 IT_OUTPUT-COL102
     IT_OUTPUT-COL103 IT_OUTPUT-COL104 IT_OUTPUT-COL105
       IT_OUTPUT-COL106 IT_OUTPUT-COL107 IT_OUTPUT-COL108
         IT_OUTPUT-COL109 IT_OUTPUT-COL110 IT_OUTPUT-COL111
           IT_OUTPUT-COL112 IT_OUTPUT-COL113 IT_OUTPUT-COL114
             IT_OUTPUT-COL115 IT_OUTPUT-COL116 IT_OUTPUT-COL117
  IT_OUTPUT-COL118 IT_OUTPUT-COL119 IT_OUTPUT-COL120
  IT_OUTPUT-COL121 IT_OUTPUT-COL122 IT_OUTPUT-COL123
 IT_OUTPUT-COL124 IT_OUTPUT-COL125 IT_OUTPUT-COL126
 IT_OUTPUT-COL127 IT_OUTPUT-COL128 IT_OUTPUT-COL129

     IT_OUTPUT-COL130 IT_OUTPUT-COL131 IT_OUTPUT-COL132
       IT_OUTPUT-COL133 IT_OUTPUT-COL134 IT_OUTPUT-COL135
         IT_OUTPUT-COL136 IT_OUTPUT-COL137 IT_OUTPUT-COL138
           IT_OUTPUT-COL139 IT_OUTPUT-COL140 IT_OUTPUT-COL141
             IT_OUTPUT-COL115 IT_OUTPUT-COL116 IT_OUTPUT-COL117
  IT_OUTPUT-COL142 IT_OUTPUT-COL143 IT_OUTPUT-COL144
  IT_OUTPUT-COL145 IT_OUTPUT-COL146 IT_OUTPUT-COL147
 IT_OUTPUT-COL148 IT_OUTPUT-COL149 IT_OUTPUT-COL150
 IT_OUTPUT-COL151 IT_OUTPUT-COL152 IT_OUTPUT-COL153

 IT_OUTPUT-COL154 IT_OUTPUT-COL155
       IT_OUTPUT-COL156 IT_OUTPUT-COL157 IT_OUTPUT-COL158
         IT_OUTPUT-COL159 IT_OUTPUT-COL160 IT_OUTPUT-COL161
           IT_OUTPUT-COL162 IT_OUTPUT-COL163 IT_OUTPUT-COL164
             IT_OUTPUT-COL165 IT_OUTPUT-COL166 IT_OUTPUT-COL167
  IT_OUTPUT-COL168 IT_OUTPUT-COL169 IT_OUTPUT-COL170
  IT_OUTPUT-COL171 IT_OUTPUT-COL172 IT_OUTPUT-COL173
 IT_OUTPUT-COL174 IT_OUTPUT-COL175 IT_OUTPUT-COL176
 IT_OUTPUT-COL177 IT_OUTPUT-COL178 IT_OUTPUT-COL179

     IT_OUTPUT-COL180 IT_OUTPUT-COL181 IT_OUTPUT-COL182
       IT_OUTPUT-COL183 IT_OUTPUT-COL184 IT_OUTPUT-COL185
         IT_OUTPUT-COL186 IT_OUTPUT-COL187 IT_OUTPUT-COL188
           IT_OUTPUT-COL189 IT_OUTPUT-COL190 IT_OUTPUT-COL191
*            IT_OUTPUT-col015 IT_OUTPUT-col016 IT_OUTPUT-col017
  IT_OUTPUT-COL192 IT_OUTPUT-COL193 IT_OUTPUT-COL194
  IT_OUTPUT-COL195 IT_OUTPUT-COL196 IT_OUTPUT-COL197
 IT_OUTPUT-COL198 IT_OUTPUT-COL199 IT_OUTPUT-COL200
 IT_OUTPUT-DATE
     INTO L_REMARKS
     SEPARATED BY C_TAB.


    OPEN DATASET DSN IN TEXT MODE FOR APPENDING.
    TRANSFER L_REMARKS TO DSN.
  ENDLOOP.

  CLOSE DATASET DSN.

  IF SY-SUBRC = 0.

    WRITE: /10 'File was downloaded Sucessfully'.
    SKIP.
    WRITE: /10 'File Name:', DSN.
*    SKIP.
*    WRITE: /10 'TOTAL RECORDS:', W_CNT.
  ELSE.
    FORMAT COLOR 6.
*    WRITE: /10 'TOTAL RECORDS: ', W_CNT.
*    SKIP.
    WRITE: /10 'FILE DOWNLOAD FAILED!'.
    FORMAT COLOR OFF.
    MESSAGE E000 WITH 'FILE DOWLOAD FAILED.'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  read_normal_class
*&---------------------------------------------------------------------*
FORM READ_NORMAL_CLASS USING  P_VMNO  P_CHAR
                             CHANGING P_VALUE.
  SELECT SINGLE AU~ATWRT
    INTO P_VALUE
    FROM AUSP AS AU
      INNER JOIN CABN AS CA ON AU~ATINN = CA~ATINN
    WHERE OBJEK = P_VMNO      AND
          KLART = '002'       AND
          CA~ATNAM = P_CHAR  .
ENDFORM.                    " read_normal_classification
*&---------------------------------------------------------------------*
*&      Form  READ_NORMAL_CLASS_ATFLV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_OBJEK_OBJEK  text
*      -->P_0461   text
*      <--P_L_ATFLV_TEMP  text
*----------------------------------------------------------------------*
FORM READ_NORMAL_CLASS_ATFLV USING  P_VMNO  P_CHAR
                             CHANGING P_VALUE.
  SELECT SINGLE AU~ATFLV
      INTO P_VALUE
      FROM AUSP AS AU
        INNER JOIN CABN AS CA ON AU~ATINN = CA~ATINN
      WHERE OBJEK = P_VMNO      AND
            KLART = '002'       AND
            CA~ATNAM = P_CHAR  .
ENDFORM.                    " READ_NORMAL_CLASS_ATFLV
