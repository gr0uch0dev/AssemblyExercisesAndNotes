.386
.model flat, STDCALL

include irvine32.inc

; This version uses the Irvine32 procedure to print the integers in the hexadecimal format
; NICE VARIANT TODO: use adhoc conversion procedures

PRINT_CRLF MACRO
  mov edx, OFFSET carriage_lf
  call WriteString
ENDM

mGetTwoOperands MACRO
; macro that prompts the user to insert two operands
; the inputs are then saved in provided memory locations
  mov edx, OFFSET msg_first_operand
  call WriteString
  call ReadHex
  mov firstOperand, eax
  PRINT_CRLF
  mov edx, OFFSET msg_second_operand
  call WriteString
  call ReadHex
  mov secondOperand, eax
  PRINT_CRLF
ENDM

mGetOneOperand MACRO
; prompts the user to input a single integer in hexadecimal format
; and stores it into the location provided
  mov edx, OFFSET msg_first_operand
  call WriteString
  call ReadHex
  mov firstOperand, eax
  PRINT_CRLF
ENDM

.data
  chosenOption BYTE ?
  firstOperand DWORD ?
  secondOperand DWORD ?
  result DWORD ?

  carriage_lf BYTE 0Dh, 0Ah, 0
  msg BYTE "Choose one out of the following options: ", 0Dh, 0Ah,
           "1. x AND y", 0Dh, 0Ah,
           "2. x OR y",  0Dh, 0Ah,
           "3. NOT x", 0Dh, 0Ah,
           "4. x XOR y", 0Dh, 0Ah,
           "5. Exit" , 0Dh, 0Ah,
           "Your Choice: ", 0
  msgWrongOption BYTE "You are allowed to choose between 1-5. Try again!", 0Dh, 0Ah, 0

  table BYTE '1'
        DWORD op_and
  entrySize = ($-table)
        BYTE '2'
        DWORD op_or
        BYTE '3'
        DWORD op_not
        BYTE '4'
        DWORD op_xor
        BYTE '5'
        DWORD op_exit
  tableNumEntries = ($ - table)/entrySize

  op_and_msg BYTE "Performing logic AND", 0
  op_or_msg BYTE "Performing logic OR", 0
  op_not_msg BYTE "Performing logic NOT", 0
  op_xor_msg BYTE "Performing logic XOR", 0
  op_exit_msg BYTE "Good Bye!", 0

  msg_first_operand BYTE "Insert the first 32-bit operand (hex): ", 0
  msg_second_operand BYTE "Insert the second 32-bit operand (hex): ", 0

  msg_result BYTE "Result: ", 0

  ;hex_char_set BYTE "0123456789ABCDEF"

.code

  main PROC

    L0_option_choice:
      mov edx, OFFSET msg
      call WriteString
      call ReadChar; save the read char into AL
      ; TODO: sanity on input
      mov chosenOption, al
      PRINT_CRLF
      mov ebx, OFFSET table
      mov ecx, tableNumEntries; we use LOOP accordingly to ECX

    L1:
      mov dl, BYTE PTR [ebx]
      cmp chosenOption, dl
      je L2_entry_found
      ; if not equal increase by entrySize
      add ebx, entrySize
      loop L1

    L3_wrong_option:
      mov edx, OFFSET msgWrongOption
      call WriteString
      jmp L0_option_choice

    L2_entry_found:
      ; when the entry is found the address of the procedure is one byte right to what ebx holds
      call NEAR PTR [ebx + 1]
      ; we expect the result into eax
      mov result, eax
      mov edx, OFFSET msg_result
      call WriteString
      mov edx, OFFSET result
      call WriteHex
      ;mov edx, OFFSET carriage_lf
      ;call WriteString
      jmp exit_prog

  main ENDP


  op_and PROC
    mov edx, OFFSET op_and_msg
    call WriteString
    PRINT_CRLF
    mGetTwoOperands
    mov eax, secondOperand
    and eax, firstOperand
    ; we return the result into eax
    ret
  op_and ENDP

  op_or PROC
    mov edx, OFFSET op_or_msg
    call WriteString
    PRINT_CRLF
    mGetTwoOperands
    mov eax, secondOperand
    mov edx, firstOperand
    or eax, firstOperand
    ret
  op_or ENDP

  op_not PROC
    mov edx, OFFSET op_not_msg
    call WriteString
    PRINT_CRLF
    mGetOneOperand
    mov eax, firstOperand
    not eax
    ret
  op_not ENDP

  op_xor PROC
    mov edx, OFFSET op_xor_msg
    call WriteString
    PRINT_CRLF
    mGetTwoOperands
    mov eax, secondOperand
    xor eax, firstOperand
    ret
  op_xor ENDP

  op_exit PROC
    mov edx, OFFSET op_exit_msg
    call WriteString
    mov eax, 0
    ret
  op_exit ENDP

  exit_prog:
    invoke ExitProcess, 0
END main
