# ADDIU_ADDU_ZERO.asm
# Cobertura de la tabla 3:
# addiu, addu: mediante li con constante -1234 (16 bits con signo)
# y move entre registros.
# Registro $zero: intento de escritura y lectura posterior.
#
# Salida esperada:
# FFFFFB2E
# FFFFFB2E
# 00000000

.text
.globl main

main:
    # LI con constante negativa de 16 bits: MARS genera addiu.
    li   $t0, -1234
    addi $a0, $t0, 0
    jal  print_hex

    # MOVE: MARS genera addu. Destino inicialmente distinto.
    addi $t1, $zero, 77
    move $t1, $t0
    addi $a0, $t1, 0
    jal  print_hex

    # Escribir en $zero no debe producir ningun efecto.
    addi $t2, $zero, 19
    add  $zero, $t2, $t2
    add  $a0, $zero, $zero
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
