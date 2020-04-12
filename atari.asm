	processor 16f716
        include "p16f716.inc"
        include "coff.inc"
        __CONFIG _RC_OSC & _WDT_OFF & _CP_OFF & _BOREN_OFF
        radix dec

        CONSTANT IRQ_W=0x7f
        CONSTANT IRQ_STATUS=0x7e
        CONSTANT COMMAND=0x7d
        CONSTANT SRQ_COUNT=0x7c

        CONSTANT XFER_TMP_BUF=0x30
        CONSTANT RESP_BUF=0x40
        CONSTANT RESP_BUF_LEN=0x4F

        ; 0x30 - 0x38 send/receive temp space
        ; 0x40 - 0x4E command response buffer

MAIN CODE
start

        .sim ".frequency=20e6"
        .sim "module library libgpsim_modules"
        .sim "module load usart U1"

        .sim "node n0"
        .sim "node n1"

        .sim "attach n0 portb2 U1.RXPIN"
        .sim "attach n1 portb1 U1.TXPIN"

        .sim "U1.txbaud = 19200"
        .sim "U1.rxbaud = 19200"

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
        ; set all RA0-3 to digital
        bsf     ADCON1, PCFG0
        bsf     ADCON1, PCFG1
        bsf     ADCON1, PCFG2
        bcf     STATUS, RP0
        incf    PORTA, F

loop:
        incf    PORTB, F
        goto    loop
        end
