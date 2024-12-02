; =============================================================================
; TITLE    : MOUSE MANAGEMENT
; AUTHOR   : - Daniel Giralt Pascual
;            - Harpo Joan Alberola
; =============================================================================

; -----------------------------------------------------------------------------
MOUSEINIT
; Mouse init.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            
            CLR.W   (MOUSEX)
            CLR.W   (MOUSEY)
            CLR.B   (MOUSECLK)
            CLR.L   (MOUSEVAL)
            CLR.L   (MOUSEDGE)
            
            MOVE.L  #MSEISRQ,($80+SYSMOUIN*4)
            MOVE.L  #60,D0
            MOVE.L  #SYSMOUIN<<1|7,D1
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D1
            RTS
   
; -----------------------------------------------------------------------------
MSEISRQ
; MOUSE ISR
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES - MOUSEY/X: Screen pointers
;          - MOUSECLK: Action performed
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            
            MOVE.L  #$02,D1
            MOVE.L  #61,D0
            TRAP    #15
            
            MOVE.L  D1,(MOUSEY)
            AND.L   #3,D0
            CMP.B   #3,D0
            BNE     .CONT                   ; IF BOTH PRESSED
            MOVE.B  #0,D0
            
.CONT:      LSL.W   #4,D1
            LSL.L   #4,D1
            OR.B    D0,D1
            
            MOVE.B  D0,(MOUSECLK)
            MOVE.L  (MOUSEVAL),D0           ; COMPUTE EDGE.
            NOT.L   D0                      ; EDGE= NOT(PREVIOUS) AND CURRENT.
            AND.L   D1,D0
            MOVE.L  D1,(MOUSEVAL)           ; STORE VALUES (PRESS AND EDGE)
            MOVE.L  D0,(MOUSEDGE)
            
.END:       MOVEM.L (A7)+,D0-D1
            RTE
            
; -----------------------------------------------------------------------------
TILE_POS
; Reads if a tile was pressed and wich.
; INPUT    - NONE
; OUTPUT   - D0: Number of the tile, -1 if out of bounds.
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D1-D2,-(A7)
            
            CLR.L   D0
            CLR.L   D1
            CLR.L   D2
            MOVE.W  (MOUSEX),D1
            MOVE.W  (MOUSEY),D2
            
            CMP.W   #BORDER,D1
            BLO     .OUT
            CMP.W   #SCRWIDTH-BORDER-1,D1
            BHI     .OUT
            
            CMP.W   #2*BORDER+BANNER,D2
            BLO     .OUT
            CMP.W   #SCRHEIGH-BORDER-1,D2
            BHI     .OUT
            
            SUB.W   #BORDER,D1
            DIVU.W  #40,D1
            SUB.W   #2*BORDER+BANNER,D2
            DIVU.W  #40,D2
            
            MOVE.W  D2,D0
            MULU.W  #SIZE,D0
            ADD.W   D1,D0
            BRA     .FIN
            
          
.OUT:       MOVE.L  #-1,D0
            
.FIN:       MOVEM.L (A7)+,D1-D2
            RTS
            
; -----------------------------------------------------------------------------
CHECK_SMILEY
; Reads if the smiley was pressed.
; INPUT    - NONE
; OUTPUT   - D5: 0 if pressed, -1 otherwise.
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D1/D2,-(A7)
            
            CLR.L   D5
            CLR.L   D1
            CLR.L   D2
            MOVE.W  (MOUSEX),D1
            MOVE.W  (MOUSEY),D2
            
            CMP.W   #BORDER+7*SQUARESZ,D1
            BLO     .FIN
            CMP.W   #BORDER+9*SQUARESZ-1,D1
            BHI     .FIN
            
            CMP.W   #BORDER,D2
            BLO     .FIN
            CMP.W   #BORDER+BANNER-1,D2
            BHI     .FIN
            
            MOVE.L  #-1,D5
            
.FIN        MOVEM.L (A7)+,D1/D2
            RTS
            
; -----------------------------------------------------------------------------
CHECK_START
; Reads if the smiley was pressed.
; INPUT    - NONE
; OUTPUT   - D5: 0 if pressed, -1 otherwise.
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D1/D2,-(A7)
            
            CLR.L   D5
            CLR.L   D1
            CLR.L   D2
            MOVE.W  (MOUSEX),D1
            MOVE.W  (MOUSEY),D2
            
            CMP.W   #BORDER+7*SQUARESZ,D1
            BLO     .FIN
            CMP.W   #BORDER+9*SQUARESZ-1,D1
            BHI     .FIN
            
            CMP.W   #BORDER,D2
            BLO     .FIN
            CMP.W   #BORDER+BANNER-1,D2
            BHI     .FIN
            
            MOVE.L  #-1,D5
            
.FIN        MOVEM.L (A7)+,D1/D2
            RTS
            
; -----------------------------------------------------------------------------
CHECK_DIFFICULTY
; Reads if the smiley was pressed.
; INPUT    - NONE
; OUTPUT   - D5: 0,1,2 choosen difficulty, -1 otherwise.
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D1/D2,-(A7)
            
            CLR.L   D5
            CLR.L   D1
            CLR.L   D2
            MOVE.W  (MOUSEX),D1
            MOVE.W  (MOUSEY),D2
            
            CMP.W   #BORDER+7*SQUARESZ,D1
            BLO     .FIN
            CMP.W   #BORDER+9*SQUARESZ-1,D1
            BHI     .FIN
            
            CMP.W   #BORDER,D2
            BLO     .FIN
            CMP.W   #BORDER+BANNER-1,D2
            BHI     .FIN
            
            MOVE.L  #-1,D5
            
.FIN        MOVEM.L (A7)+,D1/D2
            RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
