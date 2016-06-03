#!/bin/sed -f


s/&#39;/'/g 
s/&quot;/"/g
s/[#@]//g
s/\[//g
s/\]//g
s!http\(s\)\{0,1\}://[^[:space:]]*!!g
s!pic\.[^[:space:]]*!!g
s![[:space:]]\{2\}!!g
p