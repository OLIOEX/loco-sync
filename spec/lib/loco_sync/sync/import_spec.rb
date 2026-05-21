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
      allow(LocoSync::Config).to receive(:locales_path).and_return locales_path
    end

    context "when the request is successful" do
      before do
        allow(connection).to receive(:get).and_return response
        allow(response).to receive(:body).and_return body
        subject.import!(locale: locale)
      end

      it "writes the locale file" do
        expect(translations_files_count).to eq(1)
        expect(YAML.load_file(translations_file)[locale].count).to eq(2)
      end
    end

    context "when the response root key matches the locale with a region subtag" do
      let(:body) { "ko-KR:\n hello: 안녕" }
      let(:locale) { "ko" }

      before do
        allow(connection).to receive(:get).and_return response
        allow(response).to receive(:body).and_return body
        subject.import!(locale: locale)
      end

      it "writes the locale file using the Loco response root key" do
        expect(YAML.load_file(translations_file).keys).to eq(["ko-KR"])
      end
    end

    context "when the request is unsuccessful" do
      before do
        allow(connection).to receive(:get).and_raise(
          Faraday::UnauthorizedError.new(401, { status: 401, body: "unauthorized error" })
        )
      end

      it "does not raise and writes a placeholder when no usable file exists" do
        expect { subject.import!(locale: locale) }.not_to raise_error
        parsed = YAML.load_file(translations_file)
        expect(parsed.keys).to eq([locale])
        expect(parsed[locale]).to be_empty
      end

      context "and a valid locale file already exists" do
        before do
          add_translation_file(locale)
        end

        it "leaves the existing file untouched" do
          original = File.read(translations_file)
          subject.import!(locale: locale)
          expect(File.read(translations_file)).to eq(original)
        end
      end
    end

    context "when the response is valid YAML but the wrong shape" do
      let(:body) { %({"error": "Invalid project key"}) }

      before do
        allow(connection).to receive(:get).and_return response
        allow(response).to receive(:body).and_return body
      end

      it "does not raise and writes a placeholder" do
        expect { subject.import!(locale: locale) }.not_to raise_error
        parsed = YAML.load_file(translations_file)
        expect(parsed.keys).to eq([locale])
        expect(parsed[locale]).to be_empty
      end
    end
  end
end
