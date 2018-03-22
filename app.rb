require 'sinatra'
require 'csv'

get '/' do
  erb :index
end

post '/' do
  result = {}

  CSV.foreach(params[:file][:tempfile]) do |row|
    result[row[0]] = (result[row[0]] || 0) + row[1].to_f
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
