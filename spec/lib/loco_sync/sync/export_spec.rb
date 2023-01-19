# frozen_string_literal: true

describe LocoSync::Sync::Export do
  let(:locale) { "en" }
  let(:connection) { double("Faraday::Connection") }
  let(:response) { double("Faraday::Response") }
  let(:body) { { message: "successfully imported translations " } }
  let(:translations_file) { "#{locales_path}/#{locale}.yml" }

  subject { LocoSync::Sync::Export }

  after do
    remove_translation_file
  end

  describe ".export!" do
    before do
      add_translation_file(locale)
      allow(Faraday).to receive(:new).and_return connection
      allow(LocoSync::Config).to receive(:locales_path).and_return locales_path
    end

    context "when the request is successful" do
      before do
        allow(connection).to receive(:post).and_return response
        allow(response).to receive(:body).and_return body
      end

      it "the translations are imported correctly" do
        expect(connection).to receive(:post)
        subject.export!(locale: locale)
      end
    end

    context "when the request is unsuccessful" do
      before do
        allow(connection).to receive(:post).and_raise(Faraday::UnauthorizedError.new(401,
                                                                                     { status: 401,
                                                                                       body: "unauthorized error" }))
      end

      it "raises the error with a useful message" do
        expect do
          subject.export!(locale: locale)
        end.to raise_error("Loco Sync failed to export locale #{locale}: unauthorized error")
      end
    end
  end
end
