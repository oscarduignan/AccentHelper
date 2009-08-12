#Include <Misc.au3>
#Include <Clipboard.au3>
#NoTrayIcon

FileInstall(".\taskbar.ico", ".\")

_Singleton("LanguageTools")

; -----------------------------------------
; Configure tray menu
; -----------------------------------------

Opt("TrayOnEventMode",1)
Opt("TrayMenuMode", 1)

Global $sequencesMenu = TrayCreateMenu("Character Set")
Global $sequences[2]
$sequences[0] = TrayCreateItem("All", $sequencesMenu)
$sequences[1] = TrayCreateItem("Limited (spanish, greek, danish)", $sequencesMenu)
TrayCreateItem("")
Global $exitItem = TrayCreateItem("Exit")

TrayItemSetOnEvent($sequences[0], "SetSequenceToAll")
TrayItemSetOnEvent($sequences[1], "SetSequenceToDanishGreekSpanish")
TrayItemSetOnEvent($exitItem,"ExitScript")

TraySetState()
TraySetToolTip("Accent Helper (Hotkey = F8)")
TraySetIcon("taskbar.ico")

; -----------------------------------------
; Configure settings
; -----------------------------------------

HotKeySet("{F8}", "GetNextCharacter")

; -----------------------------------------
; Sequences
; -----------------------------------------

Global $_all = "aáàåâäãæαaAÁÀÅÂÄÃÆΔAbβbcχçcCÇCdδϝðdDΔϜÐDeéèêëεηeEÉÈÊËEfƒfgγgGΓGiíìîïιiIÍÌÎÏIkκklλlLΛLoóòôöõøωoOÓÒÔÖÕØΩOpπφψpPΠΦΨPuúùûüυuUÚÙÛÜUmμmnñnNÑNrρrsšσsSΣStθτtTΘTxξxXΞXyýyYÝYzžzZŽZzζz"
Global $_danishgreekspanish = "aáåæαaAÁÅÆΔAbβbcχcdδϝdDΔϜDeéεηeEÉEgγgGΓGiíιiIÍIkκklλlLΛLoóøωoOÓØΩOpπφψpPΠΦΨPuúüυuUÚÜUmμmnñnNÑNrρrsσsSΣStθτtTΘTxξxXΞXzζz"
Global $_symbols = "1¹12²23³34⁴45⁵56⁶67⁷78⁸89⁹90⁰0)⁾)(⁽(=≠⁼=-⁻-+±⁺+%÷%<≤«‹<>≥»›>*×✩*|/\|'′″‴'.•·.!¡!?¿?£€¢¥£"

If IniRead("config.ini", "settings", "sequence", "all") == "danishgreekspanish" Then
	Global $_sequence = $_danishgreekspanish & $_symbols
	TrayItemSetState($sequences[1], 1)
Else
	Global $_sequence = $_all & $_symbols
	TrayItemSetState($sequences[0], 1)
EndIf

; -----------------------------------------
; Body loop
; -----------------------------------------

While 1
	Sleep(10) ; Idle Loop
WEnd

; -----------------------------------------
; Functions
; -----------------------------------------

Func GetNextCharacter()
    $clipboard = ClipGet()
    ClipPut("")
    
    Send("+{LEFT}^c")
    Sleep(100)

    $charPosition = StringInStr($_sequence, ClipGet(), 1)
    
    If $charPosition > 0 Then
        ClipPut(StringMid($_sequence, $charPosition+1, 1))
        Send("^v")
    Else
        Send("{RIGHT}")
    EndIf
    
	ClipPut($clipboard)
EndFunc

Func SetSequenceToAll()
	$_sequence = $_all & $_symbols
	IniWrite("config.ini", "settings", "sequence", "all")
	TrayItemSetState($sequences[0], 1)
	TrayItemSetState($sequences[1], 4)
EndFunc

Func SetSequenceToDanishGreekSpanish()
	$_sequence = $_danishgreekspanish & $_symbols
	IniWrite("config.ini", "settings", "sequence", "danishgreekspanish")
	TrayItemSetState($sequences[0], 4)
	TrayItemSetState($sequences[1], 1)
EndFunc

Func ExitScript()
    Exit
EndFunc
