        processor 6502

        include "vcs.h"
        include "macro.h"

        SEG
        ORG $F000

reset
fstart
	;; Start of vertical blank processing
        lda #0
        sta VBLANK

        lda #2
        sta VSYNC

        ;; 3 scanlines of VSYNCH signal...
        sta WSYNC
        sta WSYNC
        sta WSYNC

        lda #0
        sta VSYNC
        sta COLUBK		; reset color at the VSYNC

        ;; 37 scanlines of vertical blank...
	;; =====================================
	REPEAT 37
        sta WSYNC
	REPEND
	
	;; 192 scanlines of picture...
	;; =====================================
        ldx #0
        REPEAT 192		; # scanlines

        inx
        stx COLUBK

	sta WSYNC

        REPEND

        lda #%01000010
        sta VBLANK                     ; end of screen - enter blanking
	
	;; 30 scanlines of overscan...
	;; =====================================
	REPEAT 30
        sta WSYNC
	REPEND

        jmp fstart

	;; RESET & INTERRUPT VECTORS
	;; =====================================	
        ORG $FFFA
        .word reset          ; NMI
        .word reset          ; RESET
        .word reset          ; IRQ

    	END
