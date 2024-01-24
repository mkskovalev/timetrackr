namespace :data_conversion do
  task :run do
    puts ">>> Base convertations started..."

    current_version = DataConversion.first_or_create.version
    last_version = 1

    (current_version + 1).upto(last_version) do |version|
      if respond_to?("conversion_#{version}", true)
        puts "Call conversion_#{version}"

        send("conversion_#{version}")
        DataConversion.update(version: version, completed_at: Time.current)
      end
    end

    puts "<<< Base convertations finished"
  end

  private

  def conversion_1
    Category.find_each do |category|
      category.send(:update_level)

      puts "category: #{category.name}, level: #{category.level}"

      category.save if category.level_changed?
    end
  end
end
