; =============================================================================
; TITLE    : GAME CONSTANTS
; AUTHOR   : - Daniel Giralt Pascual
;            - Harpo Joan Alberola
; =============================================================================

MIN_DIF:    EQU     20                      ; MIN DIFFICULTY

SIZE        EQU     16                      ; NUMBER OF TILES (N*N)
SQUARESZ    EQU     40                      ; WIDHT OF THE TILE
BORDER      EQU     SQUARESZ/2              ; WIDTH OF THE BORDER
QBORDER     EQU     BORDER/4                ; QUARTER OF A BORDER
BANNER      EQU     SQUARESZ*2              ; HIEGHT OF THE BANNER

FILEBYTES   EQU     4800                    ; NUMBER OF BYTES PER SPRITE
SKIPBYTES   EQU     54                      ; BYTES SKIPPED WHEN READING
NSPRITES    EQU     14                      ; NUMBER OF TILE SPRITES
NSPRITES2   EQU     3                       ; NUMBER OF SMILEY SPRITES

STANONE     EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
STAINTR     EQU     0                       ; INTRO/PRESS FIRE STATE
STAPLAY     EQU     1                       ; NORMAL GAME STATE
STAGOVR     EQU     2                       ; GAME OVER STATE

SEED:       DS.B    1
RNDINDEX    DS.B    1

REMOVE_FLAG EQU     1                       ; ALLOWS REMOVING PLACED FLAGS

; --- COLOR LIBRARY $00BBGGRR -------------------------------------------------

WHITE       EQU     $00FFFFFF               ;WHITE
BLACK       EQU     $00000000
RED         EQU     $000000FF               ;RED
DRED        EQU     $00000033               ;DARK RED
PINK        EQU     $008000FF               ;PINK
DPINK       EQU     $006600CC               ;DARK PINK
YELLOW      EQU     $0000FFFF               ;YELLOW
DYELLOW     EQU     $00000033               ;DARK YELLOW
BLUE        EQU     $00FF0000               ;BLUE
TURQUESA    EQU     $00B9C15D               ;LUE TURQUESA
DBLUE       EQU     $00330000               ;DARK BLUE
GREEN       EQU     $0035A100               ;GREEN
DGREEN      EQU     $00003300               ;DARK GREEN
DINOGN      EQU     $00398F00
GRAY        EQU     $00545454               ;GRAY
GRAYT4      EQU     $00D0D0D0               ;TELE GRAY 4
LTGRAY      EQU     $00C0C0C0 
MAROON      EQU     $00000080               ;GRANATE 
OLIVE       EQU     $00008080 
NAVY        EQU     $00800000               ;AZUL MARINO
PURPLE      EQU     $00800080 
TEAL        EQU     $00808000               ;AZUL CERCETA
SOBLUE      EQU     $00E4A900               ;SOFT BLUE
LIME        EQU     $0000FF00 
FUCHSIA     EQU     $00FF00FF 
AQUA        EQU     $00FFFF00
BROWN       EQU     $00204B6A
CBROWN      EQU     $0016354B
CLOUD       EQU     $00F4DAA5               ;WHITE - SKY 
ORANGE      EQU     $0041ADFC
SORANGE     EQU     $0072D1FE               ;ORANGE - SKY
CORANGE     EQU     $00BAD9F3               ;ORANGE - CLOUD


*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
