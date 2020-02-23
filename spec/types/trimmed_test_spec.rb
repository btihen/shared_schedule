require 'rails_helper'
require 'active_model'

# test ideas
# https://github.com/Azdaroth/active_model_attributes/blob/master/spec/active_model_attributes_spec.rb

describe TrimmedText do

  class TrimmedTextTest
    include ActiveModel::Model
    include ActiveModel::Attributes
    # do not use attr_accessor with attributes!
    # attr_accessor :name, :text
    attribute :name, :trimmed_text
    attribute :text, TrimmedText.new
    def self.model_name
      ActiveModel::Name.new(self, nil, 'TrimmedTextTest')
    end
  end

  let(:attribs)  { {name: " Bill \n Tihen ", text: " \t \n\r Hi \n \t there \n\r \t "} }
  let(:expected) { {name: "Bill \n Tihen",   text: "Hi \n \t there"} }
  let(:model)    { TrimmedTextTest.new( attribs ) }

  context "explicit casting" do
    it "removes leading and trailing white spaces & multiple internal spaces" do
      expect( TrimmedText.new.cast attribs[:name] ).to eq( expected[:name] )
      expect( TrimmedText.new.cast attribs[:text] ).to eq( expected[:text] )
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
