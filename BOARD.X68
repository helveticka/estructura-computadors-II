; =============================================================================
; TITLE    : GAME BOARD
; AUTHOR   : - Daniel Giralt Pascual
;            - Harpo Joan Alberola
; =============================================================================
            
; -----------------------------------------------------------------------------
BOARDINIT
; Initializes the game board.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - ARR
; -----------------------------------------------------------------------------
            MOVEM.L D0-D3/A0-A2,-(A7)
            
            LEA.L   ARR,A0
            MOVE.W  #SIZE,D0
            MULU.W  D0,D0
            SUBQ.W  #1,D0
            
.LOOPINIT:    CLR.B   (A0)+                 ; CLEAR ARRAY
            DBRA    D0,.LOOPINIT
            
            
            MOVE.L  #1,D0                   ; DIFFICULTY
            MULS.W  #MIN_DIF,D0
            DIVU.W  #5,D0
            ADD.W   #MIN_DIF,D0
            MOVE.B  D0,(FLAGS)
            MOVE.B  #0,(WIN)
            
            
            JSR     RNDINIT                 ; INIT MINES
            SUBQ.L  #1,D0
            
.LOOP_MINES:  JSR     RNDGET
              MOVE.L  D1,A0
              CMP.B   #$0F,ARR(A0)
            BEQ     .LOOP_MINES
            
            MOVE.B  #$0F,ARR(A0)
            DBRA    D0,.LOOP_MINES
            
            
            LEA.L   ARR,A0                  ; UPDATE NEAR TILES
            MOVE.W  #SIZE,D0
            MULU.W  D0,D0
            SUBQ.W  #1,D0
    
.LOOP:        MOVEA.L A0,A1
              CMP.B   #$0F,(A0)+
              BLT     .END_LOOP
              
              JSR     CHECK_TILE
              
  .LOOP1:       MOVEA.L A1,A2
                MOVE.L  D2,D3
                
    .LOOP2:       CMP.B   #$0F,(A2)
                  BEQ     .END_LOOP2
                  ADDQ.B  #1,(A2) 
                  
    .END_LOOP2:   ADDQ.L  #1,A2
                DBRA    D3,.LOOP2
                
                ADD.L   #SIZE,A1
              DBRA    D1,.LOOP1
            
.END_LOOP:  DBRA    D0,.LOOP
            
            
            MOVEM.L (A7)+,D0-D3/A0-A2
            RTS
            
; -----------------------------------------------------------------------------
CHECK_TILE
; Checks the position in the board, to know if you are in a corner, in the edge
; or anywhere else in the middle.
; INPUT    - A1: Points the tile to check.
; OUTPUT   - D1: Height of the rectangle.
;          - D2: Width of the rectangle.
; MODIFIES - A1: Points the up-left corner of the tiles rectangle that
; borders the initial tile.
; -----------------------------------------------------------------------------
            MOVEM.L D0,-(A7)
            
            MOVE.L  A1,D0
            AND.L   #$FF,D0
            
            CMP.B   #$00,D0
            BEQ     .CORNER
            
            CMP.B   #$0F,D0
            BEQ     .CORNER2
            
            CMP.B   #$F0,D0
            BEQ     .CORNER3
            
            CMP.B   #$FF,D0
            BEQ     .CORNER4
            
            
            AND.L   #$F0,D0
            
            CMP.B   #$00,D0
            BEQ     .SIDEX
            
            CMP.B   #$F0,D0
            BEQ     .SIDEX2
            
            
            MOVE.L  A1,D0
            AND.L   #$0F,D0
            
            CMP.B   #$00,D0
            BEQ     .SIDEY
            
            CMP.B   #$0F,D0
            BEQ     .SIDEY2
            
            
            SUBQ.L  #1,A1
            SUB.L   #SIZE,A1
            
            MOVE.L  #2,D1
            MOVE.L  #2,D2
            BRA     .END
            
            
            
  .CORNER2: SUBQ.L  #1,A1
            BRA     .CORNER
            
  .CORNER3: SUB.L  #SIZE,A1
            BRA     .CORNER
            
  .CORNER4: SUBQ.L  #1,A1
            SUB.L  #SIZE,A1
            
.CORNER:    MOVE.L  #1,D1
            MOVE.L  #1,D2
            BRA     .END
            
            
  .SIDEX2:  SUB.L  #SIZE,A1

.SIDEX:     SUBQ.L  #1,A1
            
            MOVE.L  #1,D1
            MOVE.L  #2,D2
            BRA     .END
            
            
  .SIDEY2:  SUBQ.L  #1,A1
            
.SIDEY:     SUB.L   #SIZE,A1
            
            MOVE.L  #2,D1
            MOVE.L  #1,D2
            
            
.END:       MOVEM.L (A7)+,D0
            RTS
            
