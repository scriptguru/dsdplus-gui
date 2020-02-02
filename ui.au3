#include <Constants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>

Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

Global Const $NORMAL_SCREEN_COLOR = 0xfcfcfc
Global Const $ENTRY_SCREEN_COLOR = 0xffff00

; win titles
; FMP24  in 1
; FMP24  in 2
; VC DSD
; CC DSD

Global $configFile = "config.ini"
Global $winWidth = IniRead($configFile, "UI", "width", "700")
Global $textEntryMode = False
Global $tabHeight = 80
Global $unitsPerGap = 1
Global $unitsPerButton = 4
Global $buttonsPerRow = 5
Global $unitsPerRow = ($buttonsPerRow * $unitsPerButton) + (($buttonsPerRow + 1) * $unitsPerGap)
Global $unit = $winWidth / $unitsPerRow
Global $btnSize = $unit * $unitsPerButton
Global $gapSize = $unit * $unitsPerGap
Global $screenLabelHeight = 2 * $btnSize
Global $winHeight = GetButtonPosTop(4)
Global $stepVal = ""
Global $bandVal = ""
Global $gainVal = ""
Global $freqStr = ""
Global $fmpxWinTitle = IniRead($configFile, "DSD", "fmpx_win_title", "")
Global $dsdWinTitle = IniRead($configFile, "DSD", "dsd_win_title", "")
Global $buttonPressHandler = ""

Func UpdateStep()
	GUICtrlSetData($labelStep, "Step: " & $stepVal)
EndFunc

Func UpdateBand()
	GUICtrlSetData($labelBand, "Bandwidth: " & $bandVal)
EndFunc

Func UpdateGain()
	GUICtrlSetData($labelGain, "Gain: " & $gainVal)
EndFunc

Func GetButtonPosLeft($n)
	Local $res = $gapSize + ($btnSize * $n) + ($gapSize * $n)
	Return $res
EndFunc

Func GetButtonPosTop($n)
	Local $res = ($gapSize * 2) + $screenLabelHeight + ($btnSize * $n) + ($gapSize * $n) + $tabHeight
	Return $res
EndFunc

Func GetButtonSize($n)
	Return ($n * $btnSize) + (($n - 1) * $gapSize)
EndFunc

Func CreateButton($label, $row, $col)
	Local $btn = GUICtrlCreateButton ($label, GetButtonPosLeft($col), GetButtonPosTop($row), $btnSize, $btnSize)
	GUICtrlSetFont ($btn, $buttonFontSize)
	GUICtrlSetOnEvent($btn, $buttonPressHandler)
	Return $btn
EndFunc

Func CreateBigButton($label, $row, $col, $w, $h)
	Local $buttonWidth = GetButtonSize($w)
	Local $buttonHeight = GetButtonSize($h)
	Local $btn = GUICtrlCreateButton ($label, GetButtonPosLeft($col), GetButtonPosTop($row), $buttonWidth, $buttonHeight)
	GUICtrlSetFont ($btn, $buttonFontSize)
	GUICtrlSetOnEvent($btn, $buttonPressHandler)
	Return $btn
EndFunc

