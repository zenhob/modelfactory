class FixtureConverter # :nodoc:
  def initialize(opts = {})
    @body   = []
    @header = []
    @indent_depth = opts[:indent_depth] || 0
    @output_style = opts[:output_style]
  end
  
  def powder?
    @output_style == :clay
  end
  
  def convert_fixture(path)
    fixture = YAML.load_file(path)
    return if not fixture

    plural_model_name = path.basename.to_s.split('.').first
    model_name        = plural_model_name.singularize
    header do
      "#{plural_model_name} = {}"
    end

    body 'before(:all) do' if powder?
    indent(powder?) do
      body "# Setup #{plural_model_name}"
      body "# Generated from fixture in #{path.dirname.basename}/#{path.basename}"
      body '#'
      body ''
      fixture.each do |name, record|
        max_length = record.keys.collect {|key| key.length}.max
      
        body "#{plural_model_name}[:#{name}] = Factory.create_#{model_name}("
        indent do
          body do
            record.collect do |key,value|
              value = "\"#{value}\"" if value.kind_of?(String)
              key   = key.ljust(max_length)
              ":#{key} => #{value}"
            end
          end
        end
        body ')'
      end
    end
    body 'end' if powder?
    body ''
  end

  def convert_scenario(path)
    path.each_entry do |file|
      next if file.extname != '.yml'
      next if file.basename.to_s =~ /relationships/
      convert_fixture( path + file )
    end
  end

  def out
    puts @header.join("\n")
    puts "\n"
    puts @body.join("\n")
  end

private
  INDENT = '  '

  def indent(enabled = true)
    @indent_depth += 1 if enabled
    yield
    @indent_depth -= 1 if enabled
  end

  def body(*lines)
    lines = yield if block_given?
    lines = [lines].flatten
    
    lines.each do |line|
      @body << indent_line(line, @indent_depth)
    end
  end

  def header(*lines)
    lines = yield if block_given?
    lines = [lines].flatten
    
    lines.each do |line|
      @header << line
    end
  end
  
  def indent_line(line, indent_depth)
    ws = ''
    indent_depth.times do
      ws += INDENT
    end
    ws + line
  end
end
