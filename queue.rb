require 'csv'

class Queue < Array
attr_accessor :queue
attr_accessor :current_csv

  def intiialize
    @queue = []
  end

  def save(file_name, headers)
    # parts = file_name.split(".")
    # name = parts[0]
    Dir.mkdir("saved_queues") unless Dir.exists? "saved_queues"
    name = "saved_queues/#{file_name}"
    
    File.open(name, 'w') do |file|
      #EventReporter::current_csv.rewind
      #file.puts EventReporter::current_csv["headers"]
      # file.print headers
      # file.print "\n"
      file << ["ID","RegDate","first_Name","last_Name","Email_Address","HomePhone","Street","City","State","Zipcode"]
      file.print "\n"
      file.puts self
    end
  end

  def print_by(attribute)
    print ["ID","RegDate","first_Name","last_Name","Email_Address","HomePhone","Street","City","State","Zipcode"]
    print "\n"
    case attribute
    when 'zipcode' then puts self.sort_by{|e| e["Zipcode"]}
    when 'first_name' then puts self.sort_by{|e| e["first_Name"]}
    when 'last_name' then puts self.sort_by{|e| e["last_Name"]}
    end
  end


end










