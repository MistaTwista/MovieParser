module Cashbox
  def cash
    @cash || 0
  end

  def take(who)
    raise 'Everybody be cool, this is a robbery!' if who != "Bank"
    make_encashment
  end

  private

  def cash=(amount)
    @cash = amount
  end

  def make_encashment
    self.cash = 0
  end

  def withdraw(amount)
    validate_enough!(amount)
    self.cash -= amount
  end

  def deposit(amount)
    self.cash += amount
  end

  def validate_enough!(amount)
    if self.cash < amount
      raise "Insufficient funds. Cost #{amount} and you have #{cash}"
    end
  end
end

module OnlineTheatre
  def pay(amount)
    deposit(amount)
  end
end

module TicketMaster
  def buy_ticket(title)
    deposit_bought(title)
    puts "You bought ticket to #{title}"
  end
end
