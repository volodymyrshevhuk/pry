require_relative 'helper'

describe Pry::Prompt do
  describe ".[]" do
    it "accesses prompts" do
      expect(subject[:default]).not_to be_nil
    end
  end

  describe ".all" do
    it "returns a hash with prompts" do
      expect(subject.all).to be_a(Hash)
    end

    it "returns a duplicate of original prompts" do
      subject.all[:foobar] = Object.new
      expect(subject[:foobar]).to be_nil
    end
  end

  describe ".add" do
    after { described_class.instance_variable_get(:@prompts).delete(:my_prompt) }

    it "adds a new prompt" do
      subject.add(:my_prompt)
      expect(subject[:my_prompt]).to be_a(Hash)
    end

    it "raises error when separators.size != 2" do
      expect { subject.add(:my_prompt, '', [1, 2, 3]) }
        .to raise_error(ArgumentError)
    end

    it "returns nil" do
      expect(subject.add(:my_prompt)).to be_nil
    end
  end

  describe "prompt invocation" do
    let(:pry) { Pry.new }

    let(:enum) do
      Enumerator.new do |y|
        range = ('a'..'z').to_enum
        loop { y << range.next }
      end
    end

    it "computes prompt name dynamically" do
      proc = subject[:default][:value].first
      pry.config.prompt_name = Pry.lazy { enum.next }
      expect(proc.call(Object.new, 1, pry, '>')).to eq('[1] a(#<Object>):1> ')
      expect(proc.call(Object.new, 1, pry, '>')).to eq('[1] b(#<Object>):1> ')
    end
  end
end
