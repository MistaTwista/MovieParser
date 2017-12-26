require 'money'

# Help with I18n::InvalidLocale: :en is not a valid locale
I18n.enforce_available_locales = false

module Movienga
  # Add cashbox to instance or class
  module Cashbox
    CURRENCY = 'USD'.freeze

    # Current cash count
    def cash
      @cash || money(0)
    end

    # Take cash from cashbox
    #
    # @param who [String] Call to police if not a bank there
    def take(who)
      raise 'Everybody be cool, this is a robbery!' if who != 'Bank'
      make_encashment
    end

    # Shut up and take their money!
    #
    # @param amount [Number] Amount of money to deposit
    def deposit_cash(amount)
      self.cash += money(amount)
    end

    # Creates money!
    def money(amount, money_class = Money)
      money_class.new(amount, CURRENCY)
    end

    private

    def cash=(amount)
      @cash = money(amount)
    end

    def make_encashment
      self.cash = money(0)
    end
  end
end
