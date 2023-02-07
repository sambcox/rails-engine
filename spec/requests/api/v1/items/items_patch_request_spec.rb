require 'rails_helper'

describe "Items Patch Request" do
  it "can update an item" do
    create_list(:merchant, 3)
    create_list(:item, 10)
    item_params = ({
                    name: Faker::Commerce.product_name,
                    description: Faker::TvShows::Community.quotes,
                    unit_price: Faker::Number.within(range: 1.0..1000.0),
                    merchant_id: Merchant.all.shuffle.shuffle.first.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{Item.first.id}", headers: headers, params: JSON.generate(item: item_params)
    updated_item = Item.first

    expect(response).to be_successful
    expect(updated_item.name).to eq(item_params[:name])
    expect(updated_item.description).to eq(item_params[:description])
    expect(updated_item.unit_price).to eq(item_params[:unit_price])
    expect(updated_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "returns an error if item is not found" do
    create_list(:merchant, 3)
    create_list(:item, 10)

    item_raw = Item.first

    item_params = ({
                    name: Faker::Commerce.product_name,
                    description: Faker::TvShows::Community.quotes,
                    unit_price: Faker::Number.within(range: 1.0..1000.0),
                    merchant_id: Merchant.all.shuffle.shuffle.first.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item_raw.id - 1}", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to_not be_successful
  end
end