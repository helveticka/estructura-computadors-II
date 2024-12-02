; =============================================================================
; TITLE    : GAME VARIABLES
; AUTHOR   : - Daniel Giralt Pascual
;            - Harpo Joan Alberola
; =============================================================================

STACUR      DS.W    1                       ; CURRENT STATE
STANEXT     DS.W    1                       ; NEXT STATE


FLAGS       DS.B    1                       ; FLAGS LEFT
WIN         DS.B    1                       ; WIN=1, LOSE=0


FNUM1       DC.B    'SPRITES/01.bmp',0      ; ALL SPRITES
NUM1        DS.B    FILEBYTES
FNUM2       DC.B    'SPRITES/02.bmp',0
NUM2        DS.B    FILEBYTES
FNUM3       DC.B    'SPRITES/03.bmp',0
NUM3        DS.B    FILEBYTES
FNUM4       DC.B    'SPRITES/04.bmp',0
NUM4        DS.B    FILEBYTES
FNUM5       DC.B    'SPRITES/05.bmp',0
NUM5        DS.B    FILEBYTES
FNUM6       DC.B    'SPRITES/06.bmp',0
NUM6        DS.B    FILEBYTES
FNUM7       DC.B    'SPRITES/07.bmp',0
NUM7        DS.B    FILEBYTES
FNUM8       DC.B    'SPRITES/08.bmp',0
NUM8        DS.B    FILEBYTES

FEMPTY      DC.B    'SPRITES/EMPTY.bmp',0
EMPTY       DS.B    FILEBYTES
FHIDDEN     DC.B    'SPRITES/HIDDEN.bmp',0
HIDDEN      DS.B    FILEBYTES
FFLAG       DC.B    'SPRITES/FLAG.bmp',0
FLAG        DS.B    FILEBYTES

FBOMB       DC.B    'SPRITES/BOMB.bmp',0
BOMB        DS.B    FILEBYTES
FBOMB_EX    DC.B    'SPRITES/BOMB_EXPLOTED.bmp',0
BOMB_EX     DS.B    FILEBYTES
FBOMB_WR    DC.B    'SPRITES/BOMB_WRONG.bmp',0
BOMB_WR     DS.B    FILEBYTES

FSMILEY     DC.B    'SPRITES/SMILEY.bmp',0
SMILEY      DS.B    FILEBYTES*4
FSMILEY_WIN DC.B    'SPRITES/SMILEY_WIN.bmp',0
SMILEY_WIN  DS.B    FILEBYTES*4
FSMILEY_LOS DC.B    'SPRITES/SMILEY_LOSE.bmp',0
SMILEY_LOS  DS.B    FILEBYTES*4
            
            
            ORG     $1000                   ; ARRAY WHERE THE BOARD TILES
ARR:        DS.B    SIZE*SIZE                 ; ARE UPDATED AND SAVED

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
