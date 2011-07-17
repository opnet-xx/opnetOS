; written by Joel Klassen, aka opnet
;
; compiled with nasm -f bin -o boot.bin boot.asm


[BITS 16]			; tell nasm to use 16 bit assembly

org 0x7C00			; set up a 4KB stack space
jmp 0x0000:start		; jump to the beginning

start:
	call prompt
	cli_interface db 'command> ', 0	

prompt:
	mov ah, 0x0E		; BIOS call, print string
	mov si, cli_interface	; mov the string into si


.repeat:
	lodsb			; load the next byte

	cmp al, 0		; if the string is over jump to .getstring
	je .getstring

	int 0x10		; print a character
	jmp .repeat		; go around until 0

.getstring:
        mov ah, 0x10		; BIOS call, wait for key
        int 0x16		; wait for key

        cmp al, 0x0D		; check for a carriage return character
        je .newline		; jump to the checkstring function

        mov ah, 0x0E		; BIOS call, print string
        int 0x10		; print the string

        jmp .getstring		; go back to the beginning


; the newline function was necessary because hitting enter only put the carriage return character in ah but dropped the LF character

.newline:
        mov ah, 0x0E		; BIOS call, print string		
        mov al, 0x0D		; CR character
        int 0x10		; print the string

        mov ah, 0x0E		; BIOS call, print string
        mov al, 0x0A		; LF character
        int 0x10		; print the string

        jmp prompt

done:
        ret


        times 510-($-$$) db 0   ; pad the rest of the binary with 0s
        dw 0xAA55               ; standard boot signature

