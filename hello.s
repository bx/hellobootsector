BITS 16 			; tells the assembler that the processor is operating in 16-bit mode
ORG 0x7C00			; tells the assembler that it should assume the program is loaded at address 0x7C00 

; this is the first instruction that is executed when this bootloader is invoked
	mov ebx, msg	; Load address of message into a general purpose register.
	                ; ebx will hold the address of the next byte in the message to print 
printchar:
	mov al, [ebx] 		; Move next character in message to al register 
	inc ebx			; Increment the address of the next byte to print
	cmp al, 0		; Check if we have reached past the end of the string we want to print
	je finish		; If we have printed the full string jump to the label 'hang'
	mov ah, 0x0e		; Move the magic value 0x0e to the register ah
	int 0x10		; This interrupt will cause BIOS-style systems to invoke the "Video Services" interrupt
	                        ; Because the magic value 0x0e is in register ah Video Services will write a character in TTY mode
	                        ; and it will print character specified by register al (which we set earlier)
	jmp printchar		; Loop to print the next character

finish:	jmp finish		; Loop in place to cause the bootloader to hang


msg:	db 'Hello, boot sector!', 0 ; This is the null-terminated string we want to print

times (510) - ($ - $$)  db 0 	; pad the rest of the bootloader with zeros through byte 510

BIOS_signature: 		; a valid boot sector is expected to have bytes 511-512 contain 0x55 and 0xaa
	db 0x55
	db 0xaa
