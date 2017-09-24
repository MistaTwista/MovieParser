require 'money'

# Help with I18n::InvalidLocale: :en is not a valid locale
I18n.enforce_available_locales = false

module Cashbox
  CURRENCY = 'USD'

  def cash
    @cash || money(0)
  end

  def take(who)
    raise 'Everybody be cool, this is a robbery!' if who != "Bank"
    make_encashment
  end

  def deposit_cash(amount)
    self.cash += money(amount)
  end

  private

  def money(amount)
    Money.new(amount, CURRENCY)
  end

  def cash=(amount)
    @cash = money(amount)
  end

  def make_encashment
    self.cash = money(0)
  end
end
