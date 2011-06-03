require 'rubygems'
require 'sinatra'
require 'config/database'

helpers do

  def link_to(url, title)
    "<a href='#{url}'>#{title}</a>"
  end

  def from_id
    (@question && @question[:id]) || Integer(params[:from])
  end

  def create_from_correct params
    previous_question = Question.find(:id => params[:from][:id])
    new_question = Question.new
    new_question[:question] = params[:new_question][:question]
    new_question[:wrong] = previous_question[:correct]
    
    new_answer = Question.new
    new_answer[:question] = params[:answer][:question]
    new_answer.save

    new_question[:correct] = new_answer[:id]
    new_question.save

    previous_question[:correct] = new_question[:id]
    previous_question.save
  end

  def create_from_wrong params
    previous_question = Question.find(:id => params[:from][:id])
    new_question = Question.new
    new_question[:question] = params[:new_question][:question]
    new_question[:wrong] = previous_question[:wrong]

    new_answer = Question.new
    new_answer[:question] = params[:answer][:question]
    new_answer.save

    new_question[:correct] = new_answer[:id]
    new_question.save
    
    previous_question[:wrong] = new_question[:id]
    previous_question.save
  end
end


get '/' do
  erb :index
end


get '/question/:id' do
  @question = Question.find(:id => params[:id])
  if @question.nil?
    redirect '/question/1'
  else
    erb :questions
  end
end

#prompts the user to enter a new question, and an answer for that question?
get '/newquestion/:from' do
  #basically, if there's a correct pointing to the one we just came from,
  #assign @question to it, else find the Question who has a :wrong to our :from
  if @question = Question.find(:correct => params[:from]) #does this work?
    @type = :correct
  else
    @question = Question.find(:wrong => params[:from])
    @type = :wrong
  end
  puts params.inspect
  if @question.nil? && params[:from] != "1"
    redirect '/question/:from'
  else
    erb :newquestion
  end
end

get '/solved' do 
  erb :solved
end

post '/create' do
 puts params.inspect 

 if params[:from][:type] == "correct"
   create_from_correct(params)
 else
   create_from_wrong(params)
 end

 redirect '/question/1'
 
end
