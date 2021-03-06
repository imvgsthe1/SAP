*----------------------------------------------------------------------*
*   INCLUDE ZRIMLCMGTTOP                                              *
*----------------------------------------------------------------------*
*&  프로그램명 : 수입실적(개설일기준)                                  *
*&      작성자 : 맹성호 INFOLINK Ltd.                                  *
*&      작성일 : 2002.11.10                                            *
*&---------------------------------------------------------------------*
*&   DESC.     :
*&
*&---------------------------------------------------------------------*
*& [변경내용]
*&
*&---------------------------------------------------------------------*


*-----------------------------------------------------------------------
* Tables 및 변수 Define
*-----------------------------------------------------------------------
TABLES : ZTREQHD,         " 수입의뢰 Header
         ZTREQIT,         " 수입의뢰 Item
         ZTREQST,         " 수입의뢰 Status
         ZTPMTHD,         " Payment Notice Header
         LFA1.            " 구매처마스터 (일반섹션)

*-----------------------------------------------------------------------
* SELECT RECORD 절.
*-----------------------------------------------------------------------
DATA: BEGIN OF IT_SELECTED OCCURS 0,
      ZFREQNO    LIKE ZTREQST-ZFREQNO,           " 수입의뢰 관리번호.
      ZFAMDNO    LIKE ZTREQST-ZFAMDNO,           " Amend Seq.
END OF IT_SELECTED.

DATA : W_ERR_CHK(1)      TYPE C,
       W_SELECTED_LINES  TYPE P,                 " 선택 LINE COUNT
       W_PAGE            TYPE I,                 " Page Counter
       W_TABIX           LIKE SY-TABIX,
       W_LINE            TYPE I,                 " 페이지당 LINE COUNT
       LINE(3)           TYPE N,                 " 페이지당 LINE COUNT
       W_COUNT           TYPE I,                 " 전체 COUNT
       W_ITCOUNT(3),                             " 품목 COUNT.
       W_FIELD_NM        LIKE DD03D-FIELDNAME,   " 필드명.
       W_MIN_ZFITMNO     LIKE ZTREQIT-ZFITMNO,   " 항목번호.
       W_MAX_ZFAMDNO_OLD LIKE ZTREQST-ZFAMDNO,
       W_MAX_ZFAMDNO     LIKE ZTREQST-ZFAMDNO.
