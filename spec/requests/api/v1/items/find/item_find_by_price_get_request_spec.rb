require 'rails_helper'

describe "Find Item by Price Get Request" do
  it "returns an item given a minimum price" do
    create_list(:merchant, 3)
    findable = create(:item, unit_price: Faker::Number.within(range: 100.00..1000.00))
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.99))

    get "/api/v1/items/find?min_price=100"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    item = data[:data]

    expect(item[:id].to_i).to eq(findable.id)
    expect(item[:attributes][:unit_price]).to be >= 100
  end

  it "returns all items given a maximum price" do
    create_list(:merchant, 3)
    findable = create(:item, unit_price: Faker::Number.within(range: 1.00..250.00))
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 251.00..1000.00))

    get "/api/v1/items/find?max_price=250"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    item = data[:data]

    expect(item[:id].to_i).to eq(findable.id)
    expect(item[:attributes][:unit_price]).to be <= 250
  end

  it "returns all items given a minimum and maximum price" do
    create_list(:merchant, 3)
    findable = create(:item, unit_price: Faker::Number.within(range: 100.00..500.00))
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
    lost_items_2 = create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

    get "/api/v1/items/find?min_price=100&max_price=500"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    item = data[:data]

    expect(item[:id].to_i).to eq(findable.id)
    expect(item[:attributes][:unit_price]).to be <= 500
    expect(item[:attributes][:unit_price]).to be >= 100
  end

  it "returns an empty object if no items are found" do
    create_list(:merchant, 3)
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
    lost_items_2 = create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

    get "/api/v1/items/find?min_price=100&max_price=500"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:data]).to eq({})
  end

  it 'returns an error if max price is less than min price' do
    create_list(:merchant, 3)
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
    lost_items_2 = create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

    get "/api/v1/items/find?min_price=500&max_price=250"

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Minimum price must be less than maximum price'])
  end

  it "returns an error when no minimum price is given" do
    create_list(:merchant, 3)
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
    lost_items_2 = create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

    get "/api/v1/items/find?min_price="

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Price must be a number'])
  end

  it "returns an error when no maximum price is given" do
    create_list(:merchant, 3)
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
    lost_items_2 = create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

    get "/api/v1/items/find?max_price="

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Price must be a number'])
  end

  it "returns an error when maximum price is a string" do
    create_list(:merchant, 3)
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
    lost_items_2 = create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

    get "/api/v1/items/find?max_price=Jordan"

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Price must be a number'])
  end

  it "returns an error when minimum price is a string" do
    create_list(:merchant, 3)
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
    lost_items_2 = create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

    get "/api/v1/items/find?min_price=Jordan"

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Price must be a number'])
  end

  it "returns an error when minimum price and name parameters are given" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, name: 'Jordan 191')
    lost_items = create_list(:item, 5, description: "Ferrari 641")

    get "/api/v1/items/find?min_price=100&name=Jordan"

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Please provide either name or price parameters, not both'])
  end

  it "returns an error when maximum price and name parameters are given" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, name: 'Jordan 191')
    lost_items = create_list(:item, 5, description: "Ferrari 641")

    get "/api/v1/items/find?max_price=100&name=Jordan"

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Please provide either name or price parameters, not both'])
  end

  it "returns an error when minimum price is below zero" do
    create_list(:merchant, 3)
    create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
    create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

    get "/api/v1/items/find?min_price=-100"

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Price parameter cannot be below zero'])
  end

  it "returns an error when maximum price is below zero" do
    create_list(:merchant, 3)
    create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
    create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

    get "/api/v1/items/find?max_price=-100"

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Price parameter cannot be below zero'])
  end
end