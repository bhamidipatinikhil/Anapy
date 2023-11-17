unit module Classes;

class Operator is export {
    has Str $.action is required;
    multi method gist(Operator:D:) { "op $.action" }
}
class Variable is export {
    has Str $.name is required;
    multi method gist(Variable:D:) { "var $.name" }
}

class If is export {
    has $.condition;
    has @.block;
    multi method gist(If:D:) {
        "if " ~ $.condition.gist ~ ' {' ~ @.block.gist ~ '}'
    }
}

class Anapy::Actions is export {
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
    method variable_name($/) { make Variable.new(name => $/.Str) }
    method term($/)     { make $/.caps[0].value.made; }
    method number($/)   { make $/.Int }
    method operator($/) { make Operator.new(action => $/.Str) }
}

enum ErrorMode is export <TooMuch TooLittle NotSeenBefore>;
class X::Anapy::WrongIndentation is Exception is export {
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