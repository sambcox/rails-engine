require 'rails_helper'

describe "Merchant Items Request" do
  it "sends a list of merchant items" do
    create_list(:merchant, 3)
    create_list(:item, 10)

    merchant_raw = Merchant.first

    items_raw = merchant_raw.items

    get "/api/v1/merchants/#{merchant_raw.id}/items"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    items = data[:data]

    expect(items.count).to eq(merchant_raw.items.count)

    items.each do |item|
      expect(item).to have_key(:id)
      found_item = Item.find(item[:id])

      expect(item[:attributes]).to have_key(:name)
      expect(found_item.name).to eq(item[:attributes][:name])
      expect(item[:attributes]).to have_key(:description)
      expect(found_item.description).to eq(item[:attributes][:description])
      expect(item[:attributes]).to have_key(:unit_price)
      expect(found_item.unit_price).to eq(item[:attributes][:unit_price])
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(found_item.merchant_id).to eq(item[:attributes][:merchant_id])
    end
  end

  it "returns an error if merchant is not found" do
    create_list(:merchant, 3)

    merchant_raw = Merchant.first

    get "/api/v1/merchants/#{merchant_raw.id - 1}/items"

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(["Couldn't find Merchant with 'id'=#{merchant_raw.id - 1}"])
  end
end