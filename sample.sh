#!/bin/bash

display_dir () {
  dir="$1"
  resp="<html><head><title>Index of ${dir#$DIR}</title></head><body><h1>"
  resp="${resp}Index of ${dir#$DIR}</h1><pre>"
  while IFS= read -d $'\0' -r f ; do
    file=$(echo "$f" | cut -c4-)
    if [[ -z "$file" ]]; then
      continue
    fi
    fil=$(file "$file")
    usec=$(stat -f '%B' "$file")
    utime=$(date -r "$usec" +"%d-%b-%Y %H:%M")
    size=$(wc -c "$file" | awk '{print $1}')
    resp="${resp}${utime}\t$size\t<a href='/$file'>$file</a>${fil#$file}\n"
  done < <(find "$dir" \( ! -regex '.*/\..*' \) -print0)
  resp="${resp}</pre></body></html>"
  send_response_eval "$resp"
}

display_file () {
  file="$1"
  mt="$(file --mime-type "$file")"
  mt="${mt#$file: }"
  content_type "$mt"
  send_response "$(<$file)"
}

respond () {
  resp="<html><head><title>Hello world!</title></head><body>"
  if test -d "${DIR}${_PATH}"; then
    display_dir "${DIR}${_PATH}"
  elif test -f "${DIR}${_PATH}"; then
    display_file "${DIR}${_PATH}"
  else
    status_code 404
    send_response_eval "<html><head><title>Hello world!</title></head><body>Hi! You requested <code>$_PATH</code>, which doesn't seem to exist. Sorry!</body></html>"
  fi
}
