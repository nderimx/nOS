org 0x7e00
[bits 32]

; print message
mov bx, msg
call print


; ~halt
jmp $

print:
    mov ecx, 0xb8000    ; video memory location (upper left corner)
    .print_loop:
        mov al, [bx]
        cmp al, 0
        je .terminate_print
        mov ah, 0x0f
        mov [ecx], ax
        inc bx
        add ecx, 2
        jmp .print_loop
    .terminate_print:
    ret

msg:        db "Welcome to the Kernel", 0
times 25600 db 0	; 50 sectors