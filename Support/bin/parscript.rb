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

consnip = /[\/\>]\/([^\n$]+)\/.*[\n$]?/
snip_loc = stdin =~ consnip


fail_softly("Not a vaid consnip!") if (!snip_loc)

entire, script = stdin.match(consnip).to_a
stdin.sub!(consnip,'')
output = ''
IO.popen(script, "w+") do |pipe|
  pipe.puts stdin
  pipe.close_write  # If other_program process doesn't flush its output, you probably need to use this to send an end-of-file, which tells other_program to give us its output. If you don't do this, the program may hang/block, because other_program is waiting for more input.
  output = pipe.read
end

print output
# print output