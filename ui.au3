#include <Constants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>

Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

Global Const $NORMAL_SCREEN_COLOR = 0xfcfcfc
Global Const $ENTRY_SCREEN_COLOR = 0xffff00

Global $configFile = "config.ini"
Global $textEntryMode = False
Global $winWidth = 700 ; window width, should be read from the command line
Global $unitsPerGap = 1
Global $unitsPerButton = 4
Global $buttonsPerRow = 5
Global $unitsPerRow = ($buttonsPerRow * $unitsPerButton) + (($buttonsPerRow + 1) * $unitsPerGap)
Global $unit = $winWidth / $unitsPerRow
Global $btnSize = $unit * $unitsPerButton
Global $gapSize = $unit * $unitsPerGap
Global $screenLabelHeight = 2 * $btnSize
Global $winHeight = GetButtonPosTop(4) ; window height, should be read from the command line

Func GetButtonPosLeft($n)
	Local $res = $gapSize + ($btnSize * $n) + ($gapSize * $n)
	Return $res
EndFunc

Func GetButtonPosTop($n)
	Local $res = ($gapSize * 2) + $screenLabelHeight + ($btnSize * $n) + ($gapSize * $n)
	Return $res
EndFunc

Func GetButtonSize($n)
	Return ($n * $btnSize) + (($n - 1) * $gapSize)
EndFunc

Func CreateButton($label, $row, $col)
	Local $btn = GUICtrlCreateButton ($label, GetButtonPosLeft($col), GetButtonPosTop($row), $btnSize, $btnSize)
	; GUICtrlSetFont ( controlID, size [, weight [, attribute [, fontname [, quality]]]] )
	GUICtrlSetFont ($btn, $buttonFontSize); [, weight [, attribute [, fontname [, quality]]]] )
	Return $btn
EndFunc

Func CreateBigButton($label, $row, $col, $w, $h)
	Local $buttonWidth = GetButtonSize($w)
	Local $buttonHeight = GetButtonSize($h)
	Local $btn = GUICtrlCreateButton ($label, GetButtonPosLeft($col), GetButtonPosTop($row), $buttonWidth, $buttonHeight)
	GUICtrlSetFont ($btn, $buttonFontSize)
	Return $btn
EndFunc

Func OnClose()
	Exit
EndFunc

Func UpdateScreen()
	GUICtrlSetData($screen, $freqStr)
EndFunc

Func AddChar($ch)
	$freqStr &= $ch
	UpdateScreen()
EndFunc

Func DelChar()
	$freqStr = StringTrimRight ($freqStr, 1)
	UpdateScreen()
EndFunc

Func ClearScreen()
	$freqStr = ""
	UpdateScreen()
EndFunc

Func EnableTextEntryMode()
	$textEntryMode = True;
	GUICtrlSetBkColor($screen, $ENTRY_SCREEN_COLOR)
EndFunc

Func DisableTextEntryMode()
	$textEntryMode = False;
	GUICtrlSetBkColor($screen, $NORMAL_SCREEN_COLOR)
EndFunc

Func OnButtonPress()
	
	If $textEntryMode == False Then
		ClearScreen()
		EnableTextEntryMode()
	EndIf

	Switch @GUI_CtrlId
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
			; TODO: set frequency
			SendStr($freqStr)
			DisableTextEntryMode()
	EndSwitch
EndFunc

