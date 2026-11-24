# JAL_JR.asm
# Cobertura de la tabla 3:
# jal, jr: procedimiento no hoja que llama a otro,
# guarda $ra en la pila y retorna correctamente.
#
# Salida esperada:
# 0000002A
# 00000000

.text
.globl main

main:
    # Guardar el valor inicial de $sp para verificar su restauracion.
    addi $s0, $sp, 0
    addi $a0, $zero, 6
    jal  outer

    # Resultado: (6 + 1) * 4 + 14 = 42.
    addi $a0, $v1, 0
    jal  print_hex

    # Diferencia de SP tras volver: debe ser cero.
    sub  $a0, $sp, $s0
    jal  print_hex

    # Terminar programa.
    addi $v0, $zero, 10
    syscall

# Procedimiento no hoja: salva la direccion de retorno antes del jal.
outer:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    addi $a0, $a0, 1
    jal  inner
    addi $v1, $v1, 14
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra

# Procedimiento hoja: multiplica por 4 mediante desplazamiento.
inner:
    sll  $v1, $a0, 2
    jr   $ra

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
