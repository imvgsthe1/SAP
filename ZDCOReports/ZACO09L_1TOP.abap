*----------------------------------------------------------------------*
*   INCLUDE ZACO09L_1TOP                                               *
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
*   Include Program
*----------------------------------------------------------------------*
* For Global Value in CO
INCLUDE ZLZGCO_GLOBAL_FORMTO1.

* For Global Value in CO For SHOP
INCLUDE ZLZGCO_GLOBAL_FORMTO2.


*----------------------------------------------------------------------*
*   Data Definition
*----------------------------------------------------------------------*
** Tables
TABLES : KEKO, KEPH,   CKHS,  CKIS,  TCKH3, TCKH2, CSKB ,TCKH4, COOMCO,
         KHSK,MARA.
TABLES : CKI64A, COVJA, RKPLN.
TABLES : TCK03,  TCK05.
TABLES : T001W,  MACKU, MARC.
TABLES : ZVCO_RP1, TKA01, ZTCO_SHOPCOST,
         ZSCO_SHOPCOST_001, ZSCO_SHOPCOST_KEY.
TABLES : CRHD, PLPO, PLKO, MKAL.

** Internal Tables
*  For Valuation Info. of Materials
DATA : BEGIN OF IT_MAT OCCURS 100,
        MATNR LIKE MACKU-MATNR,
        WERKS LIKE MARC-WERKS,
        BWKEY LIKE MACKU-BWKEY,
        BWTAR LIKE MACKU-BWTAR,
        MTART LIKE MACKU-MTART,
        BESKZ LIKE MARC-BESKZ,   "Procurement Type
        SOBSL LIKE MARC-SOBSL,   "Special procurement type
        VSPVB LIKE MARC-VSPVB,   "Proposed Supply Area
       END OF IT_MAT.
DATA : BEGIN OF IT_FSC_MAT OCCURS 500.
        INCLUDE STRUCTURE IT_MAT.
DATA : END OF IT_FSC_MAT.
* Main ITAB
DATA : IT_ZTCO_SHOPCOST  LIKE STANDARD TABLE OF ZTCO_SHOPCOST
                         WITH HEADER LINE .
* Temp. Table for Main ITAB
DATA : BEGIN OF IT_TMP_SHOPCOST OCCURS 5000.
        INCLUDE STRUCTURE IT_ZTCO_SHOPCOST.
DATA : END OF  IT_TMP_SHOPCOST.
* Temp. Table for Main ITAB - add on
DATA : BEGIN OF IT_ADD_TMP_SCOST OCCURS 100.
        INCLUDE STRUCTURE IT_ZTCO_SHOPCOST.
DATA : END OF   IT_ADD_TMP_SCOST .
* Temp. Table for Main ITAB - Press/Engine
DATA : BEGIN OF IT_TMP_PREN OCCURS 100.
        INCLUDE STRUCTURE IT_ZTCO_SHOPCOST.
DATA : END OF   IT_TMP_PREN .
* Temp. Table for Main ITAB - Press / Engine
DATA : BEGIN OF IT_TMP_PE OCCURS 0,
        LLV_MATNR LIKE MARA-MATNR ,
        WERKS     LIKE T001W-WERKS,
        BWKEY     LIKE MBEW-BWKEY ,
        BWTAR     LIKE MBEW-BWTAR .
DATA : END OF   IT_TMP_PE .
* KEKO
DATA : BEGIN OF IT_CKIKEKOKEY OCCURS 0.
        INCLUDE STRUCTURE CKIKEKOKEY.
DATA : KADAT LIKE KEKO-KADAT,
       BIDAT LIKE KEKO-BIDAT,
       MATNR LIKE KEKO-MATNR,
       WERKS LIKE KEKO-WERKS,
       BWKEY LIKE KEKO-BWKEY,
       BWTAR LIKE KEKO-BWTAR.
DATA : END OF IT_CKIKEKOKEY.
* Itemization
DATA : IT_KIS1  LIKE STANDARD TABLE OF KIS1
                WITH HEADER LINE .
DATA : IT_KHS1  LIKE STANDARD TABLE OF KHS1
                WITH HEADER LINE .
* ZVCO_RP1 (Report Point Linkage)
DATA : IT_ZVCO_RP1       LIKE STANDARD TABLE OF ZVCO_RP1
                         WITH HEADER LINE .
* Plant Info.
DATA : IT_T001W LIKE STANDARD TABLE OF T001W
                WITH HEADER LINE .
* For BAPI
DATA : IT_COSTCENTERLIST LIKE STANDARD TABLE OF BAPI0012_CCLIST
                         WITH HEADER LINE.
DATA : IT_RETURN         LIKE STANDARD TABLE OF BAPIRET2
                         WITH HEADER LINE.
DATA : BEGIN  OF IT_CCTR  OCCURS 0,
        SHOP  LIKE IT_ZTCO_SHOPCOST-SHOP,
        KOSTL LIKE CSKS-KOSTL.
