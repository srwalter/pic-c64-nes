	processor 16f716
        include "p16f716.inc"
        include "coff.inc"
        __CONFIG _RC_OSC & _WDT_OFF & _CP_OFF & _BOREN_OFF
        radix dec

        CONSTANT BUTTONS=0x20
        CONSTANT TMP=0x21

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
        bcf     STATUS, C
        btfsc   PORTA, PORTA_DATA
        bsf     STATUS, C
        rlf     BUTTONS, F

        bsf     PORTA, PORTA_CLK
        call    delay
        bcf     PORTA, PORTA_CLK
        call    delay
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

        ; delay ~50uS
delay:
        movlw   50
        movwf   TMP
delay_loop:
        decf    TMP, F
        btfss   STATUS, Z
        goto    delay_loop
        return

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
        call    delay
        bcf     PORTA, PORTA_LATCH
        call    delay

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
