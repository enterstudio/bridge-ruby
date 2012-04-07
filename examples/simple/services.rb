require 'bridge'

EventMachine.run do
  bridge = Bridge::Bridge.new(:api_key => 'abcdefgh')
  bridge.connect


  #
  # Publishing a Bridge service
  #
  # Any Javascript object can be published. A published service 
  # can be retrieved by any Bridge client with the same API key pair.
  #
  # Only Bridge clients using the prviate API key may publish services.
  #
  class TestService
    def ping
      puts 'Received ping request!'
      yield 'Pong'
    end
  end

  bridge.publish_service 'testService', TestService.new



  #
  # Retrieving a Bridge service 
  #
  # This can be done from any Bridge client connected to the same 
  # Bridge server, regardless of language.
  # If multiple clients publish a Bridge service, getService will 
  # retrieve from the publisher with the least load.
  #
  bridge.get_service 'testService' do |testService, name|
    puts 'Sending ping request'
    testService.ping do |msg|
      puts msg
    end
  end
end