; -----------------------------------------------------------------------------
SHOW_TILE
; Reveals what's under the selected tile.
; INPUT    - NONE
; OUTPUT   - D5: -1 if bomb, 0 else.
; MODIFIES - Tile in the board array if it's been pressed.
; -----------------------------------------------------------------------------
            MOVEM.L D0/A1-A2,-(A7)
            
            CLR.L   D5
            JSR     TILE_POS
            CMP.L   #-1,D0
            BEQ     .END
            
            MOVEA.W D0,A2
            MOVE.B  ARR(A2),D0
            LSR.B   #4,D0
            CMP.B   #$0F,D0
            BEQ     .END
            CMP.B   #$0A,D0
            BEQ     .END
            
            CMP.B   #$0F,ARR(A2)            ; CHECK IF BOMB
            BNE     .CONT
            OR.B    #$F0,ARR(A2)
            MOVE.L  #1,D0
            JSR     DRAW_BOMB
            MOVE.L  #-1,D5
            BRA     .END
            
.CONT:      JSR     DRAW_TILE               ; OTHER TILES
            OR.B    #$F0,ARR(A2)
            CMP.B   #$F0,ARR(A2)            ; IF 0, CHECK IT'S SIDES
            BHI     .END
            
            MOVEA.L A2,A1
            JSR     ZERO
            
.END:       MOVEM.L (A7)+,D0/A1-A2
            RTS
            
; -----------------------------------------------------------------------------
ZERO
; Recursive method that also reveals the near tiles of an empty one.
; INPUT    - A1: Actual tile
; OUTPUT   - NONE
; MODIFIES - ARR
; -----------------------------------------------------------------------------
            MOVEM.L D0/D5/A1-A2,-(A7)
            
            CLR.L   D5
            JSR     CHECK_TILE
            
            
.LOOP1:       MOVEA.L A1,A2
              MOVE.L  D2,D3
            
                
  .LOOP2:       CMP.B   #$F0,ARR(A2)
                BHS     .ENDLOOP2
                
                CMP.B   #$00,ARR(A2)
                BHI     .ENDLOOP1
                
                ;Afegir a llista de següents
                MOVE.L  A2,D0
                MOVE.B  D0,-(A7)
                ADDQ.B  #1,D5
                
    .ENDLOOP1:  JSR     DRAW_TILE
                
    .ENDLOOP2:  OR.B    #$F0,ARR(A2)
                ADDQ.L  #1,A2
              DBRA    D3,.LOOP2
            
              ADD.L   #SIZE,A1
            DBRA    D1,.LOOP1
            
            
            CMP.L   #0,D5
            BEQ     .END
            
            SUBQ.L  #1,D5
.LOOP_STACK:
              MOVE.B  (A7)+,D0
              MOVEA.L D0,A1
              JSR     ZERO
            DBRA     D5,.LOOP_STACK
                        
            
.END:       MOVEM.L (A7)+,D0/D5/A1-A2
            RTS

            
; -----------------------------------------------------------------------------
CHECK_BOARD
; Checks the board once all flags have been placed.
; INPUT    - NONE
; OUTPUT   - D5: -1 if game finished, 0 else.
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            
            CLR.L   D5
            LEA.L   ARR,A0
            MOVE.W  #SIZE,D0
            MULU.W  D0,D0
            SUBQ.W  #1,D0
            
            
.LOOP:        CMP.B   #$0F,(A0)+
              BEQ     .END
            DBRA    D0,.LOOP
            
            MOVE.B  #1,(WIN)
            MOVE.L  #-1,D5
            
.END:       MOVEM.L (A7)+,D0/A0
            RTS
            
; -----------------------------------------------------------------------------
REVEAL_BOARD
; Reveals all tiles in board once the game has finished.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A0,-(A7)
            
            CLR.L   D0
            CMP.B   #0,(WIN)
            BNE     .NEXT
            ADDQ.B  #1,D0
            
  .NEXT:    ADDQ.B  #1,D0
            JSR     DRAW_SMILEY
            
            MOVEA.L #0,A2
            MOVE.L  #SIZE,D2
            MULU.W  D2,D2
            SUBQ.W  #1,D2
            
            CLR.L   D1
            
            
.LOOP:        MOVE.B  ARR(A2),D1
              LSR.B   #4,D1
              CMP.B   #$0F,D1
              BEQ     .END
              
              CMP.B   #$AF,ARR(A2)
              BEQ     .END
              
              CMP.B   #$0A,D1
              BNE     .CONT1
              MOVE.W  #2,D0
              JSR     DRAW_BOMB
              BRA     .END
              
  .CONT1:     CMP.B   #$0F,ARR(A2)
              BNE     .CONT2
              MOVE.W  #0,D0
              JSR     DRAW_BOMB
              BRA     .END
              
  .CONT2:     JSR     DRAW_TILE
              
  .END:       ADDA.L  #1,A2
            DBRA    D2,.LOOP
            
            
            MOVEM.L (A7)+,D0-D7/A0
            RTS









*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
