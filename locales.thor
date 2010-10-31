require File.dirname(__FILE__) + '/rails/test/lib/key_structure.rb'

class Locales < Thor
  desc 'test_all', 'Check formality of all locale files.'
  def test_all
    Dir.glob(File.dirname(__FILE__) + '/rails/locale/*.{rb,yml}') do |filename|
      if md = filename.match(/([\w\-]+)\.(rb|yml)$/)
        locale = md[1]
        [2, 3].each do |version|
          unless KeyStructure.check(locale, version).empty?
            puts "[#{locale}] Some keys are missing for Rails #{version}."
          end
        end
      end
    end
  end

  desc 'test LOCALE', 'Check formality of a locale file.'
  def test(locale)
    good = true
    [2, 3].each do |version|
      missing_keys = KeyStructure.check(locale, version)
      unless missing_keys.empty?
        puts "The following keys are missing for Rails #{version}."
        missing_keys.each do |key|
          puts "  " + key
        end
        good = false
      end
    end

    puts "The structure is good for Rails 2 and 3." if good
  end

  desc 'list', 'List locale names.'
  def list
    locales = []
    Dir.glob(File.dirname(__FILE__) + '/rails/locale/*.{rb,yml}') do |filename|
      if md = filename.match(/([\w\-]+)\.(rb|yml)$/)
        locales << md[1]
      end
    end
    puts locales.sort.join(', ')
  end

  desc 'ready', 'List locales ready for Rails 2 and 3.'
  def ready
    locales = []
    Dir.glob(File.dirname(__FILE__) + '/rails/locale/*.{rb,yml}') do |filename|
      if md = filename.match(/([\w\-]+)\.(rb|yml)$/)
        locale = md[1]
        if [2, 3].all? { |version| KeyStructure.check(locale, version).empty? }
          locales << locale
        end
      end
    end
    puts locales.sort.join(', ')
  end

  desc 'ready_for VERSION', 'List locales ready for a VERSION of Rails.'
  def ready_for(version)
    locales = []
    Dir.glob(File.dirname(__FILE__) + '/rails/locale/*.{rb,yml}') do |filename|
      if md = filename.match(/([\w\-]+)\.(rb|yml)$/)
        locale = md[1]
        if KeyStructure.check(locale, version).empty?
          locales << locale
        end
      end
    end
    puts locales.sort.join(', ')
  end
end
