
# test_add_sub.asm
# Cobertura de la tabla 3:
# add: operandos positivos y un operando negativo.
# sub: operandos positivos y un operando negativo.
# addi: inmediato negativo.
# syscall: servicios 11 y 10.
# Salida esperada: 9527

.text
.globl main

main:

    # Servicio 11: imprimir caracter
    addi $v0, $zero, 11

    # Caso 1: add con operandos positivos
    addi $t0, $zero, 7
    addi $t1, $zero, 2
    add  $t2, $t0, $t1

    addi $a0, $t2, 48
    syscall

    # Caso 2: sub con operandos positivos
    sub  $t2, $t0, $t1

    addi $a0, $t2, 48
    syscall

    # Caso 3: add con un operando negativo
    addi $t0, $zero, -3
    addi $t1, $zero, 5
    add  $t2, $t0, $t1

    addi $a0, $t2, 48
    syscall

    # Caso 4: sub con un operando negativo
    addi $t0, $zero, 3
    addi $t1, $zero, -4
    sub  $t2, $t0, $t1

    addi $a0, $t2, 48
    syscall

    # Imprimir salto de linea
    addi $a0, $zero, 10
    syscall

    # Servicio 10: terminar programa
    addi $v0, $zero, 10
    syscall
