      SUBROUTINE zrits_  (IFLTAB, CPATH, JULS, ISTIME, JULE,
     * IETIME, ITIMES, VALUES, KVALS, NVALS, IBDATE, CUNITS, CTYPE,
     * ISTAT, L_CPATH, L_CUNITS, L_CTYPE)
C
      INTEGER   IFLTAB !![REFERENCE]
      CHARACTER CPATH  !![REFERENCE]
      INTEGER   JULS   !![REFERENCE]
      INTEGER   ISTIME !![REFERENCE]
      INTEGER   JULE   !![REFERENCE]
      INTEGER   IETIME !![REFERENCE]
      INTEGER   ITIMES !![REFERENCE]
      REAL      VALUES !![REFERENCE]
      INTEGER   KVALS  !![REFERENCE]
      INTEGER   NVALS  !![REFERENCE]
      INTEGER   IBDATE !![REFERENCE]
      CHARACTER CUNITS !![REFERENCE]
      CHARACTER CTYPE  !![REFERENCE]
      INTEGER   ISTAT  !![REFERENCE]
      INTEGER L_CPATH  !![VALUE]
      INTEGER L_CUNITS !![VALUE]
      INTEGER L_CTYPE  !![VALUE]
C
      CALL ZRITS (IFLTAB, CPATH(1:L_CPATH), JULS, ISTIME,
     * JULE, IETIME, ITIMES, VALUES, KVALS, NVALS, IBDATE,
     * CUNITS(1:L_CUNITS), CTYPE(1:L_CTYPE), ISTAT)
C
      RETURN
      END
