#!/bin/bash

randomstr () {
  head -1 /dev/urandom | base64 | cut -c1-10 | head -1
}

respond () {
  content_type "text/html"

  send_response "
<meta charset='utf-8'>
<p>Hello, world! You requested http://$(header "Host")${_PATH}?${_QSTR}.</p>
<p>$(query_arg "code")</p>
<p>Try going to a <a href='/$(randomstr)'>random</a> location!</p>
"
}
