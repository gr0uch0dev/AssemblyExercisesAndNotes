;11.6
; Write a program that creates a new text file. Prompt the user for a student identification number,
; last name, first name, and date of birth. Write this information to the file. Input several more
; records in the same manner and close the file.
.386
.model flat, STDCALL
;flat is the memory model used => protected mode => 32-bit addresses
;STDCALL is the convention for the naming and the call of the procedures
option casemap:none

; we use our own library (check the inc file and the source code to create the static library)
include groucho32.inc
includelib groucho32.lib

include irvine32.inc ; Irvine imports windows and kernel32 inc files on its own

NUM_STUDENTS = 3

.data
	fHandle HANDLE ?
	outHandle HANDLE ?
	inHandle HANDLE ?
	fName BYTE "students.txt", 0
	newline BYTE 0Ah
	bytesWritten DWORD ?
	msgStudentNum BYTE "STUDENT #"
	lenMsgStudentNum DWORD ($ - msgStudentNum)
	currentStudNum BYTE ?
	msg1 BYTE "Student ID: "
	lenMsg1 DWORD ($ - msg1)
	msg2 BYTE "Student lastname: "
	lenMsg2 DWORD ($ - msg2)
	msg3 BYTE "Student date of birth: "
	lenMsg3 DWORD ($ - msg3)
	msgEndOfRecord BYTE "==================================="
	lenMsgEndOfRecord DWORD ($ - msgEndOfRecord)
.code

	CreateNormalFileAlways PROC, lpFileName:DWORD
	; file handle saved in eax
	mov edx, lpFileName
	INVOKE CreateFileA, lpFileName, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
	ret
	CreateNormalFileAlways ENDP

	main PROC

	mov ebx, OFFSET fName
	INVOKE CreateNormalFileAlways, ADDR fName

	cmp eax, INVALID_HANDLE_VALUE
	jne ok_to_continue
	INVOKE WriteWindowsMsg ;if error
	jmp quit

	ok_to_continue:
	mov fHandle, eax

	INVOKE GetStdHandle,  STD_OUTPUT_HANDLE
	mov outHandle, eax
	INVOKE GetStdHandle,  STD_INPUT_HANDLE
	mov inHandle, eax

	xor ecx, ecx
	inc ecx; number of students (it is a natural number)
	push edx ; edx and ecx changed by the MACROS used next
	L1:
		push ecx
		mov eax, ecx
		add al,030h ; 0 ASCII
		mov currentStudNum, al
		INVOKE WriteFile, fHandle, ADDR newline, 1, ADDR bytesWritten, NULL ;write a newline to have a nicer output
		INVOKE WriteFile, fHandle, ADDR msgStudentNum, lenMsgStudentNum, ADDR bytesWritten, NULL
		INVOKE WriteFile, fHandle, ADDR currentStudNum, 1, ADDR bytesWritten, NULL
		INVOKE WriteFile, fHandle, ADDR newline, 1, ADDR bytesWritten, NULL ;write a newline to have a nicer output


		mWriteStringToConsole outHandle, "Insert Student's ID: "
		mGetStringFromConsole inHandle
		push edx
		push ecx
		; in accordance to the macros imported by groucho32.inc we have that
		; edx holds the offset of the buffer to be printed
		; ecx holds the bytes length
		; write string to file
		INVOKE WriteFile, fHandle, ADDR newline, 1, ADDR bytesWritten, NULL
		INVOKE WriteFile, fHandle, ADDR msg1, lenMsg1, ADDR bytesWritten, NULL
		pop ecx
		pop edx
		INVOKE WriteFile, fHandle, edx, ecx, ADDR bytesWritten, NULL
		INVOKE WriteFile, fHandle, ADDR newline, 1, ADDR bytesWritten, NULL

		mWriteStringToConsole outHandle, "Insert Student's lastname: "
		mGetStringFromConsole inHandle
		push edx
		push ecx
		INVOKE WriteFile, fHandle, ADDR msg2, lenMsg2, ADDR bytesWritten, NULL
		pop ecx
		pop edx
		INVOKE WriteFile, fHandle, edx, ecx, ADDR bytesWritten, NULL
		INVOKE WriteFile, fHandle, ADDR newline, 1, ADDR bytesWritten, NULL

		mWriteStringToConsole outHandle, "Insert Student's date of birth: "
		mGetStringFromConsole inHandle
		push edx
		push ecx
		INVOKE WriteFile, fHandle, ADDR msg3, lenMsg3, ADDR bytesWritten, NULL
		pop ecx
		pop edx
		INVOKE WriteFile, fHandle, edx, ecx, ADDR bytesWritten, NULL
		INVOKE WriteFile, fHandle, ADDR newline, 1, ADDR bytesWritten, NULL

		INVOKE WriteFile, fHandle, ADDR msgEndOfRecord, lenMsgEndOfRecord, ADDR bytesWritten, NULL

		pop ecx; pop the counter that was pushed
		cmp ecx, NUM_STUDENTS
		je finish_loop
		inc ecx
		jmp L1; we have too many bytes of instructions to be able to use loop (according to ecx)

	finish_loop:
	pop edx

	quit:
	INVOKE ExitProcess, 0
	main ENDP
	end main
