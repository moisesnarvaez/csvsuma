require 'sinatra'
require 'csv'

def process_csv(params, separator)
  result = {}
  CSV.foreach(params[:file][:tempfile], { :col_sep => separator }) do |row|
    result[row[0]] = (result[row[0]] || 0) + row[1].to_f
  end
  result
end

get '/' do
  erb :index
end

post '/' do
  begin
    result = process_csv(params, ',')
  rescue
    result = process_csv(params, ';')
  end

  content_type 'application/csv'
  attachment   'totales.csv'

  CSV.generate do |csv|
    result.map do |k, v|
      lb = (v / 1000) * 2.20462
      csv << [k, lb.ceil]
    end
  end
end
