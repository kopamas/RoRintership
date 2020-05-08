#card = ['suit', rank]
def show (card)       # show - methods to print card's name to console in RIGHT way - with J,Q,K,A
  if card[0] == 1
    card[0] = 'H' # H ==1, D==2, C==3, S==4
  elsif card[0] == 2 then card[0] = 'D'
  elsif card[0] == 3 then  card[0] = 'C'
  elsif card[0] == 4 then  card[0] = 'S'
  end
  if card[1] == 11
    card[1] = 'J'
  elsif card[1] == 12 then    card[1] = 'Q'
  elsif card[1] == 13 then    card[1] = 'K'
  elsif card[1] == 14 then    card[1] = 'A'
  end
  print card
end
pack_of_card = Array.new(52)  #suit = ['H','D','S','C']
z=0
for r in 2..14
  for i in 1..4
    pack_of_card[z] = [i, r]
    z +=1    #show [suit[i], r]
  end
end
def array_suit_rank (cards) #cards is array of 7 cards
  cards.sort!{|first,second| second<=>first}
  h=Array.new; d=Array.new; c=Array.new; s=Array.new
  (0..6).each { |i| #sorting card by suit in 4 different array h,d,s,c
    if cards[i][0] == 1
      h.push(cards[i][1])
    elsif cards[i][0] == 2
      d.push(cards[i][1])
    elsif cards[i][0] == 3
      c.push(cards[i][1])
    elsif cards[i][0] == 4
      s.push(cards[i][1])
    end
  }
  { :suit_H => h,  :suit_D => d,  :suit_C => c,  :suit_S => s }
end
c = Array.new(7) {rand(0..51)} #выбор случайных карт без проверки их не повторяемости.
card_in_game = Array.new
(0..6).each { |m|  card_in_game[m] = pack_of_card[c[m]] }
print 'Cards in game:'
print card_in_game
hash_7_card = array_suit_rank card_in_game
print"\n Cards on the table: "
(2..6).each { |n|  show pack_of_card[c[n]] }
print "\n Cards in hand of your player: "
show pack_of_card[c[0]]
show pack_of_card[c[1]]
 # методы для поиска выигрышной комбинации из набора карт hash_7_card
def flash_straight(hash_7_card)
  # метод получает 7 карт в таблице (hash) key=suit, value=[rank]все в виде чисел
  # one suit : 14-i,13-i,12-i,11-i,10-i where i in 0..8
  (0..8).each { |i|
    hash_7_card.each {|s, r|
      next unless r.length >= 5 #если более либо равно 5 карт в масти то сравнивается массив масти и все комбинации этой номинации
      if [14 - i, 13 - i, 12 - i, 11 - i, 10 - i] & r == [14 - i, 13 - i, 12 - i, 11 - i, 10 - i]
        return [s, [14 - i, 13 - i, 12 - i, 11 - i, 10 - i]]
      end
    }
  }
  nil
end
def four_of_kind(hash_7_card)
  # 4 suit : 14-i,14-i,14-i,14-i where i in 0..12
  (0..12).each {  |i|
    fok = Hash.new(nil)
    num = 0
    hash_7_card.each {  |s, _r|
      next unless [14 - i] & hash_7_card[s] == [14 - i]
      fok[s] = [14 - i]
      num += 1
      return fok if num == 4
    }
  }
  nil
end
def full_house(hash_7_card)
  # any suit : 14-i,14-i,14-i where i in 0..12 and any suit : 14-e,14-e where e in 0..12
  (0..12).each {  |i|
    fok = Hash.new(nil)
    num = 0
    hash_7_card.each {  |s, _r|
      next unless [14 - i] & hash_7_card[s] == [14 - i]
      fok[s] = [14 - i]
      num += 1
      next unless num==3
      (0..12).each {  |j|
        fok_1 = Hash.new(nil)
        num_1 = 0
        hash_7_card.each {  |su, _ra|
          next unless [14 - j] & hash_7_card[su] == [14 - j]
          fok_1[su] = [14 - j]
          num_1 += 1
          return fok,fok_1 if (num_1==2)&&(fok[su]!=fok_1[su])
        }
      }
    }
  }
  nil
