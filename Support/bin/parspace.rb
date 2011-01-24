#! /usr/bin/env ruby
SUPPORT = "#{ENV['TM_SUPPORT_PATH']}"

stdin = STDIN.read

res = stdin.split("\n").map{|x| x.scan(/([^\s]+)/)}

max_length = res.map{|x| x.length}.max
lengths = (0..max_length).map{|x| res.map{|y| 
  begin
    y[x][0].length + 1
  rescue Exception => e
    0
  end  
}.max}

res.map{|x|
  lengths.each_index{|idx|
    len = lengths[idx]
      begin

        x[idx][0] = x[idx][0].ljust(len,' ')
      rescue Exception => e
      end
    }
    x
}

print res.map{|x| x.join("")}.join("\n")