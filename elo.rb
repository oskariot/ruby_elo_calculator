require_relative './colorize.rb'
require_relative './utils.rb'
require 'ordinalize_full/integer'

def get_input(prompt, error_msg, first_prompt_ready = false)
  if first_prompt_ready
    Color.bold_yellow
  else
    in_color('bold_blue', 'bold_yellow') { print prompt, ' ' }
  end
  until yield(value = gets.chomp)
    in_color('bold_blue', 'bold_yellow') { print "#{error_msg}\n#{prompt} " }
  end
  value
end

ELO_TABLE = [
    0, 4, 11, 18, 26, 33, 40, 47, 54, 62, 69, 77, 84, 92, 99, 107, 114, 122,
    130, 138, 146, 154, 163, 171, 180, 189, 198, 207, 216, 226, 236, 246,
    257, 268, 279, 291, 303, 316, 329, 345, 358, 375, 392
]

def expected(self_rating, op_rating)
  diff = (self_rating - op_rating).abs
  exp = diff >= 392 ? 0.42 : (ELO_TABLE.index { |x| x > diff } - 1).fdiv(100)
  (self_rating > op_rating ? 0.5 + exp : 0.5 - exp).round(2)
end

begin
  in_color 'bold_blue' do
    puts 'ELO Calculator by Oskar Wieczorek'
    puts 'Type your rating and press <ENTER>'
  end

  self_rating = (get_input 'Your rating:', 'Incorrect rating!', true do |val|
    val.is_i? && val.to_i.between?(1, 2999)
  end).to_i

  n_of_games = (get_input 'Nº of games:', 'Incorrect number!' do |val|
    val.is_i?
  end).to_i

  n_of_points = (get_input 'Nº of points:', 'Incorrect number!' do |val|
    val.is_f? && (val.to_f % 0.5).zero? && val.to_f.between?(0, n_of_games)
  end).to_f

  expected_overall = 0.0
  1.upto(n_of_games) do |i|
    opponent_rating = (get_input "#{i.ordinalize} opponent's rating:", 'Incorrect rating!' do |val|
      val.is_i? && val.to_i.between?(1, 2999)
    end).to_f
    expected_overall += expected(self_rating, opponent_rating)
  end

  k_factor = (get_input 'K factor:', 'Incorrect factor!' do |val|
    val.is_i? && [10, 20, 40].include?(val.to_i)
  end).to_i

  elo_change = ((n_of_points - expected_overall).round(2) * k_factor).round(2)

  in_color('bold_blue') { print 'ELO change: ' }
  in_color(elo_change >= 0.0 ? 'bold_green' : 'bold_red') { puts format("%+g\n", elo_change) }
rescue SystemExit, Interrupt
  puts
rescue StandardError => e
  Color.bold_red
  puts "\nError! \n#{e}"
ensure
  Color.default
end
