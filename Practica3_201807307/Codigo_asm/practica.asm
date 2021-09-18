include macros.asm
spila segment stack
	DB 32 DUP ('stack___')
spila ends

sdatos segment 

	welcome db "PRACTICA #3 - 201807307","$"
	salto db 0ah, "$"
	msg1 db "Escoja una opcion: ",0DH, 0AH, "$"
	msg2 db "1. Jugar", 0DH, 0AH, "$"
	msg3 db "2. Crear jugadores",0DH, 0AH, "$"
	msg4 db "3. Salir", 0DH, 0AH, "$"

	msgo1 db "JUGANDO",0DH, 0AH,"$"
	msgo2 db "CREANDO JUGADORES",0DH, 0AH, "$"
	msgo3 db "ADIOS... ",0DH, 0AH,"$"

	msgu1 db "Ingrese nombre de jugador 1: ", "$"
	msgu2 db "Ingrese nombre de jugador 2: ", "$"
	namesJ db "--- Jugadores ---", 0DH, 0AH, "$"
	errorJ db "Error. Se debe crear jugadores primero "

	shownameJ1 db "Jugador 1: ", "$"
	shownameJ2 db "Jugador 2: ", "$"

	nameJ1 db 50 dup("$")
	nameJ2 db 50 dup("$")
	bool_name db 0

sdatos ends


scodigo segment 'CODE'
    
	ASSUME SS:spila, DS:sdatos, CS:scodigo         
	
	
	main proc far 
	    
	    push ds
		mov si, 0
		push si
		mov ax, sdatos
		mov ds,ax
		mov es,ax 
		;limpiarT

		show_menu:
		; IMPRIMIENDO DATOS DE MENU PRINCIPAL
		imprimir welcome
		imprimir salto
		imprimir msg1
		imprimir msg2
		imprimir msg3
		imprimir msg4
		
		
		mov ah, 01h ;leyendo entrada de opciones 
		int 21h

		cmp al, 31h
		je opcion1
		cmp al, 32h
		je opcion2
		cmp al, 33h
		je opcion3

		jmp show_menu

		opcion1:
			

			; verificando si ya se crearon jugadores 
			cmp bool_name, 1
			je playgame ; si ya fueron creados salta al juego
			;sino imprime el aviso y direcciona a la creacion de jugadores
			imprimir salto
			imprimir errorJ
			imprimir salto
			jmp opcion2

			playgame:
				imprimir salto
				imprimir msgo1
				imprimir salto
				;guardado de nombres
			
				imprimir namesJ
				imprimir shownameJ1
				imprimir nameJ1
				imprimir salto
				imprimir shownameJ2
				imprimir nameJ2
				imprimir salto

			jmp show_menu
		opcion2:
			imprimir salto
			imprimir msgo2
			imprimir salto


			;pidiendo nombre de jugador 1
			imprimir msgu1
			imprimir salto
			readjugador nameJ1
			imprimir salto
			

			;pidiendo nombre de jugador 2
			imprimir msgu2
			imprimir salto
			readjugador nameJ2
			imprimir salto

			;activo banderas de usuarios creados
			mov bool_name, 1

			

		
		

			jmp opcion1
		opcion3:
			imprimir salto
			imprimir msgo3
			imprimir salto
			
			
			
			

			



		;imprimir entradaTeclado
		
        
		ret
    main endp
	
scodigo ends


end main
    