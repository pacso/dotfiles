module Decideable
  def ask(question)
    decideable.ask question
  end

  def decideable
    @decideable ||= Decision.new
  end

  class Decision
    def initialize
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
      $stdout.print @question + ' [ynaq]: '
    end

    def get_response
      unless @all_positive
        output_question
        @response = $stdin.gets.chomp.downcase
        get_response unless allowed_responses.include? @response
      end
    end

    def parse_response
      if @response == 'q'
        ConsoleNotifier.banner 'Terminating Execution'
        exit
      end
      @all_positive = true if @response == 'a'
      @all_positive || @response == 'y'
    end

    def allowed_responses
      %w{y n a q}
    end
  end
end

