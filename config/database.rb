require 'sinatra/sequel'
require 'yaml'

content = File.new("config/database.yml").read
settings = YAML.load(content)

set :database, "#{settings['adapter']}://#{Dir.pwd}/config/#{settings['database']}"
puts "the questions table doesn't exist" if !database.table_exists?('questions')

migration "create question table" do
  database.create_table :questions do
    primary_key :id
    text        :question, :null => :false
    integer     :correct 
    integer     :wrong
  end
end

#ex) Question.new(question,correct#,wrong#)
class Question < Sequel::Model
  attr_accessor :question, :correct, :wrong
end

migration "seed the database" do
  q = Question.new
  q[:question] = "Does it have 4 legs?"
  q[:correct] = 2
  q.save
  q = Question.new
  q[:question] = "Is it a horse?"
  q.save
end
