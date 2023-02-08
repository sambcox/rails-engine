require 'rails_helper'

describe "Find Items Get Request" do
  it "returns all items given a name" do
    create_list(:merchant, 3)
    findable_items = create_list(:item, 5, name: 'Jordan 191')
    lost_items = create_list(:item, 5, name: "Ferrari 641")

    get "/api/v1/items/find_all?name=#{'Jordan 191'}"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    items = data[:data]

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

    item_ids = findable_items.map(&:id)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item_ids).to include(item[:id].to_i)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to eq('Jordan 191')
    end
  end
end