;Final Term project
INCLUDE Irvine32.inc
INCLUDE macros.inc

ExitProcess proto,dwExitCode:dword

PDWORD TYPEDEF PTR DWORD

.data
BUFFER_SIZE = 10000
buffer BYTE BUFFER_SIZE DUP(?)
filename    BYTE 80 DUP(0)
fileHandle   HANDLE ?
stringLength DWORD ?
bytesWritten DWORD ?

globalCount BYTE 0
answer DWORD BUFFER_SIZE DUP(?)
fileanswer BYTE "answer.txt"

choosePart BYTE ?
a DWORD ?
keyOrder DWORD 0,0,0,0
key DWORD "HACK"

index DWORD 0
indexNext DWORD 0

keyPTR PDWORD key
keyOrderPTR PDWORD keyOrder

numA BYTE ?
numb BYTE ?

check DWORD 0 
maxSize DWORD ?

result DWORD BUFFER_SIZE DUP(?)

.code
main PROC

mWrite "Enter an input filename: "
	;User inputs filename
	mov	edx,OFFSET filename
	mov	ecx,SIZEOF filename
	call	ReadString
	
	;Opens said filename
	mov	edx,OFFSET filename
	call	OpenInputFile
	mov	fileHandle,eax
	
	; Read the file into a buffer.
	mov	edx,OFFSET buffer
	mov	ecx,BUFFER_SIZE
	call	ReadFromFile
	jnc	check_buffer_size			; error reading?
	mWrite "Error reading file. "		; yes: show error message
	call	WriteWindowsMsg
	jmp	close_file

		
check_buffer_size:
	cmp	eax,BUFFER_SIZE			; buffer large enough?
	jb	buf_size_ok				; yes
	mWrite <"Error: Buffer too small for the file",0dh,0ah>
	jmp	close_file						; and quit
	
buf_size_ok:	
	mov	buffer[eax],0		; insert null terminator
	mWrite "File size: "
	call	WriteDec			; display file size
	call	Crlf

; Display the buffer.
	mWrite <"Buffer:",0dh,0ah,0dh,0ah>
	mov	edx,OFFSET buffer	; display the buffer
	call	WriteString
	call	Crlf

close_file:
	mov	eax,fileHandle
	call	CloseFile


