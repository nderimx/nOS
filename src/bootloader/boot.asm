org 0x7C00

kernel_location equ 0x7E00

; save boot disk number
mov [disk_num], dl

; set segments
cli
xor ax, ax
mov es, ax
mov ds, ax
mov ss, ax
mov sp, 0x7C00
mov bp, 0x8000
mov sp, bp
sti

; load kernel into memory
mov ah, 2
mov al, 50
mov ch, 0
mov cl, 2
mov dh, 0
mov dl, [disk_num] ; 0x80 while testing
mov bx, kernel_location
int 0x13

jc disk_read_error
cmp ah, 0x00
jne disk_read_error

; clear screen
mov ax, 3
int 0x10

; hand off execution to kernel
jmp kernel_location

disk_read_error:
    mov bl, ah
    add bx, "0"
    mov ah, 0x0E
    mov al, bl
    int 0x10

jmp $

disk_num:    db 0

times 510-($-$$) db 0
dw 0xAA55