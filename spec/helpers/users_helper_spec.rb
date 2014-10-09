require 'rails_helper'

describe UsersHelper do
  describe "gravatar_for" do
    let(:user) { User.new(email: "example@railstutorial.org",
      name: "Example") }

    describe "with user parameter" do
      it "should return image tag" do
        expect(gravatar_for(user)).
          to match(/\<img .*\/\>/)
      end
    end
    describe "with user and size parameters" do
      subject { gravatar_for(user, size: 40) }

      it { should match(/\<img .*\/\>/) }
      it { should match(/class=\"gravatar\"/) }
      it { should match(/alt=\"Example\"/) }
      it { should match(/src=\".*s=40\"/) }
    end
    
  end
end