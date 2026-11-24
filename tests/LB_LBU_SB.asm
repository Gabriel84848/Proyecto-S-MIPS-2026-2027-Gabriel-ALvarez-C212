# LB_LBU_SB.asm
# Cobertura de la tabla 3:
# lb, lbu: bytes con bit 7 igual a 1 en posiciones 0 y 3.
# sb: las cuatro posiciones de una palabra; lw tras cada sb
# para comprobar que los otros tres bytes no cambian.
#
# Salida esperada:
# FFFFFFA5
# 000000A5
# FFFFFF80
# 00000080
# 807F9211
# 807F2211
# 80332211
# 44332211

.text
.globl main

main:
    # Reservar una palabra alineada en la pila.
    addi $sp, $sp, -4
    lui  $t0, 0x807F
    ori  $t0, $t0, 0x92A5
    sw   $t0, 0($sp)

    # Little-endian: bytes A5, 92, 7F, 80.
    # Posicion 0: A5, con y sin extension de signo.
    lb   $a0, 0($sp)
    jal  print_hex
    lbu  $a0, 0($sp)
    jal  print_hex

    # Posicion 3: 80, con y sin extension de signo.
    lb   $a0, 3($sp)
    jal  print_hex
    lbu  $a0, 3($sp)
    jal  print_hex

    # Escribir cada carril y leer la palabra COMPLETA.
    addi $t1, $zero, 0x11
    sb   $t1, 0($sp)
    lw   $a0, 0($sp)
    jal  print_hex

    addi $t1, $zero, 0x22
    sb   $t1, 1($sp)
    lw   $a0, 0($sp)
    jal  print_hex

    addi $t1, $zero, 0x33
    sb   $t1, 2($sp)
    lw   $a0, 0($sp)
    jal  print_hex

    addi $t1, $zero, 0x44
    sb   $t1, 3($sp)
    lw   $a0, 0($sp)
    jal  print_hex

    addi $sp, $sp, 4

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
