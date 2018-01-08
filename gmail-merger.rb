#!/usr/bin/env ruby

require 'gmail'
require 'time'
require 'yaml'
require 'erb'

if ARGV.length != 2
    puts "Syntax: #{__FILE__} gmail-username gmail-password"
    exit
end

config = YAML.load_file("#{File.dirname(__FILE__)}/config.yaml")
body = ERB.new(config['body'])

gmail = Gmail.connect(ARGV[0], ARGV[1])

# variable 'name' is important given it is used in body as well
for name, email_id in config['to'] do
    puts "sending to #{email_id}"
   	email = gmail.compose do
	    to email_id
	    from config['from']
   	    subject config['subject']
   	    body body.result(binding)
	end
	email.deliver!
end

gmail.logout
