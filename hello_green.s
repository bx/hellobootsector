BITS 16 			; tells the assembler that the processor is operating in 16-bit mode
ORG 0x7C00			; tells the assembler that it should assume the program is loaded at address 0x7C00 

; this is the first instruction that is executed when this bootloader is invoked
	mov ebp, msg	; Load address of message into ebp because it's not being use by anything else
			; ebp will hold the address of the next byte in the message to print
			; we use ebp because all of the general purpose registers get clobbered
	
printchar:
	mov al, [ebp] 		; Move next character in message to al register 
	inc ebp			; Increment the address of the next byte to print
	cmp al, 0		; Check if we have reached past the end of the string we want to print
	je finish		; If we have printed the full string jump to the label 'hang'
	mov ah, 0x9		; Move the magic value 0x09 to the register ah 
	mov bl, 0xa 		; color red
	mov cx, 0x1		; number of times to print character
	int 0x10		; This interrupt will cause BIOS-style systems to invoke the "Video Services" interrupt
	                        ; Because the magic value 0x0a is in register ah Video Services will write a red character in TTY mode
	                        ; and it will print character specified by register al (which we set earlier) in the color
	                        ; specified in bl, and the number of times specified in cx

	;; get cursor position
	mov ah, 0x3 		; magic number to get cursor position
	int 0x10		; causes cursor position information to be put in various registers
	                        ; including the cursor's vertical position in dl

	;; move cursor one place
	inc dl			; move the cursor's vertical position right once
	mov ah, 0x2		; set up ah to instruct the interrupt to set the cursor position
	int 0x10		; sets cursor's position
	
	jmp printchar		; Loop to print the next character

finish:	jmp finish		; Loop in place to cause the bootloader to hang


msg:	db 'Hello, bootsector!', 0 ; This is the null-terminated string we want to print

times (510) - ($ - $$)  db 0 	; pad the rest of the bootloader with zeros through byte 510

BIOS_signature: 		; a valid boot sector is expected to have bytes 511-512 contain 0x55 and 0xaa
	db 0x55
	db 0xaa
