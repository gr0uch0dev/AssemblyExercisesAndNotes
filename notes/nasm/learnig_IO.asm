; Notes on I/O by Groucho


; Things to remember

; ##########################################################################
; sys_read is invoked giving a value of 3 to rax
; from man: read() attempts to read up to "count" bytes from "file descriptor" fd into the "buffer" starting at buf
; key words are: file descriptor, buffer, count
; we want to take data from stdin => fd = 0 => mov rbx, 0
; with a buffer starting at a specific memory location we label in the .bss section (name here) = mov rcx, name
; for 255 bytes => mov rdx, 255

; int 128(or 0x80) is the interruption signal to be sent to the cpu.
; the interruption code passes the control to the kernel
; ##########################################################################

global _start

section .data
    welcome: db "Welcome!", 10, "Insert your name: ", 0
    greeting: db 10, "Nice to meet you, ", 0

section .bss
    name: resb 255; reserve 255 bytes in memory where we are going to save the name we got in input

section .text

string_len:
    push rsi
    xor rdx, rdx

    .loop:
      cmp byte[rsi + rdx], 0
      jz .end
      inc rdx
      jmp .loop

    .end:
      pop rsi
      ret

print_string:
    push rax
    xor rsi, rsi
    mov rsi, rax;
    call string_len; length saved into rdx

    mov rax, 1;
    mov rdi, 1;
    syscall
    pop rax
    ret


_start:
    mov rax, welcome
    call print_string
    ; according to the read call from man we expect as arguments:
    ; 1)file descriptor 2)buffer(pointer to a location in memory) 3) length
    ; the read function uses the following
    ;rbx (file descriptor), rcx (pointer to buffer), rdx(how many)
    mov rdx, 255; how much buffer we want to read
    mov rbx, 0
    mov rcx, name
    mov rax, 3; code for calling Read
    ;syscall

    int 128

    mov rax, greeting
    call print_string

    mov rax, name
    call print_string

    mov rax, 60
    syscall
