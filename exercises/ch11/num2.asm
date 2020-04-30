; 11.2
; Write a program that inputs the following information from the user, using the Win32 Read-
; Console function: first name, last name, age, phone number. Redisplay the same information
; with labels and attractive formatting, using the Win32 WriteConsole function. Do not use any
; procedures from the Irvine32 library.

; NOTES: refactor needed (change in logic as well). No control on user inputs at the moment


.386
.model flat, STDCALL
option casemap:none ; Case Sensitive

include windows.inc
include kernel32.inc
include groucho32.inc
includelib kernel32.lib
includelib groucho32.lib

USER_INFO STRUCT
  uName DWORD ?
  uLenName DWORD ?
  uLastName DWORD ?
  uLenLastName Dword ?
  uAge DWORD ?
  uLenAge DWORD ?
  uPhoneNumber DWORD ?
  uLenPhoneNumber DWORD ?
USER_INFO ENDS

.data
  outHandle HANDLE ?
  inHandle HANDLE ?
  aUser USER_INFO <>
  bytes_read DWORD ?

.code

  main PROC
  ; first of all we need to get an handle
  INVOKE GetStdHandle,  STD_OUTPUT_HANDLE
  mov outHandle, eax
    INVOKE GetStdHandle,  STD_INPUT_HANDLE
  mov inHandle, eax

  push edx
  push ecx
  ; the macro saves the pointer to the buffer in edx and the number of bytes into ecx
  mWriteStringToConsole outHandle, "Insert your name: "
  mGetStringFromConsole inHandle
  mov aUser.uName, edx
  mov aUser.uLenName, ecx

  mWriteStringToConsole outHandle, "Insert your last name: "
  mGetStringFromConsole inHandle
  mov aUser.uLastName, edx
  mov aUser.uLenLastName, ecx

  mWriteStringToConsole outHandle, "Insert your age: "
  mGetStringFromConsole inHandle
  mov aUser.uAge, edx
  mov aUser.uLenAge, ecx

  mWriteStringToConsole outHandle, "Insert your phone number: "
  mGetStringFromConsole inHandle
  mov aUser.uPhoneNumber, edx
  mov aUser.uLenPhoneNumber, ecx

pop ecx
pop edx

mWriteStringToConsole outHandle, "Your name is: "
INVOKE WriteConsole, outHandle, aUser.uName, aUser.uLenName, NULL, 0

mWriteStringToConsole outHandle, "Your lastname is: "
INVOKE WriteConsole, outHandle, aUser.uLastName, aUser.uLenLastName, NULL, 0

mWriteStringToConsole outHandle, "Your age is: "
INVOKE WriteConsole, outHandle, aUser.uAge, aUser.uLenAge, NULL, 0

mWriteStringToConsole outHandle, "Your phone number is: "
INVOKE WriteConsole, outHandle, aUser.uPhoneNumber, aUser.uLenPhoneNumber, NULL, 0


INVOKE ExitProcess, 0

main ENDP
end main
