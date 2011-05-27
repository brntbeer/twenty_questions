require 'rubygems'
require 'sinatra'
require 'config/database'

helpers do
  def link_to(url, title)
    "<a href='#{url}'>#{title}</a>"
  end
end

get '/' do
  erb :index
end


get '/question/:id' do
  @question = Question.find(:id => params[:id])
  erb :questions
end

#prompts the user to enter a new question, and an answer for that question?
get '/newquestion/:from' do
  @question = Question.find(:id => params[:from])
  erb :newquestion
end

#create the new questions as we need to
#regardless of what happens we're creating two new questions
# but we need to make sure we're pointing questions to the correct place
