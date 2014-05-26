class Decision
  def initialize(input = STDIN, output = STDOUT)
    @input = input
    @output = output
  end

  def question=(question)
    @question = question
  end

  def ask!
    @output.puts @question
    @answer = @input.gets.chomp
    @output.puts 'The answer was: ' + @answer
  end
end
