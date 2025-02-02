org 0x7c00 ; Signal assembler to treat this as the respective beginning memory address for all 
           ; specified memory addresses to start from. 
bits 16 ; Signal the assembler to output 16 bit code.

main:
    hlt ; Stop the cpu

.halt:
    jmp .halt

times 510-($-$$) db 0
dw 0aa55h ; Bytes identifier for a bootable partition.