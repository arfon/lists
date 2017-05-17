require './config/environment'

class Lists < Thor
  desc 'clone', 'Clone the target list source repository'
  def clone(repository_address)
    repo_name = File.basename(repository_address, ".git")
    g = Git.clone(repository_address, "tmp/#{repo_name}")
    puts "Repository cloned to #{g.repo}"
  end

  desc 'verify', 'Verify target list is structured correctly'
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

    # TODO: Should pass an option flag to continue further than here.

    # TODO: Dynamically assign the User
    list = List.new(:name => list_yaml['name'], :description => list_yaml['description'], :user => User.first)

    puts ""
    puts "List appears to be valid" if list.valid?
    puts "Adding List properties"
    list_yaml['properties'].each do |property|
      puts "Adding #{property} to List properties"
      list.add_property!(property)
    end

    puts "Adding Things to List"
    things = Dir.glob("#{local_repository}/things/*.yaml")
    puts "Found #{things.size} Things"
    things.each do |source_thing|
      thing_name = File.basename(source_thing)
      thing_yaml = YAML.load_file("#{source_thing}")
      thing = Thing.new(:list => list, :properties => thing_yaml['properties'])
      if thing.valid?
        puts "#{thing_name} appears to be a valid Thing"
        thing.save
      else
        puts "ERROR: #{thing_name} doesn't appear to be valid"
        puts "#{thing.errors}"
      end
    end
  end
end
