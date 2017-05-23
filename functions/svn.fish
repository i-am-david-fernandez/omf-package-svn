function __svn_status -d "Subversion status command wrapper."
    for line in (command svn status $argv)
        set -l tag (echo $line | awk '{print $1}')
        switch $tag
            case 'M'
                set_color yellow
                echo $line
            case 'A'
                set_color green
                echo $line
                set_color normal
            case 'D'
                set_color red
                echo $line
                set_color normal
            case '?'
                set_color cyan
                echo $line
                set_color normal
            case '!'
                set_color brred
                echo $line
                set_color normal
            case '*'
                set_color normal
                echo $line
            ;;
        end
    end

    set_color normal
end

function svn -d "Subversion command wrapper"
    # Package entry-point

    set new_args

    for arg in $argv
        set -e argv[1]

        switch $arg
            case '--all'

                set -l root './'
                if test -d $argv[1]
                    set root $argv[1]
                    set -e argv[1]
                end

                for repo in (find $root -type d -name ".svn")
                    set -l repo (realpath "$repo/..")
                    echo-info --minor ">> $repo"
                    pushd $repo
                    svn $argv
                    popd
                end
                return

            case 'status'
                __svn_status $argv
                return

            case 'diff'
                command svn diff --diff-cmd icdiff --extensions "--line-numbers --no-bold" $argv | less -rFX
                return

            case '*'
                set new_args $new_args $arg
        end
    end

    command svn $new_args
end
