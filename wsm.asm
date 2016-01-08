#make_bin#

#LOAD_SEGMENT=FFFFh#
#LOAD_OFFSET=0000h#

#CS=0000h#
#IP=0000h#

#DS=0000h#
#ES=0000h#

#SS=0000h#
#SP=FFFEh#

#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h#

; add your code here
         jmp     st1 
         db     509 dup(0)

;IVT entry for 80H
         
         dw     t_isr
         dw     0000
         db     508 dup(0)
;main program
          
st1:      cli 
; intialize ds, es,ss to start of RAM
          mov       ax,0200h
          mov       ds,ax
          mov       es,ax
          mov       ss,ax
          mov       sp,0FFFEH
;intialise portb as input &portc as output
          mov       al,82h
		  out 		06h,al 
;timer - 1 second - 8253 clock is 10 KHz-divide by 10,000d
		  mov       al,00110110b
		  out       0Eh,al
		  mov       al,10h
		  out       08h,al
		  mov       al,27h
		  out       08h,al
;8259 intialize - vector no. 80h, edge triggered
;8259 -	enable IRO alone use AEOI	  
		  mov       al,00010011b
		  out       10h,al
		  mov       al,80h
		  out       12h,al
		  mov       al,03h
		  out       12h,al
		  mov       al,0FEh
		  out       12h,al
		  sti
;check swich input and display switch no.		  		    
		  in        al,02h
          cmp       al,0
          mov       bh,0
          jz        x3
          mov       cx,08   
          mov       bh,01
          mov       bl,01
x2:       cmp       al,bl
          jz        x3
          inc       bh
          rol       bl,1
          loop      x2  
x3:       mov       al,bh
          out       04h,al
;loop till isr
x1:       jmp       x1
;isr for 1 sec
;check switch input and display switch no.
t_isr:    in        al,02h
          cmp       al,0
          mov       bh,0
          jz        x5
          mov       cx,08   
          mov       bh,01
          mov       bl,01
x4:       cmp       al,bl
          jz        x5
          inc       bh
          rol       bl,1
          loop      x4  
x5:       mov       al,bh
          out       04h,al 
          iret
          
          
