BITS 16    ; Tells the assembler that the processor is operating in 16-bit mode
ORG 0x7C00 ; Assembler should assume the program is loaded at address 0x7C00 

; This is the first instruction that is executed when this bootloader is invoked
mov ebx, msg  ; Load address of message into a general purpose register.
              ; ebx will hold the address of the next byte in the message to print 
mov ah, 0x3   ; Setup "Get cursor position & shape" interrupt args
int 0x10      ; Causes current page number to be stored in bh
printnextchar:
	mov al, [ebx]; Move next character in message to al register 
	inc ebx	     ; Increment the address of the next byte to print
	cmp al, 0    ; Have we passed the end of the string we are printing?
	je finish    ; If we have printed the full string jump to the label 'hang'
	mov ah, 0x0e ; Move the magic value 0x0e to the register ah
	int 0x10     ; Invokes the "Video Services" interrupt
	             ; Because the magic value 0x0e is in register ah Video Services
		     ; Will write a character in TTY mode and it will print character
	             ; Specified by register al (which we set earlier)
	jmp printnextchar; Loop to print the next character

finish:	jmp finish; Loop in place to cause the bootloader to hang

; Define a null-terminated string we want to print
msg: db 'Hello, boot sector!', 0 

; Pad the rest of the bootloader with zeros through byte 510
times (510) - ($ - $$)  db 0 	

; A valid boot sector is expected to have bytes 511-512 contain 0x55 and 0xaa
BIOS_signature: 		
	db 0x55
	db 0xaa
