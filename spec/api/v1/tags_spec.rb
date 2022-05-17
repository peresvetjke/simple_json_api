require "rails_helper"

describe "Tags API", type: :request do
  let(:headers)         { { "ACCEPT" => "application/json" } }
  let!(:tag)            { create(:tag) }
  let(:tag_response)    { json["data"] }

  describe "GET /api/v1/tags/:id" do
    let(:method)    { "get" }
    let(:path)      { "/api/v1/tags/#{tag.id}" }
      
    before { do_request("get", path, params: { }, headers: headers) }

    context "tag exists" do
      it "returns 200 status" do
        expect(response.status).to eq 200
      end

      it "returns all neccessary fields" do
        %w[name slug created_at updated_at].each do |attr|
          expect(tag_response['attributes'][attr]).to eq tag.send(attr).as_json
        end
      end
    end

    context "tag does not exist" do
      let(:path) { "/api/v1/tags/not_exist" }

      it "returns 404 status" do
        expect(response.status).to eq 404
      end

      it "returns no body" do
        expect(response.body).to be_empty
      end
    end
  end

  describe "GET /api/v1/tags" do
    let(:method)            { "get" }
    let!(:tags)             { create_list(:tag, 5) }
    let(:tags_response)     { json["data"] }
    let(:path)              { "/api/v1/tags" }
    
    subject { do_request("get", path, params: params, headers: headers) }
    
    let(:params) {{ }}

    before { subject }

    
    it "returns 200 status" do
      expect(response.status).to eq 200
    end

    it "returns all records" do
      expect(tag_response.count).to eq Tag.count
    end

    it "returns all neccessary fields" do
      %w[name slug created_at updated_at].each do |attr|
        expect(tags_response.last['attributes'][attr]).to eq tags.last.send(attr).as_json
      end
    end
  end

  describe "POST /api/v1/tags" do
    let(:method)    { "post" }
    let(:path)      { "/api/v1/tags" }

    context 'with valid params' do
      before { do_request(method, 
                          path, 
                          params: { tag: attributes_for(:tag) }, 
                          headers: headers
                         ) 
              }

      it "return status 'created'" do
        expect(response.status).to eq 201
      end

      it "returns all neccessary fields of created person" do
        %w[name slug created_at updated_at].each do |attr|
          expect(tag_response['attributes'][attr]).to eq assigns(:tag).send(attr).as_json
        end
      end
    end
  end
  
  describe "PATCH /api/v1/tags/:id" do
    let(:method)    { "patch" }
    let(:path)      { "/api/v1/tags/#{tag.id}" }

    context 'with valid params' do
      before { do_request(method, path, params: { id: tag, tag: attributes_for(:tag, name: "Corrected") }, headers: headers) }

      it "return successfull status" do
        expect(response).to be_successful
      end

      it "returns all neccessary fields of updated person" do
        expect(tag_response['attributes']['name']).to eq assigns(:tag).reload.name
        %w[name slug created_at updated_at].each do |attr|
          expect(tag_response['attributes'][attr]).to eq assigns(:tag).send(attr).as_json
        end
      end
    end 
  end

  describe "DELETE /api/v1/tags/:id" do
    let(:method)    { "delete" }
    let(:path)      { "/api/v1/tags/#{tag.id}" }

    before { do_request(method, path, params: { id: tag }, headers: headers) }

    it "return successfull status" do
      expect(response).to be_successful
    end

    it "deletes record" do
      expect(assigns(:tag).persisted?).to be_falsey
    end
  end
end