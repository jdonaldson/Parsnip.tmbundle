#! /usr/bin/env ruby
SUPPORT = "#{ENV['TM_SUPPORT_PATH']}"
require SUPPORT + '/lib/escape'
require SUPPORT + '/lib/exit_codes'
require SUPPORT + '/lib/textmate' 
require SUPPORT + '/lib/ui'
require SUPPORT + '/lib/tm/htmloutput'

parsnip = /(>|\/)(>|\/)?(\/(\\\/|[^\/])*\/[a-z]*)([=><])?/
stdin = STDIN.read
snip_loc = stdin =~ parsnip




def fail_softly(err)
  TextMate.exit_show_tool_tip 'Failed: '+ err
end

fail_softly("Not a vaid parsnip!") if (!snip_loc)

all, first, order, match, match_interior, position = stdin.match(parsnip).to_a



begin
  match = Regexp.new(eval(match))
rescue
  match = nil
end

stdin.gsub!(parsnip,'')
lines = stdin.split("\n")

line_ctr = 1
ctr = 1
col = 1


splits = lines.collect{|l|
  repl = l * 1

  md =repl.match(match)

  if md != nil

    col_ctr = md.captures.length    
    TextMate.exit_show_tool_tip "No group matches found, so no snippet slots created" if col_ctr == 0
    
    (md.length-1).downto(1).each{|x|
      
      if order == nil       
        ctr = col_ctr
      else
        ctr = line_ctr
      end

      b = md.begin(x)
      e = md.end(x)-1

      fail_softly("a group doesn't match any character(s)") if e < 0 || b < 0
      if position == "<"
        repl[b..e] = "$#{ctr}#{repl[b..e]}"
      elsif position == "="
        repl[b..e] = "${#{ctr}:#{repl[b..e]}}"
      else
        repl[b..e] = "#{repl[b..e]}$#{ctr}"
      end
      col_ctr -= 1
    }
    line_ctr += 1  
  end
  
  col_ctr = 1
    

  repl
}

print splits.join("\n")