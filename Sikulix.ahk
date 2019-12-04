CoordMode Mouse, Screen
SetDefaultMouseSpeed 10

Class _Location {
    x := 0
    y := 0

    __New(_x, _y) {
        This.x := _x
        This.y := _y
    }

    isLocation() {
        return 1
    }

    targetOffset(x, y) {
        l := This.Clone()
        l.x := l.x + x
        l.y := l.y + y
        return l
    }

    msg() {
        x := This.x
        y := This.y
        MsgBox % "location: " . x . ", " . y
        return This
    }
}

Location(x, y) {
    return new _Location(x, y)
}

Class _Pattern {
    _targetOffset := Location(0,0)
    _tolerance := 5
    size := Location(0,0)

    targetOffset(x=-1, y=-1) {
        if (x = -1 and y = -1) {
            return This._targetOffset.Clone()
        }
        p := This.Clone()
        p._targetOffset := Location(x, y)
        return p
    }

    isPattern() {
        return This
    }

    __New(file) {
        This.file := file
        This.size := getImageSize(file)
    }

    exact() {
        p := This.Clone()
        p._tolerance := 0
        return p
    }

    similar(pct) {
        p := This.Clone()
        p._tolerance := Ceil((1-pct) * 255)
        return p
    }

    toString() {
        ret := """" . This.file . """"
        return ret
    }

    exists() {
        return exists(This)
    }
}

Class _Region {
    __New(x0, y0, x1, y1) {
        This.x0 := x0
        This.y0 := y0
        This.x1 := x1
        This.y1 := y1
    }

    exists(p) {
        return exists(p, This.x0, This.y0, This.x1, This.y1)
    }

    _exists(p) {
        return _exists(p)
    }
}

Region(x0, y0, x1, y1) {
    return new _Region(x0, y0, x1, y1)
}

Pattern(x) {
    return new _Pattern(x)
}

mustBePattern(p) {
    if p.isPattern() {
        return p
    }
    return Pattern(p)
}

mustBeLocation(p) {
    if p.isLocation() {
        return p
    }
    return exists(p)
}

exists(p,x0=0,y0=0,x1=0,y1=0,centralizar=True) {
    if (x1 = 0)
        x1 := A_ScreenWidth
    if (y1 = 0)
        y1 := A_ScreenHeight
    p := mustBePattern(p)
    file := "*" . p._tolerance . " " . p.file
    CoordMode, Pixel, Screen
    ImageSearch, x, y, %x0%, %y0%, %x1%, %y1%, %file%
    CoordMode, Mouse, Screen
    if (ErrorLevel = 0) {
        ret := Location(x+p.size.x/2 + p._targetOffset.x, y+p.size.y/2 + p._targetOffset.y)
        if (!centralizar) {
            ret.x -= p.size.x/2
            ret.y -= p.size.y/2
        }
        return ret
    }
    else if(ErrorLevel = 2) {
        MsgBox ErrorLevel não esperado
    }
    else if(ErrorLevel = 1) {
    }
}

_exists(p) {
    p := mustBePattern(p)
    MsgBox % "Início: " . p.file
    e := exists(p,0,0,0,0,False)
    if (e) {
        Clipboard := "Region(" . Ceil(e.x) . ", " . Ceil(e.y) . ", " . Ceil(e.x+p.size.x) . ", " . Ceil(e.y+p.size.y) . ").exists(" . p.toString() . ")"
        MsgBox Ok
    }
    else {
        MsgBox Falha
    }
    ExitApp
}

move(p) {
    p := mustBeLocation(p)
    if (p) {
        x := p.x
        y := p.y
        MouseMove, %x%, %y%
        paradinha()
    }
}

_click(p, n=1) {
    move(p)
    Click
    paradinha()
}

click(p) {
    _click(p, 1)
}

doubleClick(p) {
    _click(p, 2)
}

type(txt) {
    SendRaw, %txt%
    paradinha()
}

dragDrop(l1, l2) {
    l1 := mustBeLocation(l1)
    l2 := mustBeLocation(l2)
    MouseClickDrag left, l1.x, l1.y, l2.x, l2.y
    paradinha()
}


ImageSizes := {}

getImageSize(FileName) {
    Global
    if (ImageSizes[FileName]) {
        return ImageSizes[FileName]
    }
    gui, add,picture, vimage, %FileName%
    GuiControlGet, Pic, Pos, image  ; The position/size will be stored in PicX, PicY, PicW, and PicH
    gui, destroy
    Local p
    p := Location(PicW, PicH)
    ImageSizes[FileName] := p
    return p
}

paradinha() {
    Sleep 100
}