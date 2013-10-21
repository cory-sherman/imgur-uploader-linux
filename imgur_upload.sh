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

#client ID for anonymous upload
clientId="cd89ba6bb8f4086"

#images which fail to upload are saved here
backupDir="$HOME/Pictures/imgur-failures"

if [[ $1 == '--help' ]]
then
    cat <<'HELP'
Captures and uploads a screenshot to imgur.
By default, the entire screen is captured.
Options are passed to scrot. Options include:
        -u      capture focused window
        -s      select capture rectangle interactively
See 'man scrot' for more info.
HELP
    exit 0;
fi

cd `dirname "$0"`

#capture screnshot
imageFile=`mktemp --suffix=.png || tempfile --suffix=.png`
scrot $@ "$imageFile"
echo "saved as \"$imageFile\"";

#try to upload to imgur
echo 'uploading to imgur...'
response=`curl -s -H "Authorization: Client-ID $clientId" -F image=@$imageFile 'https://api.imgur.com/3/image.xml'`

#search imgur's response for the link
regex="<link>(.*)<\/link>"
if [[ $response =~ $regex ]]
then
  #found link, upload successful
  
  #extract link
  imgurUrl=${BASH_REMATCH[1]}

  #copy link to clipboard
  echo "$imgurUrl" | xclip -selection clipboard

  #for some reason, xclip doesn't work in a background terminal
  #so, we save the imgurUrl if imgur_upload_non-interactive called us
  if [[ -e imgur_upload_url ]]
  then
     echo "$imgurUrl" > imgur_upload_url
  fi

  outputString="Uploaded to \"$imgurUrl\". Address copied to clipboard."
    
  regex="<deletehash>(.*)</deletehash>"
  if [[ $response =~ $regex ]]
  then
    outputString="$outputString Delete code: \"${BASH_REMATCH[1]}\""
  fi

  returnCode=0

  #remove the image, since imgur hosts it now
  rm "$imageFile"

else
  #there was an error somewhere along the way, most likely curl couldn't connect, or imgur didn't like the clientId

  imageBackup="$backupDir/`date --rfc-3339=ns|tr ' ' '_'`.png"

  mkdir -p `dirname "$imageBackup"`
  mv "$imageFile" "$imageBackup"

  outputString="Error uploading to imgur! File saved to \"$imageBackup\". Error details:"

  #did imgur send an error?
  regex="<error>(.*)<\/error>"
  if [[ $response =~ $regex ]]
  then
    #append imgur's error to output
    outputString="$outputString \"${BASH_REMATCH[1]}\""
  else
    outputString="$outputString imgur did not respond."
  fi

  returnCode=1
    
fi

notify-send "$outputString"
echo "$outputString"
exit $returnCode