; GUICtrlCreateLabel ( "text", left, top [, width [, height [, style = -1 [, exStyle = -1]]]] )
Func CreateLabel($text, $row, $col, $w, $h)
	Local $buttonWidth = GetButtonSize($w)
	Local $buttonHeight = GetButtonSize($h)
	Local $btn = GUICtrlCreateLabel($text, GetButtonPosLeft($col), GetButtonPosTop($row), $buttonWidth, $buttonHeight, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetFont ($btn, $buttonFontSize)
	Return $btn
EndFunc

Func OnClose()
	Exit
EndFunc

Func UpdateFreq()
	GUICtrlSetData($screen, $freqStr)
EndFunc

Func AddChar($ch)
	$freqStr &= $ch
	UpdateFreq()
EndFunc

Func DelChar()
	$freqStr = StringTrimRight ($freqStr, 1)
	UpdateFreq()
EndFunc

Func ClearScreen()
	$freqStr = ""
	UpdateFreq()
EndFunc

Func EnableTextEntryMode()
	$textEntryMode = True;
	GUICtrlSetBkColor($screen, $ENTRY_SCREEN_COLOR)
EndFunc

Func DisableTextEntryMode()
	$textEntryMode = False;
	GUICtrlSetBkColor($screen, $NORMAL_SCREEN_COLOR)
EndFunc

Func OnInputButtonPress()
	
	If $textEntryMode == False Then
		ClearScreen()
		EnableTextEntryMode()
	EndIf

	Switch @GUI_CtrlId
		; Input
		Case $btn1
			AddChar("1")
		Case $btn2
			AddChar("2")
		Case $btn3
			AddChar("3")
		Case $btn4
			AddChar("4")
		Case $btn5
			AddChar("5")
		Case $btn6
			AddChar("6")
		Case $btn7
			AddChar("7")
		Case $btn8
			AddChar("8")
		Case $btn9
			AddChar("9")
		Case $btn0
			AddChar("0")
		Case $btnDot
			AddChar(".")
		Case $btnClear
			DelChar()
		Case $btnEnter
			If $freqStr Then
				SendStr($freqStr & "{ENTER}", $fmpxWinTitle)
			EndIf
			DisableTextEntryMode()
			ParseWindowTitle($fmpxWinTitle, True)
			UpdateFreq()
	EndSwitch
EndFunc

Func OnOtherButtonPress()
	
	Switch @GUI_CtrlId
		; Stepping
		Case $btnIncStep
			SendStr("]", $fmpxWinTitle)
			ParseWindowTitle($fmpxWinTitle, False)
			UpdateStep()

		Case $btnDecStep
			SendStr("[", $fmpxWinTitle)
			ParseWindowTitle($fmpxWinTitle, False)
			UpdateStep()

		Case $btnStepFwd
			SendStr("{RIGHT}", $fmpxWinTitle)
			ParseWindowTitle($fmpxWinTitle, True)
			UpdateFreq()

		Case $btnStepBack
			SendStr("{LEFT}", $fmpxWinTitle)
			ParseWindowTitle($fmpxWinTitle, True)
			UpdateFreq()

		Case $btn250Back
			SendStr("^{LEFT}", $fmpxWinTitle)
			ParseWindowTitle($fmpxWinTitle, True)
			UpdateFreq()

		Case $btn250Fwd
			SendStr("^{RIGHT}", $fmpxWinTitle)
			ParseWindowTitle($fmpxWinTitle, True)
			UpdateFreq()

		; Bandwidth
		Case $btnIncBand
			SendStr("+b", $fmpxWinTitle)
			ParseWindowTitle($fmpxWinTitle, False)
			UpdateBand()

		Case $btnDecBand
			SendStr("b", $fmpxWinTitle)
			ParseWindowTitle($fmpxWinTitle, False)
			UpdateBand()

		; Gain
		Case $btnIncGain
			SendStr("+g", $fmpxWinTitle)
			ParseWindowTitle($fmpxWinTitle, False)
			UpdateGain()

		Case $btnDecGain
			SendStr("g", $fmpxWinTitle)
			ParseWindowTitle($fmpxWinTitle, False)
			UpdateGain()
	EndSwitch
EndFunc

Func ParseWindowTitle($dest, $getFreq)
	; FMP24  FM 851.03750+36 Hz  Step: 6.25  BW: 7.6  Gain: 49.6
	Local $winTitle = "[TITLE:" & $dest & "; CLASS:Spectrum]"
	Local $fullTitle = WinGetTitle($winTitle, "")
	ParseStep($fullTitle)
	ParseBand($fullTitle)
	ParseGain($fullTitle)
	If $getFreq Then
		ParseFreq($fullTitle)
	EndIf
EndFunc

Func ParseStep($str)
	Local $match = StringRegExp($str, 'Step: ([^ ]+)', $STR_REGEXPARRAYMATCH)
	If Not @error Then
		$stepVal = $match[0]
	EndIf
EndFunc

Func ParseBand($str)
	Local $match = StringRegExp($str, 'BW: ([^ ]+)', $STR_REGEXPARRAYMATCH)
	If Not @error Then
		$bandVal = $match[0]
	EndIf
EndFunc

Func ParseGain($str)
	Local $match = StringRegExp($str, 'Gain: ([^ ]+)', $STR_REGEXPARRAYMATCH)
	If Not @error Then
		$gainVal = $match[0]
	EndIf
EndFunc

Func ParseFreq($str)
	Local $match = StringRegExp($str, 'FM ([^-+ ]+)', $STR_REGEXPARRAYMATCH)
	If Not @error Then
		$freqStr = $match[0]
	EndIf
EndFunc

Func DrawUI()

	; Global $freqStr = IniRead($configFile, "DSD", "freq", "") ; should be read from the FMPx window
	Global $screenFontName = IniRead($configFile, "UI", "screenFontName", "Courier New")
	Global $screenFontSize = IniRead($configFile, "UI", "screenFontSize", "72")
	Global $buttonFontSize = IniRead($configFile, "UI", "buttonFontSize", "36")

	Global $hMainGUI = GUICreate("DSD+GUI", $winWidth, $winHeight)
	GUISetOnEvent($GUI_EVENT_CLOSE, "OnClose")
	; GUICtrlCreateLabel ( "text", left, top [, width [, height [, style = -1 [, exStyle = -1]]]] )
	Global $screen = GUICtrlCreateLabel($freqStr, $gapSize, $gapSize, $winWidth - ($gapSize * 2), $btnSize * 2, BitOR($SS_SUNKEN, $SS_RIGHT, $SS_CENTERIMAGE))
	; GUICtrlSetFont ( controlID, size [, weight [, attribute [, fontname [, quality]]]] )
	GUICtrlSetFont ($screen, $screenFontSize, 600, 0, $screenFontName);
	GUICtrlSetBkColor($screen, $NORMAL_SCREEN_COLOR)

	$cTab = GUICtrlCreateTab(0, GetButtonPosTop(0) - $tabHeight, $winWidth, $winHeight)
	$cTab_0 = GUICtrlCreateTabItem("Input")
	$cTab_1 = GUICtrlCreateTabItem("Scan")
	$cTab_2 = GUICtrlCreateTabItem("Settings")
	GUICtrlCreateTabItem("")

	GUICtrlSetFont ($cTab, $buttonFontSize)

	GUISwitch($hMainGUI, $cTab_0)
	$buttonPressHandler = "OnInputButtonPress"
	Global $btn1 = CreateButton("1", 0, 0)
	Global $btn2 = CreateButton("2", 0, 1)
	Global $btn3 = CreateButton("3", 0, 2)

	Global $btn4 = CreateButton("4", 1, 0)
	Global $btn5 = CreateButton("5", 1, 1)
	Global $btn6 = CreateButton("6", 1, 2)
	
	Global $btn7 = CreateButton("7", 2, 0)
	Global $btn8 = CreateButton("8", 2, 1)
	Global $btn9 = CreateButton("9", 2, 2)
	
	Global $btnClear = CreateButton("CL", 3, 0)
	Global $btn0 = CreateButton("0", 3, 1)
	Global $btnDot = CreateButton(".", 3, 2)
	
	Global $btnEnter = CreateBigButton("Enter", 0, 3, 2, 4)

	GUISwitch($hMainGUI, $cTab_1)
	$buttonPressHandler = "OnOtherButtonPress"
	Global $btnDecStep = CreateButton("Dec", 0, 0)
	Global $labelStep = CreateLabel("Step: " & $stepVal, 0, 1, 3, 1)
	Global $btnIncStep = CreateButton("Inc", 0, 4)
	Global $btnStepBack = CreateBigButton("< Step", 1, 0, 2, 1)
	Global $btnStepFwd = CreateBigButton("Step >", 1, 3, 2, 1)
	Global $btn250Back = CreateBigButton("< 250Hz", 2, 0, 2, 1)
	Global $btn250Fwd = CreateBigButton("250Hz >", 2, 3, 2, 1)

	GUISwitch($hMainGUI, $cTab_2)
	Global $btnDecGain = CreateButton("Dec", 0, 0)
	Global $labelGain = CreateLabel("Gain: " & $gainVal, 0, 1, 3, 1)
	Global $btnIncGain = CreateButton("Inc", 0, 4)
	Global $btnDecBand = CreateButton("Dec", 1, 0)
	Global $labelBand = CreateLabel("Bandwidth: " & $bandVal, 1, 1, 3, 1)
	Global $btnIncBand = CreateButton("Inc", 1, 4)

	GUISwitch($hMainGUI)

	GUISetState(@SW_SHOW, $hMainGUI)
EndFunc

; '!'
; This tells AutoIt to send an ALT keystroke, therefore Send("This is text!a") would send the keys "This is text" and then press "ALT+a".
; N.B. Some programs are very choosy about capital letters and ALT keys, i.e., "!A" is different from "!a". The first says ALT+SHIFT+A, the second is ALT+a. If in doubt, use lowercase!

; '+'
; This tells AutoIt to send a SHIFT keystroke; therefore, Send("Hell+o") would send the text "HellO". Send("!+a") would send "ALT+SHIFT+a".

; '^'
; This tells AutoIt to send a CONTROL keystroke; therefore, Send("^!a") would send "CTRL+ALT+a".
; N.B. Some programs are very choosy about capital letters and CTRL keys, i.e., "^A" is different from "^a". The first says CTRL+SHIFT+A, the second is CTRL+a. If in doubt, use lowercase!

; '#'
; The hash now sends a Windows keystroke; therefore, Send("#r") would send Win+r which launches the Run() dialog box.
Func SendStr($str, $dest)
	Local $winTitle = "[TITLE:" & $dest & "; CLASS:Spectrum]"
	WinActivate($winTitle)
	Send($str)
	WinActivate($hMainGUI)
EndFunc

ParseWindowTitle($fmpxWinTitle, True)
DrawUI()

While 1
	Sleep(100) ; Sleep to reduce CPU usage
WEnd
