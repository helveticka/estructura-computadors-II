; =============================================================================
; TITLE    : GAME FILES
; AUTHOR   : - Daniel Giralt Pascual
;            - Harpo Joan Alberola
; =============================================================================

;------------------------------------------------------------------------------
FILESINIT
; Loads all the sprites files into the game.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - Sprites vars.
;------------------------------------------------------------------------------
            MOVEM.L D0-D7/A1-A3,-(A7)
            
            MOVE.L  #NSPRITES2,D6
            MOVE.L  #NSPRITES+NSPRITES2,D7
            SUBQ.L  #1,D7
            MOVE.L  #FILEBYTES,D3
            LEA.L   .FILES,A2
            LEA.L   .SPRITES,A3
            BRA     .LOOP
            
            
  .LOOP_AUX:  MULU.W  #4,D3
              SUBQ.L  #1,D7
              
.LOOP:        MOVEA.L (A2)+,A1
              MOVE.L  #51,D0                ; OPEN
              TRAP    #15
              CMP.W   #0,D0
              BNE     .ERROR
              
              MOVEA.L (A3)+,A1              ; SEEK POINTER
              MOVE.L  #SKIPBYTES,D2
              MOVE.L  #55,D0
              TRAP    #15
              
              MOVE.L  D3,D2                 ; READ
              MOVE.L  #53,D0
              TRAP    #15
              
              MOVE.L  #56,D0                ; CLOSE
              TRAP    #15
              
              CMP.L   D6,D7
              BEQ     .LOOP_AUX
            DBRA    D7,.LOOP
            
            
.END:       MOVEM.L (A7)+,D0-D7/A1-A3
            RTS
            
            
.FILES:     DC.L   FNUM1,FNUM2,FNUM3,FNUM4,FNUM5,FNUM6,FNUM7,FNUM8
            DC.L   FEMPTY,FHIDDEN,FFLAG,FBOMB,FBOMB_EX,FBOMB_WR
            DC.L   FSMILEY,FSMILEY_WIN,FSMILEY_LOS
            
.SPRITES:   DC.L   NUM1,NUM2,NUM3,NUM4,NUM5,NUM6,NUM7,NUM8
            DC.L   EMPTY,HIDDEN,FLAG,BOMB,BOMB_EX,BOMB_WR
            DC.L   SMILEY,SMILEY_WIN,SMILEY_LOS
            
.ERROR      SIMHALT




*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
