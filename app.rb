require 'sinatra'
require 'sinatra/json'
require "sinatra/reloader" if development?
require 'pry'

set :bind, '0.0.0.0'

database = {
  "1" => {
    type: 'proxy_data_tables',
    id: 1,
    attributes: {
      name: 'my_table',
      table_type: 'ip',
      items: [
        { key: '192.168.1.1', value: 'some value' }
      ]
    }
  }
}

get "/proxy_data_tables/?" do
  json data: database.values
end

get "/proxy_data_tables/:id" do |id|
  json data: database[id]
end

post "/proxy_data_tables/?" do
  json = JSON.parse(request.body.read)
  database[json['data']['id']] = json['data']
  201
end

put "/proxy_data_tables/:id" do |id|
  json = JSON.parse(request.body.read)
  database[id] = json['data']
  200
end

get "/*" do
  json data: "Ok"
  200
end

post "/*" do
  json data: "Ok"
  201
end
