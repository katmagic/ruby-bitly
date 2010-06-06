=begin
tiny bit.ly API library

Author: Akio Kitano
License: GPL2


You need bit.ly account and API key.  See http://bit.ly/a/your_api_key

Sample:
  # Write your ID and API key as arguments
  bit = BitLy.new('bitlyapidemo', 'R_0da49e0a9118ff35f52f629d2d71bf07')
  url = bit.ly('http://betaworks.com/')

  # Or if you have ~/.bitly.rb, You can call it without arguments
  bit = BitLy.new
  url = bit.ly('http://betaworks.com/')

Example of ~/.bitly.rb:
  {
    :login   => 'bitlyapidemo',
    :api_key => 'R_0da49e0a9118ff35f52f629d2d71bf07'
  }
=end

require 'rubygems'
require 'json'
require 'net/http'
require 'cgi'

class BitLy
  def initialize(login = nil, api_key = nil)
    @login = login
    @api_key = api_key
    unless @login or @api_key
      o = eval(File.read("#{ENV['HOME']}/.bitly.rb"))
      @login = o[:login]
      @api_key = o[:api_key]
    end
  end

  def ly(url)
    r = JSON.parse(Net::HTTP.get('api.bit.ly',
       "/v3/shorten?login=#@login&apiKey=#@api_key&longUrl=#{CGI.escape url}"))
    unless r['status_code'] == 200
      raise BitLy::Error, r
    end
    r['data']['url']
  end

  class Error < RuntimeError
    def initialize(x)
      @result = x
    end
    attr :result
  end
end

if __FILE__ == $0
  begin
    bit = BitLy.new
    p bit.ly('http://betaworks.com/')
  rescue BitLy::Error => e
    p e.result
  end

  begin
    bit = BitLy.new('bitlyapidemo', 'R_0da49e0a9118ff35f52f629d2d71bf07')
    p bit.ly('http://betaworks.com/')
  rescue BitLy::Error => e
    p e.result
  end
end
