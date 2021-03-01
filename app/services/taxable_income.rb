class TaxableIncome

  attr_reader :tax_brackets

  def initialize(tax_brackets)
    # Sorting just in case the brackets got out of order
    @tax_brackets = tax_brackets.sort_by { |bracket| bracket[:lowest_amount] }.reverse!
  end

  def calculate_total_amount(taxable_income)
    total_tax_amount = 0
    # We're going to work our way down the tax brackets from highest to lowest
    # subtracting the amount we've already taxed, then iterating
    tax_brackets.each do |bracket|
      # For each tax bracket, take all the income above the lowest amount,
      # to determine the amount of income within that tax bracket
      # and use the corresponding tax percentage to get the amount of tax owed on that amount of income.
      amount_over_lowest_amount = taxable_income - bracket[:lowest_amount]
      # If we have any income left after that subtraction,
      if amount_over_lowest_amount > 0
        # then we want to take that amount out of income left to run taxes on,
        taxable_income -= amount_over_lowest_amount
        # then calculate the taxes owed on it and
        taxes_owed_on_bracket = amount_over_lowest_amount * bracket[:percentage]
        # and add it to the total
        total_tax_amount += taxes_owed_on_bracket
      else
        # If this is the final tax bracket, i.e. the amount of remaining untaxed income
        # does not exceed the size of this tax bracked, ignore brackets after that.
        total_tax_amount += 0
      end
    end
    # Finally, return the sum of taxes owed from each tax bracket
    total_tax_amount.round(3)
  end

  # This method assumes that the tax brackets are sequential, meaning that:
  # if:
  #       tax bracket 1 has lowest_amount=0,
  #       tax bracket 2 has lowest_amount=10,000,
  #       tax bracket 3 has lowest_amount=20,000,
  # Then:
  #       bracket 1 includes all amounts from 0 to 9999,
  #       bracket 2 includes all amounts from 10,000 to 19,999.
  #       bracket 3 includes all amounts from 20,000 and up.
  #
  # This is for ease of entry and assumes there are no weird gaps between tax brackets:
  # e.g. 10,000 to 14,999 is taxed at 10%
  # and  20,000 to 50,000 is taxed at 20%,
  # BUT for some odd reason
  # the amounts between 15,000 and 19,999 have no corresponding bracket.
  # That would be weird.
  #
  # If 15,000 to 19,999 is taxed at 0%, you need to create a bracket for that:
  # { lowest_amount: 15000, percentage: 0 }
  # or things could get weird.
end
