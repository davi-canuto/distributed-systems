require 'drb/drb'

class CoupChallengeServer
  def shuffle(coups)
    coups.sample
  end
end

remote_object = CoupChallengeServer.new
URI = 'druby://172.22.31.242:3000'
DRb.start_service(URI, remote_object)

puts "Server of remote objects running in #{URI}"
DRb.thread.join