lab_2_test:
	PUSH {r4-r12,lr}

	; -------------------------
	; PERSONAL TESTS (yours)
	; Convention used by your routines:
	;   r0 = divisor
	;   r1 = dividend
	; Result returned in r0
	; -------------------------

	; ---- unsigned_division tests ----
	; 64 / 8 = 8
	MOV r0, #8
	MOV r1, #64
	BL unsigned_division

	; 15 / 3 = 5
	MOV r0, #3
	MOV r1, #15
	BL unsigned_division

	; 7 / 9 = 0
	MOV r0, #9
	MOV r1, #7
	BL unsigned_division

	; 32767 / 1 = 32767
	MOV r0, #1
	MOV r1, #32767
	BL unsigned_division

	; ---- signed_division tests ----
	; -64 / 8 = -8
	MOV r0, #8
	MOV r1, #0
	SUB r1, r1, #64
	BL signed_division

	; 64 / -8 = -8
	MOV r1, #64
	MOV r0, #0
	SUB r0, r0, #8
	BL signed_division

	; -64 / -8 = 8
	MOV r0, #0
	SUB r0, r0, #8
	MOV r1, #0
	SUB r1, r1, #64
	BL signed_division

	; 0 / 5 = 0
	MOV r0, #5
	MOV r1, #0
	BL signed_division

	; -491 / 37 = -13 (grader-like)
	MOV r0, #37
	MOV r1, #0
	SUB r1, r1, #491
	BL signed_division

	; ---- mod tests ----
	; 251 % 64 = 59
	MOV r0, #64
	MOV r1, #251
	BL mod

	; 64 % 8 = 0
	MOV r0, #8
	MOV r1, #64
	BL mod

	; 7 % 9 = 7
	MOV r0, #9
	MOV r1, #7
	BL mod

	; 32767 % 97 = 32767 - 97*337 = 78
	MOV r0, #97
	MOV r1, #32767
	BL mod

	; -------------------------
	; DO NOT MODIFY (grading)
	; -------------------------
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
