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

	msgrep db "REPORTE","$"
	wordrep db "REP","$"
	bool_rep db 0d

	puntosJ1 dw 0d; deben ser tipo number
	puntosJ2 dw  0d
	;puntoTemp db 10 dup("$")

	nameJ1 db 50 dup("$")
	nameJ2 db 50 dup("$")
	bool_name db 0d

	tituloTab db "-- TABLERO DE JUEGO --","$"
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

	readTeclado db 50 dup("$")

	ruta db "reporte.htm",0
	handle dw 0
	atab db "<table border=1>"
	ctab db "</table>"
	atr db "<tr>"
	ctr db "</tr>"
	atd db "<td>"
	ctd db "</td>"
	saltoh db "<br>"
	
	celdaJ1 db "x"
	celdaJ2 db "o"
sdatos ends


scodigo segment 'CODE'
    
	ASSUME SS:spila, DS:sdatos, CS:scodigo         
	IMPRIMIR_NUMERO proc
		; AX -> parametro donde voy a poner el número a imprimir
		push dx
		push si
		push di
		push cx
		push bx

		mov cx, '$'
		push cx
		for1num:
			xor dx, dx
			mov bx, 10d
			div bx
			push dx
			cmp ax, 10
			jge for1num		
			cmp ax, 0
			je axEs0
		push ax

		axEs0:
		for2num:
			pop dx
			cmp dl, '$'
			je finFor2
			mov ah, 02h
			add dl, 30h
			int 21h
			jmp for2num
		finFor2:
		pop bx
		pop cx
		pop di
		pop si
		pop dx
		ret
	IMPRIMIR_NUMERO endp 
	
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
			;xor readTeclado, readTeclado
			limpiarEntrada readTeclado 
			;limpio la entrada para no afectar lo demas
			;y llenarla desde cero
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

			;aqui tambien verifico si ingresa REP
			;en readTeclado esta la entrada REP
		
			verificarREP  
			cmp bool_rep, 1d
			je generateReporte

		

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
			;xor readTeclado, readTeclado
			;mostrando nuevo tablero
			;showTablero
			limpiarEntrada readTeclado
			;limpio la entrada para no afectar lo demas
			;y llenarla desde cero
			MOSTRAR_TAB
			imprimir salto
			imprimir turnomsg 
			imprimir nameJ2
			imprimir salto
			imprimir entradamovi
			imprimir salto
			leerHastaEnter readTeclado

			;validar si se ingresa REP
			verificarREP  
			cmp bool_rep, 1d
			je generateReporte

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


		generateReporte:
			limpiarT
			imprimir salto
			imprimir msgrep
			imprimir salto

			openFile ruta

			writeFile handle, 16, atab ;apertura table
			
			writeFile handle, 7, msgrep
			writeFile handle, 4, saltoh
			writeFile handle, 11, shownameJ1
			;lectura del nameJ1 caracter por caracter 
			wnameFile nameJ1
			writeFile handle, 1, lineas[1]

			writeFile handle, 1, espacio[0]
			add puntosJ1, 30h
			writeFile handle, 1, puntosJ1
			writeFile handle, 7, puntos

			writeFile handle, 4, saltoh
			writeFile handle, 11, shownameJ2
			;lectura del nameJ2 caracter por caracter 
			wnameFile nameJ2
			writeFile handle, 1, lineas[1]
			writeFile handle, 1, espacio[0]
			add puntosJ2, 30h
			writeFile handle, 1, puntosJ2

			writeFile handle, 7, puntos

			writeFile handle, 4, saltoh
			writeFile handle, 4, saltoh
			writeFile handle, 22, tituloTab
			writeFile handle, 4, saltoh
			tableroFile
			; atr y ctr para filas
			; atd y ctd para columnas

			; writeFile handle, 4, atr
			; writeFile handle, 4, atd
			; writeFile handle, 1, celdaJ1
			; writeFile handle, 5, ctd
			; writeFile handle, 4, atd
			; writeFile handle, 1, celdaJ1
			; writeFile handle, 5, ctd
			; writeFile handle, 4, atd
			; writeFile handle, 1, celdaJ2
			; writeFile handle, 5, ctd
			; writeFile handle, 5, ctr

			; writeFile handle, 4, atr
			; writeFile handle, 4, atd
			; writeFile handle, 1, celdaJ1
			; writeFile handle, 5, ctd
			; writeFile handle, 4, atd
			; writeFile handle, 1, celdaJ2
			; writeFile handle, 5, ctd
			; writeFile handle, 5, ctr

			writeFile handle, 8, ctab ;cerrando table
		

			

			closeFile handle

			jmp opcion3

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
    