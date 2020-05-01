; 4.6
; Use a loop with indirect or indexed addressing to reverse the elements of an integer array in
; place. Do not copy the elements to any other array. Use the SIZEOF, TYPE, and LENGTHOF
; operators to make the program as flexible as possible if the array size and type should be
; changed in the future.

.386
.model flat, STDCALL
option casemap:none ; Case Sensitive

include kernel32.inc

.data
array DWORD 10, 12, 32, 45, 11, 22
arrayType DWORD ?
.code

main PROC
    xor edx, edx
    mov arrayType, TYPE array
    mov eax, LENGTHOF array
    mov ebx, 2
    div ebx; in order to get always pair to exchange
    mov ecx, eax; loop counter
    or edx, edx; it there is a reminder
    ; ebx is the first on the right
    ; esi is the first on the left
    jne odd_len
    jmp even_len; if no reminder

    odd_len:
        mov ebx, eax
        inc ebx; the first on the right of the middle
        mov esi, eax
        dec esi; the first on the left of the middle
        jmp swipe

    even_len:
        mov ebx, eax
        mov esi, eax
        dec esi


    swipe:
        mov eax, esi
        mul arrayType
        mov edx, array[eax]
        push eax
        push edx

        mov eax, ebx
        mul arrayType
        pop edx; edx was modified by mul
        mov edi, array[eax]
        mov array[eax], edx; move the one got from the left

        pop eax; old index
        mov array[eax], edi; move the one got from the right

        dec esi; go towards the left
        inc ebx; go towards the right
        loop swipe

    mov eax, OFFSET array
    invoke ExitProcess, 0

main ENDP
end main
