

class Operator {
    has Str $.action is required;
    multi method gist(Operator:D:) { "op $.action" }
}
class Variable {
    has Str $.name is required;
    multi method gist(Variable:D:) { "var $.name" }
}

class If {
    has $.condition;
    has @.block;
    multi method gist(If:D:) {
        "if " ~ $.condition.gist ~ ' {' ~ @.block.gist ~ '}'
    }
}

class Anapy::Actions {
    has @.scopes;
    method TOP($/)  {
        make @.scopes[0];
    }
    method line($/) {
        @.scopes[*-1].push($<statement>.made)
    }
    method enter_scope($/) { @.scopes.push([]) }
    method leave_scope($/) {
        if @.scopes > 1 {
            my $last = @.scopes.pop;
            @.scopes[*-1][*-1].block = $last.list;
        }
    }

    method statement:sym<if>($/) {
        make If.new(condition => $<expression>.made);
    }
    method statement:sym<expression>($/) {
        make $<expression>.made;
    }
    method expression($/) { make $/.caps».value».made.Array }
    method variable-name($/) { make Variable.new(name => $/.Str) }
    method term($/)     { make $/.caps[0].value.made; }
    method number($/)   { make $/.Int }
    method operator($/) { make Operator.new(action => $/.Str) }
}

enum ErrorMode <TooMuch TooLittle NotSeenBefore>;
class X::Anapy::WrongIndentation is Exception {
    has Int $.got is required;
    has Int $.expected;
    has ErrorMode $.mode is required;
    method message() {
        if $.mode == TooMuch {
            return "Inconsistent indentation: expected "
                ~ "at most $.expected, got $.got spaces";
        }
        elsif $.mode == TooLittle {
            return "Inconsistent indentation: expected "
                ~ "more than $.expected, got $.got spaces";
        }
        else {
            return "Unexpected indentation level: $.got.";
        }
    }
}

role PythonCommentable {
    regex ws {
        \h*
    }

    regex multi-line-comment {
        '"""' [ .*? ] '"""'
    }

    rule one-line-comment {
        '#' \N*
    }
}

role Number {
    token number {
        <sign>? [
            | <integer>
            | <floating-point>
        ] <exponent>?
    }

    token sign {
        <[+-]>
    }

    token exp {
        <[eE]>
    }

    token integer {
        \d+
    }

    token floating-point {
        <integer>? ['.' <integer>]
    }

    token exponent {
        <exp> <sign>? <integer>
    }
}


