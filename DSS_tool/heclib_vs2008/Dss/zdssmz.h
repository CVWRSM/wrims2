C     ---------------------------------------
C
C     DSS Message common block
      COMMON /ZDSSMZ/ MUNIT,  MLEVEL, L80COL, IERRMS, CERRMS
      LOGICAL L80COL
      INTEGER IERRMS
      CHARACTER CERRMS*132
C
C     ---------------------------------------
