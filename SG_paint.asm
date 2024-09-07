;the question was:
;to add this question: are you... 1. student ,2. teacher, 3.segev and to say hi 
;I had a problem when I used BP in the pixel proc so I wrote a new proc that uses BP and it actually 'syso' in java
;The name of the proc is writ (lines 162-175)
;every time I needed to write something I use it (for example lines 375-434 used to call the proc write and to ask the question you asked me to do) 
;lines 162-175 for the write proc and lines 383-434 for the question.
;Segev Shalom project - SG_paint
IDEAL
MODEL small
STACK 100h
DATASEG
color db 0
x dw 0
y dw 0 
width dw 1
note  dw 2394h ;1193180 / 131 -> (hex) 
startM db '     <= The color now',13,10,'$'
startG db 'press any key to start', 13, 10,'$'
endT db '         type "exit" to close the DOSBOX window else to start a new paint     ----------------          Thanks',13,10,'$'
filename db 'start.bmp',0
filehandle dw ?
Header db 54 dup (0)
Palette db 256*4 dup (0)
ScrLine db 320 dup (0)
ErrorMsg db 'Error', 13, 10,'$'
temp db 0
q db '     you are...',13,10,'$'
one db '1.student',13,10,'$'
two db '2.teacher     ',13,10,'$'
three db '3.segev     ',13,10,'$'
he1 db '1.hi student     ',13,10,'$'
he2 db '2.hi teacher     ',13,10,'$'
he3 db '3.hi segev     ',13,10,'$'
line db ' ',13,10,'$'


CODESEG

proc OpenFile
; Open file
mov ah, 3Dh
xor al, al
mov dx, offset filename
int 21h
jc openerror
mov [filehandle], ax
ret
openerror:
mov dx, offset ErrorMsg
mov ah, 9h
int 21h
ret
endp OpenFile

proc ReadHeader
; Read BMP file header, 54 bytes
mov ah,3fh
mov bx, [filehandle]
mov cx,54
mov dx,offset Header
int 21h
ret
endp ReadHeader

proc ReadPalette
; Read BMP file color palette, 256 colors * 4 bytes (400h)
mov ah,3fh
mov cx,400h
mov dx,offset Palette
int 21h
ret
endp ReadPalette

