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