Func DrawUI()

	Global $hMainGUI = GUICreate("DSD+GUI", $winWidth, $winHeight)
	GUISetOnEvent($GUI_EVENT_CLOSE, "OnClose")
	; GUICtrlCreateLabel ( "text", left, top [, width [, height [, style = -1 [, exStyle = -1]]]] )
	Global $screen = GUICtrlCreateLabel($freqStr, $gapSize, $gapSize, $winWidth - ($gapSize * 2), $btnSize * 2, BitOR($SS_SUNKEN, $SS_RIGHT, $SS_CENTERIMAGE))
	; GUICtrlSetFont ( controlID, size [, weight [, attribute [, fontname [, quality]]]] )
	GUICtrlSetFont ($screen, $screenFontSize, 600, 0, $screenFontName);
	GUICtrlSetBkColor($screen, $NORMAL_SCREEN_COLOR)

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

	GUICtrlSetOnEvent($btn1, "OnButtonPress")
	GUICtrlSetOnEvent($btn2, "OnButtonPress")
	GUICtrlSetOnEvent($btn3, "OnButtonPress")
	GUICtrlSetOnEvent($btn4, "OnButtonPress")
	GUICtrlSetOnEvent($btn5, "OnButtonPress")
	GUICtrlSetOnEvent($btn6, "OnButtonPress")
	GUICtrlSetOnEvent($btn7, "OnButtonPress")
	GUICtrlSetOnEvent($btn8, "OnButtonPress")
	GUICtrlSetOnEvent($btn9, "OnButtonPress")
	GUICtrlSetOnEvent($btn0, "OnButtonPress")
	GUICtrlSetOnEvent($btnDot, "OnButtonPress")
	GUICtrlSetOnEvent($btnClear, "OnButtonPress")
	GUICtrlSetOnEvent($btnEnter, "OnButtonPress")

	GUISetState(@SW_SHOW, $hMainGUI)
EndFunc

Func SendStr($str)
	; WinActivate($FMPWin1)
	; WinActivate("[TITLE:FMP24  in]")
	SendKeepActive("[TITLE:FMP24  in]")
	Send($str & "{ENTER}")
	WinActivate($hMainGUI)
EndFunc

Func RunApps()
	Global $dsdPath = IniRead($configFile, "DSD", "path", "")
	Global $freqStr = IniRead($configFile, "DSD", "freq", "");'851.0375'
	Global $winWidth = IniRead($configFile, "UI", "width", "700")
	Global $screenFontName = IniRead($configFile, "UI", "screenFontName", "Courier New")
	Global $screenFontSize = IniRead($configFile, "UI", "screenFontSize", "72")
	Global $buttonFontSize = IniRead($configFile, "UI", "buttonFontSize", "36")
	
	FileChangeDir($dsdPath) ; set working dir
	Run("FMP24 -rc -i1 -o20001 -P0.0 -f851.0375")
	Global $FMPWin1 = WinWait("FMP24  in: 1", "", 2)



; START FMP24 -rc -i1 -o20001 -P0.0 -f851.0375
; timeout /t 1
; START FMP24 -rv -i2 -o20002 -P0.0
; timeout /t 1
; START DSDPlus -rc -fa -E -i20001 -v4 -O NUL
; timeout /t 1
; START DSDPlus -rv -fa -E -i20002 -v4 -O NUL

; win titles
; FMP24  in 1
; FMP24  in 2
; VC DSD
; CC DSD

EndFunc

RunApps()
DrawUI()

While 1
	Sleep(100) ; Sleep to reduce CPU usage
WEnd


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

; Local $hMainGUI = GUICreate("Hello World", 200, 100)
; GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")
; GUICtrlCreateLabel("Hello world! How are you?", 30, 10)
; Local $iOKButton = GUICtrlCreateButton("OK", 70, 50, 60)
; GUICtrlSetOnEvent($iOKButton, "OKButton")
; GUISetState(@SW_SHOW, $hMainGUI)

; While 1
;     Sleep(100) ; Sleep to reduce CPU usage
; WEnd

; Func OKButton()
;     ; Note: At this point @GUI_CtrlId would equal $iOKButton,
;     ; and @GUI_WinHandle would equal $hMainGUI
;     MsgBox($MB_OK, "GUI Event", "You selected OK!")
; EndFunc   ;==>OKButton

; Func CLOSEButton()
;     ; Note: At this point @GUI_CtrlId would equal $GUI_EVENT_CLOSE,
;     ; and @GUI_WinHandle would equal $hMainGUI
;     MsgBox($MB_OK, "GUI Event", "You selected CLOSE! Exiting...")
;     Exit
; EndFunc   ;==>CLOSEButton