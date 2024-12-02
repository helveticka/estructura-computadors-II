            OPT     MEX
            ORG     $2000
            
            INCLUDE "CONST.X68"
            INCLUDE "BOARD.X68"
            INCLUDE "PAINT.X68"
            INCLUDE "RANDOM.X68"
            INCLUDE "FILE.X68"
            INCLUDE "MACROS.X68"
            INCLUDE "STATES.X68"
            INCLUDE "MOUSE.X68"
            INCLUDE "SYSTEM.X68"
            INCLUDE "SYSCONST.X68"
            
; -----------------------------------------------------------------------------
START
; Main program.
; -----------------------------------------------------------------------------

; --- INITIALIZE --------------------------------------------------------------

START       JSR     FILESINIT
            JSR     SYSINIT                 ; INITIALIZE SYSTEM-RELATED STUFF
            JSR     STAINIT                 ; INITIALIZES STATES


; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #SYSMOUIN               ; READ MOUSE
            JSR     STAUPD

; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)
            
            BRA     .LOOP                   ; MAIN LOOP
            SIMHALT
            
; -----------------------------------------------------------------------------
            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            
            END     START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
