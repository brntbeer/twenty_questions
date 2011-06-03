require 'test/unit'
require 'rubygems'
require 'sinatra'
require 'config/database.rb'

class QuestionsTest < Test::Unit::TestCase
  
  def setup
  end

  def test_table_should_not_start_empty
    nodes = Question.all
    assert (nodes.size > 0)
  end

  def test_question_cannot_be_blank
    assert true
  end

end
