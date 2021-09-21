imprimir macro cadena, color
    
    mov dx, offset cadena
	mov ah, 09
	int 21h

endm

leerHastaEnter macro entrada
    local salto, fin
    xor bx, bx ;limpiar registros
    salto: 
        mov ah, 01h
        int 21h ;leer 
        cmp al, 0dh ;entrada == \n
        je fin
        mov entrada[bx], al 
        inc bx
        jmp salto

    fin: 

endm

limpiarT macro ;clear
    mov ah, 0Fh

    INT 10h
    mov ah, 0
    
    INT 10h
endm

readjugador macro entrada
    local ciclo
    mov si, offset entrada		
		ciclo:
			mov ah, 01
			int 21h
			;en "al" esta la letra
			mov [si], al
			inc si
			cmp al, 13d ;salto de linea
			jne ciclo
endm

showTablero macro
    local ciclo, ciclo2, ciclo3, ciclo4, reinicio, reinicio2
    
    imprimir espacio
    imprimir espacio
    imprimir espacio
    xor si, si ; limpiando si

    ciclo: 
        mov bl, cabecerasC[si] ;ABCDE...
        mov individual[0], bl
        imprimir individual
        imprimir espacio
        imprimir espacio
        imprimir espacio

        inc si 
        cmp si, 8d ; numero de columnas 
        jnz ciclo
    imprimir salto
    xor si, si
    mov iteradorJ, 0d
    ciclo2:
        mov bl, cabecerasF[si]
        mov individual[0], bl
        imprimir individual
        imprimir espacio
     
        imprimir linver

        mov iteradorI, 0d

        ciclo3: 
            mov di, iteradorJ
            verificarValor tablero[di]
           
            inc iteradorJ
            ;imprimir individual
            imprimirficha individual

            inc iteradorI
            cmp iteradorI, 8d
            jz reinicio

            imprimir espacio
            mov bl, lineas[0]
            mov individual[0], bl
            imprimir individual
            imprimir espacio
            jmp ciclo3

        reinicio: 
            ; linea divisoria entre filas
            imprimir espacio
            imprimir linver
            cmp si, 7d
            jz reinicio2
            mov iteradorI, 0d
            imprimir salto
            imprimir espacio
            imprimir espacio

            ciclo4:
                mov bl, lineas[1]
                mov individual[0], bl
                imprimir individual
                inc iteradorI
                cmp iteradorI, 32d
                jnz ciclo4
            
        reinicio2:
            imprimir salto
            inc si
            cmp si, 8d
            jnz ciclo2






endm

verificarValor macro valor
    local cero, uno, dos, fin

    cmp valor, 0d
    jz cero

    cmp valor, 1d
    jz uno

    dos: 
        mov color, 04d
        mov individual[0], 02
        jmp fin

    uno: 
        mov color, 11d
        mov individual[0], 01
        jmp fin

    cero: 
        mov color, 0d
        mov individual[0], " "
        jmp fin

    fin:

endm

imprimirficha macro cadena
    ;mov ax, @data 
    ;mov ds, ax

    mov ah, 09h
    mov bl, color
    mov cx, lengthof cadena - 1
    int 10h ;color
    lea dx, cadena
    int 21h ;print

endm

posFicha macro row, column
    mov ax, row
    mov bx, 8d
    mul bx
    add ax, column
    mov indice, ax
    ;usando posicion[i][j] = i * numero de columnas + j (row-major)
    ;para saber la posicion de cada ficha
endm

filaTablero macro numFpos
    local inicio, ciclo, saveFpos

    inicio:
        xor di, di ; limpio di
        mov bl, readTeclado[numFpos]

    ciclo:
        cmp cabecerasF[di], bl
        jz saveFpos ;eliminar la ficha
        inc di
        cmp di, 8d
        jnz ciclo
    
    imprimir salto
    imprimir moverror
    imprimir salto
    jmp inicio

    saveFpos:
        mov fila, di ;numero de fila 
endm

columnaTablero macro  numCpos
    local inicio, ciclo, saveCpos

    inicio:
        xor di, di
        mov bl, readTeclado[numCpos]
    
    ciclo:
        cmp cabecerasC[di], bl
        jz saveCpos
        inc di
        cmp di, 8d
        jnz ciclo
    
    imprimir salto
    imprimir moverror
    imprimir salto
    jmp inicio

    saveCpos:
        mov columna, di

endm

MOSTRAR_TAB macro
    
	imprimir namesJ
	imprimir shownameJ1
	imprimir nameJ1
	imprimir salto
	imprimir fichaInfo1
	imprimir espacio 
    mov ax, puntosJ1
	call IMPRIMIR_NUMERO 
	imprimir puntos
    xor ax, ax

	imprimir salto
	imprimir shownameJ2
	imprimir nameJ2
	imprimir salto
	imprimir fichaInfo2
	imprimir espacio 
	
    mov ax, puntosJ2
    call IMPRIMIR_NUMERO
	imprimir puntos
    xor ax, ax

	imprimir salto
	imprimir salto
	showTablero

	 
