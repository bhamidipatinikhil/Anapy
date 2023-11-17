from manim import *
import sys
sys.path.append("/home/nikhil/Documents/Nikhil Programming/MCA 4th Sem Project/Anapy/Manimations")
from DescrRectangle import *
from AnimVariable import *
from BlockSet import *

class AnimArray(VMobject):
    def __init__(self, arr_name, arr_value, **kwargs):
        super().__init__(arr_value, **kwargs)

        self.bs = BlockSet(arr_value)
        
        self.arr_var = AnimVariable(arr_name, self.bs)
        self.bs.scale_to_fit_width(self.arr_var.value_block.width)
                
        self.adjust()
        self.add(self.arr_var)

    def adjust(self):
        self.arr_var.value_block.set_width(self.bs.arr_value_block.width)
        self.arr_var.value_block.next_to(self.arr_var.name_block.get_right(), RIGHT, buff=0.0)
        self.bs.next_to(self.arr_var.name_block.get_right(), RIGHT)
        
        
    
    def append(self, value):
        self.adjust()
        return self.bs.append(value)
    
    def insert(self, index, value):
        self.adjust()
        return self.bs.insert(index, value)
    
    def pop(self, index):
        self.adjust()
        return self.bs.pop(index)



        
