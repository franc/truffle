##
 # Franc Paul
 # 
 # convert a ruby hash to coffescript object
 ##

module HashToCS

=begin
  usage:
    
  proc = Proc.new do |output| 
    coffee_script_file.puts output
  end

  HashToCs.convert(ruby_hash, "", proc)
  
=end
  
  defaultProc = Proc.new do |output|
    print output
  end

  #input is a Ruby hash
  #spaces is a prefix string of spaces used for whitespace significance
  #proc acts on the output
  def HashToCS.convert(input, spaces, proc=defaultProc)
    if input.is_a? String
      proc.call spaces + '"' + input + '"' + "\n"
    elsif input.is_a? Array
      proc.call spaces + "[\n"
      input.each do |a|
        convert(a, spaces + "  ", proc)
      end
      proc.call spaces + "]\n"
    elsif input.is_a? Hash
      proc.call spaces + "{\n"
      input.each do |k, v|
        proc.call spaces + "  #{k}:\n"
        convert(v, spaces + "    ", proc)
      end
      proc.call spaces + "}\n"
    else
      proc.call spaces + input.to_s + "\n"
    end
  end

end