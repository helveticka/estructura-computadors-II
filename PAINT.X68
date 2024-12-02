; =============================================================================
; TITLE    : GAME GRAPHICS
; AUTHOR   : - Daniel Giralt Pascual
;            - Harpo Joan Alberola
; =============================================================================

; -----------------------------------------------------------------------------
GAMEINIT
; Initializes the board graphics.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A1,-(A7)
            
            MOVE.L  #$ADADAD,D1             ; BACKGROUND COLOR
            MOVE.L  #80,D0
            TRAP    #15
            
            MOVE.L  #81,D0
            TRAP    #15
            
            MOVE.L  #0,D0
            JSR     DRAW_SMILEY
            
            
            LEA.L   HIDDEN,A1
            MOVE.L  #2*BORDER+BANNER,D2
            MOVE.L  D2,D4
            ADD.L   #SQUARESZ-1,D4
            MOVE.L  #SCRHEIGH-BORDER-1,D6
            
            
.LOOP1:       MOVE.L  #BORDER,D1
              MOVE.L  #SCRWIDTH-BORDER-1,D7
              
              
  .LOOP2:       MOVE.L  D1,D3
                ADD.L   #SQUARESZ-1,D3
                JSR     DRAW
                
                ADD.L   #SQUARESZ,D1
                CMP     D1,D7
              BGE     .LOOP2
              
              ADD.L   #SQUARESZ,D2
              MOVE.L  D2,D4
              ADD.L   #SQUARESZ-1,D4
              CMP     D2,D6
            BGE     .LOOP1
            
            
            MOVEM.L (A7)+,D0-D7/A1
            RTS

; -----------------------------------------------------------------------------
DRAW
; Draws on screen the filed selected on it's declared position.
; INPUT    - D1.W: LX
;            D2.W: UY
;            D3.W: RX
;            D4.W: LY
;            A1.L: File.
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A1,-(A7)
            
            MOVE.L  D2,D6
            MOVE.L  D4,D2
            
            MOVE.L  D3,D7
            MOVE.L  D1,D5
            
            
.LOOP1:       MOVE.L D5,D3
              
                
  .LOOP2:       CLR.L   D1
                MOVE.B  (A1)+,D1
                LSL.L   #8,D1
                MOVE.B  (A1)+,D1
                LSL.L   #8,D1
                MOVE.B  (A1)+,D1
                
                MOVE.L  #80,D0
                TRAP    #15
                
                MOVE.L  D3,D1
                MOVE.L  #82,D0
                TRAP    #15
                
                ADDQ.L  #1,D3
                CMP     D3,D7
              BGE     .LOOP2
              
              SUBQ.W  #1,D2
              CMP     D6,D2
            BGE     .LOOP1
            
            
            MOVEM.L (A7)+,D0-D7/A1
            TRAP    #SCRTRAP
            RTS

; -----------------------------------------------------------------------------
DRAW_TILE
; Draws the tile set by the pointer.
; INPUT    - A2: Position of the tile.
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A1-A2,-(A7)
            
            MOVE.B  ARR(A2),D0
            MULU.W  #10,D0
            MOVEA.L D0,A1
            JMP     .OPT(A1)
       
.OPT:       LEA.L   EMPTY,A1
            BRA     .END
            LEA.L   NUM1,A1
            BRA     .END
            LEA.L   NUM2,A1
            BRA     .END
            LEA.L   NUM3,A1
            BRA     .END
            LEA.L   NUM4,A1
            BRA     .END
            LEA.L   NUM5,A1
            BRA     .END
            LEA.L   NUM6,A1
            BRA     .END
            LEA.L   NUM7,A1
            BRA     .END
            LEA.L   NUM8,A1
            
            
