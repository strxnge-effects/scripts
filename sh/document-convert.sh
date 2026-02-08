#!/bin/bash
f=$1
filename=${f%.*}
filetype=${f##*.}
filepath=$(dirname "$f")

function html {
    if [[ $filetype == "rtf" || $filetype == "fodt" ]]; then
        soffice --headless --convert-to html --outdir $filepath "${f}"
    else
        pandoc --wrap=none -t html "${f}" > "$filename.html"
    fi
    exit
}

function md {
    if [[ $filetype == "rtf" || $filetype == "fodt" ]]; then
        soffice --headless --convert-to markdown --outdir $filepath "${f}"
    else
        pandoc --wrap=none -t markdown "${f}" > "$filename.md"
    fi
    exit
}

function txt {
    if [[ $filetype == "rtf" || $filetype == "fodt" ]]; then
        soffice --headless --convert-to txt --outdir $filepath "${f}"
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
    esac
}

begin
