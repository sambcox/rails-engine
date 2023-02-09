require 'rails_helper'

describe "Find Item by Name Get Request" do
  it "returns one item given a name" do
    create_list(:merchant, 3)
    findable = create(:item, name: 'Jordan 191')
    lost = create_list(:item, 5, name: "Ferrari 641")

    get "/api/v1/items/find?name=Jordan 191"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    item = data[:data]

    expect(item[:id].to_i).to eq(findable.id)
    expect(item[:attributes][:name]).to eq('Jordan 191')
  end

  it "returns an item given a part of the name" do
    create_list(:merchant, 3)
    findable = create(:item, name: 'Jordan 191')
    lost = create_list(:item, 5, name: "Ferrari 641")

    get "/api/v1/items/find?name=Jord"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    item = data[:data]

    expect(item[:id].to_i).to eq(findable.id)
    expect(item[:attributes][:name]).to eq('Jordan 191')
  end

  it "returns an item given a description" do
    create_list(:merchant, 3)
    findable = create(:item, description: 'Jordan 191')
    lost = create_list(:item, 5, description: "Ferrari 641")

    get "/api/v1/items/find?name=Jordan 191"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    item = data[:data]

    expect(item[:id].to_i).to eq(findable.id)
    expect(item[:attributes][:description]).to eq('Jordan 191')
  end

  it "returns an item given a partial description" do
    create_list(:merchant, 3)
    findable = create(:item, description: 'Jordan 191')
    lost = create_list(:item, 5, description: "Ferrari 641")

    get "/api/v1/items/find?name=Jord"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    item = data[:data]

    expect(item[:id].to_i).to eq(findable.id)
    expect(item[:attributes][:description]).to eq('Jordan 191')
  end

  it "returns the item first alphabetically" do
    create_list(:merchant, 3)
    description_match = create(:item, name: 'Alphatauri AT02', description: 'Jordan 191')
    name_match = create(:item, name: "Jordan 191")

    get "/api/v1/items/find?name=Jord"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    item = data[:data]

    expect(item[:id].to_i).to eq(description_match.id)
    expect(item[:attributes][:description]).to eq('Jordan 191')
  end

  it "returns an empty object when no items exist" do
    create_list(:merchant, 3)
    findable = create(:item, name: 'Jordan 191')
    lost = create_list(:item, 5, description: "Ferrari 641")

    get "/api/v1/items/find?name=F2004"

    expect(response).to be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    data = data[:data]

    expect(data).to eq({})
  end

  it "returns an error when no parameter is given" do
    create_list(:merchant, 3)
    findable = create(:item, name: 'Jordan 191')
    lost_items = create_list(:item, 5, description: "Ferrari 641")

    get "/api/v1/items/find"

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Query must be provided'])
  end

  it "returns an error when no query is given" do
    create_list(:merchant, 3)
    findable = create(:item, name: 'Jordan 191')
    lost_items = create_list(:item, 5, description: "Ferrari 641")

    get "/api/v1/items/find?name="

    expect(response).to_not be_successful

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to eq(['Name must be provided'])
  end
end