.END:       MOVE.L  A2,D0
            DIVU.W  #SIZE,D0
            CLR.L   D2
            MOVE.W  D0,D2
            SWAP.W  D0
            CLR.L   D1
            MOVE.W  D0,D1
            
            MULU.W  #40,D1
            ADD.W   #BORDER,D1
            MULU.W  #40,D2
            ADD.W   #2*BORDER+BANNER,D2
            MOVE.W  D1,D3
            ADD.W   #SQUARESZ-1,D3
            MOVE.W  D2,D4
            ADD.W   #SQUARESZ-1,D4
            JSR     DRAW
            
            MOVEM.L (A7)+,D0-D7/A1-A2
            RTS

; -----------------------------------------------------------------------------
DRAW_BOMB
; Draws the bomb set by the pointer.
; INPUT    - A2: Position of the tile.
;          - D0: Kind of the bomb.
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A1,-(A7)
            
            MULU.W  #10,D0
            MOVEA.L D0,A1
            JMP     .OPT(A1)
            
            
.OPT:       LEA.L   BOMB,A1
            BRA     .END
            LEA.L   BOMB_EX,A1
            BRA     .END
            LEA.L   BOMB_WR,A1
            
            
.END:       MOVE.L  A2,D0
            DIVU.W  #SIZE,D0
            CLR.L   D2
            MOVE.W  D0,D2
            SWAP.W  D0
            CLR.L   D1
            MOVE.W  D0,D1
            
            MULU.W  #40,D1
            ADD.W   #BORDER,D1
            MULU.W  #40,D2
            ADD.W   #2*BORDER+BANNER,D2
            MOVE.W  D1,D3
            ADD.W   #SQUARESZ-1,D3
            MOVE.W  D2,D4
            ADD.W   #SQUARESZ-1,D4
            JSR     DRAW
            
            MOVEM.L (A7)+,D0-D7/A1
            RTS

; -----------------------------------------------------------------------------
DRAW_FLAG
; Draws the flag set by the pointer.
; INPUT    - A2: Position of the tile.
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4/A1-A2,-(A7)
            
            CLR.L   D5
            JSR     TILE_POS
            CMP.L   #-1,D0
            BEQ     .END
            
            MOVEA.W D0,A2
            MOVE.B  ARR(A2),D0
            LSR.B   #4,D0
            CMP.B   #$0F,D0
            BEQ     .END
            
            MOVE.L  #REMOVE_FLAG,D5
            CMP.B   #0,D5
            BEQ     .CHECK
            CMP.B   #$0A,D0
            BEQ     .RMV
            
            
.CHECK:     CMP.B   #$0A,D0
            BEQ     .END
            
            
.CONT1:     CMP.B   #0,(FLAGS)
            BEQ     .END
            LEA.L   FLAG,A1
            OR.B    #$A0,ARR(A2)
            SUBQ.B  #1,(FLAGS)
            CMP.B   #0,(FLAGS)
            BNE     .CONT2
            MOVE.L  #-1,D5
            BRA     .CONT2
            
            
  .RMV:     LEA.L   HIDDEN,A1
            AND.B   #$0F,ARR(A2)
            ADDQ.B  #1,(FLAGS)
            
            
.CONT2:     MOVE.L  A2,D0
            DIVU.W  #SIZE,D0
            CLR.L   D2
            MOVE.W  D0,D2
            SWAP.W  D0
            CLR.L   D1
            MOVE.W  D0,D1
            
            MULU.W  #40,D1
            ADD.W   #BORDER,D1
            MULU.W  #40,D2
            ADD.W   #2*BORDER+BANNER,D2
            MOVE.W  D1,D3
            ADD.W   #SQUARESZ-1,D3
            MOVE.W  D2,D4
            ADD.W   #SQUARESZ-1,D4
            JSR     DRAW
            
            
.END:       MOVEM.L (A7)+,D0-D4/A1-A2
            RTS

; -----------------------------------------------------------------------------
DRAW_SMILEY
; Draws the smiley selected.
; INPUT    - D0: Kind of smiley.
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A1,-(A7)
            
            MULU.W  #10,D0
            MOVEA.L D0,A1
            JMP     .OPT(A1)
            
            
