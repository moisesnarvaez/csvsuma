require 'sinatra'
require 'csv'

def process_csv(params)
  result = {}
  options = {
    col_sep: params[:separator],
    encoding: 'ISO-8859-1'
  }
  CSV.foreach(params[:file][:tempfile], options) do |row|
    result[row[0]] = (result[row[0]] || 0) + row[1].to_f
  end
  result
end

get '/' do
  erb :index
end

post '/' do
  content_type 'application/csv'
  attachment   'totales.csv'

  result = process_csv(params)

  CSV.generate do |csv|
    result.map do |k, v|
      lb = (v / 1000) * 2.20462
      csv << [k, lb.ceil]
    end
  end
end
