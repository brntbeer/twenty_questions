require 'twenty_questions'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class QuestionsTest < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end

  def test_root
    get '/'
    assert last_response.ok?
  end

  def test_solved
    get '/solved'
    assert last_response.ok?
  end

  def test_question_id_looks_up_correct_question
    get '/question/1'
    assert last_response.ok?
    question = Question[:id => 1][:question]
    assert_equal("Does it have 4 legs?", question)
  end

  def test_table_should_not_start_empty
    nodes = Question.all
    assert (nodes.size > 0)
  end

  def test_question_cannot_be_blank
    question = Question.all.first
    assert_not_nil(question[:question].nil?)
  end

end
