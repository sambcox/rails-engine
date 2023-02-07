require 'rails_helper'

describe "Merchants Get Request" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get "/api/v1/merchants/find?name=#{Merchant.first.name}"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    merchant = data[:data]

    expect(merchant).to have_key(:id)
    expect(Merchant.exists?(id: merchant[:id])).to eq true

    expect(merchant[:attributes]).to have_key(:name)
    expect(Merchant.exists?(name: merchant[:attributes][:name])).to eq true
  end
end