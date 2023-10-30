$regfile = "m8def.dat"
$crystal = 8000000


Config Portb = Output
Config Portd = Output
Config Pinc.0 = Input
Config Pinc.1 = Input
Config Pinc.2 = Input
Config Pinc.3 = Input
Config Pinc.4 = Input


'##### прерывание

Config Timer0 = Timer , Prescale = 64 , Clear Timer = 0
'On Ocr2 Dimmer
On Ovf0 Refresh

'Ocr0a = 50

Enable Interrupts
Enable Ovf0

'#####

Dim N_line As Byte
Dim I As Byte
Dim J As Byte
Dim Temp As Byte
Dim Temp_1 As Byte
Dim Signal(8) As Byte

'Dim Flag_pos_i As Byte
'Dim Flag_pos_j As Byte

'(
For I = 2 To 8 Step 2
   J = I - 1
   Array(j) = Array(j) * &B100 + Line1
   Array(i) = Array(i) * &B100 + Line2
Next
')

Portb = 0
Portd = 0



Signal(1) = &B01111111
Signal(2) = &B10111111
Signal(3) = &B11011111
Signal(4) = &B11101111
Signal(5) = &B11110111
Signal(6) = &B11111011
Signal(7) = &B11111101
Signal(8) = &B11111110

I = 0

Do

   For I = 1 To 8
      Rotate Signal(i) , Right

   Next

   'Debounce Pinc.1 , 0 , Up_button , Sub
   'Debounce Pinc.2 , 0 , Down_button , Sub
   'Debounce Pinc.0 , 0 , Left_button , Sub
   'Debounce Pinc.3 , 0 , Right_button , Sub
   'Debounce Pinc.4 , 0 , Brightness_button , Sub

   Waitms 20

Loop

End





Up_button:
   Toggle Portd.0
   Waitms 50
Return




Down_button:

   Toggle Portd.5

   Waitms 50

Return




Left_button:

'(
   Temp_1 = Flag_pos_j Mod 8

   If Temp_1 <> 7 Then

      Temp = Signal(flag_pos_i)



   End If
')
   Toggle Portb.3

   Waitms 50

Return




Right_button:

   Toggle Portb.3

   Waitms 50

Return




Brightness_button:



   Waitms 50

Return


Refresh:
   Reset Portd
   Set Portb
   Incr N_line
   If N_line > 7 Then N_line = 0
   Portd = Signal(n_line)
   Reset Portb.n_line
Return

'(
Dimmer:
   Set Portb.n_line
Return
')