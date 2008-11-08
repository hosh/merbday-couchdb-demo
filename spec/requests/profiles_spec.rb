require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a profile exists" do
  Profile.all.destroy!
  request(resource(:profiles), :method => "POST", 
    :params => { :profile => { :id => nil }})
end

describe "resource(:profiles)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:profiles))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of profiles" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a profile exists" do
    before(:each) do
      @response = request(resource(:profiles))
    end
    
    it "has a list of profiles" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Profile.all.destroy!
      @response = request(resource(:profiles), :method => "POST", 
        :params => { :profile => { :id => nil }})
    end
    
    it "redirects to resource(:profiles)" do
      @response.should redirect_to(resource(Profile.first), :message => {:notice => "profile was successfully created"})
    end
    
  end
end

describe "resource(@profile)" do 
  describe "a successful DELETE", :given => "a profile exists" do
     before(:each) do
       @response = request(resource(Profile.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:profiles))
     end

   end
end

describe "resource(:profiles, :new)" do
  before(:each) do
    @response = request(resource(:profiles, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@profile, :edit)", :given => "a profile exists" do
  before(:each) do
    @response = request(resource(Profile.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@profile)", :given => "a profile exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Profile.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @profile = Profile.first
      @response = request(resource(@profile), :method => "PUT", 
        :params => { :profile => {:id => @profile.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@profile))
    end
  end
  
end

