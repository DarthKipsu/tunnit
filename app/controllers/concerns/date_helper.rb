module DateHelper
  def parseDuration userInput
    temp = ''
    time = 0
    userInput.split(//).each do |char|
      if !!(char =~ /\A[-+]?[0-9]+\z/)
        temp << char
      elsif char.eql? '.' or char.eql? ':'
        time = temp.to_f * 60
        temp = ''
      elsif char.eql? 'h'
        if time == 0
          time = temp.to_f * 60
          temp = ''
        else
          time = time + 6 * temp.to_f
          temp = ''
          break
        end
      elsif char.eql? ' '
        next
      elsif !temp.empty?
        time = time + temp.to_f
        temp = ''
        break
      end
      puts "parsing..."
      puts temp
      puts time
    end
    if !temp.empty? then time = time + temp.to_f end
    time
  end
end
