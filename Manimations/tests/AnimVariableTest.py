import sys
sys.path.append('..')
from AnimVariable import *

class Test(Scene):
    def construct(self):
        av = AnimVariable("count", Text(str(0)))
        
        self.play(Create(av))
        self.wait(1)
        
        av.update_value_2(Text(str(1)))
        self.wait(1)
        
        av.update_value_2(Text(str(1)))
        self.wait(1)

        av.update_value_2(Text(str(1)))
        self.wait(1)

        av.update_value_2(Text(str(1)))
        self.wait(1)

        
        