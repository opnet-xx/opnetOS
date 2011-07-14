	BITS 16

org 0x7C00			; set up a 4KB stack space
jmp 0x0000:start		; jump to the beginning

start:
	call prompt
	cli_interface db 'command> ', 0	

prompt:
	mov ah, 0x0E
	mov si, cli_interface


.repeat:
	lodsb

	cmp al, 0
	je .getstring

	int 0x10
	jmp .repeat

.getstring:
        mov ah, 0x10		; BIOS call, wait for key
        int 0x16		; wait for key

        cmp al, 0x0D		; check for a carriage return character
        je .checkstring		; jump to the checkstring function

        mov ah, 0x0E		; BIOS call, print string
        int 0x10		; print the string

        jmp .getstring		; go back to the beginning
	.tmp_buf db ''
.checkstring:
        mov ah, 0x0E
        mov al, 0x0D
        int 0x10

        mov ah, 0x0E
        mov al, 0x0A
        int 0x10

        jmp prompt

done:
        ret


        times 510-($-$$) db 0   ; Pad remainder of boot sector with 0s
        dw 0xAA55               ; The standard PC boot signature

