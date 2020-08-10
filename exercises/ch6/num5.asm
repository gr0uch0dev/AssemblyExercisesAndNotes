.386
.model flat, STDCALL

include irvine32.inc



.data
  chosenOption BYTE ?
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


.code

  main PROC

    L0_option_choice:
      mov edx, OFFSET msg
      call WriteString
      call ReadChar; save the read char into AL
      ; TODO: sanity on input
      mov chosenOption, al
      mov edx, OFFSET carriage_lf
      call WriteString
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
      jmp exit_prog

  main ENDP

  op_and PROC, op_1:BYTE, op_2:BYTE
    mov edx, OFFSET op_and_msg
    call WriteString
    ret
  op_and ENDP

  op_or PROC op_1:BYTE, op_2:BYTE
    mov edx, OFFSET op_or_msg
    call WriteString
    ret
  op_or ENDP

  op_not PROC op_1:BYTE
    mov edx, OFFSET op_not_msg
    call WriteString
    ret
  op_not ENDP

  op_xor PROC op_1:BYTE, op_2:BYTE
    mov edx, OFFSET op_xor_msg
    call WriteString
    ret
  op_xor ENDP

  op_exit PROC
    mov edx, OFFSET op_exit_msg
    call WriteString
    ret
  op_exit ENDP

  exit_prog:
    invoke ExitProcess, 0
END main
