; Final Term Project part 2

INCLUDE Irvine32.inc
INCLUDE macros.inc
;.386
;.model flat,stdcall
;.stack 4096
;ExitProcess proto,dwExitCode:dword

; Creating a File					(CreateFile.asm)

; Inputs text from the user, writes the text to an output file. 

.data
BUFFER_SIZE = 501
buffer BYTE BUFFER_SIZE DUP(?)
filename    BYTE 80 DUP(0)
fileHandle   HANDLE ?
stringLength DWORD ?
bytesWritten DWORD ?
str1 BYTE "Cannot create file",0dh,0ah,0
str2 BYTE "Bytes written to file: ",0
str3 BYTE "Enter up to 500 characters and press "
     BYTE "[Enter]: ",0dh,0ah,0


.code
myCreateFile PROC
; Create a new text file.
	mWrite "Enter an input filename: "
	mov	edx,OFFSET filename
	mov	ecx,SIZEOF filename
	call	ReadString

	call	CreateOutputFile
	mov	fileHandle,eax

; Check for errors.
	cmp	eax, INVALID_HANDLE_VALUE	; error found?
	jne	file_ok					; no: skip
	mov	edx,OFFSET str1			; display error
	call	WriteString
;	jmp	myQuit
file_ok:

; Ask the user to input a string.
	mov	edx,OFFSET str3		; "Enter up to ...."
	call	WriteString
	mov	ecx,BUFFER_SIZE		; Input a string
	mov	edx,OFFSET buffer
	call	ReadString
	mov	stringLength,eax		; counts chars entered

; Write the buffer to the output file.
	mov	eax,fileHandle
	mov	edx,OFFSET buffer
	mov	ecx,stringLength
	call	WriteToFile
	mov	bytesWritten,eax		; save return value
	;call	CloseFile
	
; Display the return value.
	mov	edx,OFFSET str2		; "Bytes written"
	call	WriteString
	mov	eax,bytesWritten
	call	WriteDec
	call	Crlf

;myQuit:
	;Exit
myCreateFile ENDP
END myCreateFile

myReadFile PROC

; Let user input a filename.
	mWrite "Enter an input filename: "
	mov	edx,OFFSET filename
	mov	ecx,SIZEOF filename
	call	ReadString

; Open the file for input.
	mov	edx,OFFSET filename
	call	OpenInputFile
	mov	fileHandle,eax

; Check for errors.
	cmp	eax,INVALID_HANDLE_VALUE		; error opening file?
	jne	file_ok					; no: skip
	mWrite <"Cannot open file",0dh,0ah>
;	jmp	myQuit						; and quit
file_ok:

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
;	jmp	myQuit						; and quit
	
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
	
;	myQuit:
;		mWrite "myCreateFile end"
;		ret
myReadFile ENDP
END myReadFile

main PROC
call myCreateFile
call myReadFile


main ENDP
END main

