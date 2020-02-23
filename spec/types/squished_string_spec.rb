require 'rails_helper'
require 'active_model'

describe SquishedString do

  class SquishedStringModel
    include ActiveModel::Model
    include ActiveModel::Attributes
    attribute :name, :squished_string
    attribute :text, SquishedString.new
  end

  let(:attribs)  { {name: " Bill \n Tihen ", text: " \t \n\r Hi \n \t there \n\r \t "} }
  let(:expected) { {name: "Bill Tihen",      text: "Hi there"} }
  let!(:model)   { SquishedStringModel.new( attribs ) }

  context "explicit casting" do
    it "removes leading and trailing white spaces & multiple internal spaces" do
      expect( SquishedString.new.cast attribs[:name] ).to eq( expected[:name] )
      expect( SquishedString.new.cast attribs[:text] ).to eq( expected[:text] )
    end
  end

  context "implicit casting" do
    it "removes leading and trailing white spaces - when defined with registered symbol" do
      expect( model.name ).to eq( expected[:name] )
    end
    it "removes leading and trailing white spaces - when defined with class constant" do
      expect( model.text ).to eq( expected[:text] )
    end
  end

end
