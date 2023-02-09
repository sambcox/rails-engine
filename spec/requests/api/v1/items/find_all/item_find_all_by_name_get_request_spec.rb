require 'rails_helper'

describe "Find Items by Name Get Request" do
  it "returns all items given a name" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, name: 'Jordan 191')
    lost_items = create_list(:item, 5, name: "Ferrari 641")

    get "/api/v1/items/find_all?name=#{'Jordan 191'}"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    items = data[:data]

    expect(items.count).to eq(5)

    item_ids = findable_items.map(&:id)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item_ids).to include(item[:id].to_i)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to eq('Jordan 191')
    end
  end

  it "returns all items given a part of the name" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, name: 'Jordan 191')
    lost_items = create_list(:item, 5, name: "Ferrari 641")

    get "/api/v1/items/find_all?name=#{'Jord'}"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    items = data[:data]

    expect(items.count).to eq(5)

    item_ids = findable_items.map(&:id)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item_ids).to include(item[:id].to_i)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to eq('Jordan 191')
    end
  end

  it "returns all items given a description" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, description: 'Jordan 191')
    lost_items = create_list(:item, 5, description: "Ferrari 641")

    get "/api/v1/items/find_all?name=#{'Jordan 191'}"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    items = data[:data]

    expect(items.count).to eq(5)

    item_ids = findable_items.map(&:id)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item_ids).to include(item[:id].to_i)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:description]).to eq('Jordan 191')
    end
  end

  it "returns all items given a partial description" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, description: 'Jordan 191')
    lost_items = create_list(:item, 5, description: "Ferrari 641")

    get "/api/v1/items/find_all?name=#{' 191'}"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    items = data[:data]

    expect(items.count).to eq(5)

    item_ids = findable_items.map(&:id)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item_ids).to include(item[:id].to_i)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:description]).to eq('Jordan 191')
    end
  end

  it "returns no items when none exist, but does not return an error" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, name: 'Jordan 191')
    lost_items = create_list(:item, 5, description: "Ferrari 641")

    get "/api/v1/items/find_all?name=#{'F2004'}"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    data = data[:data]

    expect(data).to eq([])
  end

  it "returns an error when no parameter is given" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, name: 'Jordan 191')
    lost_items = create_list(:item, 5, description: "Ferrari 641")

    get "/api/v1/items/find_all"

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Query must be provided'])
  end

  it "returns an error when no query is given" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, name: 'Jordan 191')
    lost_items = create_list(:item, 5, description: "Ferrari 641")

    get "/api/v1/items/find_all?name="

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Name must be provided'])
  end
end