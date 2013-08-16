#!/bin/bash

randomstr () {
  head -1 /dev/urandom | base64 | sed 's!/!!' | cut -c1-10
}

respond () {
  content_type "text/html"

  send_response "
<meta charset='utf-8'>
<p>Hello, world! You requested http://$(header "Host")${_PATH}?$(html_encode "$(cgi_unescape "$_QSTR")").</p>
<p>Your query argument is <code>$(html_encode "$(query_arg "arg")")</code>.</p>
<p>Try going to a <a href='/$(randomstr)?arg=$(randomstr)'>random</a> location!</p>
"
}
