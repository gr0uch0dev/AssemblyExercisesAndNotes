; 11.4
; Write a program that fills each screen cell with a random character in a random color. Extra:
; Assign a 50% probability that the color of any character will be red.

.386
.model flat, STDCALL
option casemap:none

include irvine32.inc
;include windows.inc
;include kernel32.inc

.data
	charToPrint BYTE ?
	colorForChar BYTE ?
	outHandle HANDLE ?
.code

WriteACharWithColor PROC USES edx, scrHandle:HANDLE, inputChar:BYTE, inputColor:BYTE
	.data
	charFromInput BYTE ?
	.code
	xor edx, edx
	mov dl, inputChar
	mov charFromInput, dl

	movzx dx, inputColor
	; try also with WriteConsoleOutput (where CHAR_INFO is used)
	INVOKE SetConsoleTextAttribute, scrHandle, dx ; CHECK THIS!
	push NULL
	push NULL
	push 1
	push OFFSET charFromInput
	push scrHandle
	call WriteConsole
  ;INVOKE WriteConsole, screenHandle, ADDR inputChar, 1, NULL, NULL
  ; we had troubles with INVOKE so we called directly the procedure using
  ; STDCALL convention

	ret

WriteACharWithColor ENDP

RandomChar PROC
	mov eax, 256
	call RandomRange
	ret
RandomChar ENDP

RandomColor PROC
	; we use a standard 4-bit color definition
	; to get 50% change we can add 14 reds
	; so in totals we have 15/30 chance to get red as wanted
	; if the value is greater than 1111b (15d) then it is red
	mov eax, 30
	call RandomRange
	cmp eax, 15
	jbe return_instruction
	; if above (>=16) it means that we got a red
	xor eax, eax
	mov al, 0100b; red is decimal 4
	return_instruction:
	ret
RandomColor ENDP


main PROC
	; better to ask how many char the user wants to print
	;suppose for now 500
	Invoke GetStdHandle,  STD_OUTPUT_HANDLE
	mov outHandle, eax
	xor ecx, ecx
	mov ecx, 500
	L1:
		push ecx; somebody is modifying ecx (check!)
		INVOKE RandomChar
		add al, 32; printable Ascii chars start at 32d
		mov charToPrint, al

		INVOKE RandomColor
		mov colorForChar, al

		INVOKE WriteACharWithColor, outHandle, charToPrint, colorForChar
		pop ecx
		loop L1; loop accordingly to rcx

	invoke ExitProcess, 0
main ENDP

end main
