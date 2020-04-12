	processor 16f716
        include "p16f716.inc"
        include "coff.inc"
        __CONFIG _RC_OSC & _WDT_OFF & _CP_OFF & _BOREN_OFF
        radix dec

        CONSTANT BUTTONS=0x20

        CONSTANT PORTA_CLK=0    ; blue
        CONSTANT PORTA_DATA=1   ; green
        CONSTANT PORTA_LATCH=2  ; black

        CONSTANT PORTB_UP=7
        CONSTANT PORTB_DOWN=6
        CONSTANT PORTB_LEFT=5
        CONSTANT PORTB_RIGHT=4
        CONSTANT PORTB_POTY=3
        CONSTANT PORTB_FIRE=2
        CONSTANT PORTB_POTX=1

read_and_clock macro
        rlf     BUTTONS, F
        btfsc   PORTA, PORTA_DATA
        bsf     BUTTONS, 0

        bsf     PORTA, PORTA_CLK
        bcf     PORTA, PORTA_CLK
        endm

MAIN CODE
start

        .sim ".frequency=8e6"

        org 0
        goto main
        nop
        nop
        nop
        nop

main:
        bcf     STATUS, RP0
        clrf    PORTA
        clrf    PORTB
        bsf     STATUS, RP0
        clrf    TRISB
        clrf    TRISA
        ; DATA is an input
        bsf     TRISA, PORTA_DATA
        ; set all RA0-3 to digital
        bsf     ADCON1, PCFG0
        bsf     ADCON1, PCFG1
        bsf     ADCON1, PCFG2
        bcf     STATUS, RP0

        bsf     PORTA, PORTA_LATCH
        bcf     PORTA, PORTA_LATCH

        clrf    BUTTONS
        read_and_clock
        read_and_clock
        read_and_clock
        read_and_clock
        read_and_clock
        read_and_clock
        read_and_clock
        read_and_clock

        movfw   BUTTONS
        movwf   PORTB

loop:
        goto    loop
        end
