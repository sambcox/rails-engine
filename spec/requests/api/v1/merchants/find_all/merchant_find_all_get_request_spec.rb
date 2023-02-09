require 'rails_helper'

describe "Find All Merchants Get Request" do
  it "returns all merchants" do
    create_list(:merchant, 3, name: 'Jordan F1')
    create_list(:merchant, 3, name: 'Scuderia Ferrari')

    get "/api/v1/merchants/find_all?name=Jordan F1"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    merchants = data[:data]

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant[:attributes][:name]).to eq('Jordan F1')
    end
  end

  it "returns all merchants given a partial name" do
    create_list(:merchant, 3, name: 'Jordan F1')
    create_list(:merchant, 3, name: 'Scuderia Ferrari')

    get "/api/v1/merchants/find_all?name=Jord"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    merchants = data[:data]

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant[:attributes][:name]).to eq('Jordan F1')
    end
  end

  it "returns all merchants case insensitive" do
    create_list(:merchant, 3, name: 'Jordan F1')
    create_list(:merchant, 3, name: 'Scuderia Ferrari')

    get "/api/v1/merchants/find_all?name=jORd"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    merchants = data[:data]

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant[:attributes][:name]).to eq('Jordan F1')
    end
  end

  it "returns nil when no merchants are returned" do
    create_list(:merchant, 3)

    get "/api/v1/merchants/find_all?name=gigglygooglyboopbopbeep"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:data]).to eq([])
  end

  it "returns an error when no parameter is entered" do
    create_list(:merchant, 3)

    get "/api/v1/merchants/find_all"

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Parameter must be present'])
  end

  it "returns an error when no query is entered" do
    create_list(:merchant, 3)

    get "/api/v1/merchants/find_all?name="

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(["Parameter must be present"])
  end
end