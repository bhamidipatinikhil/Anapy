use lib '.';
# use AnapyGrammar;

sub error($message) {
    note $message;
    exit;
}


my $filename = @*ARGS[0];
error("Error: File $filename not found") unless $filename.IO.f;

# my $code = $filename.IO.slurp();

# my $evaluator = AnapyEvaluator.new();
# my $actions = AnapyActions.new(:evaluator($evaluator));
# my $ast = Anapy.parse($code, :actions($actions));

my $pure_file_name = $filename.chop(3);

my $manim_code = "";

my $manim_starter_code = q:to/END/;
from manim import *
import sys
sys.path.append(r'./Manimations/')
from AnimArray import *
from AnimVariable import *
from DescrRectangle import *
from BlockSet import *

class AnimationOutput(Scene):
    def construct(self):
        circle = Circle()  # create a circle
        circle.set_fill(PINK, opacity=0.5)  # set color and transparency

        square = Square()  # create a square
        square.rotate(PI / 4)  # rotate a certain amount

        self.play(Create(square))  # animate the creation of the square
        self.play(Transform(square, circle))  # interpolate the square into the circle
        self.play(FadeOut(square))  # fade out animation
END

# my $manim_file = "{$pure_file_name}-manim-code.py";
my $manim_file = "../manim-output.py".IO.open: :a;

# "$manim_file".IO.spurt($manim_code);

$manim_file.print($manim_starter_code);


