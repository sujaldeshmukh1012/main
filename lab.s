	.data
	.text
	.global lab_2_test

lab_2_test:
	PUSH {r4-r12,lr}

	; Optional personal tests (won't affect grading)
	; r0 = divisor, r1 = dividend
	; MOV r0, #8
	; MOV r1, #64
	; BL signed_division
	; BL unsigned_division
	; BL mod

lab_2_start:		; USED FOR GRADING.  DO NOT MODIFY.
	MOV r0, #97          ; These three lines test 30264 / 97
	MOV r1, #30264
	BL unsigned_division

	MOV r0, #0           ; These three lines test -491 / 37
	SUB r1, r0, #491
	MOV r0, #37
	BL signed_division

	MOV r1, #251         ; These three lines test 251 % 64
	MOV r0, #64
	BL mod

lab_2_end:			; USED FOR GRADING.  DO NOT MODIFY.

	POP {r4-r12,lr}
	MOV pc, lr


unsigned_division:
	PUSH {r4-r12,lr}

	@ Inputs:
	@   r0 = divisor  (unsigned, <= 15 bits)
	@   r1 = dividend (unsigned, <= 15 bits)
	@ Output:
	@   r0 = quotient

	@ (Optional) div-by-zero guard (remove if lab forbids)
	CMP     r0, #0
	BEQ     udiv_div0

	MOV     r2, r1          @ remainder
	MOV     r3, r0          @ divisor
	LSL     r3, r3, #15     @ divisor <<= 15
	MOV     r4, #0          @ quotient
	MOV     r5, #15         @ counter

udiv_loop:
	SUBS    r2, r2, r3
	BMI     udiv_neg

	LSL     r4, r4, #1
	ORR     r4, r4, #1
	B       udiv_next

udiv_neg:
	ADD     r2, r2, r3
	LSL     r4, r4, #1

udiv_next:
	LSR     r3, r3, #1
	SUBS    r5, r5, #1
	BGT     udiv_loop

	MOV     r0, r4
	B       udiv_done

udiv_div0:
	MOV     r0, #0

udiv_done:
	POP {r4-r12,lr}
	MOV pc, lr


signed_division:
	PUSH {r4-r12,lr}

	@ Inputs:
	@   r0 = divisor  (signed)
	@   r1 = dividend (signed)
	@ Output:
	@   r0 = quotient (signed)
	@ Thumb-2 only (Cortex-M): use IT blocks, not RSBLT, etc.

	@ (Optional) div-by-zero guard (remove if lab forbids)
	CMP     r0, #0
	BEQ     sdiv_div0

	EOR     r6, r0, r1      @ sign flag: negative if signs differ

	@ r0 = abs(r0)
	CMP     r0, #0
	IT      LT
	RSB     r0, r0, #0

	@ r1 = abs(r1)
	CMP     r1, #0
	IT      LT
	RSB     r1, r1, #0

	@ restoring division on magnitudes
	MOV     r2, r1
	MOV     r3, r0
	LSL     r3, r3, #15
	MOV     r4, #0
	MOV     r5, #15

sdiv_loop:
	SUBS    r2, r2, r3
	BMI     sdiv_neg

	LSL     r4, r4, #1
	ORR     r4, r4, #1
	B       sdiv_next

sdiv_neg:
	ADD     r2, r2, r3
	LSL     r4, r4, #1

sdiv_next:
	LSR     r3, r3, #1
	SUBS    r5, r5, #1
	BGT     sdiv_loop

	@ apply sign to quotient
	CMP     r6, #0
	IT      LT
	RSB     r4, r4, #0

	MOV     r0, r4
	B       sdiv_done

sdiv_div0:
	MOV     r0, #0

sdiv_done:
	POP {r4-r12,lr}
	MOV pc, lr


mod:
	PUSH {r4-r12,lr}

	@ Inputs:
	@   r0 = divisor  (unsigned, <= 15 bits)
	@   r1 = dividend (unsigned, <= 15 bits)
	@ Output:
	@   r0 = remainder (dividend % divisor)

	@ (Optional) div-by-zero guard (remove if lab forbids)
	CMP     r0, #0
	BEQ     mod_div0

	MOV     r2, r1          @ remainder
	MOV     r3, r0          @ divisor
	LSL     r3, r3, #15
	MOV     r4, #0          @ quotient (unused)
	MOV     r5, #15

mod_loop:
	SUBS    r2, r2, r3
	BMI     mod_neg

	LSL     r4, r4, #1
	ORR     r4, r4, #1
	B       mod_next

mod_neg:
	ADD     r2, r2, r3
	LSL     r4, r4, #1

mod_next:
	LSR     r3, r3, #1
	SUBS    r5, r5, #1
	BGT     mod_loop

	MOV     r0, r2
	B       mod_done

mod_div0:
	MOV     r0, #0

mod_done:
	POP {r4-r12,lr}
	MOV pc, lr

	.end
