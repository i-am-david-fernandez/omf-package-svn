function svn -d "Subversion command wrapper"
    # Package entry-point

    set new_args

    for arg in $argv
        set -e argv[1]
        switch $arg
            case 'diff'
                command svn diff --diff-cmd icdiff --extensions "--line-numbers --no-bold" $argv | less -rFX
                return
            case '*'
                set new_args $new_args $arg
        end
    end

    command svn $new_args
end
