# SLT_SLTI.asm
# Cobertura de la tabla 3:
# slt, slti: resultados 1 y 0 en ambas instrucciones.
# En cada instruccion hay operandos negativos que distinguen
# la comparacion con signo de la comparacion sin signo.
#
# Salida esperada:
# 00000001
# 00000000
# 00000001
# 00000000

.text
.globl main

main:
    addi $t0, $zero, -3
    addi $t1, $zero, 5

    # SLT: -3 < 5, pero 5 no es menor que -3.
    slt  $a0, $t0, $t1
    jal  print_hex
    slt  $a0, $t1, $t0
    jal  print_hex

    # SLTI: -3 < 5; 5 no es menor que -3.
    slti $a0, $t0, 5
    jal  print_hex
    slti $a0, $t1, -3
    jal  print_hex

    # Terminar programa.
    addi $v0, $zero, 10
    syscall


# print_hex: imprime $a0 como 8 digitos hexadecimales y un salto de linea.
# Modifica $t6-$t9, $a0 y $v0. No modifica los demas registros.
print_hex:
    addi $t6, $a0, 0
    addi $t7, $zero, 8
    addi $v0, $zero, 11
hex_loop:
    srl  $t8, $t6, 28
    slti $t9, $t8, 10
    bne  $t9, $zero, hex_decimal
    addi $a0, $t8, 55
    j    hex_print
hex_decimal:
    addi $a0, $t8, 48
hex_print:
    syscall
    sll  $t6, $t6, 4
    addi $t7, $t7, -1
    bne  $t7, $zero, hex_loop
    addi $a0, $zero, 10
    syscall
    jr   $ra
