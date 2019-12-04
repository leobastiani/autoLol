$PrintScreen::
    Send {PrintScreen}
    i := 1
    While, FileExist( i . ".bmp") {
        i := i + 1
    }
    FileAppend, , % i . ".bmp"
    run % "mspaint " . i . ".bmp"
return
Esc::ExitApp
