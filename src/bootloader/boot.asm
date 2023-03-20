org 0x7C00

mov ax, 3
int 0x10

mov bx, msg
call print

jmp $

print:
    .print_loop:
        mov ah, 0x0E
        mov al, [bx]
        cmp al, 0
        je .terminate_print
        int 0x10
        inc bx
        jmp .print_loop
    .terminate_print:

msg:    db "Booting...  ;)", 0
times 510-($-$$) db 0
dw 0xAA55