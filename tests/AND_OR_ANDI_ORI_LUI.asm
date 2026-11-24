# AND_OR_ANDI_ORI_LUI.asm
# Cobertura de la tabla 3:
# and, or: operandos con unos en los 16 bits altos.
# andi, ori: inmediato con bit 15 igual a 1.
# lui: inmediato con bit 15 igual a 1.
#
# Salida esperada:
# C0C00303
# FCFC3F3F
# 00008001
# 12348003
# ABCD0000

.text
.globl main

main:
    # Preparar operandos de 32 bits.
    lui  $t0, 0xF0F0
    ori  $t0, $t0, 0x0F0F
    lui  $t1, 0xCCCC
    ori  $t1, $t1, 0x3333

    # AND y OR de 32 bits.
    and  $a0, $t0, $t1
    jal  print_hex
    or   $a0, $t0, $t1
    jal  print_hex

    # ANDI: debe extender el inmediato con ceros.
    addi $t0, $zero, -1
    andi $a0, $t0, 0x8001
    jal  print_hex

    # ORI: los bits superiores deben conservarse.
    lui  $t0, 0x1234
    addi $t0, $t0, 2
    ori  $a0, $t0, 0x8001
    jal  print_hex

    # LUI: bit 15 del inmediato igual a 1.
    lui  $a0, 0xABCD
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
