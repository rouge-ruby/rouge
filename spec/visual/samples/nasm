;Simple test of NASM parser

SECTION .data		; Data section, initialized variables

fmt:    db "a=%d, eax=%d", 10, 0 ; The printf format, "\n",'0'
a:	dd	5		; int a=5;

%macro IRQ 2
    global irq%1
    irq%1:
        cli
        push byte 0     ; push a dummy error code
        push byte %2    ; push the IRQ number
        jmp  irq_common_stub
%endmacro

extern	printf		; the C function, to be called

SECTION .text		; Code section.

global main		; the standard gcc entry point

main:
	push    ebp
	mov     ebp,esp
	mov	eax, [a]
	add	eax, 2
	push	'a'
	push    dword [a]	; value of variable a
	push    dword fmt	; address of ctrl string
	call    printf		; Call C function
	add     esp, 12
	mov     esp, ebp	; takedown stack frame
	pop     ebp
	mov	eax,0		;  normal, no error, return value
	ret			; return

irq_common_stub:
	pusha           ; Pushes edi,esi,ebp,esp,ebx,edx,ecx,eax
	mov ax, ds      ; Lower 16-bits of eax = ds.
	mov ax, 0x10    ; load the kernel data segment descriptor
	mov ds, ax
	popa           ; Pops edi,esi,ebp,esp,ebx,edx,ecx,eax
	add esp, 8     ; Cleans up the pushed error code and pushed irq number
	sti            ; (re)Enable interrupts "set interrupt flag"
	iret           ; pops CS, EIP, EFLAGS, SS, and ESP

%assign i 0
%rep 16
IRQ i, i+32
%assign i i+1
%endrep
