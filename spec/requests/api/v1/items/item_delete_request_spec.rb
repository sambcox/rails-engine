require 'rails_helper'

describe "Item Delete Request" do
  it "deletes an item" do
    create_list(:merchant, 3)
    create_list(:item, 10)

    item_raw = Item.first

    delete "/api/v1/items/#{item_raw.id}"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    item = data[:data]

    expect(Item.exists?(id: item[:id])).to eq false

    expect(item).to have_key(:id)
    expect(item_raw.id).to eq(item[:id].to_i)
    expect(item[:attributes]).to have_key(:name)
    expect(item_raw.name).to eq(item[:attributes][:name])
    expect(item[:attributes]).to have_key(:description)
    expect(item_raw.description).to eq(item[:attributes][:description])
    expect(item[:attributes]).to have_key(:unit_price)
    expect(item_raw.unit_price).to eq(item[:attributes][:unit_price])
    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item_raw.merchant_id).to eq(item[:attributes][:merchant_id])
  end

  it "returns an error if item is not found" do
    create_list(:merchant, 3)
    create_list(:item, 10)

    item_raw = Item.first

    delete "/api/v1/items/#{item_raw.id - 1}"

    expect(response).to_not be_successful
  end
end