# For Cosmoteer, figures out a nice amount and power of output beams for an amount of input beams
# Made by rottis
# You are free to use and redistribute this code anywhere

puts("count of ions?")
count = gets.chomp.to_i
puts("count of outputs?")
outputc = gets.chomp.to_i
puts("do you want to list multiple output amounts? (y/n)")
keepgoing = (gets.chomp.downcase == "y")

if keepgoing
  puts("how many output amounts do you want to see?")
  list_amount = gets.chomp.to_i
else
  list_amount = 1
end

puts "-----"

divib = 0
while count % 2**divib == 0 && count / 2**divib > 8 || divib == 0
  divib += 1
end
# optimization + reduces a ton of obvious setups ae. (40x 2) from being displayed sometimes...

if divib == 0
  puts("man why odd beams")
  exit
end

class Array
  def combine(times = 1)
    first = true
    times.times do 
      i = 0
      while (self[i] != self[i+1]) && (first || matchable == self[i])
        i += 1
        if (i+1) >= self.length
          raise Exception
        end
      end
      self << (self.delete_at(i) + self.delete_at(i))
      self.sort!
      matchable = self[i]
      first = false 
    end
  end
end

def printlist(arr)
  dict = Hash.new(0)
  arr.each do |elem|
    dict[elem] += 1
  end
  dict.each do |val, key|
    puts("#{key}x #{val}")
  end
end

finished = false
onlypositiveinc = false
next_step = 1
basebeams = count / 2**(divib-2)
last_printed = -1
while !finished
  begin
    has_middle = ((outputc % 2) == 1)
    beamlist = []
    basebeams.times { beamlist << 2**(divib-2) }
    while beamlist.length > outputc
      if (beamlist.length - outputc) % 2 == 1
        if has_middle
          beamlist.combine
        else
          raise Exception
        end
      elsif (beamlist.length - outputc) % 2 == 0
        beamlist.combine(2)
      else
        raise Exception
      end
    end
    list_amount -= 1
    if list_amount == 0
      finished = true
    end
    last_printed = outputc
    puts("Emitters: #{count}, Outputs: #{outputc}")
    printlist(beamlist)
    puts("-----")
    raise Exception # weird but makes the code jump to the incrementing section instead of infinitely looping
  rescue Exception => e
    if e.class == Interrupt
      exit
    end

    if !keepgoing && last_printed != outputc
      puts("No ion setups found for output=#{outputc}, trying again...")
    end

    if onlypositiveinc
      outputc += 1
    else
      outputc += next_step
      next_step *= -1
      if next_step < 0
        next_step -= 1
      else
        next_step += 1
      end

      if outputc < 0
        onlypositiveinc = true
        outputc += next_step
      end
    end
    
    if outputc > basebeams
      finished = true
    end
  end
end
