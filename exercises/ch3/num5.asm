Microsoft (R) Macro Assembler Version 14.25.28614.0	    05/01/20 15:58:03
AddTwo.asm						     Page 1 - 1


				; AddTwo.asm - adds two 32-bit integers.
				; Chapter 3 example

				.386
				.model flat,stdcall
				.stack 4096; 4kb of data for the stack, from 4 * 1024bytes(=1kb)
				ExitProcess proto,dwExitCode:dword; the prototype of the function we are going to use for ExitProcess
                                          ; this function is defined into the kernel32 library
                                          ; on the bottom of the listing we can see that such a procedure is external
                                          ; this means that we are telling the compiler to not stop us also if we did not defined it.
                                          ; It is responsibility of the linker to provide for it. Indeed we have to pass the linker the object
                                          ; created here along with an object that has such a procedure in it

 00000000			.code; the label code doesn't get any space in memory (.code is indeed an alias for address 0 here)
 00000000			main proc; recall that the processor mode is protected mode (.model flat) meaning that virtual addresses are in place
 00000000  B8 00000005			mov	eax,5; we see that B8 is the byte representation for the OPCODE "mov eax"
                                     ; the operand is occupying four bytes of memory (hexadecimal representation)
                                     ; therefore the next instruction will be found 5 bytes from the beginning
                                     ; to be noticed that when we move ("copy") an immediate value into a 32-bit registry
                                     ; we are zeroing the upper bits that not used to represent the immediate value
 00000005  83 C0 06			add	eax,6;  83 C0 is the OPCODE for "add eax"

					invoke ExitProcess,0
 00000008  6A 00	   *	    push   +000000000h ; INVOKE is an Assembly directive meaning that is language of the preprocessor.
                                               ; INVOKE will be translated into Assembly language. More specifically what INVOKE does under
                                               ; the hood is: - push the argument on the stack (STDCALL convention => arguments passed through stack)
                                               ;              - call the procedure
                                               ; just to remember "call" the procedure means: 1) push eip (make sure to go back here when the procedure has finished executing)
                                                                                            ; 2) jmp to the memory location where the procedure is defined
 0000000A  E8 00000000 E   *	    call   ExitProcess ; but we said that this procedure is imported from somewhere else how could we jump to it?
                                                     ; This is due to the fact that the compiler left space in the object created to allow us to import the procedure
                                                     ; This area of memory left by the compiler at object creation will be then filled by the linker when the object containing the procedure will be linked
                                                     ; In this way we can have a final executable that holds all the necessary information
 0000000F			main endp
				end main
Microsoft (R) Macro Assembler Version 14.25.28614.0	    05/01/20 15:58:03
AddTwo.asm						     Symbols 2 - 1




Segments and Groups:

                N a m e                 Size     Length   Align   Combine Class

FLAT . . . . . . . . . . . . . .	GROUP
STACK  . . . . . . . . . . . . .	32 Bit	 00001000 DWord	  Stack	  'STACK' ; 0x1000 = 0001 0000 0000 0000b = 4096d
_DATA  . . . . . . . . . . . . .	32 Bit	 00000000 DWord	  Public  'DATA' ; size of data section zero since not used
_TEXT  . . . . . . . . . . . . .	32 Bit	 0000000F DWord	  Public  'CODE' ; the size of the code area is 15 bytes


Procedures, parameters, and locals:

                N a m e                 Type     Value    Attr

ExitProcess  . . . . . . . . . .	P Near	 00000000 FLAT	Length= 00000000 External STDCALL ; ExitProcess will be provided later
                                                                                            ; we expect that the procedure received follows the STDCALL convention
                                                                                            ; that among its requirements has: arguments through the stack and cleaning of the stack on behalf of the procedure
main . . . . . . . . . . . . . .	P Near	 00000000 _TEXT	Length= 0000000F Public STDCALL   ; main is the entrypoint for code execution. The loader is going to check for it.


Symbols:

                N a m e                 Type     Value    Attr

@CodeSize  . . . . . . . . . . .	Number	 00000000h
@DataSize  . . . . . . . . . . .	Number	 00000000h
@Interface . . . . . . . . . . .	Number	 00000003h
@Model . . . . . . . . . . . . .	Number	 00000007h
@code  . . . . . . . . . . . . .	Text   	 _TEXT
@data  . . . . . . . . . . . . .	Text   	 FLAT
@fardata?  . . . . . . . . . . .	Text   	 FLAT
@fardata . . . . . . . . . . . .	Text   	 FLAT
@stack . . . . . . . . . . . . .	Text   	 FLAT

	   0 Warnings
	   0 Errors