end
def flush(hash_7_card)
  # 1 suit : any 5 card
  fl=Hash.new
    hash_7_card.each {|s, r|
      next unless r.length >= 5 #если более либо равно 5 карт в масти то сравнивается массив масти и все комбинации этой номинации
      fl[s] = r[0..4]
      return fl
    }
  nil
end
def straight(hash_7_card)
  # any suit : 14-i,13-i,12-i,11-i,10-i where i in 0..8
  str=Hash.new
  (0..8).each { |i|
    d=[14-i,13-i,12-i,11-i,10-i]
    hash_7_card.each do |s,_r|
      str[s]=hash_7_card[s]&d
    end
    z=Array.new #проверка что полученый массив включает в себя искомый массив
    str.each{|_s,r|
      z +=r }
    return str if d&z == d
  }
  nil
end
def three(hash_7_card)
  # any suit : 14-i,14-i,14-i where i in 0..12
  str=Hash.new
  (0..12).each { |i|
    d=[14-i,14-i,14-i]
    hash_7_card.each do |s,_r|
      str[s]=hash_7_card[s]&d
    end
    z=Array.new #проверка что полученый массив = искомый массив
    str.each{|_s,r|
      z +=r }
    return str if z == d
  }
  nil
end
def two_pair(hash_7_card)
  # any suit : 14-i,14-i where i in 0..12 and any suit : 14-i,14-i where i in 0..12
  (0..12).each {  |i|
    fok = Hash.new(nil)
    num = 0
    hash_7_card.each {  |s, _r|
      next unless [14 - i] & hash_7_card[s] == [14 - i]
      fok[s] = [14 - i]
      num += 1
      next unless num==2
      (0..12).each {  |j|
        fok_1 = Hash.new(nil)
        num_1 = 0
        hash_7_card.each {  |su, _ra|
          next unless [14 - j] & hash_7_card[su] == [14 - j]
          fok_1[su] = [14 - j]
          num_1 += 1
          return fok,fok_1 if (num_1==2)&&(fok[su]!=fok_1[su])
        }
      }
    }
  }
  nil
end
def one_pair(hash_7_card)
  # any suit : 14-i,14-i where i in 0..12
  (0..12).each {  |i|
    fok = Hash.new(nil)
    num = 0
    hash_7_card.each {  |s, _r|
      next unless [14 - i] & hash_7_card[s] == [14 - i]
      fok[s] = [14 - i]
      num += 1
      next unless num==2
      return fok
    }
  }
  nil
end
def high_card(hash_7_card)
  # any suit : 14-i,14-i where i in 0..12
  (0..12).each {  |i|
    fok = Hash.new(nil)
    hash_7_card.each {  |s, _r|
      next unless [14 - i] & hash_7_card[s] == [14 - i]
      fok[s] = [14 - i]
      return fok
    }
  }
  nil
end
the_win_comb = { flash_straight: nil, for_of_kind: nil, full_house: nil, flush: nil,
                 straight: nil, three: nil, two_pair: nil, one_pair: nil,
                 high_card: nil }
the_win_comb[:flash_straight] = flash_straight hash_7_card
the_win_comb[:four_of_kind] = four_of_kind hash_7_card
the_win_comb[:full_house] = full_house hash_7_card
the_win_comb[:flush] = flush hash_7_card
the_win_comb[:straight] = straight hash_7_card
the_win_comb[:three] = three hash_7_card
the_win_comb[:two_pair] = two_pair hash_7_card
the_win_comb[:one_pair] = one_pair hash_7_card
the_win_comb[:high_card] = high_card hash_7_card

puts "\n The winner combination and cards are  - " #вывод названий выигрышных комбинаций от старшей к младшей, и их карт
the_win_comb.each {  |comb, ans|  print comb.upcase, the_win_comb[comb], ' ' unless ans.nil?}





