# SLL_SRL.asm
# Cobertura de la tabla 3:
# sll, srl: shamt igual a 0 y distinto de 0 en ambas.
# srl: operando negativo, comprobando entrada de ceros.
#
# Salida esperada:
# 81234567
# 12345670
# 81234567
# 08123456

.text
.globl main

main:
    lui  $t0, 0x8123
    ori  $t0, $t0, 0x4567

    # SLL: desplazamientos de 0 y 4 posiciones.
    sll  $a0, $t0, 0
    jal  print_hex
    sll  $a0, $t0, 4
    jal  print_hex

    # SRL: el bit de signo es 1; deben entrar ceros.
    srl  $a0, $t0, 0
    jal  print_hex
    srl  $a0, $t0, 4
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
