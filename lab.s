unsigned_division:
	PUSH {r4-r12,lr}

	@ Inputs:
	@   r0 = divisor  (unsigned, <= 15 bits)
	@   r1 = dividend (unsigned, <= 15 bits)
	@ Output:
	@   r0 = quotient

	MOV     r2, r1          @ r2 = remainder = dividend
	MOV     r3, r0          @ r3 = working divisor
	LSL     r3, r3, #15     @ divisor <<= 15
	MOV     r4, #0          @ r4 = quotient = 0
	MOV     r5, #15         @ r5 = counter = 15

udiv_loop:
	SUBS    r2, r2, r3      @ remainder -= divisor_shifted
	BMI     udiv_neg        @ if remainder < 0, restore and shift 0 into quotient

	@ remainder >= 0: shift in 1
	LSL     r4, r4, #1
	ORR     r4, r4, #1
	B       udiv_next

udiv_neg:
	ADD     r2, r2, r3      @ restore remainder
	LSL     r4, r4, #1      @ shift in 0

udiv_next:
	LSR     r3, r3, #1      @ divisor_shifted >>= 1
	SUBS    r5, r5, #1      @ counter--
	BGT     udiv_loop

	MOV     r0, r4          @ return quotient in r0

	POP {r4-r12,lr}
	MOV pc, lr


signed_division:
	PUSH {r4-r12,lr}

	@ Inputs:
	@   r0 = divisor  (signed, magnitude <= 15 bits)
	@   r1 = dividend (signed, magnitude <= 15 bits)
	@ Output:
	@   r0 = quotient (signed)

	EOR     r6, r0, r1      @ r6 sign flag: negative if signs differ

	@ abs(divisor) in r0
	CMP     r0, #0
	RSBLT   r0, r0, #0

	@ abs(dividend) in r1
	CMP     r1, #0
	RSBLT   r1, r1, #0

	@ Run same restoring division (unsigned) on magnitudes
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

	@ Apply sign to quotient
	CMP     r6, #0
	RSBLT   r4, r4, #0      @ if sign differs, negate quotient

	MOV     r0, r4

	POP {r4-r12,lr}
	MOV pc, lr


mod:
	PUSH {r4-r12,lr}

	@ Inputs:
	@   r0 = divisor  (unsigned, <= 15 bits)
	@   r1 = dividend (unsigned, <= 15 bits)
	@ Output:
	@   r0 = remainder (dividend % divisor)

	MOV     r2, r1          @ remainder = dividend
	MOV     r3, r0
	LSL     r3, r3, #15
	MOV     r4, #0          @ quotient not required, but kept for same loop shape
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

	MOV     r0, r2          @ return remainder

	POP {r4-r12,lr}
	MOV pc, lr
