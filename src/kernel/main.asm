org 0x7E00

; print message
mov bx, msg
call print


; ~halt
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
    ret

msg:        db "Welcome to the Kernel", 0
times 25600 db 0	; 50 sectors