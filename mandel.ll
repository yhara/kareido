declare i32 @putchar(i32)
define double @printdensity(double %d) {
  %reg1 = fcmp ogt double %d, 8.0
  br i1 %reg1, label %Then1, label %Else1
Then1:
  %reg2 = fptosi double 32.0 to i32
  %reg3 = call i32 @putchar(i32 %reg2)
  %reg4 = sitofp i32 %reg3 to double
  br label %EndIf1
Else1:
  %reg5 = fcmp ogt double %d, 4.0
  br i1 %reg5, label %Then2, label %Else2
Then2:
  %reg6 = fptosi double 46.0 to i32
  %reg7 = call i32 @putchar(i32 %reg6)
  %reg8 = sitofp i32 %reg7 to double
  br label %EndIf2
Else2:
  %reg9 = fcmp ogt double %d, 2.0
  br i1 %reg9, label %Then3, label %Else3
Then3:
  %reg10 = fptosi double 43.0 to i32
  %reg11 = call i32 @putchar(i32 %reg10)
  %reg12 = sitofp i32 %reg11 to double
  br label %EndIf3
Else3:
  %reg13 = fptosi double 42.0 to i32
  %reg14 = call i32 @putchar(i32 %reg13)
  %reg15 = sitofp i32 %reg14 to double
  br label %EndIf3
EndIf3:
  br label %EndIf2
EndIf2:
  br label %EndIf1
EndIf1:
  ret double 0.0
}
define double @mandleconverger(double %real, double %imag, double %iters, double %creal, double %cimag) {
  %reg16 = fcmp ogt double %iters, 255.0
  %reg17 = fmul double %real, %real
  %reg18 = fmul double %imag, %imag
  %reg19 = fadd double %reg17, %reg18
  %reg20 = fcmp ogt double %reg19, 4.0
  %reg21 = or i1 %reg16, %reg20
  br i1 %reg21, label %Then4, label %Else4
Then4:
  ret double %iters
  br label %EndIf4
Else4:
  %reg22 = fmul double %real, %real
  %reg23 = fmul double %imag, %imag
  %reg24 = fsub double %reg22, %reg23
  %reg25 = fadd double %reg24, %creal
  %reg26 = fmul double 2.0, %real
  %reg27 = fmul double %reg26, %imag
  %reg28 = fadd double %reg27, %cimag
  %reg29 = fadd double %iters, 1.0
  %reg30 = call double @mandleconverger(double %reg25, double %reg28, double %reg29, double %creal, double %cimag)
  ret double %reg30
  br label %EndIf4
EndIf4:
  ret double 0.0
}
define double @mandleconverge(double %real, double %imag) {
  %reg31 = call double @mandleconverger(double %real, double %imag, double 0.0, double %real, double %imag)
  ret double %reg31
  ret double 0.0
}
define double @mandelhelp(double %xmin, double %xmax, double %xstep, double %ymin, double %ymax, double %ystep) {
  br label %For2
For2:
  br label %Loop2
Loop2:
  %y = phi double [%ymin, %For2], [%fori2, %ForInc2]
  %forc2 = fcmp oge double %y, %ymax
  br i1 %forc2, label %EndFor2, label %ForBody2
ForBody2:
  br label %For1
For1:
  br label %Loop1
Loop1:
  %x = phi double [%xmin, %For1], [%fori1, %ForInc1]
  %forc1 = fcmp oge double %x, %xmax
  br i1 %forc1, label %EndFor1, label %ForBody1
ForBody1:
  %reg32 = call double @mandleconverge(double %x, double %y)
  %reg33 = call double @printdensity(double %reg32)
  br label %ForInc1
ForInc1:
  %fori1 = fadd double %x, %xstep
  br label %Loop1
EndFor1:
  %reg34 = fptosi double 10.0 to i32
  %reg35 = call i32 @putchar(i32 %reg34)
  %reg36 = sitofp i32 %reg35 to double
  br label %ForInc2
ForInc2:
  %fori2 = fadd double %y, %ystep
  br label %Loop2
EndFor2:
  ret double 0.0
}
define double @mandel(double %realstart, double %imagstart, double %realmag, double %imagmag) {
  %reg37 = fmul double %realmag, 78.0
  %reg38 = fadd double %realstart, %reg37
  %reg39 = fmul double %imagmag, 40.0
  %reg40 = fadd double %imagstart, %reg39
  %reg41 = call double @mandelhelp(double %realstart, double %reg38, double %realmag, double %imagstart, double %reg40, double %imagmag)
  ret double %reg41
  ret double 0.0
}
define i32 @main() {
  %reg42 = fsub double 0.0, 2.3
  %reg43 = fsub double 0.0, 1.3
  %reg44 = call double @mandel(double %reg42, double %reg43, double 0.05, double 0.07)
  ret i32 0
}