my %var;
my %arrays;
my @nums;
grammar AnapyGrammar does Number does PythonCommentable {
    my class NEW_INDENTATION { }
    method handle_indentation($match) {
        my $current = $match.Str.chars;
        my $last = @*INDENTATION[*-1];
        if $last ~~ NEW_INDENTATION {
            my $before = @*INDENTATION[*-2];
            if $current > $before {
                @*INDENTATION[*-1] = $current;
                self.enter_scope();
            }
            else {
                X::Anapy::WrongIndentation.new(
                    got      => $current,
                    expected => $before,
                    mode     => TooLittle,
                ).throw;
            }
        }
        elsif $current > $last {
                X::Anapy::WrongIndentation.new(
                    got      => $current,
                    expected => $last,
                    mode     => TooMuch,
                ).throw;
        }
        elsif $current < $last {
            my $idx = @*INDENTATION.first(:k, $current);
            if defined $idx {
                for $idx + 1 .. @*INDENTATION.end {
                    @*INDENTATION.pop;
                    self.leave_scope();
                }
            }
            else {
                X::Anapy::WrongIndentation.new(
                    got      => $current,
                    mode     => NotSeenBefore,
                ).throw;
            }
        }

    }

    method initialise_file(){

    }
    token enter_scope { <?> }
    token leave_scope { <?> }
    token TOP {
        :my @*INDENTATION = (0,);
        <.enter_scope>
        <line>*
        $

        # leave all open scopes:
        { self.handle_indentation('') }
        <.leave_scope>
    }
    token line {
        ^^ ( \h* ) { self.handle_indentation($0) }
        <statement>  $$ \n*
    }
    token ws { \h* }
    # proto token statement { * }
    # rule statement:sym<if> {
    #     'if'  <expression> ':'
    #     { @*INDENTATION.push(NEW_INDENTATION) }
    # }
    # token statement:sym<expression> {
    #     <expression>
    # }

    method strange-operation($name, $nums){
            my $manim-file = "manim-output.py".IO.open: :a;
            $manim-file.print("\n        " ~ "$name = AnimArray(\"$name\", [");
            # $manim-file.print("]).shift(LEFT*3)\n        " ~ "");
            # $manim-file.print("self.play(Create($name))\n        " ~ "");
            # $manim-file.print("self.wait(1)\n        " ~ "");
            my @ls = | list($nums);
            @ls = |@ls;
            say "Array:: " ~ @ls;
            say "Size of array:: " ~ @ls.elems;
            for @ls -> $x {
                say $x;
                say "Inside for loop";
                $manim-file.print("$x, ");
            }
            say "I ran";
            $manim-file.print("]).shift(LEFT*3)");
            $manim-file.print("\n        " ~ "self.play(Create($name))");
            $manim-file.print("\n        " ~ "self.wait(1)");

            $manim-file.close();
        
    }

    token array-assignment {
        
        <variable-name> {
            say("$<variable-name> is the arr");
        }
        
        ' = ' {
            say "I matched";
        }  
        "\[" 
        
             <list-of-nums>
            # {@nums.push(+$<number>)}
            
        "\]" {
                say "Numbers Here:: " ~ $<list-of-nums>;
                self.strange-operation($<variable-name>, $<list-of-nums>);
                say "Numbers Here:: " ~ $<list-of-nums>;
            }
    }



    token list-of-nums {
        <number>+ %% ', '

    }
    token term { <variable-name> | <number> }
    
    
    rule expression {
        <expr(1)>
    }

    multi rule expr($n) {
        <expr($n + 1)>+ %% <op($n)>
    }

    multi rule expr(6) {
        | <number>
        | <variable-name> <index>?
        | '(' <expression> ')'

    }

    multi token op(1) {
        | '|'
        | '<' | '>'
        | '<=' | '>='
        | '==' | '!='
    }

    multi token op(2) {
        '&'
    }

    multi token op(3) {
        '+' | '-'
    }

    multi token op(4) {
        '*' | '/'
    }

    multi token op(5) {
        '**'
    }

    # token string {
    #     'f'
    #     '"' ( [
    #           | <-["\\$]>+
    #           | '\\"'
    #           | '\\\\'
    #           | '\\$'
    #           | '{' <variable-name> '}' 
    #           ]* )
    #     '"'
    # }

    token function-call {
        <variable-name> '.' 
        [
            | "append" '(' <number> ')' {
                say "Function ran";
                my $manim-file = "manim-output.py".IO.open: :a;
                say "$<number>";
                $manim-file.print("\n        " ~ "self.play($<variable-name>");
                $manim-file.print(".append($<number>))");
                $manim-file.print("\n        " ~ "self.wait(1)");
                $manim-file.close();
                say "I function ran";
            }
            | "insert" '(' <number> ', ' <number> ')' {
                my $manim-file = "manim-output.py".IO.open: :a;
                $manim-file.print("\n        " ~ "self.play($<variable-name>");
                $manim-file.print(".insert($<number>[0], $<number>[1]))");
                $manim-file.print("\n        " ~ "self.wait(1)");
                $manim-file.close();
            }
            | "pop" '(' <number> ')' {
                my $manim-file = "manim-output.py".IO.open: :a;
                $manim-file.print("\n        " ~ "self.play($<variable-name>");
                $manim-file.print(".pop($<number>))");
                $manim-file.print("\n        " ~ "self.wait(1)");
                $manim-file.close();
            }
        ]
    }

    # rule variable-assignment {
    #     [
    #         | <declaration=array-declaration>
    #         | <declaration=hash-declaration>
    #         | <declaration=scalar-declaration>
    #     ]
    # }


    # rule array-assignment {
    #     <variable-name> '=' '[' [  <value>+ %% ',' ]? ']'
    # }

    rule hash-declaration {
        <variable-name>  [
            '=' [
                    |"dict()" 
                ]
        ]
    }

    rule variable-assignment {
        <variable-name> '=' <value> {
            
            if %var{'$<variable-name>'}:exists {
                %var{'$<variable-name>'} = +$<value>;
                my $manim-file = "manim-output.py".IO.open: :a;
                # $manim-file.print("$<variable-name>.update_value_2(Text(str($<value>)))\n        " ~ "");
                $manim-file.print("\n        " ~ "$<variable-name>.update_value_2");
                $manim-file.print("(Text(str($<value>)))");
                $manim-file.print("\n        " ~ "self.wait(1)");
                $manim-file.close()
            }
            else {
                my $manim-file = "manim-output.py".IO.open: :a;
                %var{'$<variable-name>'} = +$<value>;
                $manim-file.print("\n        " ~ "$<variable-name> = AnimVariable");
                my $x = 1076*543;
                $manim-file.print("(\"$<variable-name>\", Text(str($<value>)))");
                $manim-file.print("\n        " ~ "self.play(Create($<variable-name>))");
                $x = 789*8128;
                $manim-file.print("\n        " ~ "self.wait(1)");
                $manim-file.close()
            }
            
        }
    }

    

    rule index {
        | <array-index>
        | <hash-index>
    }

    rule array-index {
        '[' [ <integer> | <variable-name> ] ']'
    }

    rule hash-index {
        '[' [ <variable-name> ] ']'
    }

   
    rule value {
        | <number> {
            say "I matched number";
        }
        | <expression>
        | <function-call>
    }

    token variable-name { [<:alpha> | '_'] \w* }

    # Just pasting from here
    #`(
    rule TOP {
        [
            | <one-line-comment>
            | <statement=conditional-statement>
            | <statement=for-statement>
            | <statement=while-statement>
            | <statement> '\n'
        ]*
    }
    )
    rule conditional-statement {
        | 'if' <value> <block()> 'else' <block('\n')>
        | 'if' <value> <block('\n')>
    }

    rule for-statement {
        'for' [\w+] 'in range(' 
            | [\d+] ** 1..3
        
        ')'
        <block('\n')>
    }

    rule while-statement {
        'while' <value> <block('\n')>
    }

    # To modify for indentation based
    multi rule block() {
        | '{' ~ '}' <statement> * %% '\n'
        | <statement>
    }

    multi rule block('\n') {
        | '{' ~ '}' <statement>* %% '\n'
        | <statement> '\n'
        
    }
    
    token statement {
        || <variable-assignment> {
            my $manim-file = "manim-output.py".IO.open: :a;
            # $manim-file.print("\n        " ~ "")
            $manim-file.close();
        }
        || <array-assignment> {
            my $manim-file = "manim-output.py".IO.open: :a;
            # $manim-file.print("\n        " ~ "")
            $manim-file.close();
        }
        || <function-call> {
            my $manim-file = "manim-output.py".IO.open: :a;
            # $manim-file.print("\n        " ~ "")
            $manim-file.close();
        }
        || <?> {
            say("Error");
        }
    }
    
}

