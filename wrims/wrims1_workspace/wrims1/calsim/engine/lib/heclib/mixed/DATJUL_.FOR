      SUBROUTINE datjul_  (CDATE, JUL, IERROR, L_CDATE)
C
C     Interface routine to call HECLIB subroutine DATJUL
C
      CHARACTER CDATE !![REFERENCE]
      INTEGER*4 JUL !![REFERENCE]
      INTEGER IERROR !![REFERENCE]
      INTEGER L_CDATE !![VALUE]
C
      CALL DATJUL (CDATE(1:L_CDATE), JUL, IERROR)
C
      RETURN
      END
