Signed division flowsheet

1. Start
2. Read inputs: divisor = r0, dividend = r1
3. sign_flag = (divisor XOR dividend) is negative?
4. If divisor < 0: divisor = -divisor
5. If dividend < 0: dividend = -dividend
6. Do restoring unsigned division on magnitudes (15-bit loop) to get quotient_mag
7. If sign_flag indicates negative: quotient = -quotient_mag else quotient = quotient_mag
8. Output quotient in r0
9. End

Restoring unsigned division sub-flowsheet (used in step 6)

A) remainder = dividend_mag
B) div_shift = divisor_mag << 15
C) quotient = 0
D) count = 15
E) Loop while count > 0

* remainder = remainder - div_shift
* If remainder < 0
  remainder = remainder + div_shift   (restore)
  quotient = (quotient << 1) | 0
  Else
  quotient = (quotient << 1) | 1
* div_shift = div_shift >> 1
* count = count - 1
  F) Return quotient (and remainder exists internally if needed)

Mod flowsheet (unsigned remainder)

1. Start
2. Read inputs: divisor = r0, dividend = r1
3. (Optional guard) If divisor == 0: define behavior (usually return 0 or leave unchanged per lab)
4. Run the same restoring-division loop, but keep remainder at the end

   * remainder = dividend
   * div_shift = divisor << 15
   * count = 15
   * Loop: subtract, restore if negative, shift div_shift right, decrement count
5. Output remainder in r0
6. End

How to draw it (boxes/arrows)

Signed division:

* Process boxes: “Compute sign_flag”, “ABS divisor”, “ABS dividend”, “Restoring divide”, “Apply sign”
* Decision diamonds: “divisor < 0?”, “dividend < 0?”, “sign_flag negative?”
* One subroutine box for “Restoring divide (15-iter)” and reference its own mini-flowsheet.

Mod:

* Process boxes: “Init remainder/div_shift/count”, “Subtract”, “Restore”, “Shift divisor”, “Decrement count”, “Return remainder”
* Decision diamonds: “remainder < 0?”, “count > 0?”

Key labels to put on the chart (so it matches the assembly)

* sign_flag = r6 = r0 XOR r1
* remainder = r2
* div_shift = r3
* quotient = r4 (even if unused in mod)
* count = r5
