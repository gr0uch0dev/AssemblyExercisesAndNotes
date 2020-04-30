;11.3
; Write your own version of the link library’s Clrscr procedure that clears the screen.

.386
.model flat, STDCALL
option casemap:none ; Case Sensitive

include windows.inc

include kernel32.inc
includelib kernel32.lib


include groucho32.inc
includelib groucho32.lib

.data
 outHandle HANDLE ?
 inHandle HANDLE ?
 bytesRead DWORD ?
 cursorInfo CONSOLE_CURSOR_INFO <>
 XYInitPos COORD <0,0>
 XYCurrentPos COORD <>
 bufferInfo CONSOLE_SCREEN_BUFFER_INFO <>; prepares the space in memory to be filled with info concerning the buffer
 cellsDistanceFromInit DWORD ?
 numCharsWritten DWORD ?
.code


Clrscr PROC
 push OFFSET numCharsWritten
 push XYInitPos
 push cellsDistanceFromInit
 push " "
 push outHandle
 call FillConsoleOutputCharacter
 push XYInitPos
 push outHandle
 call SetConsoleCursorPosition
 ret
Clrscr ENDP

cellsUsedBetweenCoords PROC USES eax edx,
                     SizeScreenBuffer: COORD,
                     FirstCoord: COORD,
                     SecondCoord: COORD,
                     lpDistance: DWORD
; It computes the length in terms of cells between two COORDs
; The length is saved into the DWORD whose address is given as parameted
 LOCAL cellsUsedByFirstCoordPreviousRows:WORD
 LOCAL cellsUsedBySecondCoordPreviousRows:WORD
 LOCAL cellsDistance:WORD
 xor ax, ax
 ; how many rows have the first coord used completely?
 ; if 0 it means that that there is still space on the row
 ;mov ax, FirstCoord.Y
 ; we were having problems referencing to the field of a struct inside a procedure (can we do it?)
 ; we do it manually then
 mov ax, WORD PTR FirstCoord[2]
 ;cmp ax, SecondCoord.Y ; if 0 the cursor is on the same row
 cmp ax, WORD PTR SecondCoord[2]
 je sameline

 ;mul SizeScreenBuffer.X ; loads in eax the number of rows used by the pointer
 mul WORD PTR [SizeScreenBuffer]
 mov cellsUsedByFirstCoordPreviousRows, ax

 ;mov ax, SecondCoord.Y
 mov ax, WORD PTR SecondCoord[2]

 ;mul SizeScreenBuffer.X
 mul WORD PTR [SizeScreenBuffer]
 mov cellsUsedBySecondCoordPreviousRows, ax

 sub ax, cellsUsedByFirstCoordPreviousRows; saves in ax the difference in cells used
 ;add ax, SecondCoord.X ;add the cells in current row
 add ax, WORD PTR [SecondCoord]
 jmp final

 sameline:
   ;mov ax, SecondCoord.X
   mov ax, WORD PTR [SecondCoord]

 final:
   sub ax, WORD PTR [FirstCoord]
   mov edx, lpDistance
   mov DWORD PTR [edx], eax
   ret
cellsUsedBetweenCoords ENDP


 main PROC
 Invoke GetStdHandle,  STD_OUTPUT_HANDLE
 mov outHandle, eax
   Invoke GetStdHandle,  STD_INPUT_HANDLE
 mov inHandle, eax

 push edx
 push ecx
 mWriteStringToConsole outHandle, "Adding some text to the screen ... "
 mWriteStringToConsole outHandle, "Let's clean the screen..."
 INVOKE GetConsoleScreenBufferInfo, outHandle, ADDR bufferInfo
 mov edx, bufferInfo.dwCursorPosition
 mov XYCurrentPos, edx
 INVOKE cellsUsedBetweenCoords,
                     bufferInfo.dwSize, XYInitPos, XYCurrentPos, ADDR cellsDistanceFromInit
 INVOKE Clrscr

 mWriteStringToConsole outHandle, "This has been written after clearing!!! Yeaaaa"
pop ecx
pop edx

invoke ExitProcess, 0

main ENDP
end main
