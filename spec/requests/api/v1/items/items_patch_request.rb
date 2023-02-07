require 'rails_helper'

describe "Items Get Request" do
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