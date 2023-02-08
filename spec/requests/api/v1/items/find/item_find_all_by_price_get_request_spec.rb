require 'rails_helper'

describe "Find Items by Price Get Request" do
  it "returns all items given a minimum price" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 100.00..1000.00))
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.99))

    get "/api/v1/items/find_all?min_price=100"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    items = data[:data]

    expect(items.count).to eq(5)

    item_ids = findable_items.map(&:id)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item_ids).to include(item[:id].to_i)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be >= 100
    end
  end

  it "returns all items given a maximum price" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..250.00))
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 251.00..1000.00))

    get "/api/v1/items/find_all?max_price=250"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    items = data[:data]

    expect(items.count).to eq(5)

    item_ids = findable_items.map(&:id)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item_ids).to include(item[:id].to_i)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be <= 250
    end
  end

  it "returns all items given a minimum and maximum price" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 100.00..500.00))
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

    get "/api/v1/items/find_all?min_price=100&max_price=500"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    items = data[:data]

    expect(items.count).to eq(5)

    item_ids = findable_items.map(&:id)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item_ids).to include(item[:id].to_i)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be <= 500
      expect(item[:attributes][:unit_price]).to be >= 100
    end
  end

  it "returns an empty array if no items are found" do
    create_list(:merchant, 3)
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

    get "/api/v1/items/find_all?min_price=100&max_price=500"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:data]).to eq([])
  end

  it "returns an error when no queries are given" do
    create_list(:merchant, 3)
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.00))
    lost_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 501.00..1000.00))

    get "/api/v1/items/find_all?min_price=&max_price="

    expect(response).to_not be_successful
  end

  it "returns an error when price and name parameters are given" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, name: 'Jordan 191')
    lost_items = create_list(:item, 5, description: "Ferrari 641")

    get "/api/v1/items/find_all?min_price=100&max_price=500&name=Jordan"

    expect(response).to_not be_successful
  end
end