.OPT:       LEA.L   SMILEY,A1
            BRA     .END
            LEA.L   SMILEY_WIN,A1
            BRA     .END
            LEA.L   SMILEY_LOS,A1
            
            
.END:       MOVE.L  #BORDER+7*SQUARESZ,D1
            MOVE.L  #BORDER,D2
            MOVE.L  #BORDER+9*SQUARESZ-1,D3
            MOVE.L  #BORDER+BANNER-1,D4
            JSR     DRAW
            
            MOVEM.L (A7)+,D0-D7/A1
            RTS

; -----------------------------------------------------------------------------
GAME_FRAME
; Initializes the game frame.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A1,-(A7)
            
            MOVE.L  #$ADADAD,D1             ; BACKGROUND COLOR
            MOVE.L  #80,D0
            TRAP    #15
            
            MOVE.L  #81,D0
            TRAP    #15
            
            MOVE.L  #0,D1
            MOVE.L  #0,D2
            MOVE.L  #SCRWIDTH-1,D3
            MOVE.L  #SCRHEIGH-1,D4
            MOVE.L  #87,D0
            TRAP    #15
            
            MOVE.L  #0,D0
            JSR     DRAW_SMILEY             ; SMILEY
            
            
            MOVE.L  #$FFFFFF,D1             ; WHITE STRIPES
            MOVE.L  #80,D0
            TRAP    #15
            
            MOVE.L  #81,D0
            TRAP    #15
            
            MOVE.L  #87,D0
            MOVE.L  #0,D1
            MOVE.L  #0,D2
            MOVE.L  #SCRWIDTH-QBORDER-1,D3
            MOVE.L  #QBORDER-1,D4
            TRAP    #15
            
            MOVE.L  #BORDER,D1
            MOVE.L  #BORDER+BANNER,D2
            MOVE.L  #SCRWIDTH-BORDER-1,D3
            MOVE.L  #BORDER+BANNER+QBORDER-1,D4
            TRAP    #15
            
            ADD.L   #BORDER+SIZE*SQUARESZ,D2
            ADD.L   #BORDER+SIZE*SQUARESZ,D4
            TRAP    #15
            
            MOVE.L  #0,D1
            MOVE.L  #0,D2
            MOVE.L  #QBORDER-1,D3
            MOVE.L  #SCRHEIGH-QBORDER-1,D4
            TRAP    #15
            
            MOVE.L  #SCRWIDTH-BORDER,D1
            MOVE.L  #BORDER,D2
            MOVE.L  #SCRWIDTH-BORDER+QBORDER-1,D3
            MOVE.L  #BORDER+BANNER+QBORDER-1,D4
            TRAP    #15
            
            ADD.L   #BORDER+BANNER,D2
            ADD.L   #BORDER+SIZE*SQUARESZ,D4
            TRAP    #15
            
            
            
            MOVE.L  #$5C5C5C,D1             ; BLACK STRIPES
            MOVE.L  #80,D0
            TRAP    #15
            
            MOVE.L  #81,D0
            TRAP    #15
            
            MOVE.L  #87,D0
            MOVE.L  #QBORDER,D1
            MOVE.L  #SCRHEIGH-QBORDER,D2
            MOVE.L  #SCRWIDTH-1,D3
            MOVE.L  #SCRHEIGH-1,D4
            TRAP    #15
            
            MOVE.L  #BORDER-QBORDER,D1
            MOVE.L  #BORDER-QBORDER,D2
            MOVE.L  #SCRWIDTH-BORDER-1,D3
            MOVE.L  #BORDER-1,D4
            TRAP    #15
            
            ADD.L   #BANNER+BORDER,D2
            ADD.L   #BANNER+BORDER,D4
            TRAP    #15
            
            MOVE.L  #SCRWIDTH-QBORDER,D1
            MOVE.L  #QBORDER,D2
            MOVE.L  #SCRWIDTH-1,D3
            MOVE.L  #SCRHEIGH-1,D4
            TRAP    #15
            
            MOVE.L  #BORDER-QBORDER,D1
            MOVE.L  #BORDER-QBORDER,D2
            MOVE.L  #BORDER-1,D3
            MOVE.L  #BORDER+BANNER-1,D4
            TRAP    #15
            
            ADD.L   #BORDER+BANNER,D2
            ADD.L   #BORDER+SIZE*SQUARESZ,D4
            TRAP    #15
            
            
            
            MOVE.L  #0,D0                   ; CORNERS
            MOVE.L  #0,D1
            MOVE.L  #SCRHEIGH-QBORDER,D2
            MOVE.L  #QBORDER-1,D3
            MOVE.L  #SCRHEIGH-1,D4
            JSR     DRAW_CORNER
            
            MOVE.L  #SCRWIDTH-QBORDER,D1
            MOVE.L  #0,D2
            MOVE.L  #SCRWIDTH-1,D3
            MOVE.L  #QBORDER-1,D4
            JSR     DRAW_CORNER
            
            MOVE.L  #1,D0
            MOVE.L  #BORDER-QBORDER,D1
            MOVE.L  #SCRHEIGH-BORDER,D2
            MOVE.L  #BORDER-1,D3
            MOVE.L  #SCRHEIGH-BORDER+QBORDER-1,D4
            JSR     DRAW_CORNER
            
            MOVE.L  #BORDER+BANNER,D2
            MOVE.L  #BORDER+BANNER+QBORDER-1,D4
            JSR     DRAW_CORNER
            
            MOVE.L  #SCRWIDTH-BORDER,D1
            MOVE.L  #2*BORDER+BANNER-QBORDER,D2
            MOVE.L  #SCRWIDTH-BORDER+QBORDER-1,D3
            MOVE.L  #2*BORDER+BANNER-1,D4
            JSR     DRAW_CORNER
            
            MOVE.L  #BORDER-QBORDER,D2
            MOVE.L  #BORDER-1,D4
            JSR     DRAW_CORNER
                        
            MOVEM.L (A7)+,D0-D7/A1
            RTS

