REPORT ZRBM_CABN_CHANGING .

TABLES: CABN.
PARAMETERS: P_ATNAM LIKE CABN-ATNAM.
DATA: IT_CABN TYPE CABN OCCURS 0 WITH HEADER LINE.

SELECT *
     FROM CABN
     INTO TABLE IT_CABN
     WHERE ATNAM EQ P_ATNAM.
     DATA L_TABIX TYPE SY-TABIX.
 LOOP AT IT_CABN.
   L_TABIX = SY-TABIX.
   IT_CABN-ATWRD = ' '.
   MODIFY IT_CABN INDEX L_TABIX TRANSPORTING ATWRD.
   CLEAR IT_CABN.
 ENDLOOP.
 UPDATE CABN FROM TABLE IT_CABN.
 IF SY-SUBRC EQ 0.
   COMMIT WORK.
   WRITE: 'S'.
 ELSE.
   ROLLBACK WORK.
      WRITE: 'E'.

 ENDIF.
