      SUBROUTINE ZRPDD (IFLTAB, CPATH, NORD, NCURVE, IHORIZ,
     * C1UNIT, C1TYPE, C2UNIT, C2TYPE, DVALUES, KVALS, NVALS,
     * CLABEL, KLABEL, LABEL, IUHEAD, KUHEAD, NUHEAD, ISTAT)
C
C     Retrieve Paired Data
C
C     Written by Bill Charley at HEC, 1989
C
C
      INTEGER IFLTAB(*), IUHEAD(*)
      CHARACTER CPATH*(*), CLABEL(*)*(*)
      CHARACTER C1UNIT*(*), C1TYPE*(*), C2UNIT*(*), C2TYPE*(*)
      REAL SVALUES(1)
      DOUBLE PRECISION DVALUES(*)
      LOGICAL LABEL
C
C
      CALL ZRPDI (IFLTAB, CPATH, NORD, NCURVE, IHORIZ,
     * C1UNIT, C1TYPE, C2UNIT, C2TYPE, SVALUES, DVALUES,
     * .TRUE., KVALS, NVALS, CLABEL, KLABEL, LABEL,
     * IUHEAD, KUHEAD, NUHEAD, ISTAT)
     	
      RETURN
C
      END
