org 0x7c00

kernel_location equ 0x7e00

; save boot disk number
mov [disk_number], dl

; set segments
cli
xor ax, ax
mov es, ax
mov ds, ax
mov ss, ax
mov bp, 0x8000
mov sp, bp
sti

; load kernel into memory
mov ah, 2
mov al, 50
mov ch, 0
mov cl, 2
mov dh, 0
mov dl, [disk_number] ; 0x80 while testing
mov bx, kernel_location
int 0x13

jc disk_read_error
cmp ah, 0x00
jne disk_read_error

; clear screen
mov ax, 3
int 0x10

; Switch to Protected Mode
CODE_SEGMENT equ code_descriptor - gdt_start
DATA_SEGMENT equ data_descriptor - gdt_start

cli                     ; disable all interrupts
lgdt [gdt_descriptor]   ; load GDT
mov eax, cr0            ; change last bit
or eax, 1               ; of cr0 to 1
mov cr0, eax            ; (Protected mode = 1)

; Jump to other segments
jmp CODE_SEGMENT:start_protected_mode

disk_read_error:
    mov bl, ah
    add bx, "0"
    mov ah, 0x0e
    mov al, bl
    int 0x10

;
; DATA
;

disk_number:    db 0

; Set Global Descriptor Table
gdt_start:
    null_descriptor:
        dd 0
        dd 0
    ; Code Segment Descriptor
    code_descriptor:
        ; location and size (base=0 limit=0xfffff[* 1000 if Granularity==1])
        dw 0xffff       ; first 16bits of limit
        dw 0            ; first 16bits of base
        db 0            ; middle 8bits of base
        ; Present=1, Privilege=00, Type=1
        ; Type Flags: conainsCode=1, isConforming=0, isReadable=1, Accessed=0
        db 0b10011010   ; PPT and type flags
        ; Other Flags: Granularity=1, use32Bits=1, 00
        db 0b11001111   ; Other Flags and last 4 bits of limit (20bits)
        db 0            ; final 8 bits of base (total=32)
    ; Data Segment Descriptor
    data_descriptor:
        ; Everything same as CSD except Type Flags
        dw 0xffff
        dw 0
        db 0
        ; Type Flags: conainsCode=0 (grow "upward"), direction=0, isWritable=1, Accessed=0
        db 0b10010010
        db 0b11001111
        db 0
    gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start -1   ; size
    dd gdt_start

[bits 32]
start_protected_mode:
    ; set segment registers
    mov ax, DATA_SEGMENT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000
    mov esp, ebp

    ; hand off execution to kernel
    jmp kernel_location

times 510-($-$$) db 0
dw 0xaa55
