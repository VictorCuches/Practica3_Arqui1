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
	msg_noficha db "Seleccione la ficha correcta ", "$"
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
	repeatmov db "Repita el movimiento...",0DH, 0AH,"$"
	noficha db "Error. No se encuentra ficha a mover","$"
	cabecerasC db "ABCDEFGH$"
	cabecerasF db "12345678$"
	lineas db "|-$"
	individual db " $"
	espacio db " $"
	linver db "|$"
	color db 0
	bool_error db 0

	comeria db "izquierda-abajo","$"
	comerda db "derecha-abajo","$"

	comeriaa db "izquierda-arriba","$"
	comerdaa db "derecha-arriba","$"

	iteradorI dw 0
	iteradorJ dw 0
	iteradorK dw 0

	oldF db 0d
	oldC db 1d
	newF db 3d
	newC db 4d

	indice dw 0
	oldIndice dw 0
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
	celdaJ1R db "X'"
	celdaJ2R db "O'"
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
			mov oldIndice, 0d
			mov indice, 0d
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
			; cmp bool_error, 1d
			; je juegoDamas
			
			columnaTablero 0d
			; cmp bool_error, 1d
			; je juegoDamas

			posFicha fila, columna 
			; posicion inicial de ficha
			mov di, indice
			;mov bx, indice
			mov oldIndice, di ;guardadndo el indice inicial 
			;mov al, " "
			;cmp tablero[di], 1d
			;jnz posvacia
			
			
			;validacion para no poder seleccionar las fichas del oponente
			cmp tablero[di], 2d
			je nofichaju
			cmp tablero[di], 0d
			je nofichaju
			; cmp tablero[si], 1d
			jmp continuarturnou
			nofichaju: ;mensaje de error e intenta ingresar movimiento
				imprimir salto
				imprimir msg_noficha
				imprimir salto
				leerHastaEnter pauseEnter
				jmp juegoDamas

			continuarturnou:


				; sin restriccion de movimiento para reinas
				xor si, si
				mov si, oldIndice			 
				cmp tablero[si], 3d
				je movreinau
				jmp noreinau

				movreinau: 
					mov tablero[di], 0d
					mov fila, 0d
					mov columna, 0d
					mov indice, 0d

					filaTablero 4d
					columnaTablero 3d
					posFicha fila, columna
					mov di, indice
					mov tablero[di], 3d
					;aqui irian las validaciones para comer fichas del rival
					jmp nexTurn

				noreinau:
					mov tablero[di], 0d ;vaciando celda --------------------------------------

					
					;colocando ficha en posicion nueva
					mov fila, 0d
					mov columna, 0d
					mov indice, 0d

					filaTablero 4d
					columnaTablero 3d
					posFicha fila, columna
					mov di, indice
					mov tablero[di], 1d ; llenando la celda ----------------------------------------

					;aqui deben ir validaciones 

					;validacion para comer ficha del rival
					mov ax, indice
					sub ax, oldIndice

					cmp ax, 14d
					je comeruno ;diagonal izquierda-abajo

					mov ax, indice
					sub ax, oldIndice
					cmp ax, 18d
					je comerdos ;diagonal derecha-abajo

					
					;validacion para no moverse al frente
					xor ax, ax
					mov ax, oldIndice
					add ax, 8d
					cmp indice, ax
					je moverrorjuno

					
					

					;validacion para no moverse hacia atras
					mov ax, indice
					cmp ax, oldIndice
					jb moverrorjuno

					;validacion para coronarse
					xor ax, ax
					mov ax, indice
					cmp indice, 56d
					jae coronarJ1

					
				
					jmp nexTurn
		
		coronarJ1: 
			xor di, di
		 	mov di, indice
			mov tablero[di], 3d
			jmp nexTurn
		comeruno:
			xor ax, ax
			xor si, si
			; imprimir salto
			; imprimir comeria
			; imprimir salto

			mov ax, oldIndice
			add ax, 7d
			mov si, ax
			cmp tablero[si], 2d
			je eliminarficha
			
			jmp moverrorjuno
			eliminarficha:
				mov tablero[si], 0d
				inc puntosJ1
				jmp nexTurn
				
			;jmp opcion3
			
		comerdos: 

			xor ax, ax
			xor si, si
			
			mov ax, oldIndice
			add ax, 9d
			mov si, ax
			cmp tablero[si], 2d
			je eliminarficha2
			
			jmp moverrorjuno
			eliminarficha2:
				mov tablero[si], 0d
				inc puntosJ1
				jmp nexTurn
			;jmp nexTurn

		moverrorjuno:
			xor si, si
			xor di, di
			mov si, oldIndice
			mov tablero[si], 1d
			mov di, indice
			mov tablero[di], 0d

			imprimir moverror
			imprimir repeatmov
			leerHastaEnter pauseEnter

			
			jmp juegoDamas

		nexTurn: ;Turno del jugador 2
			mov oldIndice, 0d
			mov indice, 0d
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
			mov oldIndice, di ;guardadndo el indice inicial 
			;mov al, " "
			;cmp tablero[di], 1d
			;jnz posvacia

			;validar que no mueva fichas del rival
		
			cmp tablero[di], 1d
			je nofichajd
			cmp tablero[di], 0d
			je nofichajd
			
			jmp continuarturnod
			nofichajd: ;mensaje de error e intenta ingresar movimiento
				imprimir salto
				imprimir msg_noficha
				imprimir salto
				leerHastaEnter pauseEnter
				jmp juegoDamas

			continuarturnod:
				; sin restriccion de movimiento para reinas
				xor si, si
				mov si, oldIndice			 
				cmp tablero[si], 4d
				je movreinad
				jmp noreinad
				movreinad: 
					mov tablero[di], 0d
					mov fila, 0d
					mov columna, 0d
					mov indice, 0d

					filaTablero 4d
					columnaTablero 3d
					posFicha fila, columna
					mov di, indice
					mov tablero[di], 4d
					;aqui irian las validaciones para comer fichas del rival
					jmp juegoDamas

				noreinad:

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
				;validacion para comer ficha del rival
				mov ax, oldIndice
				sub ax, indice

				cmp ax, 18d

				je comerunod ;diagonal izquierda-arriba

				mov ax, oldIndice
				sub ax, indice
				cmp ax, 14d
				je comerdosd ;diagonal derecha-arriba

				;validacion para no mover al frente
				xor ax, ax
				mov ax, oldIndice
				sub ax, 8d

				cmp indice, ax
				je moverrorjdos

				;sin restriccion de movimiento diagonal para reinas
				; mov di, oldIndice
				; mov al, tablero[di]
				; cmp al, 4d
				; je juegoDamas

				;validacion para no moverse hacia atras
				mov ax, indice
				cmp ax, oldIndice
				ja moverrorjdos

				;validacion para coronarse
				xor ax, ax
				mov ax, indice
				cmp indice, 7d
				jbe coronarJ2
				

				;salto a esta parte porque quiero mostrar el tablero
				;con los nombres y punteos actuales
				jmp juegoDamas 

		coronarJ2:
			mov di, indice
			mov tablero[di], 4d
			jmp juegoDamas
		comerunod: ; izquierda-arriba
			xor ax, ax
			xor si, si
			mov ax, oldIndice
			sub ax, 9d
			mov si, ax

			cmp tablero[si], 1d
			je eliminarfichau
			jmp moverrorjdos
			eliminarfichau: 
				mov tablero[si],0d
				inc puntosJ2
				jmp juegoDamas
			
		comerdosd: ;derecha-arriba
			xor ax, ax
			xor si, si
			mov ax, oldIndice
			sub ax, 7d
			mov si, ax

			cmp tablero[si], 1d
			je eliminarfichaud
			jmp moverrorjdos
			eliminarfichaud: 
				mov tablero[si], 0d
				inc puntosJ2
				jmp juegoDamas

		moverrorjdos:
			xor si, si
			xor di, di
			mov si, oldIndice
			mov tablero[si], 2d
			mov di, indice
			mov tablero[di], 0d

			imprimir moverror
			imprimir repeatmov
			leerHastaEnter pauseEnter

			
			jmp nexTurn

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
    