class ConsoleNotifier
  MAX_WIDTH = 80

  def self.banner(text)
    n = ConsoleNotifier.new
    n.banner(text)
  end

  def banner(text, width = 60)
    $stdout.puts "\n" + '#' * width
    banner_lines(text, width).each do |line|
      $stdout.puts hash_wrap line, width
    end
    $stdout.puts '#' * width + "\n\n"
  end

  private

  def hash_wrap(text, width)
    '# ' + "%-#{width - 4}.#{width - 4}s" % text + ' #'
  end

  def banner_lines(text, width)
    text_width = width - 4
    lines = []

    if text.length > text_width
      process_text = text
      while process_text.length > 0
        if process_text.length <= text_width
          segment = process_text.dup
        else
          split_point = process_text.enum_for(:scan, / /).map { Regexp.last_match.begin(0) if Regexp.last_match.begin(0) < text_width }.compact.last
          segment = process_text.slice(0, split_point)
        end
        lines << segment
        process_text.gsub!(segment, '').strip!
      end
    else
      lines << text
    end

    lines
  end
end
