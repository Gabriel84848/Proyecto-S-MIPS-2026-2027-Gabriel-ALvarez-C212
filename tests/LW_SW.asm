# LW_SW.asm
# Cobertura de la tabla 3:
# lw, sw: desplazamientos positivos y negativos en ambas.
#
# Salida esperada:
# 11223344
# AABBCCDD
# 55667788
# 99AABBCC

.text
.globl main

main:
    # Reservar 16 bytes de pila. Usar el centro como base.
    addi $sp, $sp, -16
    addi $t0, $sp, 8

    # Inicializar las dos palabras respecto a $sp.
    # Las cargas siguientes usan offsets respecto al centro.
    lui  $t1, 0x1122
    ori  $t1, $t1, 0x3344
    sw   $t1, 12($sp)
    lui  $t1, 0xAABB
    ori  $t1, $t1, 0xCCDD
    sw   $t1, 4($sp)

    # LW con desplazamiento positivo y negativo.
    lw   $a0, 4($t0)
    jal  print_hex
    lw   $a0, -4($t0)
    jal  print_hex

    # SW positivo: leer usando una base distinta, offset 0.
    lui  $t1, 0x5566
    ori  $t1, $t1, 0x7788
    sw   $t1, 4($t0)
    addi $t2, $sp, 12
    lw   $a0, 0($t2)
    jal  print_hex

    # SW negativo: leer usando una base distinta, offset 0.
    lui  $t1, 0x99AA
    ori  $t1, $t1, 0xBBCC
    sw   $t1, -4($t0)
    addi $t2, $sp, 4
    lw   $a0, 0($t2)
    jal  print_hex

    addi $sp, $sp, 16

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
