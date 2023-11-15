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

class Pythonesque::Actions {
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
    method identifier($/) { make Variable.new(name => $/.Str) }
    method term($/)     { make $/.caps[0].value.made; }
    method number($/)   { make $/.Int }
    method operator($/) { make Operator.new(action => $/.Str) }
}


enum ErrorMode <TooMuch TooLittle NotSeenBefore>;
class X::Pythonesque::WrongIndentation is Exception {
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


grammar Pythonesque {
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
                X::Pythonesque::WrongIndentation.new(
                    got      => $current,
                    expected => $before,
                    mode     => TooLittle,
                ).throw;
            }
        }
        elsif $current > $last {
                X::Pythonesque::WrongIndentation.new(
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
                X::Pythonesque::WrongIndentation.new(
                    got      => $current,
                    mode     => NotSeenBefore,
                ).throw;
            }
        }

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
    proto token statement { * }
    rule statement:sym<if> {
        'if'  <expression> ':'
        { @*INDENTATION.push(NEW_INDENTATION) }
    }
    token statement:sym<expression> {
        <expression>
    }

    

    rule expression  { <term> + % <operator>   }
    token term       { <identifier> | <number> }
    token number     { \d+                     }
    token identifier { <:alpha> \w*            }
    token operator   {
        <[-+=<>*/]> | '==' | '<=' | '>=' | '!='
    }
}

