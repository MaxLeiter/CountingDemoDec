.nolist
#include "kernel.inc"
#include "corelib.inc"
.list
    .db "KEXC"
    .db KEXC_ENTRY_POINT
    .dw start
    .db KEXC_STACK_SIZE
    .dw 50
    .db KEXC_KERNEL_VER
    .db 0, 6
    .db KEXC_NAME
    .dw name
    .db KEXC_THREAD_FLAGS
    .db THREAD_NON_SUSPENDABLE, 0
    .db KEXC_HEADER_END
name:
    .db "Counting Demo", 0
start:
    pcall(getLcdLock)
    pcall(getKeypadLock)

    pcall(allocScreenBuffer)

    ; Load dependencies
    kld(de, corelibPath)
    pcall(loadLibrary)
    ld hl, 0x0000 ;initial starting number
_:  push hl
        kld(hl, windowTitle)
        xor a ; xors a to itself, basically setting to 0, used by drawWindow
        corelib(drawWindow)

        ld b, 2 ; left-margin for drawStr
        ld de, 0x0208 ; x,y for drawStr
        kld(hl, helloString) ; drawStr uses HL
        pcall(drawStr)
    pop hl
    
    inc hl
    ld de, 0x0210 ; x,y
    pcall(drawDecHL)

    pcall(fastCopy)
    corelib(appGetKey) ; loads A with the pressed key

    cp kMode ; cp subtracts from A
    jr nz, -_ ; if A isn't zero, go to the label specified (if key == kMode) exit()
    ret

helloString:
    .db "Press [MODE] to exit.", 0
windowTitle:
    .db "Counting Demo", 0
corelibPath:
    .db "/lib/core", 0
