#!/bin/bash
filename=${1%.*}
filetype=${1##*.}
f=$1

function html {
    if [[ $filetype == "rtf" ]]; then
        soffice --headless --convert-to html "${f}"
    else
        pandoc --wrap=none -t html "${f}" > "$filename.html"
    fi
    exit
}

function md {
    if [[ $filetype == "rtf" ]]; then
        soffice --headless --convert-to markdown "${f}"
    else
        pandoc --wrap=none -t markdown "${f}" > "$filename.md"
    fi
    exit
}

function txt {
    if [[ $filetype == "rtf" ]]; then
        soffice --headless --convert-to txt "${f}"
    else
        pandoc "${f}" -t plain > "$filename.txt"
    fi
    exit
}


function begin {
    echo DOCUMENT-CONVERT
    echo ==========
    echo select conversion for file ${f}:
    echo "1) to html"
    echo "2) to markdown"
    echo "3) to txt"
    read -p "your selection: " op

    case $op in 
        1)
            html
            ;;
        2)
            md
            ;;
        3)
            txt
            ;;
        exit)
            exit
            ;;
        *)
            echo please make a selection or type "exit"
            ;;
    esac
}

begin
