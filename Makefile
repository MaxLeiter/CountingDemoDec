include .knightos/variables.make


ALL_TARGETS:=$(BIN)count \
	$(APPS)count.app \
	$(SHARE)icons/count.img

$(BIN)count: count/*.asm
	mkdir -p $(BIN)
	$(AS) $(ASFLAGS) --listing $(OUT)count.list count/main.asm $(BIN)count

$(APPS)count.app: config/count.app
	mkdir -p $(APPS)
	cp config/count.app $(APPS)

$(SHARE)icons/count.img: config/count.png
	mkdir -p $(SHARE)icons
	kimg -c config/count.png $(SHARE)icons/count.img

include .knightos/sdk.make
