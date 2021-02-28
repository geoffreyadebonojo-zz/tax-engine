# Simulates user upload
csv_path = "#{Rails.root.to_s}/spec/csvs/brackets/basic_functionality_test.csv"
data = CSVParser.execute(csv_path)

uuid = "9b44abb039da2fec8bbb"
User.create!(uuid: uuid, tax_brackets: data)
