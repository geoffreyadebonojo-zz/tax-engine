require 'csv'

module CSVParser
  def self.execute(path)
    csv_text = File.read(path)
    csv = CSV.parse(csv_text, :headers => true)
    csv.map do |row|
      {
        lowest_amount:       row["lowest_amount"].to_i,
        percentage:  row["percentage"].to_f
      }
    end
  end
end
