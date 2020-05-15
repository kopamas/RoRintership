
    puts "To play game - print 1
    program will answer best combination to win
    with cards in your hand and on the table
    
    To find combination you are interested for - print 2"
    
    way_of_program = gets.chomp.to_i
    
    if way_of_program==1 then
      start = CardOnTable.new
      start.print_game
      game =Combinations.new(start.card_in_game)
      game.winner
    elsif way_of_program==2 then
      find_combination
    else
      puts "\n Please make your choice 1 or 2"
    end
    
describe 'Poker game' do
  it 'choose way of program' do
    expect(2).to eq('z')
  end
end