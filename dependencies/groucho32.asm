.386
.model flat, STDCALL
option casemap:none ; Case Sensitive
option PROC:private

PUBLIC GetLenString
.data


.code
;###########################
;#          PROCEDURES     #
;###########################
GetLenString PROC USES esi edx ebx, lp_string:DWORD
    xor esi, esi
    L1:
        mov edx, lp_string
        mov ebx, [lp_string]
        movzx edx, BYTE PTR [ebx + esi]
        cmp dl, 0
        je quit
        inc esi
        jmp L1
    quit:
        mov ecx, esi; save the length of the string into ecx
        ret
GetLenString ENDP

end
