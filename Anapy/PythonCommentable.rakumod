unit module PythonCommentable;

role PythonCommentable is export {
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