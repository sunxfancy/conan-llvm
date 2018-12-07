; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s  --check-prefix=X64

; Shift i64 integers on 32-bit target

define i64 @test1(i64 %X, i8 %C) nounwind {
; X86-LABEL: test1:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    shll %cl, %eax
; X86-NEXT:    shldl %cl, %esi, %edx
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    je .LBB0_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:  .LBB0_2:
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
;
; X64-LABEL: test1:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    shlq %cl, %rdi
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    retq
        %shift.upgrd.1 = zext i8 %C to i64              ; <i64> [#uses=1]
        %Y = shl i64 %X, %shift.upgrd.1         ; <i64> [#uses=1]
        ret i64 %Y
}

define i64 @test2(i64 %X, i8 %C) nounwind {
; X86-LABEL: test2:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl %esi, %edx
; X86-NEXT:    sarl %cl, %edx
; X86-NEXT:    shrdl %cl, %esi, %eax
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    je .LBB1_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    sarl $31, %esi
; X86-NEXT:    movl %edx, %eax
; X86-NEXT:    movl %esi, %edx
; X86-NEXT:  .LBB1_2:
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
;
; X64-LABEL: test2:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    sarq %cl, %rdi
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    retq
        %shift.upgrd.2 = zext i8 %C to i64              ; <i64> [#uses=1]
        %Y = ashr i64 %X, %shift.upgrd.2                ; <i64> [#uses=1]
        ret i64 %Y
}

define i64 @test3(i64 %X, i8 %C) nounwind {
; X86-LABEL: test3:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl %esi, %edx
; X86-NEXT:    shrl %cl, %edx
; X86-NEXT:    shrdl %cl, %esi, %eax
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    je .LBB2_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %edx, %eax
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:  .LBB2_2:
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
;
; X64-LABEL: test3:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    shrq %cl, %rdi
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    retq
        %shift.upgrd.3 = zext i8 %C to i64              ; <i64> [#uses=1]
        %Y = lshr i64 %X, %shift.upgrd.3                ; <i64> [#uses=1]
        ret i64 %Y
}

; Combine 2xi32/2xi16 shifts into SHLD

define i32 @test4(i32 %A, i32 %B, i8 %C) nounwind {
; X86-LABEL: test4:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shldl %cl, %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: test4:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shldl %cl, %esi, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
        %shift.upgrd.4 = zext i8 %C to i32              ; <i32> [#uses=1]
        %X = shl i32 %A, %shift.upgrd.4         ; <i32> [#uses=1]
        %Cv = sub i8 32, %C             ; <i8> [#uses=1]
        %shift.upgrd.5 = zext i8 %Cv to i32             ; <i32> [#uses=1]
        %Y = lshr i32 %B, %shift.upgrd.5                ; <i32> [#uses=1]
        %Z = or i32 %Y, %X              ; <i32> [#uses=1]
        ret i32 %Z
}

define i16 @test5(i16 %A, i16 %B, i8 %C) nounwind {
; X86-LABEL: test5:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shldw %cl, %dx, %ax
; X86-NEXT:    retl
;
; X64-LABEL: test5:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shldw %cl, %si, %di
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
        %shift.upgrd.6 = zext i8 %C to i16              ; <i16> [#uses=1]
        %X = shl i16 %A, %shift.upgrd.6         ; <i16> [#uses=1]
        %Cv = sub i8 16, %C             ; <i8> [#uses=1]
        %shift.upgrd.7 = zext i8 %Cv to i16             ; <i16> [#uses=1]
        %Y = lshr i16 %B, %shift.upgrd.7                ; <i16> [#uses=1]
        %Z = or i16 %Y, %X              ; <i16> [#uses=1]
        ret i16 %Z
}

; Combine 2xi32/2xi16 shifts into SHRD

define i32 @test6(i32 %A, i32 %B, i8 %C) nounwind {
; X86-LABEL: test6:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrdl %cl, %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: test6:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shrdl %cl, %esi, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
        %shift.upgrd.4 = zext i8 %C to i32              ; <i32> [#uses=1]
        %X = lshr i32 %A, %shift.upgrd.4         ; <i32> [#uses=1]
        %Cv = sub i8 32, %C             ; <i8> [#uses=1]
        %shift.upgrd.5 = zext i8 %Cv to i32             ; <i32> [#uses=1]
        %Y = shl i32 %B, %shift.upgrd.5                ; <i32> [#uses=1]
        %Z = or i32 %Y, %X              ; <i32> [#uses=1]
        ret i32 %Z
}

define i16 @test7(i16 %A, i16 %B, i8 %C) nounwind {
; X86-LABEL: test7:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrdw %cl, %dx, %ax
; X86-NEXT:    retl
;
; X64-LABEL: test7:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shrdw %cl, %si, %di
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
        %shift.upgrd.6 = zext i8 %C to i16              ; <i16> [#uses=1]
        %X = lshr i16 %A, %shift.upgrd.6         ; <i16> [#uses=1]
        %Cv = sub i8 16, %C             ; <i8> [#uses=1]
        %shift.upgrd.7 = zext i8 %Cv to i16             ; <i16> [#uses=1]
        %Y = shl i16 %B, %shift.upgrd.7                ; <i16> [#uses=1]
        %Z = or i16 %Y, %X              ; <i16> [#uses=1]
        ret i16 %Z
}

; Shift i64 integers on 32-bit target by shift value less then 32 (PR14593)

define i64 @test8(i64 %val, i32 %bits) nounwind {
; X86-LABEL: test8:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    shll %cl, %eax
; X86-NEXT:    shldl %cl, %esi, %edx
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
;
; X64-LABEL: test8:
; X64:       # %bb.0:
; X64-NEXT:    andb $31, %sil
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    shlq %cl, %rdi
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    retq
  %and = and i32 %bits, 31
  %sh_prom = zext i32 %and to i64
  %shl = shl i64 %val, %sh_prom
  ret i64 %shl
}

define i64 @test9(i64 %val, i32 %bits) nounwind {
; X86-LABEL: test9:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    shrdl %cl, %edx, %eax
; X86-NEXT:    sarl %cl, %edx
; X86-NEXT:    retl
;
; X64-LABEL: test9:
; X64:       # %bb.0:
; X64-NEXT:    andb $31, %sil
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    sarq %cl, %rdi
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    retq
  %and = and i32 %bits, 31
  %sh_prom = zext i32 %and to i64
  %ashr = ashr i64 %val, %sh_prom
  ret i64 %ashr
}

define i64 @test10(i64 %val, i32 %bits) nounwind {
; X86-LABEL: test10:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    shrdl %cl, %edx, %eax
; X86-NEXT:    shrl %cl, %edx
; X86-NEXT:    retl
;
; X64-LABEL: test10:
; X64:       # %bb.0:
; X64-NEXT:    andb $31, %sil
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    shrq %cl, %rdi
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    retq
  %and = and i32 %bits, 31
  %sh_prom = zext i32 %and to i64
  %lshr = lshr i64 %val, %sh_prom
  ret i64 %lshr
}

; SHLD/SHRD manual shifts

define i32 @test11(i32 %hi, i32 %lo, i32 %bits) nounwind {
; X86-LABEL: test11:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    andl $31, %ecx
; X86-NEXT:    # kill: def $cl killed $cl killed $ecx
; X86-NEXT:    shldl %cl, %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: test11:
; X64:       # %bb.0:
; X64-NEXT:    andl $31, %edx
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shldl %cl, %esi, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
  %and = and i32 %bits, 31
  %and32 = sub i32 32, %and
  %sh_lo = lshr i32 %lo, %and32
  %sh_hi = shl i32 %hi, %and
  %sh = or i32 %sh_lo, %sh_hi
  ret i32 %sh
}

define i32 @test12(i32 %hi, i32 %lo, i32 %bits) nounwind {
; X86-LABEL: test12:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    andl $31, %ecx
; X86-NEXT:    # kill: def $cl killed $cl killed $ecx
; X86-NEXT:    shrdl %cl, %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: test12:
; X64:       # %bb.0:
; X64-NEXT:    andl $31, %edx
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shrdl %cl, %edi, %esi
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    retq
  %and = and i32 %bits, 31
  %and32 = sub i32 32, %and
  %sh_lo = shl i32 %hi, %and32
  %sh_hi = lshr i32 %lo, %and
  %sh = or i32 %sh_lo, %sh_hi
  ret i32 %sh
}

define i32 @test13(i32 %hi, i32 %lo, i32 %bits) nounwind {
; X86-LABEL: test13:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shldl %cl, %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: test13:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shldl %cl, %esi, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
  %bits32 = sub i32 32, %bits
  %sh_lo = lshr i32 %lo, %bits32
  %sh_hi = shl i32 %hi, %bits
  %sh = or i32 %sh_lo, %sh_hi
  ret i32 %sh
}

define i32 @test14(i32 %hi, i32 %lo, i32 %bits) nounwind {
; X86-LABEL: test14:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrdl %cl, %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: test14:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shrdl %cl, %edi, %esi
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    retq
  %bits32 = sub i32 32, %bits
  %sh_lo = shl i32 %hi, %bits32
  %sh_hi = lshr i32 %lo, %bits
  %sh = or i32 %sh_lo, %sh_hi
  ret i32 %sh
}

define i32 @test15(i32 %hi, i32 %lo, i32 %bits) nounwind {
; X86-LABEL: test15:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shldl %cl, %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: test15:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shldl %cl, %esi, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
  %bits32 = xor i32 %bits, 31
  %lo2 = lshr i32 %lo, 1
  %sh_lo = lshr i32 %lo2, %bits32
  %sh_hi = shl i32 %hi, %bits
  %sh = or i32 %sh_lo, %sh_hi
  ret i32 %sh
}

define i32 @test16(i32 %hi, i32 %lo, i32 %bits) nounwind {
; X86-LABEL: test16:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrdl %cl, %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: test16:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shrdl %cl, %esi, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
  %bits32 = xor i32 %bits, 31
  %lo2 = shl i32 %lo, 1
  %sh_lo = shl i32 %lo2, %bits32
  %sh_hi = lshr i32 %hi, %bits
  %sh = or i32 %sh_lo, %sh_hi
  ret i32 %sh
}

define i32 @test17(i32 %hi, i32 %lo, i32 %bits) nounwind {
; X86-LABEL: test17:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrdl %cl, %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: test17:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shrdl %cl, %esi, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
  %bits32 = xor i32 %bits, 31
  %lo2 = add i32 %lo, %lo
  %sh_lo = shl i32 %lo2, %bits32
  %sh_hi = lshr i32 %hi, %bits
  %sh = or i32 %sh_lo, %sh_hi
  ret i32 %sh
}
