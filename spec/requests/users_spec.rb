require 'spec_helper'

describe "Users" do
  
  describe "signup" do
    
    describe "failure" do
    
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do
    
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
    
  end
  
  describe "sign in/out" do
  
    describe "failure" do
      it "should not sign a user in" do
        user = User.new(:email => "", :password => "")
        integration_sign_in(user)
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end
  
    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        integration_sign_in(user)
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end
  
  describe "when signed in as" do
    
    describe "an admin user" do
    
      before(:each) do
        @user = Factory(:user)
        @user.toggle!(:admin)
        integration_sign_in(@user)
      end
      
      it "should have a delete link" do
        visit users_path
        response.should have_selector("a", :href => user_path(@user),
                                            :content => "delete")
      end
      
    end
    
    describe "a normal user" do

      before(:each) do
        @user = Factory(:user)
        integration_sign_in(@user)
      end
      
      it "should not have a delete link" do
        visit users_path
        response.should_not have_selector("a", :href => user_path(@user), :content => "delete")
      end
    end
  end
  
end
