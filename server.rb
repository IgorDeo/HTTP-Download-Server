require 'socket'

require_relative 'landingPage.rb'

server = TCPServer.new('0.0.0.0', 3333)

SIZE = 1024 * 1024 * 10


def list_files(client, path, protocol)
  begin
    files_names= []
    
    Dir.each_child("./Files#{path}") do |filename|
      match = filename.match(/\./)
      if match.class != MatchData
        filename = filename + "/"
      end
      if filename == "index.html"
        send_file(client, path+filename, protocol)
        return
      end     
        files_names.append(filename)
      
    end
    
    files = html(files_names)

    response = protocol + " " + "200 OK" + "\n" + "\n"
    
    client.puts response    

    client.puts files

  rescue Errno::ENOENT
    response = protocol + " " + "404 Not Found" + "\n"
    client.puts response
  end 

end

def send_file(client, file_chosen, protocol)
  begin
  
    File.open("./Files#{file_chosen}", 'rb') do |file|
      response = protocol + " " + "200 OK" + "\n" + "\n"
    
     client.puts response 
      while packet = file.read(SIZE)
        client.write(packet)
      end
      file.close
    end
  rescue Errno::ENOENT
    response = protocol + " " + "404 Not Found" + "\n"
    client.puts response
  end   
end

loop do
  client = server.accept

  puts "Client conected"

  command_received = client.gets.split(" ")
  header_received = client.gets
  verb = command_received[0]
  path  = command_received[1]
  # protocol = command_received[2]
  protocol = "HTTP/1.1"
 


  if verb == "GET" && path[(path.length)-1] == "/"##Comando para a listagem de arquivos
    list_files(client, path, protocol)
  end

  if verb == "GET" && path[(path.length)-1] != "/"
    send_file(client, path, protocol)
  end
    
  client.close
end  
