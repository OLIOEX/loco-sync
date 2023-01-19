# frozen_string_literal: true

describe LocoSync::Sync::Import do
  let(:locale) { "en" }
  let(:connection) { double("Faraday::Connection") }
  let(:response) { double("Faraday::Response") }
  let(:body) { "en:\n translation_1: this is the first translation\n translation_2: this is the second translation" }
  let(:locales_path) { "spec/support/mock/locale" }
  let(:translations_file) { "#{locales_path}/#{locale}.yml" }

  subject { LocoSync::Sync::Import }

  after do
    remove_translation_file
  end

  describe ".import!" do
    before do
      allow(Faraday).to receive(:new).and_return connection
    end
    context "when the request is successful" do
      before do
        allow(connection).to receive(:get).and_return response
        allow(response).to receive(:body).and_return body
        allow(LocoSync::Config).to receive(:locales_path).and_return locales_path
        subject.import!(locale: locale)
      end

      it "the translations are imported correctly" do
        expect(translations_files_count).to eq(1)
        expect(YAML.load_file(translations_file)[locale].count).to eq(2)
      end
    end

    context "when the request is unsuccessful" do
      before do
        allow(connection).to receive(:get).and_raise(Faraday::UnauthorizedError.new(401,
                                                                                    { status: 401,
                                                                                      body: "unauthorized error" }))
      end

      it "raises the error with a useful message" do
        expect do
          subject.import!(locale: locale)
        end.to raise_error("Loco Sync failed to import locale #{locale}: unauthorized error")
      end
    end
  end
end