; -----------------------------------------------------------------------------
DRAW_CORNER
; Draws the selected corner.
; INPUT    - D1.W: LX
;            D2.W: UY
;            D3.W: RX
;            D4.W: LY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A1,-(A7)
            
            MOVE.L  D1,D5
            MOVE.L  #QBORDER-1,D7
            MOVE.L  D0,D6
            
            MOVEA.L #$5CFFFFFF,A1
            MOVE.L  A1,D1
            AND.L   #$00FFFFFF,D1
            MOVE.L  #80,D0
            TRAP    #15
            
            CMP.L   #0,D6
            BEQ     .START
            
            
.LOOP1:       JSR     FLIP
             
  .START:     MOVE.L  D5,D1
              MOVE.L  #0,D6
              
              
    .LOOP2:     CMP.L   D6,D7
                BEQ     .SKIP
                
                MOVE.L  #82,D0
                TRAP    #15
                BRA     .END
                
      .SKIP:    JSR     FLIP
                
      .END:     ADDQ.L  #1,D6
                ADDQ.L  #1,D1
                CMP     D1,D3
              BGE     .LOOP2
              
              SUBQ.L  #1,D7
              ADDQ.L  #1,D2
              CMP     D2,D4
            BGE     .LOOP1
            
            
            MOVEM.L (A7)+,D0-D7/A1
            RTS

; -----------------------------------------------------------------------------
FLIP
; Changes the color to paint, saving the previus.
; INPUT    - D1
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            
            MOVE.L  A1,D0
            MOVE.L  D0,D1
            AND.L   #$FF000000,D0
            SWAP.W  D0
            LSR.L   #8,D0
            
            AND.L   #$FF,D1
            LSL.L   #8,D1
            OR.B    D0,D1
            LSL.L   #8,D1
            OR.B    D0,D1
            LSL.L   #8,D1
            OR.B    D0,D1
            
            MOVEA.L D1,A1
            AND.L   #$00FFFFFF,D1
            MOVE.L  #80,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D1
            RTS







*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
