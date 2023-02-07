require 'rails_helper'

describe "Merchants Get Request" do
  it "sends a list of merchants" do
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

  it "sends a list of merchants" do
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
end