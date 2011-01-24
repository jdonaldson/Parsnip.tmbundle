#! /usr/bin/env ruby
SUPPORT = "#{ENV['TM_SUPPORT_PATH']}"
require SUPPORT + '/lib/escape'
require SUPPORT + '/lib/exit_codes'
require SUPPORT + '/lib/textmate' 
require SUPPORT + '/lib/ui'
require SUPPORT + '/lib/tm/htmloutput'

stdin = STDIN.read

res = stdin.split("\n").map{|x| x.scan(/((\/\/.*)|[^\s]+|\s+)/)}

max_length = res.map{|x| x.length}.max
lengths = (0..max_length).map{|x| res.map{|y| 
  begin
    y[x][0].length
  rescue Exception => e
    0
  end  
}.max}

res.map{|x|

  lengths.each_index{|idx|
    len = lengths[idx]
      begin
        x[idx][0] = x[idx][0].ljust(len,' ')
        x[idx] = x[idx][0]
      rescue Exception => e
      end
    }
    x
}

print res.map{|x| x.join("")}.join("\n")