;CODE CLEAR
;ENDING OF READ PORTION
Part1:
			
			mov esi, 0
			add esi, TYPE DWORD
			mov eax, keyPTR[esi]

			
			
			
			




			mov check, 0                     ;If program iterates twice without an illegal order of letters, check will not equal zero
			mov esi, 0
			mov edi, 0
			mov ecx, 0
			mov maxSize, LENGTHOF key
			sub maxSize, TYPE DWORD
			OrderEncryptionBegin:
			  cmp esi, maxSize
			  je OrderEncryptionEnd                    ;if it the last element, go to OrderEncryptionend
			  L1:
			  add edi, TYPE DWORD							;add by 4 to move esi by 1
																;algorithm: first two values that are the same in arrayB, compare their arrayA values for addL/R
			  mov eax, keyOrderPTR[esi]
			  mov ebx, keyOrderPTR[edi]
			  cmp eax,ebx
			  je checkAdd

			  cmp edi, maxSize
			  je L2
			  jmp  L1

			  L2:
			  add esi, TYPE DWORD
			  mov edi, esi
			  mov check, 0
			  jmp OrderEncryptionBegin

			  checkAdd:
				mov eax, keyPTR[esi]
				mov ebx, keyPTR[edi]
				cmp eax,ebx
				ja addLeft                   ;if the order cannot be equal
				jb addRight						
				;je myQuit
			addLeft:
				inc check
				inc keyOrderPTR[esi]
				jmp OrderEncryptionNext
			addRight:
				inc check
				inc keyOrderPTR[edi]
				jmp OrderEncryptionNext
			OrderEncryptionNext:
			  inc check                       ;check is incremented to show that there # number of swaps were done
			  jmp OrderEncryptionBegin
			OrderEncryptionEnd:
    			mov ecx, offset check
				mov check, 0			;check is resetted first
				cmp ecx, 0				;if there were any swaps, the order is "checked" again by jumping back to OrderBegin
				jne OrderEncryptionBegin 


		mov edi, -1
		index = -1; counter
		mov check, 0
		bufferPTRA PDWORD buffer
		mov esi, 0
		mov edi, 0

		indexResult DWORD 0

		En_Begin:
			add edi, DWORD					;increase index by 1 for next L1 iteration
			inc index				;index here stays the same, becomes COUNTER
			cmp index, LENGTHOF keyOrder			;if (index > keyorderLength) then the current L2 will be invalid
			je En_End
			mov eax, bufferPTRA[edi] 				;put the order value into a
			mov a, eax
			mov check, 0					;Set i to zero
	
		En_Dust2:
			mov eax,check
			mov ebx, LENGTHOF keyOrder
			mul ebx						;Mult eax by ebx into EDX:EAX
			mov indexNext, eax			;Dont know what these two are for actually
			mov indexNext, edx			;Ive been replacing IndexNext with EDI and index with ESI
			mov eax, indexNext
			mov ebx, a
			add eax, ebx
			mov edi, eax
			mov eax, bufferPTRA[edi]	
			add result, eax
			inc check
			mov eax, LENGTHOF buffer	;top
			mov ecx, LENGTHOF keyOrder	;bottom edx = remainder
			div ecx
			inc indexResult
			cmp check, eax
			je En_Begin
			jmp En_Dust2
	
		En_End: ;just here to show its ended::empty
	
  
			;Reverse				;I tried something here, but I didnt like it so i deleted it
				resultPTR PDWORD result		;I think you should pop from the result array and 
				mov ecx, 0			;WriteChar for each one
				mov esi, resultPTR
			copy_reverse:
				mov index, LENGTHOF result
				mov eax, [esi + ecx]
				sub index, ecx
				mov ebx, [esi + index]
				mov [esi + ecx], ebx
				mov [esi + LENGTHOF result], eax
				inc ecx
				cmp ecx, LENGTHOF result
				jne copy_reverse
			jmp myWrite

