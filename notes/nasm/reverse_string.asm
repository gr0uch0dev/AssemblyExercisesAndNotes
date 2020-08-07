global _start

section .data
  msg: db "ABCDEF", 0

section .text

revere_string:
  xor rax, rax ; use rax as a counter
  xor r10, r10 ; use r10 as a counter

  mov rsi, rdi; rsi is the register that will be used by the write (rax=1) system call
              ; rsi holds the memory value of where the system call will find the first byte to write

  push 0; the new ending for the string that will be popped

  .loop:
    cmp byte[rdi + rax], 0
    je .swiping_loop

    mov r8b, byte[rdi + rax]
    push r8; even if we need just a byte we still have to push 64 bits to the stack
           ; this is why we used the lowest part of r8. By using r8b the info is loaded in just 1 byte
    inc rax;
    jmp .loop

  .swiping_loop:
    ; we enter this loop as soon as all the elements of the string (except the termination char)
    ; have been placed into the stack

    ; at the beginning rsi and rdi were holding the same value
    ; in the previous loop we accessed the memory location "loaded" in rdi plus a displacement using [rdi + rax]
    ; to use the same area of memory we are going now to use [rsi + r10]
    ; where r10 holds now the counter
    ; for instance if in [rdi + 0] we placed the byte representing the char "A"
    ; we are now to replace it with the char "F" (the first to be popped) using [rsi + 0]

    pop r9

    mov byte[rsi + r10], r9b
    cmp r9b, 0; we get the 0 that we placed as the first operation made on the stack
    je .end
    inc r10
    jmp .swiping_loop

  .end:
    mov rdx, r10; rdx is used by the write system call as the argument holding the number of bytes that need to be read in memory
                ; these bytes are equal to the counter we saved in r10 (that is considering also the termination 0)
    ret

_start:
  mov rdi, msg
  call revere_string

  mov rax, 1
  mov rdi, 1
  syscall
  mov rax, 60
  syscall
