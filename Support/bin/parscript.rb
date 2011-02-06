#! /usr/bin/env ruby
SUPPORT = "#{ENV['TM_SUPPORT_PATH']}"
require SUPPORT + '/lib/escape'
require SUPPORT + '/lib/exit_codes'
require SUPPORT + '/lib/textmate' 
require SUPPORT + '/lib/ui'
require SUPPORT + '/lib/tm/htmloutput'

def fail_softly(err)
  TextMate.exit_show_tool_tip 'Failed: '+ err
end

stdin = STDIN.read

snip = /[\/\>]\/([^\n$]+)\/\s*$/
snip_loc = stdin =~ snip


fail_softly("Not a vaid parscript!") if (!snip_loc)

entire, script = stdin.match(snip).to_a
stdin.sub!(snip,'')
output = ''
IO.popen(script, "w+") do |pipe|
  pipe.puts stdin
  pipe.close_write  
  output = pipe.read
end

print output

