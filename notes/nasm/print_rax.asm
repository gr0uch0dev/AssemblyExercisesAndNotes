section .data


codes: db '0123456789ABCDEF'
newline: db 10 ; To copy the data to a file descriptor, the data needs to be in memory
section .text

global _start

_start:

  mov rax, 0x1122334455667788 ;16 hex values. 4 bits (a nibble) are necessary to store each of them ( 0001-0001-0010-0010-.......)

  mov rdi, 1 ;the file descriptor we want to use (1 stands for stdout)
  mov rdx, 1
  mov rcx, 64

  ; rax will be filled with 64 bits. The first step is to take the first 4 bits from the left and print the desired value
  ; then we iterate the procedure

  ; Each 4 bits should be output as one hexadecimal digit
  ; Use shift and bitwise AND to isolate them
  ; the result is the offset in 'codes' array
.loop:
  push rax; we push the rax register into the stack since we need to use it inside the loop to print the values
  sub rcx, 4
  ; cl is a register, lowest significant byte of rcx

  shr rax, cl
  and rax, 0xf
  ; 0xf is 00000....F in hexadecimal
  ; 0000000....1111 is the mask for the bitwise and
  lea rsi, [codes + rax] ;codes points at the start of "codes" and "+ rax" says how much I have to move from there
  ; rsi is used by the system call to write to the file descriptor (here the STDOUT since we want to print)

  mov rax, 1 ; rax 1 means that we want to call the "write" system call
  ; (when we invoke syscall it is going to look at the value in rax)
  ; here is clear why we pushed rax into the stack to store its value
  ; indeed anytime we loop we print a char

  ; syscall changes rcx and r11
  ; we say that in this case rcx is a "caller-saved registry"
  push rcx
  syscall
  pop rcx
  pop rax
  ; test can be used for the fastest 'is it a zero?' check

  test rcx, rcx
  jnz .loop

;print a new line
mov rax, 1
mov rdi, 1
mov rsi, newline
mov rdx, 1
syscall

mov rax, 60 ; invoke 'exit' system call
xor rdi, rdi
syscall
