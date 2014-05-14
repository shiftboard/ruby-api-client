#!/usr/local/bin/ruby

# API Documentation: https://api.shiftboard.com/api-documentation/

require 'pp'
require 'json'
require 'base64'
require 'openssl'
require 'net/http'

api_url       = 'https://api.shiftdata.com/api/api.cgi'
signature_key = 'YOUR_SIGNATURE_KEY'
access_key_id = 'YOUR_ACCESS_KEY_ID'

request = {
  foo: 'bar',
  answer: 42,
  dinner: 'nachos'
}

# Convert the request to JSON
json = request.to_json

# Base64 encode JSON
encoded_json = Base64.strict_encode64(json)

# API method name
method = 'system.echo'

# Bits that are used in the cryptographic signature
sign = "method" + method + "params" + json

# Sign the bits with our key.
digest = OpenSSL::Digest.new('sha1')
signature = Base64.strict_encode64( OpenSSL::HMAC.digest(digest, signature_key, sign) )

params = {
  jsonrpc:        '2.0',          # JSON-RPC version
  access_key_id:  access_key_id,
  method:         method,
  params:         encoded_json,
  signature:      signature,
  id:             1               # Integer or string. Can be used by the client to correlate a response with its request.
}

uri = URI(api_url)
uri.query = URI.encode_www_form params

response = Net::HTTP.get_response(uri)
data = response.body

# Pretty-print the response to standard output
pp JSON.parse data
