class Decision
  def initialize(input = STDIN, output = STDOUT)
    @input = input
    @output = output
    @all_positive = false
  end

  def ask(question)
    @question = question
    @response = nil
    get_response
    parse_response
  end

  private

  def output_question
    @output.print @question + ' [ynq]: '
  end

  def get_response
    unless @all_positive
      output_question
      @response = @input.gets.chomp.downcase
      get_response unless allowed_responses.include? @response
    end
  end

  def parse_response
    exit if @response == 'q'
    @all_positive = true if @response == 'a'
    @all_positive || @response == 'y'
  end

  def allowed_responses
    %w{y n a q}
  end
end
