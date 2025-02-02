org 0x7c00 ; Signal assembler to treat this as the respective beginning memory address for all 
           ; specified memory addresses to start from. 
bits 16 ; Signal the assembler to output 16 bit code.

%define ENDL 0x0d, 0x0a


;
;   FAT12 header
;
jmp short start
nop

bdb_oem: db 'MSWIN4.l'  ; 8 bytes
bdb_bytes_per_sector: dw 512
bdb_sectors_per_cluster: db 1
bdb_reserved_sectors: dw 1
bdb_fat_count: db 2
bdb_dir_entries_count: dw 0e0h
bdb_total_sectors: dw 2880
bdb_media_descriptor_type: db 0f0h
bdb_sectors_per_fat: dw 9
bdb_sectors_per_track: dw 18
bdb_heads: dw 2
bdb_hidden_sectors: dd 0
bdb_large_sector_count: dd 0

; Extended boot record
ebr_drive_number: db 0
db 0

ebr_signature: db 29h
ebr_volume_id: db 12h, 34h, 56h, 78h
ebr_volume_label: db 'SnmanKernel'
ebr_system_id: db 'FAT12   '

;
; Code goes here
;


start:
    jmp main


; Prints string to the screen
; Params: -ds:si points to string.
puts:

    ; Save registers we will modify
    push si
    push ax

.loop:

    lodsb ; Loads next character in al.

    ; This commented out code provides the same operation as 'lodsb' and is 
    ; present for demonstration purposes.
    ; mov al, [si]    ; Load the next byte of the string by dereferencing the 
    ;                 ; address of the si register
    ; inc si;

    or al, al       ; verify if next character is null
    jz .done        ; Jumps if the 0 register is set.
    mov ah, 0x0e    ; Set the INT flag for writing a character in TTY Mode.
    mov bh, 0;      ; Set print page to 0
    int 0x10        ; Flag interrupt
    jmp .loop

.done:

    pop ax
    pop si
    ret


main:

    ; Setup data segments
    mov ax, 0 ; Can't write to ds/es directly
    mov ds, ax
    mov es,ax 

    ; Setup stack
    mov ss, ax
    mov sp, 0x7c00 ; Stack grows downwards, so place the start of the stack at the start of the 
                   ; program memory so it grows underneath it.

    ; Print message
    mov si, msg_hello
    call puts

    hlt ; Stop the cpu

.halt:
    jmp .halt


msg_hello: db 'Hello World!', ENDL, 0

times 510-($-$$) db 0
dw 0aa55h ; Bytes identifier for a bootable partition.