proc CopyPal
; Copy the colors palette to the video memory
; The number of the first color should be sent to port 3C8h
; The palette is sent to port 3C9h
mov si,offset Palette
mov cx,256
mov dx,3C8h
mov al,0
; Copy starting color to port 3C8h
out dx,al
; Copy palette itself to port 3C9h
inc dx
PalLoop:
; Note: Colors in a BMP file are saved as BGR values rather than RGB.
mov al,[si+2] ; Get red value.
shr al,2 ; Max. is 255, but video palette maximal
; value is 63. Therefore dividing by 4.
out dx,al ; Send it.
mov al,[si+1] ; Get green value.
shr al,2
out dx,al ; Send it.
mov al,[si] ; Get blue value.
shr al,2
out dx,al ; Send it.
add si,4 ; Point to next color.
; (There is 
loop PalLoop
ret
endp CopyPal

proc CopyBitmap
; BMP graphics are saved upside-down.
; Read the graphic line by line (200 lines in VGA format),
; displaying the lines from bottom to top.
mov ax, 0A000h
mov es, ax
mov cx,200
PrintBMPLoop:
push cx
; di = cx*320, point to the correct screen line
mov di,cx
shl cx,6
shl di,8
add di,cx
; Read one line
mov ah,3fh
mov cx,320
mov dx,offset ScrLine
int 21h
; Copy one line into video memory
cld ; Clear direction flag, for movsb
mov cx,320
mov si,offset ScrLine


rep movsb ; Copy line to the screen
 ;rep movsb is same as the following code:
 ;mov es:di, ds:si
 ;inc si
 ;inc di
 ;dec cx
 ;loop until cx=0
pop cx
loop PrintBMPLoop
ret
endp CopyBitmap

; Process BMP file
proc ProcessBMPFile

push ax
push bx 
push cx
push dx 
call OpenFile
call ReadHeader
call ReadPalette
call CopyPal
call CopyBitmap
pop dx 
pop cx 
pop bx 
pop ax 
ret

endp  ProcessBMPFile

; this proc is just to use BP (by the way it is syso)
proc write
push ax
push dx
push bp 

mov bp, sp
mov dx,[bp + 2]
 mov ah, 9h 
 int 21h 

pop bp
pop dx
pop ax 
endp write
; paints a pixel
proc pixle


push ax
push bx 
push cx
push dx

    mov bh,0h 
	mov cx, [x]
	mov dx, [y]
	mov al, [color]
	mov ah,0ch
	int 10h  
   
pop dx
pop cx

pop bx

pop ax



ret 
endp pixle
 
; paints a row
proc shora


push ax
push bx
push cx
push dx
push [x]
mov cx , [width]
theLoop:


call pixle

add [x], 1

loop theLoop
pop [x]
pop dx
pop cx
pop bx
pop ax

ret
endp shora

;paints a square
proc reboa


push ax
push bx
push cx
push dx
push [y]
mov cx , [width]
theLoopForTheReboa:
call shora
add [y],1

loop theLoopForTheReboa
pop [y]
pop dx
pop cx
pop bx
pop ax

ret
endp reboa
; paints the preview of the color
proc preView
push [width]
mov [width],20
call reboa
pop [width]
endp preView



proc paint
push ax
push bx 
push cx 
push dx
push [y]
push [x]
push [width]
;Paint near mouse location

shr cx,1 ; adjust cx to range 0-319, to fit screen
sub dx,[width] ; move one pixel, so the pixel will not be hidden by mouse
mov bh,0h
mov al,[color]
;-----------
mov [y],dx
mov [x],cx
call reboa
;-----------
pop [width]
pop [x]
pop [y]
pop dx
pop cx
pop bx
pop ax

ret
endp paint


;makes a sound if the user press y it deletes all the paint else no 
proc areYouSure
push ax

; open speaker 
in al, 61h    
or al, 00000011b  
out 61h, al    
; send control word to change frequency 
mov al, 0B6h 
out 43h, al 
; play frequency 131Hz 
mov ax, [note] 
out 42h, al ; Sending lower byte  
mov al, ah 
out 42h, al  ; Sending upper byte 


;waits for answer
mov ah, 0
int 16h 
  
  
cmp al ,'y'
je delete 
;close the speaker 
  
in al, 61h    
and al, 11111100b  
out 61h, al 
pop dx
 
ret
 
 
delete:
push ax
; close the speaker 
in al, 61h    
and al, 11111100b  
out 61h, al 

mov [color], 0
push [width]
mov [width],320
mov ax,0h; makes the muse Invisible because it cant paint pixels that the muse above them
int 33h
call reboa
mov ax,1h
int 33h
pop [width] 
pop ax
pop dx
;to know if the user chose del 
mov [temp],1

 ret
endp areYouSure


start:
mov ax,@data
mov ds,ax


; Graphics mode
mov ax,13h
int 10h

; Process BMP file
call  ProcessBMPFile

; Wait for key press
mov ah,1
int 21h

;TextMode:
mov ax,3h
int 10h

;prints the message with the write proc (with bp)
mov dx ,offset startG
push dx
call write
 ;------------------------
 ; Wait for key press
mov ah,1
int 21h
;prints the message
mov dx ,offset q
push dx
call write
;prints the message
mov dx ,offset one
push dx
call write
 ;prints the message
mov dx ,offset two
push dx
call write
 ;prints the message
mov dx ,offset three
push dx
call write
; Wait for key press
push ax
mov ah,1
int 21h
;prints line 
mov dx ,offset line
push dx
call write

cmp al,'1'
je student
cmp al,'2'
je teacher
cmp al,'3'
je segev
jmp s
pop ax
student:
;prints the message
mov dx ,offset he1
push dx
call write
 jmp h
 teacher:
mov dx ,offset he2
push dx
call write
jmp h 
segev:
mov dx ,offset he3
push dx
call write
 jmp h
 h:
 s:
 ;------------------------
 ;prints the message
mov dx ,offset startG
push dx
call write
 
; Wait for key press
mov ah,1
int 21h
help3:
   
; Graphics mode
mov ax,13h
int 10h

;Initializes the mouse
mov ax,0h
int 33h
;Show mouse
mov ax,1h
int 33h
;the message
mov dx ,offset startM
push dx
call write
;====================================
loopTheGame:

;show the current color at the up-left corner of the screen
call preView
;AL=0 : NO KEY PRESSED, AL!=0 : KEY PRESSED
mov ah, 0bh
int 21h      
cmp al, 0
je  MouseLP
;PROCESS KEY.        
mov ah, 0
int 16h 
   
cmp al,'b'
je swichToBlue
  
cmp al,'r'
je swichToRed
  
cmp al,'g'
je swichToGreen
  
cmp al,'d'
je help

cmp al,'w'
je swichToWhite

cmp al,'k'
je swichToBlack

cmp al,'1'
je X1

cmp al,'2'
je X2

cmp al,'3'
je X3

cmp al,'4'
je X4

cmp al,'5'
je X5


cmp al ,'e'
je TextMode
MouseLP:

mov ax,3h
int 33h

cmp bx,1h ; check left mouse click

jne MouseLP

call paint

jmp loopTheGame
;just help============
help2:
jmp help3
;===============  

X1:

mov [width],1
jmp loopTheGame

X2:
mov [width],2
jmp loopTheGame

X3:
mov [width],4
jmp loopTheGame

X4:
mov [width],6
jmp loopTheGame

X5:

mov [width],10

jmp loopTheGame
  
  
  


swichToBlue:
mov [color],1
  
jmp loopTheGame

helpForLoopTheGame:
jmp loopTheGame

help: 
jmp dellAllBlack

help1:
jmp help2

swichToRed:
mov [color],12
  
  jmp loopTheGame

  swichToGreen:
  mov [color],3
  jmp loopTheGame
  
  swichToBlack:
  mov [color],0
jmp loopTheGame

swichToWhite:
mov [color],31
jmp loopTheGame 

  dellAllBlack:
 call areYouSure
 cmp [temp],1;if it =1 it means that are you sure chose 'y' 
mov [temp],0
je help2
 
  jmp loopTheGame
  




  ; Text mode
TextMode:
mov ax,3h
int 10h

mov dx ,offset endT
push dx
call write
 ; Wait for key press
mov ah,1
int 21h
mov [color],0
cmp al,'e'
jne help1 

mov ah,1
int 21h
cmp al,'x'
jne help1 

mov ah,1
int 21h
cmp al,'i'
jne jumpHelp2 

mov ah,1
int 21h
cmp al,'t'
jne jumpHelp2
jmp exit

jumpHelp2:
jmp help2 


exit:
mov ax,4C00h
int 21h
END start