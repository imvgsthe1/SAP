FUNCTION Z_FPM_CAL_BREAKDOWN_RATE.
*"---------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     REFERENCE(I_AJAHR) LIKE  ZTPM_ANBD-AJAHR
*"     REFERENCE(I_SHOP) LIKE  ZTPM_ANBD-SHOP OPTIONAL
*"  TABLES
*"      T_RATE STRUCTURE  ZTPM_ANBD
*"---------------------------------------------------------------------

*  DATA: BEGIN OF IT_SHOP OCCURS 0,
*          SHOP LIKE ZSPM_PARAM-SHOP,
*        END OF IT_SHOP.
*
*  DATA: BEGIN OF IT_ANBD OCCURS 0.
*  DATA:   AJAHR LIKE ZTPM_ANBD-AJAHR.
*          INCLUDE STRUCTURE ZVPM_ANBD.
*  DATA: END OF IT_ANBD.
*
*  DATA: WA_AJAHR(5),
*        WA_OPTIME    LIKE ZTPM_OPTIME-OPTIME,
*        WA_INTERVAL  TYPE I,
*        WA_SUM_BREAK TYPE I.
*
*  CONCATENATE I_AJAHR '0101' INTO WA_S_DAY.
*  CONCATENATE I_AJAHR '1231' INTO WA_E_DAY.
*
*  IF I_SHOP EQ SPACE.
*    SELECT DISTINCT BEBER AS SHOP
*            INTO CORRESPONDING FIELDS OF TABLE IT_SHOP
*            FROM  T357
*            WHERE BEBER BETWEEN '100' AND '500'.
*  ELSE.
*    MOVE E_SHOP TO  IT_SHOP-SHOP.
*    APPEND IT_SHOP.
*  ENDIF.
*
*  SELECT * INTO  CORRESPONDING FIELDS OF TABLE IT_TEMP
*         FROM  VIQMEL
*         WHERE BEBER IN I_SHOP
*         AND   QMART IN ('M1' , 'M2').
*  LOOP AT IT_TEMP.
*    SELECT SINGLE BUDAT INTO WA_BUDAT
*           FROM AFRU
*           WHERE AUFNR = IT_TEMP-AUFNR
*           AND   BUDAT BETWEEN WA_S_DAY AND WA_E_DAY.
*    IF SY-SUBRC EQ 0.
*      SELECT SINGLE A~STAT INTO WA_STAT
*             FROM JEST  AS A
*                 INNER JOIN AUFK AS B
*                 ON A~OBJNR = B~OBJNR
*             WHERE  B~AUFNR = IT_TEMP-AUFNR
*             AND    A~STAT  = 'I0045'
*             AND    A~INACT = SPACE.
*      IF SY-SUBRC EQ 0.
*        MOVE-CORRESPONDING IT_TEMP TO IT_ANBD.
*        APPEND IT_ANBD.
*      ENDIF.
*    ENDIF.
*  ENDLOOP.
*
*
*  MOVE   I_AJAHR TO IT_ANBD-AJAHR.
*  MODIFY IT_ANBD TRANSPORTING AJAHR WHERE EQUNR NE ''.
*  SORT   IT_ANBD BY BEBER.
*
*  LOOP AT IT_SHOP.
*    SELECT  SUM( OPTIME ) INTO WA_OPTIME
*            FROM  ZTPM_OPTIME
*            WHERE AJAHR = E_AJAHR
*            AND   SHOP  = IT_SHOP-SHOP.
*
*    LOOP AT IT_ANBD WHERE BEBER = IT_SHOP-SHOP.
*      TIME_TABLE-I_UNIT  = 'S'.
*      TIME_TABLE-E_UNIT  = I_MAUEH.
*      TIME_TABLE-I_VALUE = IT_ANBD-AUSZT.
*      APPEND TIME_TABLE.
*
*      CALL FUNCTION 'TIME_CONVERSION'
*           TABLES
*                TIME_TABLE = TIME_TABLE.
*
*      READ TABLE TIME_TABLE INDEX 1.
*
*      WA_INTERVAL = TIME_TABLE-E_VALUE.
*
*      IF WA_OPTIME NE 0.
*        WA_SUM_BREAK = WA_SUM_BREAK + WA_INTERVAL.
*      ENDIF.
*      CLEAR : WA_INTERVAL, TIME_TABLE, TIME_TABLE[].
*    ENDLOOP.
*
*    CHECK WA_OPTIME NE SPACE.
*    T_RATE-AVRATE  = WA_SUM_BREAK / WA_OPTIME * 100.
*    T_RATE-SHOP  = IT_SHOP-SHOP.
*    T_RATE-AJAHR = E_AJAHR.
*    APPEND T_RATE.
*
*    CLEAR: WA_OPTIME, WA_SUM_BREAK, T_RATE.
*  ENDLOOP.
*
ENDFUNCTION.