Part2:
	Restart_point: ;returns back to here if the key is not correct
		inc globalCount
  
		;SortKey
		  ;uses key to find order of the encryption using permutation
		  ;keyorder = 1,2,3,4,...n
		  ;key = <combination of letters elements 1...n> ; HACK EXAMPLE BELOW
			
			mov keyOrder, "0123"	;should add something here that makes 	
						;key order start at keyOrder, "0"
						;and adds the previous element + 1 to make a list from 0 to n
						;eax, 0
						;ecx = n
						;L1:
						;cmp eax, ecx
						;je endL
						;keyOrder += eax
						;inc eax
						;jmp L1


			keyPTR PDWORD key
						;keyOrderPTR PDWORD keyOrder
						;mov esi, holdA
						;mov eax, keyOrder
						;mov keyOrderPTR, eax
						;mov edi, keyOrderPTR

			mov check, 0                     ;If program iterates twice without an illegal order of letters, check will not equal zero
			mov index, 0
			mov esi, 0
			OrderBegin:
			  cmp index, LENGTHOF key
			  je OrderEnd                    ;if it the last element, go to orderend
			  inc check
			  mov eax, index
			  mov indexNext, eax
			  inc indexNext
			  mov eax, keyPTR[esi]		;Still compares eax and ebx that have index values next to each other
			  mov edi, esi
			  add edi, TYPE DWORD
			  mov ebx, keyPTR[edi]		;added "add" instructions
			  cmp eax, ebx
			  ja OrderSwap                   ;if the order is illegal (letterA !< letterB) skip swap

			OrderNext:
			  add esi, TYPE DWORD		;edit
			  inc index
			  jmp OrderBegin

			OrderSwap:  		;Technicaly could be put above orderNext without the OrderSwap:, but its easier for me to read this way
			  mov eax, keyPTR[esi] 
			  mov ebx, keyPTR[edi]
			  mov keyPTR[esi], ebx
			  mov keyPTR[edi], eax
			  mov eax, keyOrderPTR[esi]
			  mov ebx, keyOrderPTR[edi]
			  mov keyOrderPTR[esi], ebx
			  mov keyOrderPTR[edi], eax

			  inc check                       ;check is incremented to show that there # number of swaps were done
			  jmp OrderNext

			OrderEnd:
    			mov ecx, offset check
				mov check, 0			;check is resetted first
				cmp ecx, 0				;if there were any swaps, the order is "checked" again by jumping back to OrderBegin
				jne OrderBegin 
      


		mov index, -1						;Starts at -1 for the first loop to have index = 0
		mov check, 0
		bufferPTRB PDWORD buffer
		;mov esi, bufferPTRB
		;mov indexNext, 0


		;mov edi, keyOrder

		mov esi, 0
		mov edi, 0
		De_Begin:
			inc index					;increase index by 1 for next L1 iteration
			cmp index, LENGTHOF keyOrder			;if (index > keyorderLength) then the current L2 will be invalid
			je De_End
			
			mov edi, keyOrderPTR[esi]
			mov eax, bufferPTRB[edi] 				;put the order value into a
			mov a, eax
			mov check, 0					;Set i to zero
	
		De_Dust2:
			mov eax,check
			mov ebx, LENGTHOF keyOrder
			mul ebx						;Mult eax by ebx into EDX:EAX
			mov esi, eax
			mov esi, edx					;Care multiplication instruction, look to higher up code
			mov eax, edi				;for replacement multiplication
			mov ebx, a
			add eax, ebx
			mov esi, eax
			mov eax, bufferPTRB[esi]	
			add result, eax
			inc check
			mov eax, LENGTHOF buffer	;top
			mov ecx, LENGTHOF keyOrder	;bottom edx = remainder
			div ecx
			inc indexResult
			cmp check, eax
			je De_Begin
			jmp De_Dust2
	
		De_End: ;just here to show its ended::empty
	
  								;look above for other reverse advice
			;Reverse
				mov eax, result
				mov resultPTR, eax
				mov ecx, 0
				mov esi, resultPTR
			reverse:
				mov index, LENGTHOF result
				mov eax, [esi + ecx]
				sub index, ecx
				mov ebx, [esi + index]
				mov [esi + ecx], ebx
				mov [esi + LENGTHOF result], eax
				inc ecx
				cmp ecx, LENGTHOF result
				jne copy_reverse
		

				;Opens fileanswer to get comparable string
				mov	edx,OFFSET fileanswer
				call	OpenInputFile
				mov	fileHandle,eax
	
				; Read the file into a buffer.
				mov	edx,OFFSET answer
				mov	ecx,BUFFER_SIZE
				call	ReadFromFile
				jnc	check_buffer_size			; error reading?
				mWrite "Error reading file. "		; yes: show error message
				call	WriteWindowsMsg
				jmp	close_file

				mov index, 0
				mov esi, result
				mov edi, answer
				
				Compare_result:
					mov eax, [esi + index]
					mov ebx, [edi + index]
					cmp eax,ebx
					jne Restart_point
					inc index
					cmp index, LENGTHOF answer
					je Compare_result

			;Writes result into file
		myWrite:
			mWrite "Enter an input filename: "
			;User inputs filename
			mov	edx,OFFSET filename
			mov	ecx,SIZEOF filename
			call	ReadString
		
			; Write the buffer to the output file.
		
			mov	eax,fileHandle
			mov	edx,OFFSET result
			mov	ecx,stringLength
			call	WriteToFile
			mov	bytesWritten,eax		; save return value
			call	CloseFile
	
	myQuit:
		INVOKE ExitProcess,0
	main ENDP
	END main
