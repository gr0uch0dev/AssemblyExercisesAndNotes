; write a program that prints 123123 in STDOUT
global _start

section .data
  num: dd 12312311; use a label to refer to a specific location in memory
  newline: db 0xA

section .test

string_len:
  xor rax, rax; empty rax to be used as counter over the elements

  .loop:
    cmp byte[rdi + rax], 0
    je .end
    inc rax
    jmp .loop

  .end:
    ret

print_newline:
  xor rax, rax
  mov rax, 1; we want to WRITE
  mov rdi, 1; into the 1 file descriptor (STDOUT)
  mov rsi, newline; newline char
  mov rdx, 1; just one byte
  syscall
  ret

print_string:
  push rdi; caller-saved argument
  call string_len
  pop rsi; take from the stack the old value of rdi that is now stored in rsi because this is the starting point for printing
  mov rdx, rax; how many bytes we need to read equals the length of the string we just computed through the previous call
  mov rax, 1
  mov rdi, 1
  syscall
  ret;

print_uint:
  mov rax, rdi
  push 0; 0 is pushed to the stack. This will be the termination point for the string representing the number
  mov rdi, rsp;
  sub rsp, 16; we create a buffer on the stack that we are going to fill
             ; with the previous we take 16 bytes from the stack
  dec rdi; move below the 0 is pointing to
  mov r8, 10;

  .loop:
    xor rdx, rdx;
    div r8; quotient will be saved in rax while reminder in rdx
    or dl, 0x30; dl is the lowest byte of rdx. Here we get the relevant ascii code for the reminder (the bitwise or is going to increse the 0x30 moving over the ascii table)
    dec rdi;
    mov [rdi], dl
    test rax, rax
    jnz .loop

  call print_string
  add rsp, 24 ; why 24 here??? if less there will be a segmentation fault
              ; we give back space to the stack that we don't need anymore
  ; SOLUTION: is 24 because the architecture is 64 bits so the slot are of 8*8
  ; this means that we need to go back and pass the block that contains the 0 (made of 8 slices of 8 bits)
  ; ______________________________________________________________________________________
  ; if we add back to the stack 24 of buffer we get to the state before the 0 was pushed into the stack
  ; recall that the status of the world has to be resetted at the end of the function execution
  ; when we pop from the stack we need to get the same rip we pushed by calling the funcion
  ret


_start:
  ;mov rdi, qword[num] ; this will create problems becuase the compiler will go to read in more memory area than desired
  mov edi, dword[num] ; num is used as a label for the memory area while we need to get the data in the memory cell
  ; how can we extend the 32 bit num so that the remaining bits are 0 instead of taking it from memory
  call print_uint
  call print_newline
  mov rax, 60;
  xor rdi,rdi;
  syscall;

; Troubles encountered/ mistakes I made
; 1) pushing into the registry data with lower bits than 64
; if we print without the newline everythin works fine
; but if we add the newline, this is printed but the number showed is different
; we were accessing the memory like this: mov rdi, [num]
; but instead of 32bits the compiler was trying to put into rdi 64bits
; if there was nothing into the memory(undefined) we did not get the unexpected behaviour
; but if in the adjacent places in memory there was some data (like newline in this case)
; then we get a corruption due to this data
; so since [num] will go to
