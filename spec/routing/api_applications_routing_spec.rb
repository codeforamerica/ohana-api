require "spec_helper"

describe ApiApplicationsController do
  describe "routing" do

    it "routes to #index" do
      get("/api_applications").should route_to("api_applications#index")
    end

    it "routes to #new" do
      get("/api_applications/new").should route_to("api_applications#new")
    end

    it "routes to #show" do
      get("/api_applications/1").should route_to("api_applications#show", :id => "1")
    end

    it "routes to #edit" do
      get("/api_applications/1/edit").should route_to("api_applications#edit", :id => "1")
    end

    it "routes to #create" do
      post("/api_applications").should route_to("api_applications#create")
    end

    it "routes to #update" do
      put("/api_applications/1").should route_to("api_applications#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/api_applications/1").should route_to("api_applications#destroy", :id => "1")
    end

  end
end
