use lib '.';
# use AnapyGrammar;

sub error($message) {
    note $message;
    exit;
}


my $filename = @*ARGS[0];
error("Error: File $filename not found") unless "$filename".IO.f;

# my $code = $filename.IO.slurp();

# my $evaluator = AnapyEvaluator.new();
# my $actions = AnapyActions.new(:evaluator($evaluator));
# my $ast = Anapy.parse($code, :actions($actions));

my $pure_file_name = $filename.chop(3);

# my $manim_code = "";

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
END

# my $manim_file = "{$pure_file_name}-manim-code.py";
my $manim_file = "manim-output.py".IO.open: :a;

# "$manim_file".IO.spurt($manim_code);

$manim_file.print($manim_starter_code);


