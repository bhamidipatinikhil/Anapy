import sys
sys.path.append('..')
from DescrRectangle import *

class Test(Scene):
    def construct(self):
        dr = DescrRectangle(Text(str(0)))
        self.play(Create(dr))
        self.wait(1)
        k=6
        for i in range(7):
            # self.play(dr.update_value_2(k))
            dr.update_value_2(Text(str(k)))
            self.wait(1)
            k+=1
        self.play(dr.animate.shift(UP))
        self.wait(2)