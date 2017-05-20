# TODO: Lots of this logic should be moved into the List and Thing model. i.e.
# they should know how to load a YAML representation of themselves and assert
# whether they are valid etc.

require './config/environment'

class Lists < Thor
  desc 'clone', 'Clone the target list source repository'
  def clone(repository_address)
    repo_name = File.basename(repository_address, ".git")
    g = Git.clone(repository_address, "tmp/#{repo_name}")
    puts "Repository cloned to #{g.repo}"
  end

  desc 'verify', 'Verify target repository has correct basic structure'
  def verify(local_repository)
    puts "CHECKING LIST REPOSITORY STRUCTURE"
    top_level_entries = Dir.entries(local_repository)

    required_top_level = ["list.yaml", "things"]

    required_top_level.each do |item|
      if top_level_entries.include?(item)
        puts "Found #{item} at '#{local_repository}/#{item}'"
      else
        puts "ERROR: Can't find #{item}in '#{local_repository}'"
      end
    end

    puts ""
    puts "CHECKING list.yaml STRUCTURE"
    # Check list.yaml structure
    list_yaml = YAML.load_file("#{local_repository}/list.yaml")

    required_yaml_keys = ["name", "description", "properties"]

    required_yaml_keys.each do |key|
      if list_yaml.keys.include?(key)
        puts "Found key #{key} in '#{local_repository}/list.yaml'"
      else
        puts "ERROR: Can't find required key #{key} in '#{local_repository}/list.yaml'"
      end
    end

    # For comparison with Things later
    property_keys = list_yaml['properties'].collect { |property| property['key'] }

    puts ""
    puts "CHECKING properties of Things"
    things = Dir.glob("#{local_repository}/things/*.yaml")
    thing_properties = []
    things.each do |source_thing|
      thing_name = File.basename(source_thing)
      thing_yaml = YAML.load_file("#{source_thing}")
      thing_properties << thing_yaml['properties']
    end

    thing_propery_keys = thing_properties.flatten.collect { |property| property['property_key'] }

    unassigned_thing_keys = thing_propery_keys - property_keys
    puts "ERROR: Things have invalid property keys #{unassigned_thing_keys.uniq}" if unassigned_thing_keys.any?

    unused_property_keys = property_keys - thing_propery_keys
    puts "WARN: List havs unused property keys #{unused_property_keys.uniq}" if unused_property_keys.any?

    if unused_property_keys.empty?
      puts "Thing and List properties appear to be valid"
    end
  end

  desc 'load', 'Load the target repository'
  option :save, :type => :boolean, :default => false
  def load(local_repository)
    list_yaml = YAML.load_file("#{local_repository}/list.yaml")

    # TODO: Dynamically assign the User
    list = List.new(:name => list_yaml['name'], :description => list_yaml['description'], :user => User.first)

    if list.valid?
      puts "List appears to be valid"
      puts "Adding List properties"
      list_yaml['properties'].each do |property|
        puts "Adding #{property} to List properties"
        list.add_property!(property)
      end

      puts ""
      puts "Adding Things to List"
      things = Dir.glob("#{local_repository}/things/*.yaml")
      puts "Found #{things.size} Things"
      things.each do |source_thing|
        thing_name = File.basename(source_thing)
        thing_yaml = YAML.load_file("#{source_thing}")
        # byebug
        thing = Thing.new(:list => list, :properties => thing_yaml)
        if thing.valid?
          puts "#{thing_name} appears to be a valid Thing"
          thing.save
        else
          puts "ERROR: #{thing_name} doesn't appear to be valid"
          puts "#{thing.errors}"
        end
      end

      if options[:save] == false
        puts ""
        puts "Cleaning up List and Things. Use --save=true to save the records"
        list.destroy
      elsif options[:save] == true
        puts ""
        puts "Saving List and Things."
        puts "List ID: #{list.to_param}"
      end
    else
      puts ""
      puts "List appears to be invalid. Aborting."
    end
  end
end
