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

  it "can update an item given partial information" do
    create_list(:merchant, 3)
    create_list(:item, 10)
    item_params = ({
                    description: Faker::TvShows::Community.quotes,
                    unit_price: Faker::Number.within(range: 1.0..1000.0),
                    merchant_id: Merchant.all.shuffle.shuffle.first.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{Item.first.id}", headers: headers, params: JSON.generate(item: item_params)
    updated_item = Item.first

    expect(response).to be_successful
    expect(updated_item.description).to eq(item_params[:description])
    expect(updated_item.unit_price).to eq(item_params[:unit_price])
    expect(updated_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'returns an error if the merchant does not exist' do
    create_list(:merchant, 3)
    create_list(:item, 10)

    item_raw = Item.first

    item_params = ({
                    name: Faker::Commerce.product_name,
                    description: Faker::TvShows::Community.quotes,
                    unit_price: Faker::Number.within(range: 1.0..1000.0),
                    merchant_id: Merchant.last.id + 1
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item_raw.id}", headers: headers, params: JSON.generate(item: item_params)

    expect(response.status).to eq 404

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Merchant must exist'])
  end

  it 'returns an error if the item unit price is not a number' do
    create_list(:merchant, 3)
    create_list(:item, 10)

    item_raw = Item.first

    item_params = ({
                    name: Faker::Commerce.product_name,
                    description: Faker::TvShows::Community.quotes,
                    unit_price: 'unit',
                    merchant_id: Merchant.all.shuffle.shuffle.first.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item_raw.id}", headers: headers, params: JSON.generate(item: item_params)

    expect(response.status).to eq 404

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Unit price is not a number'])
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

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(["Couldn't find Item with 'id'=#{item_raw.id - 1}"])
  end
end