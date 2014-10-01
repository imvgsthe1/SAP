FUNCTION Z_FPP_GET_PMT07OB.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  TABLES
*"      T_ZSPP_PMT07OB STRUCTURE  ZSPP_PMT07OB
*"----------------------------------------------------------------------

  DATA IT_ZTPP_PMT07OB LIKE TABLE OF ZTPP_PMT07OB WITH HEADER LINE.

*------> MOVE INBOUNDED TABLE TO ITAB
  LOOP AT T_ZSPP_PMT07OB.
    MOVE-CORRESPONDING T_ZSPP_PMT07OB TO IT_ZTPP_PMT07OB.
    MOVE : SY-DATUM    TO   IT_ZTPP_PMT07OB-ZEDAT,   "INTERFACE DATE
           SY-UZEIT    TO   IT_ZTPP_PMT07OB-ZETIM.   "INTERFACE TIME
    APPEND IT_ZTPP_PMT07OB.
  ENDLOOP.

*------> TEMP TABLE INSERT
*  DELETE ZTPP_PMT07OB FROM TABLE IT_ZTPP_PMT07OB.
  DELETE FROM ZTPP_PMT07OB
         CLIENT SPECIFIED
         WHERE MANDT EQ SY-MANDT.
  INSERT ZTPP_PMT07OB FROM TABLE IT_ZTPP_PMT07OB
                      ACCEPTING DUPLICATE KEYS.
*------> RETURN CODE
  IF SY-SUBRC EQ 0.
    COMMIT WORK.
    MOVE  'S'  TO  T_ZSPP_PMT07OB-ZZRET.
  ELSE.
    ROLLBACK WORK.
    MOVE  'E'  TO  T_ZSPP_PMT07OB-ZZRET.
    DELETE FROM ZTPP_PMT07OB CLIENT SPECIFIED WHERE MANDT = SY-MANDT.
  ENDIF.
  MODIFY T_ZSPP_PMT07OB TRANSPORTING ZZRET
                        WHERE ZZRET EQ SPACE.

*------>  CREATE ZTPP_PMT07GB
*  SUBMIT ZIPP111I_0010 AND RETURN.
ENDFUNCTION.