require 'rails_helper'

describe "Items Request" do
  it "sends a list of items" do
    create_list(:merchant, 3)
    create_list(:item, 10)

    items_raw = Item.all

    get "/api/v1/items"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    items = data[:data]

    expect(items.count).to eq(10)

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

  it "sends a single item" do
    create_list(:merchant, 3)
    create_list(:item, 10)

    item_raw = Item.first

    get "/api/v1/items/#{item_raw.id}"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    item = data[:data]

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

  it "can create a new item" do
    create_list(:merchant, 3)
    item_params = ({
                    name: Faker::Commerce.product_name,
                    description: Faker::TvShows::Community.quotes,
                    unit_price: Faker::Number.within(range: 1.0..1000.0),
                    merchant_id: Merchant.all.shuffle.shuffle.first.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end
end