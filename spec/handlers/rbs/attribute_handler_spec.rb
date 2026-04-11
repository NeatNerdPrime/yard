# frozen_string_literal: true
require File.dirname(__FILE__) + '/spec_helper'

RSpec.describe YARD::Handlers::RBS::AttributeHandler do
  it "registers a reader method for attr_reader" do
    parse_rbs <<-RBS
class Foo
  attr_reader name: String
end
    RBS
    obj = Registry.at('Foo#name')
    expect(obj).to be_a(CodeObjects::MethodObject)
    expect(obj.tag(:return).types).to eq ['String']
  end

  it "registers a writer method for attr_writer" do
    parse_rbs <<-RBS
class Foo
  attr_writer name: String
end
    RBS
    obj = Registry.at('Foo#name=')
    expect(obj).to be_a(CodeObjects::MethodObject)
    expect(obj.tag(:param).types).to eq ['String']
  end

  it "registers both reader and writer for attr_accessor" do
    parse_rbs <<-RBS
class Foo
  attr_accessor age: Integer
end
    RBS
    expect(Registry.at('Foo#age')).to be_a(CodeObjects::MethodObject)
    expect(Registry.at('Foo#age=')).to be_a(CodeObjects::MethodObject)
  end

  it "registers a class-side reader for attr_reader self.name" do
    parse_rbs <<-RBS
class Foo
  attr_reader self.count: Integer
end
    RBS
    obj = Registry.at('Foo.count')
    expect(obj).to be_a(CodeObjects::MethodObject)
    expect(obj.tag(:return).types).to eq ['Integer']
  end

  it "preserves docstring for attributes" do
    parse_rbs <<-RBS
class Foo
  # The user's name.
  attr_reader name: String
end
    RBS
    expect(Registry.at('Foo#name').docstring).to eq "The user's name."
  end

  it "handles nullable attribute type" do
    parse_rbs <<-RBS
class Foo
  attr_reader nickname: String?
end
    RBS
    expect(Registry.at('Foo#nickname').tag(:return).types).to eq ['String', 'nil']
  end

  it "parses attr declarations without space after colon" do
    parse_rbs <<-RBS
class Foo
  attr_reader count:Integer
end
    RBS
    obj = Registry.at('Foo#count')
    expect(obj).to be_a(CodeObjects::MethodObject)
    expect(obj.tag(:return).types).to eq ['Integer']
  end

  it "ignores inline comments on attr declarations" do
    parse_rbs <<-RBS
class Foo
  attr_reader name: String # the name
end
    RBS
    obj = Registry.at('Foo#name')
    expect(obj.tag(:return).types).to eq ['String']
  end
end
