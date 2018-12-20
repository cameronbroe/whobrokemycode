function whobrokemycode {
    function usage {
        print "\
Usage: whobrokemycode [file] [line_number]
        -c number of lines to show

Examples:
$ whobrokemycode -c 10 broken_code.py 10"
        return 0
    }

    # Parse arguments
    count=
    while getopts ':c:h' arg
    do
        case $arg in
        c )
            count=$OPTARG
            ;;
        h )
            usage
            return 0
            ;;
        : )
            echo "Invalid Option: $OPTARG requires an argument" 1>&2
            ;;
        esac
    done
    shift $((OPTIND -1))


    if [[ ${count} == "" ]]; then
        count=20 # Default value
    fi
    # Generate variables for Git blame command
    file_check=$1
    line_number=$2

    # Input validation
    if [[ ${file_check} == "" ]]; then
        usage
        return 0
    fi

    if [[ ${line_number} == "" ]]; then
        usage
        return 0
    fi

    if [[ ${line_number} -le 0 ]]; then
        usage
        return 0
    fi

    upper_line=$(expr "$line_number" + "$count")
    lower_line=$(expr "$line_number" - "$count")

    if [[ $lower_line -le 0 ]]; then
        lower_line=1 # at least 1 for lower_line
    fi

    git blame ${file_check} -L ${lower_line},${upper_line} | grep --color -E ".*${line_number}.*" -C ${count}
}
