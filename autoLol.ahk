#SingleInstance force
#Include Sikulix.ahk

PlayRanked() {
  click(LoLLocation(130, 50))
  Sleep 1000
  click(LoLLocation(120, 575))
  Sleep 1000
  click(LoLLocation(485, 688))
}

ReadIni() {
  Global Pick, Ban, Primary, Secondary, Password
  IniRead, Pick, autoLol.ini, autoLol, Pick,
  IniRead, Ban, autoLol.ini, autoLol, Ban,
  IniRead, Primary, autoLol.ini, autoLol, Primary, mid
  IniRead, Secondary, autoLol.ini, autoLol, Secondary, jg
  IniRead, Password, autoLol.ini, autoLol, Password, jg
}
ReadIni()

TestLane(lane) {
  l := PorLane(Location(0,0),lane)
  if l.isLocation() {
    return 1
  }
  return 0
}

EditIni() {
  Global Pick, Ban, Primary, Secondary, Password
  RunWait notepad autoLol.ini
  ReadIni()
  if (!(TestLane(Primary) && TestLane(Secondary))) {
    MsgBox As lanes devem ser: top, jg, mid, adc, sup, any
    EditIni()
  }
}

PorLane(l, lane) {
  if (lane = "top") {
    return l.targetOffset(-150, 0)
  }
  else if (lane = "jg") {
    return l.targetOffset(-150, -150)
  }
  else if (lane = "mid") {
    return l.targetOffset(0, -150)
  }
  else if (lane = "adc") {
    return l.targetOffset(150, -150)
  }
  else if (lane = "sup") {
    return l.targetOffset(150, 0)
  }
  else if (lane = "any") {
    return l.targetOffset(0, 150)
  }
}

LoLLocation(_x, _y) {
  WinGetPos, X, Y, width, height, League of Legends
  if (X >= 0) {
    return Location(_x+X, _y+Y)
  }
}

PorChamp(name) {
  click(LoLLocation(830, 110))
  Sleep 500
  type(name)
  Sleep 1000
  click(LoLLocation(379, 167))
  Sleep 1500
  click(LoLLocation(637, 604))
}

While True {
  if !WinExist("League of Legends") {
    Sleep 1000
    Continue
  }
  Break
}

While True {
  if WinExist("League of Legends (TM) Client") {
    ExitApp
  }
  if !WinExist("League of Legends") {
    ExitApp
  }
  if !WinActive("League of Legends") {
    Sleep 1000
    Continue
  }

  ; MsgBox Ini

  if exists("Login.bmp") {
    login := Pattern("Login.bmp").targetOffset(-6,-183).exists()
    click(login)
    type(Password)
    click(login.targetOffset(0, 300))
  }
  else if exists("Chat1.bmp") {
    click(Pattern("Chat1.bmp").targetOffset(86, -332))
  }
  else if exists("Chat2.bmp") {
    click(Pattern("Chat2.bmp").targetOffset(86, -332))
  }
  else if exists("EscolherLane.bmp") {
    pri := Pattern("EscolherLane.bmp").targetOffset(-50,-6).exists()
    sec := Pattern("EscolherLane.bmp").targetOffset(50,-6).exists()
    dragDrop(pri, PorLane(pri, Primary))
    dragDrop(sec, PorLane(sec, Secondary))
  }
  else if (exists("EncontrarPartida.bmp") and exists("BandeiraPessoa.bmp")) {
    click(LoLLocation(336, 167))
    Sleep 500
    click(LoLLocation(445, 180))
  }
  else if exists("AceitarConvite.bmp") {
    click("AceitarConvite.bmp")
  }
  else if exists(Pattern("AceitarPartida.bmp")) {
    click(Pattern("AceitarPartida.bmp"))
    Run x -nt, , Hide
  }
  else if exists("Bana.bmp") {
    PorChamp(Ban)
  }
  else if exists(Pattern("Escolha.bmp").similar(0.9)) {
    PorChamp(Pick)
  }
  Sleep 5000
}

LolOnTop() {
  Global gLolOnTop
  if (gLolOnTop) {
    WinSet, AlwaysOnTop, Off, League of Legends
    gLolOnTop := 0
  }
  else {
    WinSet, AlwaysOnTop, On, League of Legends
    gLolOnTop := 1
  }
}

#IfWinActive League of Legends
9::ExitApp
+=::EditIni()
8::PlayRanked()
0::Pause, Toggle
-::LolOnTop()
#IfWinActive