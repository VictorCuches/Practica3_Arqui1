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

	
	msgo2 db "CREANDO JUGADORES",0DH, 0AH, "$"
	msgo3 db "ADIOS... ",0DH, 0AH,"$"

	msgu1 db "Ingrese nombre de jugador 1: ", "$"
	msgu2 db "Ingrese nombre de jugador 2: ", "$"
	namesJ db "----- Jugadores -----", 0DH, 0AH, "$"
	errorJ db "Error. Se debe crear jugadores primero ", "$"
	pauseEnter db 50 dup("$"), "$"

	shownameJ1 db "Jugador 1: ", "$"
	shownameJ2 db "Jugador 2: ", "$"
	fichaInfo1 db "Ficha verde ","$"
	fichaInfo2 db "Ficha roja ","$"
	puntos db " puntos","$"

	turnomsg db "Turno de: ","$"
	entradamovi db "Ingrese movimiento de fichas: ","$"

	puntosJ1 db "1$" ; deben ser tipo number
	puntosJ2 db "2$"

	nameJ1 db 50 dup("$")
	nameJ2 db 50 dup("$")
	bool_name db 0

	tituloTab db "----- TABLERO DE JUEGO -----","$"
	moverror db "Movimiento incorrecto ",0DH, 0AH,"$"
	noficha db "Error. No se encuentra ficha a mover","$"
	cabecerasC db "ABCDEFGH$"
	cabecerasF db "12345678$"
	lineas db "|-$"
	individual db " $"
	espacio db " $"
	linver db "|$"
	color db 0

	iteradorI dw 0
	iteradorJ dw 0
	iteradorK dw 0

	oldF db 0d
	oldC db 1d
	newF db 3d
	newC db 4d

	indice dw 0
	fila dw 0
	columna dw 0

	tablero db 1,0,1,0,1,0,1,0
			db 0,1,0,1,0,1,0,1
			db 1,0,1,0,1,0,1,0
			db 0,0,0,0,0,0,0,0
			db 0,0,0,0,0,0,0,0
			db 0,2,0,2,0,2,0,2
			db 2,0,2,0,2,0,2,0
			db 0,2,0,2,0,2,0,2 ,"$"

	readTeclado db 50 dup("$"), "$"
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
			
				

				limpiarT
				

				
			
			;jmp show_menu
			
		
		juegoDamas:
			;showTablero ;mostrando tablero
			MOSTRAR_TAB
			imprimir salto
			imprimir turnomsg 
			imprimir nameJ1
			imprimir salto 
			imprimir entradamovi
			imprimir salto
			leerHastaEnter readTeclado
			;como la entrada en completa -> C2:D5
			;leo de una vez todo y lo envio a sus diferntes lecturas de fila y columna

			;imprimir readTeclado[2]
			filaTablero 1d
			columnaTablero 0d
			posFicha fila, columna 
			; posicion inicial de ficha
			mov di, indice
			;mov al, " "
			;cmp tablero[di], 1d
			;jnz posvacia
			mov tablero[di], 0d ;vaciando celda

			;colocando ficha en posicion nueva
			mov fila, 0d
			mov columna, 0d
			mov indice, 0d

			filaTablero 4d
			columnaTablero 3d
			posFicha fila, columna
			mov di, indice
			mov tablero[di], 1d

			;aqui deben ir validaciones 


			limpiarT
			jmp nexTurn

		nexTurn: ;Turno del jugador 2
			;mostrando nuevo tablero
			;showTablero
			MOSTRAR_TAB
			imprimir salto
			imprimir turnomsg 
			imprimir nameJ2
			imprimir salto
			imprimir entradamovi
			imprimir salto
			leerHastaEnter readTeclado

			;entrada de jugador 2 
			;su num es el "2" / las fichas de abajo
			
			;ficha a mover
			mov fila, 0d
			mov columna, 0d
			mov indice, 0d
			filaTablero 1d
			columnaTablero 0d
			posFicha fila, columna 
			; posicion inicial de ficha
			mov di, indice
			;mov al, " "
			;cmp tablero[di], 1d
			;jnz posvacia
			mov tablero[di], 0d ;vaciando celda
			;colocando ficha en posicion nueva
			mov fila, 0d
			mov columna, 0d
			mov indice, 0d

			filaTablero 4d
			columnaTablero 3d
			posFicha fila, columna
			mov di, indice
			mov tablero[di], 2d

			;aqui deben ir validaciones 
			

			limpiarT

			;salto a esta parte porque quiero mostrar el tablero
			;con los nombres y punteos actuales
			jmp juegoDamas 



		posvacia:
			imprimir salto
			imprimir noficha
			imprimir salto
			imprimir salto
			jmp juegoDamas
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

			

		
			limpiarT

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
    