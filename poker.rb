# create array of cards for game
# need nothing for input, output is hash_7_card for analize in Combinatioins.class
class Card_on_table

  def initialize
    # create array of cards for game
    # 7 random (snuffle) card taking into game form pack_of_card
    @pack_of_card = Array.new # suit = ['H','D','S','C']
  end

  #get 7 random (snuffle) card taking into game form pack_of_card
  # prepare $hash_7_card for Combination.class with the help of array_suit_rank method
  def card_in_game
    (2..14).each  {|r| (1..4).each { |i| @pack_of_card << [i, r] }}
    @cards = @pack_of_card.shuffle.take(7)
    # @hash_7_card is hash prepared for analyze combinations and the highest combination to win
    $hash_7_card = array_suit_rank
  end

  # show - methods to print card's name to console in RIGHT way - with J,Q,K,A for rates and H,D,C,S for suits
  # card = ['suit', rank] is element of pack_of_card
  def show(card)
    # H ==1, D==2, C==3, S==4
    card[0] = 'H' if card[0] == 1
    card[0] = 'D'if card[0] == 2
    card[0] = 'C' if card[0] == 3
    card[0] = 'S' if card[0] == 4
    card[1] = 'J' if card[1] == 11
    card[1] = 'Q' if card[1] == 12
    card[1] = 'K' if card[1] == 13
    card[1] = 'A' if card[1] == 14
    card
  end

  # putting cards into hash, where key is suits(H,D,S,C), value is 4 different descending arrays
  # method for array of 7 cards like [siut,rate]
  def array_suit_rank
    h = []; d = []; c = []; s = []
    (0..6).each { |i|
      h << (@cards[i][1]) if @cards[i][0] == 1
      d<<(@cards[i][1]) if @cards[i][0] == 2
      c<<(@cards[i][1]) if @cards[i][0] == 3
      s<<(@cards[i][1]) if @cards[i][0] == 4 }
    # sort rank in any suit
    { :suit_H => h, :suit_D => d, :suit_C => c, :suit_S => s }.each { |suit, rank|
      rank.sort! { |first, second| second <=> first } }
  end

  #take 7 ramdom cards for game
  # print "cards in game", "Cards on table", "cards in hand of player"
  # output hash_7_card for Combinations.class
  def open_card
    card_in_game
    return $hash_7_card
  end

  # print "cards in game", "Cards on table", "cards in hand of player" and hash for class Combinations
  def print_game
    print " Cards in game: "
    (0..6).each { |c| print show @cards[c] }
    print "\n Cards on the table: "
    (2..6).each { |n| print show @cards[n] }
    print "\n Cards in hand of your player: "
    (0..1).each { |index| print show @cards[index] }
    print "\n Hash to analize combinations in game: ",$hash_7_card
  end
