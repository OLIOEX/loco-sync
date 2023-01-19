# frozen_string_literal: true

describe LocoSync do
  it "returns a proper version" do
    expect(LocoSync::VERSION).to be_a(String)
  end
end
