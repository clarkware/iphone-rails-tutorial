require 'rubygems'
require 'active_resource'
require 'highline/import'

def prompt(prompt, mask=true)
  ask(prompt) { |q| q.echo = mask}
end

class Goal < ActiveResource::Base
  login = prompt('Login: ')
  password = prompt('Password: ', '*')
  
  #self.site = "http://#{login}:#{password}@localhost:3000/"
  self.site = "http://#{login}:#{password}@saveup.heroku.com/"
end

goals = Goal.all
puts goals.map(&:name)
