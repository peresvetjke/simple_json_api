require "rails_helper"

describe "Topics API", type: :request do
  let(:headers)         { { "ACCEPT" => "application/json" } }
  let!(:topic)          { create(:topic) }
  let(:topic_response)  { json["data"] }

  shared_examples "show" do
    context "topic exists" do
      it "returns 200 status" do
        expect(response.status).to eq 200
      end

      it "returns all neccessary fields" do
        %w[title url publication_date image_link annonce body created_at updated_at].each do |attr|
          expect(topic_response['attributes'][attr]).to eq topic.send(attr).as_json
        end
      end
    end

    context "topic does not exist" do
      let(:path) { "/api/v1/topics/not_exist" }

      it "returns 404 status" do
        expect(response.status).to eq 404
      end

      it "returns no body" do
        expect(response.body).to be_empty
      end
    end
  end

  describe "SHOW" do
    let(:method)    { "get" }
    let!(:topic)    { create(:topic) }
    
    before { do_request("get", path, params: { }, headers: headers) }

    context "GET /api/v1/topics/:id" do
      let(:path)      { "/api/v1/topics/#{topic.id}" }
      it_behaves_like "show"
    end

    context "GET /api/v1/topics/:path_to_topic" do
      let(:path)      { "/api/v1/topics/#{topic.url}" }
      it_behaves_like "show"
    end
  end

  describe "GET /api/v1/topics" do
    let(:method)              { "get" }
    let!(:topics)             { create_list(:topic, 5) }
    let(:topics_response)     { json["data"] }
    let(:path)                { "/api/v1/topics" }
    
    subject { do_request("get", path, params: params, headers: headers) }
    
    context "no params" do
      let(:params) {{ }}

      before { subject }

      it "returns 200 status" do
        expect(response.status).to eq 200
      end

      it "returns all records" do
        expect(topics_response.count).to eq Topic.count
      end

      it "returns all neccessary fields" do
        %w[title url publication_date image_link annonce body created_at updated_at].each do |attr|
          expect(topics_response.last['attributes'][attr]).to eq Topic.find(topics_response.last['attributes']['id']).send(attr).as_json
        end
      end
    end
      

    context "with params" do
      let(:topics_ids)   { nil }
      let(:title_query)  { nil }
      let(:tags)         { nil }
      let(:params) {{ "topics_ids"  => topics_ids,
                      "title_query" => title_query,
                      "tags"        => tags
                   }}

      context "ids" do
        let(:topics_ids) { [topics.first.id, topics.last.id] }

        before { subject }
        
        it "returns 200 status" do
          expect(response.status).to eq 200
        end

        it "returns selected records" do
          expect(topics_response.count).to eq 2
        end

        it "returns all neccessary fields" do
          %w[title url publication_date image_link annonce body created_at updated_at].each do |attr|
            expect(topics_response.last['attributes'][attr]).to eq Topic.find(topics_response.last['attributes']['id']).send(attr).as_json
          end
        end
      end

      context "tags" do
        let(:tags) { ['awesome'] }

        before {
          topics.first.tag_list.add("cool")
          topics.first.tag_list.add("awesome")
          topics.first.save!
          topics.last.tag_list.add("awesome")
          topics.last.save!
          subject
        }

        it "returns 200 status" do
          expect(response.status).to eq 200
        end

        it "returns selected records" do
          expect(topics_response.count).to eq 2
        end

        it "returns all neccessary fields" do
          %w[title url publication_date image_link annonce body created_at updated_at].each do |attr|
            expect(topics_response.last['attributes'][attr]).to eq topics.last.send(attr).as_json
          end
        end
      end

      context "title_query" do
        let(:title_query) { topics.last.title }

        before { subject }

        it "returns 200 status" do
          expect(response.status).to eq 200
        end

        it "returns selected records" do
          expect(topics_response.count).to eq 1
        end

        it "returns all neccessary fields" do
          %w[title url publication_date image_link annonce body created_at updated_at].each do |attr|
            expect(topics_response.last['attributes'][attr]).to eq topics.last.send(attr).as_json
          end
        end
      end
    end

    describe "pagination" do
      let(:params)              {{ page: { size: 3 } }}

      before { subject }
        
      it "returns 200 status" do
        expect(response.status).to eq 200
      end

      it "returns all records" do
        expect(topics_response.count).to eq 3
      end

      it "returns all neccessary fields" do
        %w[title url publication_date image_link annonce body created_at updated_at].each do |attr|
          expect(topics_response.first['attributes'][attr]).to eq Topic.find(topics_response.first['attributes']['id']).send(attr).as_json
        end
      end
    end

    describe "sorting" do
      let(:params) {{ }}
      let(:path)   { "/api/v1/topics?sort=-id&publication_date" }

      before { subject }

      it "returns sorted records" do
        expect(topics_response.first['attributes']['id']).to eq Topic.last.id
      end

      it "returns 200 status" do
        expect(response.status).to eq 200
      end

      it "returns all records" do
        expect(topics_response.count).to eq 6
      end

      it "returns all neccessary fields" do
        %w[title url publication_date image_link annonce body created_at updated_at].each do |attr|
          expect(topics_response.first['attributes'][attr]).to eq Topic.find(topics_response.first['attributes']['id']).send(attr).as_json
        end
      end
    end
  end

  describe "POST /api/v1/topics" do
    let(:method)    { "post" }
    let(:path)      { "/api/v1/topics" }

    context 'with valid params' do
      before { do_request(method, 
                          path, 
                          params: { topic: attributes_for(:topic) }, 
                          headers: headers
                         ) 
              }

      it "return status 'created'" do
        expect(response.status).to eq 201
      end

      it "returns all neccessary fields of created person" do
        %w[title url publication_date image_link annonce body created_at updated_at].each do |attr|
          expect(topic_response['attributes'][attr]).to eq assigns(:topic).send(attr).as_json
        end
      end
    end

    context "with tags" do
      let!(:tag_1) { create(:tag) }
      let!(:tag_2) { create(:tag) }

      before { do_request(method, 
                          path, 
                          params: { topic: attributes_for(:topic).merge({tag_list: [tag_1.name, tag_2.name]}) }, 
                          headers: headers
                         ) 
              }

      it "return status 'created'" do
        expect(response.status).to eq 201
      end

      it "returns all neccessary fields of created person" do
        %w[title url publication_date image_link annonce body created_at updated_at].each do |attr|
          expect(topic_response['attributes'][attr]).to eq assigns(:topic).send(attr).as_json
        end
      end

      it "assigns tags" do
        expect(assigns(:topic).reload.tag_list).to match_array([tag_1.name, tag_2.name])
      end
    end

    context 'with invalid params' do
      before { do_request(method, 
                          path, 
                          params: { topic: attributes_for(:topic, title: "") }, 
                          headers: headers
                         ) 
              }

      it "return status 'unprocessable'" do
        expect(response.status).to eq 422
      end

      it "returns errors messages" do
        expect(json["errors"].first['message']).to eq "Title can't be blank"
      end
    end
  end
  
  describe "PATCH /api/v1/topics/:id" do
    let(:method)    { "patch" }
    let(:path)      { "/api/v1/topics/#{topic.id}" }

    context 'with valid params' do
      before { do_request(method, path, params: { id: topic, topic: attributes_for(:topic, title: "Corrected") }, headers: headers) }

      it "return successfull status" do
        expect(response).to be_successful
      end

      it "returns all neccessary fields of updated person" do
        expect(topic_response['attributes']['title']).to eq assigns(:topic).reload.title
        %w[title url publication_date image_link annonce body created_at updated_at].each do |attr|
          expect(topic_response['attributes'][attr]).to eq assigns(:topic).send(attr).as_json
        end
      end
    end

    context 'with invalid params' do
      before { do_request(method, path, params: { id: topic, topic: attributes_for(:topic, title: "") }, headers: headers) }

      it "return status 'unprocessable'" do
        expect(response.status).to eq 422
      end

      it "returns errors messages" do
        expect(json["errors"].first['message']).to eq "Title can't be blank"
      end
    end
  end

  describe "DELETE /api/v1/topics/:id" do
    let(:method)    { "delete" }
    let(:path)      { "/api/v1/topics/#{topic.id}" }

    before { do_request(method, path, params: { id: topic }, headers: headers) }

    it "return successfull status" do
      expect(response).to be_successful
    end

    it "deletes record" do
      expect(assigns(:topic).persisted?).to be_falsey
    end
  end
end