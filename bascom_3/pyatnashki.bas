$regfile = "m8def.dat"
$crystal = 8000000

' Изменил!!!! output на input
Config Portb = Input
Config Portd = Output
Config Pinc.0 = Input
Config Pinc.1 = Input
Config Pinc.2 = Input
Config Pinc.3 = Input
Config Pinc.4 = Input

Config Debounce = 2


'##### прерывание

'Config Timer = Timer , Prescale = 8 , Clear Timer = 0
Config Timer1 = Timer , Prescale = 1024
Config Timer2 = Timer , Prescale = 8 , Clear Timer = 0
'On Oc2 Dimmer
On Timer2 Refresh


Enable Interrupts
Enable Timer2
'Enable Oc2

'#####



'##### variables

Dim Count As Byte

Dim Signal(8) As Byte
Dim Signal_e(8) As Eram Byte

Dim Flag_i As Byte
Dim Flag_j As Byte

Dim Next_i As Byte
Dim Next_j As Byte

Dim I As Byte
Dim J As Byte

Dim Two_step As Byte

Dim Temp As Bit
Dim Temp_byte As Byte

Dim Status_e As Eram Byte
Dim Flag_i_e As Eram Byte
Dim Flag_j_e As Eram Byte



' #####


If Status_e = 1 Then
   For I = 1 To 8
      Signal(i) = Signal_e(i)
   Next
   Flag_i = Flag_i_e
   Flag_j = Flag_j_e

   Temp_byte = Status_e
   Status_e = 0

End If

If Temp_byte = 1 Then
   Goto Game:
End If

' #####



Portb = 0
Portd = 0


Signal(1) = 0
Signal(2) = 0
Signal(3) = 0
Signal(4) = 0
Signal(5) = 0
Signal(6) = 0
Signal(7) = 0
Signal(8) = 0


Start Timer2

I = 1
Dim Delitel As Byte
Delitel = 16

Dim Polozh(16) As Byte
Polozh(1) = 1
Polozh(2) = 2
Polozh(3) = 3
Polozh(4) = 4
Polozh(5) = 5
Polozh(6) = 6
Polozh(7) = 7
Polozh(8) = 8
Polozh(9) = 9
Polozh(10) = 10
Polozh(11) = 11
Polozh(12) = 12
Polozh(13) = 13
Polozh(14) = 14
Polozh(15) = 15
Polozh(16) = 16


' ##### Временная штука!!!!
'Ocr2 = 8

Dim Cifra As Byte
Cifra = 1
While Cifra <= 16

   Debounce Pinc.1 , 0 , Random , Sub
   Debounce Pinc.2 , 0 , Random , Sub
   Debounce Pinc.0 , 0 , Random , Sub
   Debounce Pinc.3 , 0 , Random , Sub

Wend

Stop Timer1


Game:

Start Timer2


Do

   Debounce Pinc.1 , 0 , Up_button , Sub
   Debounce Pinc.2 , 0 , Down_button , Sub
   Debounce Pinc.0 , 0 , Left_button , Sub
   Debounce Pinc.3 , 0 , Right_button , Sub
   Debounce Pinc.4 , 0 , Brightness_button , Sub

Loop

Stop Timer2

End


Random:
   Temp_byte = Timer1
   Temp_byte = Temp_byte Mod Delitel
   Temp_byte = Temp_byte + 1
   Dim Mas As Byte
   Mas = Temp_byte
   Temp_byte = Polozh(mas)

   Dim Temp_1 As Byte
   Temp_1 = Delitel - 1
   For I = Mas To Temp_1
      J = I + 1
      Polozh(i) = Polozh(j)
   Next
   Erase Temp_1
   Erase Mas


   Flag_i = Temp_byte - 1
   Flag_i = Flag_i / 4                                      ' 0(1-4), 1(5-8), 2(9-12), 3(13-16)
   Flag_i = Flag_i * 2
   'Flag_i = Flag_i / 2
   Flag_i = Flag_i + 1

   Flag_j = Temp_byte - 1
   Flag_j = Flag_j Mod 4                                    ' 1(1,5,9,13), 2(2,6,10,14), 3(3,7,11,15), 0(4,8,12,16)
   Flag_j = Flag_j * 2

   Next_i = Flag_i + 1
   Next_j = Flag_j + 1

   Temp_byte = Lookup(cifra , Digit)
   Signal(flag_i).flag_j = Temp_byte.3
   Signal(flag_i).next_j = Temp_byte.2
   Signal(next_i).flag_j = Temp_byte.1
   Signal(next_i).next_j = Temp_byte.0


   Delitel = Delitel - 1
   Cifra = Cifra + 1


Return


Up_button:

   If Flag_i <> 7 Then

        Next_i = Flag_i + 1
        Next_j = Flag_j + 1

        For I = Flag_i To Next_i
           Two_step = I + 2
           For J = Flag_j To Next_j
              Temp = Signal(i).j
              Signal(i).j = Signal(two_step).j
              Signal(two_step).j = Temp
           Next
        Next

        Flag_i = Flag_i + 2

   End If

   Waitms 20
Return


Down_button:

   If Flag_i <> 1 Then

        Next_i = Flag_i + 1
        Next_j = Flag_j + 1

        For I = Flag_i To Next_i
           Two_step = I - 2
           For J = Flag_j To Next_j
              Temp = Signal(i).j
              Signal(i).j = Signal(two_step).j
              Signal(two_step).j = Temp
           Next
        Next

        Flag_i = Flag_i - 2

   End If

   Waitms 20
Return


Left_button:

   If Flag_j <> 6 Then

        Next_i = Flag_i + 1
        Next_j = Flag_j + 1

        For J = Flag_j To Next_j
           Two_step = J + 2
           For I = Flag_i To Next_i
              Temp = Signal(i).j
              Signal(i).j = Signal(i).two_step
              Signal(i).two_step = Temp
           Next
        Next

        Flag_j = Flag_j + 2

   End If

   Waitms 20
Return


Right_button:

   If Flag_j <> 0 Then

        Next_i = Flag_i + 1
        Next_j = Flag_j + 1

        For J = Flag_j To Next_j
           Two_step = J - 2
           For I = Flag_i To Next_i
              Temp = Signal(i).j
              Signal(i).j = Signal(i).two_step
              Signal(i).two_step = Temp
           Next
        Next

        Flag_j = Flag_j - 2

   End If

   Waitms 20
Return


Brightness_button:
'(   If Ocr2 <> 1 Then
      Ocr2 = Ocr2 - 1
   Else
      Ocr2 = 7
   End If
')

   Flag_i_e = Flag_i
   Flag_j_e = Flag_j

   For I = 1 To 8
      Signal_e(i) = Signal(i)
   Next
   Status_e = 1

   Waitms 100
Return


Refresh:
   Portb = &B11111111
   Incr Count : If Count > 8 Then Count = 1
   Portd = Signal(count)
   Select Case Count
      Case 1 : Reset Portb.7
      Case 2 : Reset Portb.6
      Case 3 : Reset Portb.5
      Case 4 : Reset Portb.4
      Case 5 : Reset Portb.3
      Case 6 : Reset Portb.2
      Case 7 : Reset Portb.1
      Case 8 : Reset Portb.0
   End Select
Return


Dimmer:
   Portb = &B11111111
Return


Digit:

Data &B0000 , &B0001 , &B0010 , &B0011 , &B0100 , &B0101 , &B0110 , &B0111
Data &B1000 , &B1001 , &B1010 , &B1011 , &B1100 , &B1101 , &B1110 , &B1111
Data &B0000