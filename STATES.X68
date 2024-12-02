; =============================================================================
; TITLE    : GAME STATE MANAGEMENT
; AUTHOR   : - Daniel Giralt Pascual
;            - Harpo Joan Alberola
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #STANONE,(STACUR)
            MOVE.W  #STAINTR,(STANEXT)
            RTS

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)             ; IF STATE CHANGED, DO INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
            
.DOUPD      CLR.L   D0                      ; IN ANY CASE, DO UPDATE
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            
            MOVEM.L (A7)+,D0/A0
            RTS
            
.INITBL     DC.L    STAINTRI,STAPLAYI,STAGOVRI
.UPDTBL     DC.L    STAINTRU,STAPLAYU,STAGOVRU

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            
            MOVEM.L (A7)+,D0/A0
            RTS
            
.PLTTBL     DC.L    STAINTRP,STAPLAYP,STAGOVRP

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS


; =============================================================================
; =============================================================================
; =============================================================================


; -----------------------------------------------------------------------------
STAPLAYI
; PLAY STATE INITIALIZATION.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     BOARDINIT
            JSR     GAMEINIT
            RTS

; -----------------------------------------------------------------------------
STAPLAYU
; PLAY STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/D5,-(A7)
            
            CLR.L   D5
            
            MOVE.L  (MOUSEDGE),D0
            CMP.L   #0,D0
            BEQ     .END
            
            MOVE.B  (MOUSECLK),D0
            CMP.B   #1,D0
            BNE     .CONT2
            
            JSR     CHECK_SMILEY
            CMP.L   #-1,D5
            BNE     .CONT1
            MOVE.W  #STAINTR,(STANEXT)
            BRA     .END
            
.CONT1      JSR     SHOW_TILE
            CMP.L   #-1,D5
            BEQ     .NEXT
            BRA     .END
            
.CONT2      CMP.B   #2,D0
            BNE     .END
            JSR     DRAW_FLAG
            CMP.L   #-1,D5
            BNE     .END
            JSR     CHECK_BOARD
            CMP.L   #-1,D5
            BNE     .END
            
.NEXT       MOVE.W  #STAGOVR,(STANEXT)
            
.END        MOVEM.L (A7)+,D0/D5
            RTS
            

; -----------------------------------------------------------------------------
STAPLAYP
; PLAY STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
.END        RTS
            
            

; =============================================================================
; =============================================================================
; =============================================================================


; -----------------------------------------------------------------------------
STAINTRI
; INTRO STATE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR DMMINIT TO RELEASE ALL MEMORY
; -----------------------------------------------------------------------------
            MOVEM.L D0,-(A7)
            
            JSR     GAME_FRAME
            
            STRING_COLOR #WHITE
            PEN_COLOR #RED
            FIL_COLOR #DRED
            
            PRINT_STRING_CENTER 12,24,.STR0
            TRAP    #SCRTRAP
            PRINT_STRING_CENTER 2,26,.STR1
            TRAP    #SCRTRAP
            PRINT_STRING_CENTER 10,28,.STR2
            TRAP    #SCRTRAP
            
*            BTST.B  #3,SCRCYCCT             ;LOOP TO BLINK
*            BEQ     .END           
*            PRINT_STRING_CENTER 5,16,.STR3                     
*.END    
            
            
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            MOVEM.L (A7)+,D0
            RTS
            
*.TEXT1:     DC.B    '- MINESWEEPER 2024 -',0
.STR0       DC.B    'PRESS  START',0        ;12 CHARS
.STR1       DC.B    'OR',0                  ;2 CHARS
.STR2       DC.B    'PUSH SPACE',0          ;10 CHARS
            DS.W    0
            
; -----------------------------------------------------------------------------
STAINTRU
; INTRO STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0,-(A7)

            MOVE.L  (MOUSEDGE),D0
            CMP.L   #0,D0
            BEQ     .END
            
            MOVE.B  (MOUSECLK),D0
            CMP.B   #1,D0
            BNE     .END
            MOVE.W  #STAPLAY,(STANEXT)
            
.END        MOVEM.L (A7)+,D0
            RTS

; -----------------------------------------------------------------------------
STAINTRP
; INTRO STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR INTPLOT
; -----------------------------------------------------------------------------
         *   JSR     GAME_FRAME
            
*            STRING_COLOR #WHITE
*            PEN_COLOR #RED
*            FIL_COLOR #DRED
*            
*            PRINT_STRING_CENTER 16,8,.STR0
*            
*            PRINT_STRING_CENTER 10,10,.STR1
*            
*            PRINT_STRING_CENTER 12,24,.STR2
*            
*            PRINT_STRING_CENTER 2,26,.STR4
*            
*            PRINT_STRING_CENTER 10,28,.STR5
*
*            PAINT_RECTANGLE  #SCRWIDTH/2-5,#SCRHEIGH/2+8,#54,#22
*            
*            BTST.B  #3,SCRCYCCT             ;LOOP TO BLINK
*            BEQ     .END           
*            PRINT_STRING_CENTER 5,16,.STR3                     
*.END            
            
*            TRAP    #SCRTRAP
            RTS
            
*.STR0       DC.B    'PRESS  START',0        ;12 CHARS
*.STR1       DC.B    'START',0               ;5 CHARS
*.STR2       DC.B    'OR',0                  ;2 CHARS
*.STR3       DC.B    'PUSH SPACE',0          ;10 CHARS
*            DS.W    0
            

; =============================================================================
; =============================================================================
; =============================================================================


; -----------------------------------------------------------------------------
STAGOVRI
; GAME OVER STATE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; ------------------------------------------------------------------------------
            JSR     REVEAL_BOARD
            RTS

; -----------------------------------------------------------------------------
STAGOVRU
; GAME OVER STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D5,-(A7)
            JSR     CHECK_SMILEY
            CMP.L   #-1,D5
            BNE     .END
            
            MOVE.W  #STAINTR,(STANEXT)
            
.END        ;CLR.B   (MOUSECLK)
            
            MOVEM.L (A7)+,D5
            RTS

; -----------------------------------------------------------------------------
STAGOVRP
; GAME OVER STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            RTS
            

; =============================================================================
; =============================================================================
; =============================================================================


































*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
