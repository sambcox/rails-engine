require 'rails_helper'

describe "Item Merchant Get Request" do
  it "sends the merchant for a given item" do
    create_list(:merchant, 3)
    create_list(:item, 10)

    item_raw = Item.first

    get "/api/v1/items/#{item_raw.id}/merchant"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    merchant = data[:data]

    expect(merchant).to have_key(:id)
    expect(Merchant.exists?(id: merchant[:id])).to eq true

    expect(merchant[:attributes]).to have_key(:name)
    expect(Merchant.exists?(name: merchant[:attributes][:name])).to eq true
  end
end