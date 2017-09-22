module Cashbox
  def account
    @account || 0
  end

  def cash
    account
  end

  def take(who)
    raise 'Everybody be cool, this is a robbery!' if who != "Bank"
    make_encashment
  end

  private

  def account=(amount)
    @account = amount
  end

  def make_encashment
    self.account = 0
  end

  def withdraw(amount)
    validate_enough!(amount)
    self.account -= amount
  end

  def deposit(amount)
    self.account += amount
  end

  def validate_enough!(amount)
    if account < amount
      raise "Insufficient funds. Cost #{amount} and you have #{account}"
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
