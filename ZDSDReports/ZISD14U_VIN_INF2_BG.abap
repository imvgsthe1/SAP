************************************************************************
* Author                 : JUN HO CHOI
* Creation Date          : 2004-04-12
* Specifications By      :
* Development Request No : UD1K909304
* Addl documentation     :
* Description            : VIN INFORMATION DOWNLOAD
* Modification Log
* Date       Developer    Request ID Description
* 01/12/2005 WSKIM   Issue#  change layout of download
************************************************************************

REPORT  ZISD14U_VIN_INF2_BG NO STANDARD PAGE HEADING
                            MESSAGE-ID ZMSD.
*
TABLES: AUSP, CABN.


*
DATA : BEGIN OF IT_AUSP OCCURS 0.
        INCLUDE STRUCTURE AUSP.
DATA : END OF IT_AUSP.

DATA: IT_AUSP_TEMP LIKE TABLE OF IT_AUSP WITH HEADER LINE.

RANGES R_ATINN FOR AUSP-ATINN OCCURS 0.
RANGES S_ATFLV FOR AUSP-ATFLV.

DATA : BEGIN OF IT_CABN OCCURS 0,
       ATINN LIKE CABN-ATINN,
       ATNAM LIKE CABN-ATNAM,
       END OF IT_CABN.

DATA : BEGIN OF IT_LIST OCCURS 0,
       VIN(17),
       F2(5),
       DESTINATION_CODE(5),
       RP18_SHOP_DATE(8),
       RP19_SHOP_DATE(8),
       F6(20),
       WORK_ORDER(15),
** Changed by Furong on 11/08/07
       MANIFEST(11),
       ENGINE_NO(15),
** End of change
       219_28(1),
       219_7(1),
       F11(1),
       KEY_NO(5),
       TM_NO(15),
       EXT_COLOR(3),
       INT_COLOR(3),
       AIRBAG_NO16(14),
       END OF IT_LIST.

DATA : W_CNT TYPE I,
       W_N_8(8) TYPE N,
       W_ATINN LIKE CABN-ATINN,
       W_ATNAM LIKE CABN-ATNAM,
       W_ATFLV(10).

DATA : VARIANT LIKE INDX-SRTFD VALUE 'ISD14_02'.
DATA : VAR_DES LIKE INDX-SRTFD VALUE 'ISD14_02_DES'.
DATA : VAR_NEW LIKE INDX-SRTFD VALUE 'ISD14_02_NEW'.

FIELD-SYMBOLS : <FS>.
DATA : FIELD(30).


*
*SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
*SELECT-OPTIONS : S_DATE  FOR SY-DATUM NO-DISPLAY. " ATFLV
*PARAMETERS: P_DES(1) NO-DISPLAY.
*PARAMETERS: P_NEW(1) NO-DISPLAY.
*SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : S_DATE  FOR SY-DATUM . " ATFLV
PARAMETERS: P_DES(1) .
PARAMETERS: P_NEW(1) .
SELECTION-SCREEN END OF BLOCK B1.


*
START-OF-SELECTION.

  PERFORM INIT_CABN.
  PERFORM READ_DATA.
  PERFORM MODIFY_DATA.


*
END-OF-SELECTION.
  PERFORM DOWNLOAD_DATA.

  INCLUDE ZISD14U_VIN_INF2_BG_F01.