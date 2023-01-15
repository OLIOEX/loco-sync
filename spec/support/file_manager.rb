# frozen_string_literal: true

require "fileutils"

module FileManager
  def translations_files_count
    locales_dir.count { |file| File.file?(file) }
  end

  def remove_translation_file
    FileUtils.rm_rf locales_dir
  end

  def add_translation_file(locale)
    File.open("#{locales_path}/#{locale}.yml", "w+:UTF-8") do |f|
      f.write translation_data
    end
  end

  def locales_path
    "spec/support/mock/locale"
  end

  def locales_dir
    Dir["#{LocoSync::Config.locales_path}/**/*"]
  end

  private

  def translation_data
    <<~DATA
      en:
        translation_1: this is the first translation
        translation_2: this is the second translation
    DATA
  end
end
