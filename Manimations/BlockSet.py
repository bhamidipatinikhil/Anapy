from manim import *
import sys
sys.path.append("/home/nikhil/Documents/Nikhil Programming/MCA 4th Sem Project/Anapy/Manimations")
from DescrRectangle import *

class BlockSet(VMobject):
    def __init__(self, arr, **kwargs):
        super().__init__(**kwargs)
        self.arr = arr
        self.posn_ptr = 0
        self.arr_value_block = VGroup()
        for i in range(len(arr)):
            self.arr_value_block.add(DescrRectangle(Text(str(arr[i])), width=1, height=1).shift(RIGHT*i))
        self.posn_ptr = self.arr_value_block[-1].get_center()+RIGHT
        self.height = self.arr_value_block.height
        self.add(self.arr_value_block)
        
    def get_gap(self):
        return self.arr_value_block[1].get_center()-self.arr_value_block[0].get_center()

    def get_height(self):
        return self.arr_value_block[0].height

    def append(self, value):
        self.posn_ptr = self.arr_value_block[-1].get_center()+self.get_gap()
        to_add = DescrRectangle(Text(str(value)), width=1, height=1).shift(self.posn_ptr)
        to_add.scale_to_fit_height(self.get_height())
        self.arr_value_block.add(to_add)
        self.posn_ptr += self.get_gap()
        return AnimationGroup(
            Circumscribe(to_add)
        )
        

    def insert(self, index, value):
        right_group = VGroup()
        self.posn_ptr = self.arr_value_block.submobjects[index].get_center()
        for i in range(index, len(self.arr_value_block.submobjects)):
            obj = self.arr_value_block.submobjects[i]
            right_group.add(obj)
        
        to_add = DescrRectangle(Text(str(value)), width=1, height=1).move_to(self.posn_ptr)
        to_add.scale_to_fit_height(self.get_height())
        self.arr_value_block.submobjects.insert(index, to_add)
        return AnimationGroup(
            right_group.animate.shift(self.get_gap()),
            Wiggle(to_add),
        )
    
    def pop(self, index):
        right_group = VGroup()
        
        for i in range(index+1, len(self.arr_value_block.submobjects)):
            obj = self.arr_value_block.submobjects[i]
            right_group.add(obj)
        
        to_remove = self.arr_value_block.submobjects[index]
        self.posn_ptr = self.arr_value_block.submobjects[index-1].get_right()
        self.arr_value_block.submobjects.pop(index)
        return AnimationGroup(
            # right_group.animate.shift(LEFT),
            Uncreate(to_remove),
            right_group.animate.next_to(self.posn_ptr, RIGHT, buff=0.0),
        )

        
    