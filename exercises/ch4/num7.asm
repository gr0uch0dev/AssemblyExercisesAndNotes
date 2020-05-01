;4.7
; Write a program with a loop and indirect addressing that copies a string from source to target,
; reversing the character order in the process. Use the following
.386
.model flat, STDCALL

ExitProcess PROTO, choice:DWORD

.data
source BYTE "This is the source string",0
lenSourceWithNull = ($ - source)
target BYTE SIZEOF source DUP('#')

.code
main PROC
    mov ecx, lenSourceWithNull
    dec ecx; remove 0
    mov edx, OFFSET source
    add edx, ecx
    dec edx; edx starts from the last non null char and go backwards
    mov ebx, OFFSET target

    L1:
        mov al, BYTE PTR [edx]
        push eax; store in the stack

        mov al, BYTE PTR[ebx]
        mov BYTE PTR [edx], al

        pop eax; the one we stored is in al
        mov BYTE PTR[ebx], al
        inc ebx
        dec edx
        loop L1
    mov BYTE PTR[ebx], 0; add null char

    push 0
    call ExitProcess

main ENDP
end main
