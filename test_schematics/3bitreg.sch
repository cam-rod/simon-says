EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text GLabel 3250 2850 0    50   Input ~ 0
reset
$Comp
L 74xGxx:74AUC1G79 U?
U 1 1 5FE7F006
P 4650 2850
F 0 "U?" H 4650 3167 50  0000 C CNN
F 1 "74AUC1G79" H 4650 3076 50  0000 C CNN
F 2 "" H 4650 2850 50  0001 C CNN
F 3 "http://www.ti.com/lit/sg/scyt129e/scyt129e.pdf" H 4650 2850 50  0001 C CNN
	1    4650 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	3900 2950 4250 2950
$Comp
L 74xGxx:74AUC1G79 U?
U 1 1 5FE7F6A4
P 6150 2850
F 0 "U?" H 6150 3167 50  0000 C CNN
F 1 "74AUC1G79" H 6150 3076 50  0000 C CNN
F 2 "" H 6150 2850 50  0001 C CNN
F 3 "http://www.ti.com/lit/sg/scyt129e/scyt129e.pdf" H 6150 2850 50  0001 C CNN
	1    6150 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 2950 4250 3100
Wire Wire Line
	4250 3100 5500 3100
Wire Wire Line
	5500 3100 5500 2950
Text HLabel 3200 2050 0    50   Input ~ 0
clr
$Comp
L 74xGxx:74AUC1G79 U?
U 1 1 5FE7FF35
P 7800 2850
F 0 "U?" H 7800 3167 50  0000 C CNN
F 1 "74AUC1G79" H 7800 3076 50  0000 C CNN
F 2 "" H 7800 2850 50  0001 C CNN
F 3 "http://www.ti.com/lit/sg/scyt129e/scyt129e.pdf" H 7800 2850 50  0001 C CNN
	1    7800 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	5500 3100 6600 3100
Wire Wire Line
	6600 3100 6600 2950
Connection ~ 5500 3100
$Comp
L Analog_Switch:NC7SB3157L6X U?
U 1 1 5FE83115
P 4050 2450
F 0 "U?" H 4050 2692 50  0000 C CNN
F 1 "NC7SB3157L6X" H 4050 2601 50  0000 C CNN
F 2 "Package_SON:Fairchild_MicroPak-6_1.0x1.45mm_P0.5mm" H 4050 2150 50  0001 C CNN
F 3 "https://www.onsemi.com/pub/Collateral/NC7SB3157-D.PDF" H 4050 2450 50  0001 C CNN
	1    4050 2450
	-1   0    0    -1  
$EndComp
$Comp
L Analog_Switch:NC7SB3157L6X U?
U 1 1 5FE83824
P 5450 2450
F 0 "U?" H 5450 2692 50  0000 C CNN
F 1 "NC7SB3157L6X" H 5450 2601 50  0000 C CNN
F 2 "Package_SON:Fairchild_MicroPak-6_1.0x1.45mm_P0.5mm" H 5450 2150 50  0001 C CNN
F 3 "https://www.onsemi.com/pub/Collateral/NC7SB3157-D.PDF" H 5450 2450 50  0001 C CNN
	1    5450 2450
	-1   0    0    -1  
$EndComp
$Comp
L Analog_Switch:NC7SB3157L6X U?
U 1 1 5FE845BE
P 7050 2450
F 0 "U?" H 7050 2692 50  0000 C CNN
F 1 "NC7SB3157L6X" H 7050 2601 50  0000 C CNN
F 2 "Package_SON:Fairchild_MicroPak-6_1.0x1.45mm_P0.5mm" H 7050 2150 50  0001 C CNN
F 3 "https://www.onsemi.com/pub/Collateral/NC7SB3157-D.PDF" H 7050 2450 50  0001 C CNN
	1    7050 2450
	-1   0    0    -1  
$EndComp
Entry Wire Line
	3450 2050 3550 2150
Entry Wire Line
	4800 2050 4900 2150
Entry Wire Line
	6300 2050 6400 2150
Wire Wire Line
	4350 2550 4350 2750
Wire Wire Line
	5750 2750 5750 2550
Wire Wire Line
	7350 2550 7350 2750
Wire Wire Line
	7350 2750 7550 2750
Wire Wire Line
	5500 2950 5900 2950
Wire Wire Line
	6600 2950 7550 2950
Wire Wire Line
	3200 2200 3650 2200
Wire Wire Line
	3650 2200 3650 2450
Wire Wire Line
	3650 2450 3750 2450
Connection ~ 3650 2200
Wire Wire Line
	3650 2200 5050 2200
Wire Wire Line
	3550 2150 3550 2650
Wire Wire Line
	3550 2650 3750 2650
Wire Wire Line
	5150 2650 4900 2650
Wire Wire Line
	4900 2650 4900 2150
Wire Wire Line
	5050 2200 5050 2450
Wire Wire Line
	5050 2450 5150 2450
Connection ~ 5050 2200
Wire Wire Line
	6750 2450 6550 2450
Wire Wire Line
	5050 2200 6550 2200
Wire Wire Line
	6550 2200 6550 2450
Wire Wire Line
	6400 2150 6400 2650
Wire Wire Line
	6400 2650 6750 2650
$Comp
L power:GND #PWR?
U 1 1 5FE8AEBB
P 3200 2200
F 0 "#PWR?" H 3200 1950 50  0001 C CNN
F 1 "GND" V 3205 2072 50  0000 R CNN
F 2 "" H 3200 2200 50  0001 C CNN
F 3 "" H 3200 2200 50  0001 C CNN
	1    3200 2200
	0    1    1    0   
$EndComp
Wire Wire Line
	3250 2850 3500 2850
Wire Wire Line
	3500 2850 3500 3250
Wire Wire Line
	3500 3250 5450 3250
Wire Wire Line
	5450 3250 5450 2850
Connection ~ 3500 2850
Wire Wire Line
	3500 2850 4050 2850
Wire Wire Line
	5450 3250 7050 3250
Wire Wire Line
	7050 3250 7050 2850
Connection ~ 5450 3250
Text HLabel 3900 2950 0    50   Input ~ 0
load_clr
Text Label 3550 2650 0    50   ~ 0
clr[2]
Text Label 4900 2650 0    50   ~ 0
clr[1]
Text Label 6400 2650 0    50   ~ 0
clr[0]
Wire Wire Line
	5900 2750 5750 2750
Wire Wire Line
	4400 2750 4350 2750
Wire Wire Line
	4400 2950 4250 2950
Connection ~ 4250 2950
Text HLabel 8850 3500 2    50   Input ~ 0
clr_out
Entry Wire Line
	8350 3400 8450 3500
Entry Wire Line
	6750 3400 6850 3500
Entry Wire Line
	5200 3400 5300 3500
Wire Wire Line
	8350 3400 8350 2750
Wire Wire Line
	8350 2750 8050 2750
Wire Wire Line
	4900 2750 5200 2750
Wire Wire Line
	5200 2750 5200 3400
Wire Wire Line
	6400 2750 6750 2750
Wire Wire Line
	6750 2750 6750 3400
Wire Bus Line
	3200 2050 6300 2050
Wire Bus Line
	5300 3500 8850 3500
Text Label 4900 2750 0    50   ~ 0
cout[2]
Text Label 6400 2750 0    50   ~ 0
cout[1]
Text Label 8050 2750 0    50   ~ 0
cout[0]
$EndSCHEMATC
