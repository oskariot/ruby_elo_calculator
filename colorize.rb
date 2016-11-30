class Color
  def self.default
    print "\e[0m"
  end

  def self.bold_red
    print "\e[1m\e[31m"
  end

  def self.bold_green
    print "\e[1m\e[32m"
  end

  def self.bold_blue
    print "\e[1m\e[34m"
  end

  def self.bold_yellow
    print "\e[1m\e[33m"
  end
end

def in_color(color_start, color_end = 'default')
  Color.send(color_start)
  yield
  Color.send(color_end)
end