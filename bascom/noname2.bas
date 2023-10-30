$regfile "m8def.dat"
$crystal = 8000000

Config Pind.2 = Input
Config Portb = Output


Config Timer0 = Timer , Prescale = 256
'Off Ovf0 Refresh
Config Adc = Single , Prescaler = Auto , Reference = Internal

'Enable Interrupts
'Enable Ovf0

Dim I As Integer

I = 0
Dim Maxi As Byte
Maxi = 7

Portb = &B111

Start Adc

Do

'(
   If Getadc(2) >= 128 Then
      Portb.0 = 1
   Else
      Portb.0 = 0
   End If

   If Getadc(2) >= 256 Then
      Portb.1 = 1
   Else
      Portb.1 = 0
   End If

   If Getadc(2) >= 384 Then
      Portb.2 = 1
   Else
      Portb.2 = 0
   End If

   If Getadc(2) >= 512 Then
      Portb.3 = 1
   Else
      Portb.3 = 0
   End If

   If Getadc(2) >= 640 Then
      Portb.4 = 1
   Else
      Portb.4 = 0
   End If

   If Getadc(2) >= 768 Then
      Portb.5 = 1
   Else
      Portb.5 = 0
   End If

   If Getadc(2) >= 896 Then
      Portb.6 = 1
   Else
      Portb.6 = 0
   End If

   If Getadc(2) >= 1020 Then
      Portb.7 = 1
   Else
      Portb.7 = 0
   End If
')

   Dim Sign As Integer

   Sign = Getadc(2)

   Sign = Sign Mod 8

   Portb = 0

   Portb.sign = 1


   Waitms 400



Loop



Refresh:

   Rotate Portb , Left

Return

End


Pics:

Data &B10000000 , &B01000000 , &B00100000 , &B00010000
Data &B00001000 , &B00000100 , &B00000010 , &B00000001