DATA : END    OF IT_CCTR.
* KSBT Costing Rate BY KOSTL LSTAR
DATA : BEGIN OF IT_KOAT_P OCCURS 0.
DATA :  GJAHR    LIKE CCSS-GJAHR,
        POPER    LIKE CCSS-BUPER,
        KOSTL    LIKE CSKS-KOSTL,
        LSTAR    LIKE CSLA-LSTAR,
        ELEMT    LIKE KKB_SPLIT-ELEMT,
        W000     LIKE KKB_SPLIT-W000 ,
        WAERS    LIKE KKB_SPLIT-WAERS,
        TOTAL    LIKE KKB_SPLIT-W000 ,
        CP_%(16) TYPE P DECIMALS 7.
DATA : END OF IT_KOAT_P.
DATA : BEGIN OF IT_KOSTL_LSTAR_PCT OCCURS 0.
DATA :  FROM_PER LIKE COBK-PERAB,
        TO_PER   LIKE COBK-PERAB,
        OBJNR    LIKE COOMCO-OBJNR,
        KADKY    LIKE SY-DATUM ,
        BIDAT    LIKE SY-DATUM .
        INCLUDE STRUCTURE IT_KOAT_P.
DATA : END OF IT_KOSTL_LSTAR_PCT.
DATA : BEGIN OF IT_COOMCO OCCURS 0.
        INCLUDE STRUCTURE COOMCO.
DATA :  POPER    LIKE CCSS-BUPER,
        FROM_PER LIKE COBK-PERAB,
        TO_PER   LIKE COBK-PERAB,
        KOSTL    LIKE CSKS-KOSTL,
        LSTAR    LIKE CSLA-LSTAR.
DATA : END OF IT_COOMCO.
data : record_num type i.
** Global Vriables
DATA : GV_RECORD_TYPE LIKE ZTCO_SHOPCOST-RECORD_TYPE.
DATA : GV_VERWE LIKE PLKO-VERWE.
DATA : GV_TARKZ LIKE COKL-TARKZ.
DATA : GV_FREIG LIKE KEKO-FREIG.


*----------------------------------------------------------------------*
*   DEFINITION                                                *
*----------------------------------------------------------------------*
DEFINE SCREEN_PERIOD_D.
* Period Check No Longer than To_period
* P_PERBI
*Issue # 20041201-001 requested by HS CHO
*Changed by wskim,on 01112005
*-----Start
*  DELETE   &1
*   WHERE   BDATJ =  P_BDATJ
*     AND   (   POPER <  P_PERAB
*          OR   POPER >  P_PERBI ).
*----End
END-OF-DEFINITION.


*----------------------------------------------------------------------*
*   Selection Condition                                                *
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK BL1 WITH FRAME TITLE TEXT-001.
* General Info.
PARAMETERS : P_KOKRS LIKE CSKS-KOKRS   MEMORY ID CAC  OBLIGATORY.
PARAMETERS : P_KLVAR LIKE CKI64A-KLVAR MEMORY ID KRT  MODIF ID DIV,
             P_VERSN LIKE RKPLN-VERSN  MEMORY ID KVS  MODIF ID DIV,
             P_TVERS LIKE KEKO-TVERS   DEFAULT '01'   MODIF ID DIV.
PARAMETERS : P_ELEHK LIKE TCKH4-ELEHK  DEFAULT 'H1'   MODIF ID DIV.

SELECTION-SCREEN SKIP 1.

* Costing Type
SELECTION-SCREEN BEGIN OF BLOCK BL2 WITH FRAME TITLE TEXT-002.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT  1(13)  TEXT-032. "Business Plan
SELECTION-SCREEN POSITION 15.
PARAMETERS : P_STD RADIOBUTTON GROUP RA01
             USER-COMMAND  CTY.
SELECTION-SCREEN COMMENT  25(13) TEXT-031. "Standard Plan
SELECTION-SCREEN POSITION 39.
PARAMETERS : P_BPL RADIOBUTTON GROUP RA01.
*SELECTION-SCREEN COMMENT  49(13) TEXT-033. "Actual
*SELECTION-SCREEN POSITION 63.
*PARAMETERS : P_ACT RADIOBUTTON GROUP RA01.
SELECTION-SCREEN END OF LINE.
parameters: p_freig like keko-freig default 'X'.
SELECTION-SCREEN END OF BLOCK BL2.
SELECTION-SCREEN END OF BLOCK BL1.

SELECTION-SCREEN BEGIN OF BLOCK BL3 WITH FRAME TITLE TEXT-003.
* Posted Yr.
PARAMETERS : P_BDATJ LIKE KEKO-BDATJ MEMORY ID BDTJ OBLIGATORY.
* periods
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT  1(30) TEXT-021. "From
SELECTION-SCREEN POSITION 33.
PARAMETERS: P_PERAB LIKE COVJA-PERAB MEMORY ID VPE
            MODIF ID PER OBLIGATORY.
*SELECTION-SCREEN COMMENT  52(3) TEXT-022. "To
*SELECTION-SCREEN POSITION 58.
*PARAMETERS: P_PERBI LIKE COVJA-PERBI MEMORY ID BPE
*            MODIF ID PER OBLIGATORY.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK BL3.

* Option
SELECTION-SCREEN BEGIN OF BLOCK BL4 WITH FRAME TITLE TEXT-004.
SELECT-OPTIONS : S_MATNR FOR KEKO-MATNR MEMORY ID MAT.
*PARAMETERS : P_DEL AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK BL4.
