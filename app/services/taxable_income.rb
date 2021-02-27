class TaxableIncome
  include CSVParser

  attr_reader :tax_brackets
  # def initialize(tax_brackets)
  def initialize(csv_path)
    brackets = CSVParser.execute(csv_path)
    # sort just in case our array is out of order
    @tax_brackets = brackets.sort_by {|hsh| hsh[:limit]}.reverse!
  end

  def calculate_total_amount(taxed_income)
    total_tax_amount = 0

    tax_brackets.each do |bracket|
      amount_over_limit = taxed_income - bracket[:limit]

      if amount_over_limit > 0
        taxed_income     -= amount_over_limit
        total_tax_amount += amount_over_limit * bracket[:percentage]
      else
        total_tax_amount += 0
      end

    end

    total_tax_amount.round(3)
  end

  # a couple of assumptions
  # 1) the tax brackets are sequential: meaning that
  #    if tax bracket 1 has limit 10,000
  #    and tax bracket 2 has limit 20,000
  #    bracket y includes all amounts from 10,001 to 20,000.
  #    This is for ease of entry and assumes there are no weird gaps
  #    between tax brackets, e.g. 10,000 to 14,999 is taxed at 10%
  #    and 20,000 to 50,000 is taxed at 20%, but for some odd reason
  #    amounts between 15,000 and 19,999 have no corresponding bracket.
  #    If 15,000 to 19,999 is taxed at 0% you need a bracket for that.
  # 2) Bracket data is being retrieved from user-provided CSV uploaded.
  #    to our S3 bucket. There's always a bit of risk in that.
  #    Users need make sure they use the correct formatting, or things will
  #    out of whack. There are only two columns now, so any problem will be
  #    easy to spot, but in the future we may need a more robust solution.
end
