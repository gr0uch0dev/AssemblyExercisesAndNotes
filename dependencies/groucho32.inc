BUFFER_SIZE = 100

GetLenString PROTO, lpString:DWORD

;###########################
;#          MACROS         #
;###########################
mWriteStringToConsole MACRO console_handle, text
  LOCAL string
  LOCAL len_str
.data
  string BYTE text, 0
  len_str DWORD ?
.code
  push ecx
  Invoke GetLenString, ADDR string
  ; ecx should be checked against BUFFER_SIZE
  Invoke WriteConsole,
              console_handle,
              ADDR string,
              ecx,
              ADDR len_str,
              0
  pop ecx
ENDM

mGetStringFromConsole MACRO console_handle
  LOCAL string_read
  LOCAL len_str
.data
  string_read BYTE BUFFER_SIZE DUP(?), 0 , 0
  len_str DWORD ?
.code
  Invoke ReadConsole,
              console_handle,
              ADDR string_read,
              BUFFER_SIZE,
              ADDR len_str,
              NULL
  mov edx, OFFSET string_read
  mov ecx, len_str
ENDM
