BOOTIMG := hello.img
SRC := hello.s
BOOTIMGGREEN := hello_green.img
SRCGREEN := hello_green.s

$(BOOTIMG): $(SRC)
	nasm -f bin -o $(BOOTIMG) $(SRC)
green: $(SRCGREEN)
	nasm -f bin -o $(BOOTIMGGREEN) $(SRCGREEN)
clean: 
	rm -f $(BOOTIMG) $(BOOTIMGGREEN)
run: $(BOOTIMG)
	qemu-system-i386 -fda $(BOOTIMG)

run-green: $(BOOTIMGGREEN)
	qemu-system-i386 -fda $(BOOTIMGGREEN)