end
# COmbinations - methods to search combinations from higher rate to lower rate in one class - Combinations
# input hash_7_card - hash of 7 cards : 5 cards on the table and 2 cards in the Hand of Player
# output is Name of higher combination and it's cards
class Combinations
  def initialize (card_on_table)
    @hash_7_card = card_on_table
  end
  # one suit : 14-i,13-i,12-i,11-i,10-i where i in 0..8
  def flash_straight
    (0..8).each { |i|
      @hash_7_card.each {|s, r|
        next unless r.length >= 5 #если более либо равно 5 карт в масти то сравнивается массив масти и все комбинации этой номинации
        if [14 - i, 13 - i, 12 - i, 11 - i, 10 - i] & r == [14 - i, 13 - i, 12 - i, 11 - i, 10 - i]
          return {s => [14 - i, 13 - i, 12 - i, 11 - i, 10 - i]}
        end
      }
    }
    nil
  end
  # 4 suit : 14-i,14-i,14-i,14-i where i in 0..12
  def four_of_kind
    (0..12).each {  |i|
      fok = {}
      num = 0
      @hash_7_card.each {  |s, _r|
        next unless [14 - i] & @hash_7_card[s] == [14 - i]
        fok[s] = [14 - i]
        num += 1
        return fok if num == 4
      }
    }
    nil
  end
  # any suit : 14-i,14-i,14-i where i in 0..12 and any suit : 14-e,14-e where e in 0..12
  def full_house
    (0..12).each {  |i|
      fok = {}
      num = 0
      @hash_7_card.each {  |s, _r|
        next unless [14 - i] & @hash_7_card[s] == [14 - i]
        fok[s] = [14 - i]
        num += 1
        next unless num==3
        (0..12).each {  |j|
          fok_1 = Hash.new(nil)
          num_1 = 0
          @hash_7_card.each {  |su, _ra|
            next unless [14 - j] & @hash_7_card[su] == [14 - j]
            fok_1[su] = [14 - j]
            num_1 += 1
            return fok,fok_1 if (num_1==2)&&(fok[su]!=fok_1[su])
          }
        }
      }
    }
    nil
  end
  # 1 suit : any 5 card
  def flush
    fl=Hash.new
    @hash_7_card.each {|s, r|
      next unless r.length >= 5 #если более либо равно 5 карт в масти то сравнивается массив масти и все комбинации этой номинации
      fl[s] = r[0..4]
      return fl
    }
    nil
  end
  # any suit : 14-i,13-i,12-i,11-i,10-i where i in 0..8
  def straight
    str= {}
    (0..8).each { |i|
      d=[14-i,13-i,12-i,11-i,10-i]
      @hash_7_card.each { |s,_r| str[s]=@hash_7_card[s]&d }
      #check that {str} has the right array of combination - straight
      z=[]
      str.each{|_s,r| z +=r }
      return str if d&z == d
    }
    nil
  end
  # any suit : 14-i,14-i,14-i where i in 0..12
  def three
    str=Hash.new
    (0..12).each { |i|
      d=[14-i,14-i,14-i]
      @hash_7_card.each {|s,_r| str[s]=@hash_7_card[s]&d }
      z=Array.new #checking that the array we did is really our target
      str.each{|_s,r| z +=r}
      return str if z == d
    }
    nil
  end
  # any suit : 14-i,14-i where i in 0..12 and any suit : 14-i,14-i where i in 0..12
  def two_pair
    (0..12).each {  |i|
      fok = Hash.new(nil)
      num = 0
      @hash_7_card.each {  |s, _r|
        next unless [14 - i] & @hash_7_card[s] == [14 - i]
        fok[s] = [14 - i]
        num += 1
        next unless num==2
        (0..12).each {  |j|
          fok_1 = Hash.new(nil)
          num_1 = 0
          @hash_7_card.each {  |su, _ra|
            next unless [14 - j] & @hash_7_card[su] == [14 - j]
            fok_1[su] = [14 - j]
            num_1 += 1
            return fok,fok_1 if (num_1==2)&&(fok[su]!=fok_1[su])
          }
        }
      }
    }
    nil
  end
  # any suit : 14-i,14-i where i in 0..12
  def one_pair
    (0..12).each {  |i|
      fok = Hash.new(nil)
      num = 0
      @hash_7_card.each {  |s, _r|
        next unless [14 - i] & @hash_7_card[s] == [14 - i]
        fok[s] = [14 - i]
        num += 1
        next unless num==2
        return fok
      }
    }
    nil
  end
  # any suit : 14-i where i in 0..12
  def high_card
    (0..12).each {  |i|
      fok = Hash.new(nil)
      @hash_7_card.each {  |s, _r|
        next unless [14 - i] & @hash_7_card[s] == [14 - i]
        fok[s] = [14 - i]
        return fok
      }
    }
    nil
  end

  #method to find and print name and cards to win
  def winner
    $the_win_comb = { flash_straight: flash_straight, for_of_kind: four_of_kind, full_house: full_house,
                      flush: flush, straight: straight, three: three, two_pair: two_pair,
                      one_pair: one_pair, high_card: high_card }
    puts "\n The highest winner combinations and cards are  - "
    $the_win_comb.each {  |comb, ans| return puts comb.upcase, $the_win_comb[comb], ' ' unless ans.nil?}
  end

  #method to find name and cards to win
  def winner_comb
    $the_win_comb = { flash_straight: flash_straight, for_of_kind: four_of_kind, full_house: full_house,
                      flush: flush, straight: straight, three: three, two_pair: two_pair,
                      one_pair: one_pair, high_card: high_card }
  end
end

#method to answer time to win with specified name of combination
def comb_to_win
  s = Card_on_table.new
  g =Combinations.new(s.open_card)
  g.winner_comb
  print "\n Give me name of combinations you wonna see on the table.\n You can choose of: "
  $the_win_comb.each{|name,m| print name, '  '}
  comb = gets.chomp.to_sym
  puts "Wait! I am working, trying to find combination : #{comb}!"
  itr = 0
  time_1 = Time.now
  find_comb = $the_win_comb[comb]
  while find_comb == nil do
    itr+=1
    s = Card_on_table.new
    g =Combinations.new(s.open_card)
    g.winner_comb
    find_comb = $the_win_comb[comb]
    time_2 = Time.now
  end
  print 'Number of itterations - ',itr, '   Time of work,s - ',time_2-time_1
end

puts "To play game - print 1
program will answer best combination to win
with cards in your hand and on the table

To find combination you are interested for - print 2"

way_of_program = gets.chomp.to_i

if way_of_program==1 then
  start = Card_on_table.new
  game =Combinations.new(start.open_card)
  game.winner
elsif way_of_program==2 then
  p= comb_to_win
else
  puts "\n Please make your choice 1 or 2"
end
