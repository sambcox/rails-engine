require 'rails_helper'

describe "Find Merchant Get Request" do
  it "returns a merchant" do
    create_list(:merchant, 3)

    get "/api/v1/merchants/find?name=#{Merchant.first.name}"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    merchant = data[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id].to_i).to eq(Merchant.first.id)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to eq(Merchant.first.name)
  end

  it "returns a merchant even when given a partial name" do
    create_list(:merchant, 3)

    partial_name = Merchant.first.name.chars[1..3].join

    get "/api/v1/merchants/find?name=#{partial_name}"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    merchant = data[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id].to_i).to eq(Merchant.first.id)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to eq(Merchant.first.name)
  end

  it "returns a merchant even when given wrong case" do
    create_list(:merchant, 3)

    partial_name = Merchant.first.name.chars[1..3].join

    get "/api/v1/merchants/find?name=#{partial_name.upcase}"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    merchant = data[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id].to_i).to eq(Merchant.first.id)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to eq(Merchant.first.name)
  end

  it "returns nil when no merchants are returned" do
    create_list(:merchant, 3)

    get "/api/v1/merchants/find?name=gigglygooglyboopbopbeep"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:data]).to eq({})
  end

  it "returns an error when no parameter is entered" do
    create_list(:merchant, 3)

    get "/api/v1/merchants/find"

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Parameter must be present'])
  end

  it "returns an error when no query is entered" do
    create_list(:merchant, 3)

    get "/api/v1/merchants/find?name="

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(["Parameter must be present"])
  end
end