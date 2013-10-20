#!/bin/bash

#The MIT License (MIT)
#
#Copyright (c) 2013 Cory Sherman
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.


#   this is meant to be run in non-interactive mode (e.g. via keyboard shortcut)
#   it works around 'scrot -s' not working in non-interactive mode,
#   and it works around xclip mysteriously not working from a secondary terminal
#   see 'imgur_upload.sh --help' for options

cd `dirname "$0"`

#xclip won't run when the script is executed with with xterm -e
#so we save the url to a file, and use xclip here

#imgur_upload.sh will save the url to this file because it exists
touch imgur_upload_url

#use xdotool to hide the forthcoming xterm
xdotool search --sync --onlyvisible --name 'UNMAP THIS WINDOW' windowunmap &

#launch xterm to execute imgur_upload
#this allows the imgur_upload_non-interactive.sh to be called as a keyboard shortcut
#and still use `scrot -s`
xterm -geometry 0x0-0-0 -T 'UNMAP THIS WINDOW' -e ./imgur_upload.sh $@

#copy the url to clipboard, if one was written there
[[ -s imgur_upload_url ]] && xclip -selection clipboard imgur_upload_url
rm imgur_upload_url