endm

verificarREP macro  
    local comparar, diferente, iguales, final
    xor di, di
    xor bh, bh
    xor bl, bl
    
    comparar:
        mov bh, readTeclado[di]
        mov bl, wordrep[di]
        cmp bh, bl
        ; sino son iguales
        jnz diferente

        cmp bl, "$" ;si es igual a dolar
        jz iguales
        ; si son iguales
        inc di
        jmp comparar

    iguales:
        ;imprimir igualesW
        mov bool_rep, 1d
        jmp final
    diferente: 
        ;imprimir diferentesW
        mov bool_rep, 0d
        jmp final
    final:  
endm

limpiarEntrada macro entradaT
    local ciclo, ciclo2, fin
    xor si, si
    ciclo:
        mov bl, "$"
        mov entradaT[si], bl
        

        cmp si, 49d
        je fin
        inc si
        jmp ciclo
    fin:

endm


openFile macro rutaFile
    mov ah, 3Dh
    mov al, 2
    mov dx, offset rutaFile
    int 21h

    mov handle, ax ;manipula archivo
    
endm

closeFile macro idFile
    mov ah, 3Eh
    mov bx, idFile
    int 21h
endm

writeFile macro idFile, numBytes, datos
    mov ah, 40h
    mov bx, idFile
    mov cx, numBytes
    lea dx, datos ; lo mismo que offset
    int 21h
endm


tableroFile macro
    local ciclo, ciclo2, ciclo3, ciclo4, reinicio, reinicio2
    
    xor si, si ; limpiando si

    writeFile handle, 4, atr ;abriendo fila de letras ABC...
    writeFile handle, 4, atd ;abriendo columna para cada letra
    writeFile handle, 1, espacio[0] ;colocando en la celda la letra
    writeFile handle, 5, ctd
    ciclo: 
        mov bl, cabecerasC[si] ;ABCDE...
        mov individual[0], bl

        writeFile handle, 4, atd ;abriendo columna para cada letra
        writeFile handle, 1, individual[0] ;colocando en la celda la letra
        writeFile handle, 5, ctd ;cerrando columna para cada letra

        inc si 
        cmp si, 8d ; numero de columnas 
        jnz ciclo
    
    writeFile handle, 5, ctr ;cerrando fila de letras ABC...
    
    xor si, si
    mov iteradorJ, 0d

    writeFile handle, 4, atr
    ciclo2:
        mov bl, cabecerasF[si]
        mov individual[0], bl
        writeFile handle, 4, atd ;
        writeFile handle, 1, individual[0] 
        ;colocando en la celda el numero 123...
        writeFile handle, 5, ctd 

        mov iteradorI, 0d

        ciclo3: 
            mov di, iteradorJ
            verificarFile tablero[di]
           
            inc iteradorJ
            ;imprimir individual
            

            inc iteradorI
            cmp iteradorI, 8d
            jz reinicio

           
            
            jmp ciclo3

        reinicio: 
            writeFile handle, 5, ctr ;aqui se empieza otra linea 
            ; por eso cierro el tr
            
            
            cmp si, 7d
            jz reinicio2
            mov iteradorI, 0d
            

            ciclo4:
                mov bl, lineas[1]
                mov individual[0], bl
                ;imprimir individual
                inc iteradorI
                cmp iteradorI, 32d
                jnz ciclo4
            
        reinicio2:
            ;imprimir salto
            inc si
            cmp si, 8d
            jnz ciclo2

endm

verificarFile macro valor
    local cero, uno, dos, fin

    cmp valor, 0d
    jz cero

    cmp valor, 1d
    jz uno

    dos: 
        
        writeFile handle, 4, atd 
        writeFile handle, 1, celdaJ2
        ;0 ficha de jugador2
        writeFile handle, 5, ctd 
        jmp fin

    uno: 
        writeFile handle, 4, atd 
        writeFile handle, 1, celdaJ1 
        ;x ficha de jugador1
        writeFile handle, 5, ctd 
        jmp fin

    cero: 
     
        mov individual[0], " "
        writeFile handle, 4, atd ;
        writeFile handle, 1, individual[0] 
        ;colocando en la celda el numero 123...
        writeFile handle, 5, ctd 
        jmp fin

    fin:

endm

; imprimirnum macro
;     push dx
;     mov cx, "$"
;     push cx
;     forInum: 
;         xor dx, dx
;         mov bx, 10d
;         div bx
;         push dx
;         cmp ax, 10
;         jge forInum

;     push ax
    
;     fordnum:
;         pop dx
;         cmp dl, "$"
;         je finford
;         mov ah, 02h
;         add dl, 30h
;         int 21h
        
;         jmp fordnum

;     finford:



;     pop dx
     
;     ret

; endm

wnameFile macro nombrep
    local ciclo, final

    xor di, di

    ciclo: 
        mov bl, nombrep[di]

        cmp bl, "$"
        jz final

        writeFile handle, 1, nombrep[di]
        inc di
        
        jmp ciclo

    final:


endm