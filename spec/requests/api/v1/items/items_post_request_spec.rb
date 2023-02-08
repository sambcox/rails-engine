require 'rails_helper'

describe "Items Post Request" do
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

    expect(response.status).to eq 201
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'will only create a new item with correct parameters' do
    create_list(:merchant, 3)
    item_params = ({
                    name: Faker::Commerce.product_name,
                    description: Faker::TvShows::Community.quotes,
                    unit_price: Faker::Number.within(range: 1.0..1000.0),
                    merchant_id: Merchant.all.shuffle.shuffle.first.id,
                    goobledegook: 'Gigglygoogly'
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    expect(created_item.attributes.include?(:goobledegook)).to eq false
  end

  it 'will not create a new item if not given all information' do
    create_list(:merchant, 3)
    item_params = ({
                    name: 'Bad Object'
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(422)
    expect(data[:errors]).to eq(["Merchant must exist", "Description can't be blank", "Unit price can't be blank", "Unit price is not a number"])
  end
end