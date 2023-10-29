require 'drb/drb'

class CoupChallengeServer
  def shuffle(coups)
    coups.sample
  end
end

remote_object = CoupChallengeServer.new
URI = 'druby://localhost:3000'
DRb.start_service(URI, remote_object)

puts "Server of remote objects running in #{URI}"
DRb.thread.join