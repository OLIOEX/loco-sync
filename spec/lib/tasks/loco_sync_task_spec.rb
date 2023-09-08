require 'loco_sync'
require 'spec_helper'

describe 'loco_sync Rake tasks' do
  let(:response) { double({ body: "wibble: wobble" }) }

  before :all do
    Rake.application.rake_require('loco_sync_task', ['lib/tasks'])
    Rake::Task.define_task(:environment)
  end

  before do
    allow(Faraday).to receive(:new).and_return(double("client", get: response, post: response))
    allow(LocoSync::Config).to receive(:locales_path).and_return "spec/support/mock/locale"
  end

  after do
    remove_translation_file
  end

  describe 'loco_sync:import' do
    subject { Rake::Task['loco_sync:import'].invoke }

    it 'imports translations from localise.biz' do
      expect(LocoSync::Sync::Import).to receive(:import!).with(locale: "en")
      subject
    end
  end

  describe 'loco_sync:export' do
    before do
      add_translation_file("en")
    end

    subject { Rake::Task['loco_sync:export'].invoke }

    it 'exports configured export locales' do
      expect(LocoSync::Sync::Export).to receive(:export!).with(locale: "en")
      subject
    end
  end
end
