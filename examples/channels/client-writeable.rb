require 'bridge-ruby'

EventMachine.run do

  bridge = Bridge::Bridge.new(:api_key => 'myapikey')

  class ChatHandler
    def message sender, msg
      puts "#{sender}: #{msg}"
    end
  end


  auth = bridge.get_service('auth')
  auth.join_writeable("bridge-lovers", "secret123", ChatHandler.new) do |channel, name|
    puts "Joined channel: #{name}"
    # The following RPC call will succeed because client was joined to channel with write permissions
    channel.message('steve', 'Can write to channel')
  end

  bridge.connect

end

