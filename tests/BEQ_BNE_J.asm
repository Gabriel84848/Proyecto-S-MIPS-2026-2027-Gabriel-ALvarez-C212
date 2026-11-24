# BEQ_BNE_J.asm
# Cobertura de la tabla 3:
# beq, bne: cada uno tomado y no tomado.
# bne: salto hacia atras en un bucle.
# j: salto incondicional hacia adelante.
#
# Salida esperada:
# 00000001
# 00000002
# 00000003
# 00000004
# 00000006
# 00000005

.text
.globl main

main:
    addi $t0, $zero, 7
    addi $t1, $zero, 7
    addi $t2, $zero, 9

    # BEQ tomado: conserva 1; si no salta, obtiene 101.
    addi $a0, $zero, 1
    beq  $t0, $t1, beq_taken_end
    addi $a0, $a0, 100
beq_taken_end:
    jal  print_hex

    # BEQ no tomado: suma 2 al resultado.
    addi $a0, $zero, 0
    beq  $t0, $t2, beq_not_end
    addi $a0, $a0, 2
beq_not_end:
    jal  print_hex

    # BNE tomado: conserva 3.
    addi $a0, $zero, 3
    bne  $t0, $t2, bne_taken_end
    addi $a0, $a0, 100
bne_taken_end:
    jal  print_hex

    # BNE no tomado: suma 4 al resultado.
    addi $a0, $zero, 0
    bne  $t0, $t1, bne_not_end
    addi $a0, $a0, 4
bne_not_end:
    jal  print_hex

    # Bucle hacia atras: sumar 3 + 2 + 1.
    addi $t3, $zero, 3
    addi $a0, $zero, 0
sum_loop:
    add  $a0, $a0, $t3
    addi $t3, $t3, -1
    bne  $t3, $zero, sum_loop
    jal  print_hex

    # J: omite la suma de 100.
    addi $a0, $zero, 5
    j    jump_end
    addi $a0, $a0, 100
jump_end:
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
