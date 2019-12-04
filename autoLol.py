try:
    click
except:
    from pysikulix import *
import time

exists_(Pattern("1544662755365.png"))

def run():

    if Region(1224,303,1429,647).exists("1544650541845.png"):
        click(Pattern("1544650541845.png").targetOffset(-6,-153))
        type('sohosparcasabe1')

    elif Region(601,499,775,581).exists(Pattern("1544653119709.png")):
        dragDrop(Pattern("1544653119709.png").targetOffset(-46,7), Pattern("1544653119709.png").targetOffset(1,-68))
        dragDrop(Pattern("1544653119709.png").targetOffset(46,6), Pattern("1544653119709.png").targetOffset(179,2))
    elif Region(1206,138,1300,179).exists("1544662755365.png"):
        click(Pattern("1544662755365.png").targetOffset(19,2))
        click(Pattern("1544662755365.png").targetOffset(45,22))

run()
# for x in range(2):
#     run()
#     time.sleep(2)
