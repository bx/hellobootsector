BOOTIMG := hello.img
SRC := hello.s

$(BOOTIMG): $(SRC)
	nasm -f bin -o $(BOOTIMG) $(SRC)
clean: 
	rm -f $(BOOTIMG)
run:
	qemu-system-i386 -fda $(BOOTIMG)

