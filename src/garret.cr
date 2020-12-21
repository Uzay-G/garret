# TODO: Write documentation for `Garret`
require "json"
require "option_parser"

module Garret
  VERSION = "0.1.0"

  bookmarks_path = uninitialized Nil | String
  ignored_path = uninitialized Nil | String
  output_path = uninitialized Nil | String

  # Class that handles parsing / matching of urls / category names that the user prefers
  # to not include in his generation of the markdown
  class Ignored
    def initialize(ignored_path : String | Nil)
      if ignored_path.nil?
        @folders = [] of String
        @urls = [] of String
      else
        parsed = File.read(ignored_path).split("--").map { |section| section.strip.split("\n")[1..] }.not_nil!
        @folders = parsed[0]
        @urls = parsed[1]
      end
    end

    def match_folders(content : JSON::Any)
      @folders.any? { |matched| /#{matched}/.match(content.as_s) }
    end

    def match_urls(content : JSON::Any)
      @urls.any? { |matched| /#{matched}/.match(content.as_s) }
    end
  end

  # Handles parsing of JSON to markdown
  class BookmarkParser
    def initialize(@ignored : Ignored, @bookmark_data : JSON::Any)
    end

    def parse_data(depth : Int32, current_folder : JSON::Any)
      output = ""
      # base level setup
      if depth == 0
        output = "# Digital Attic\n"
      end

      if !@ignored.match_folders(current_folder["title"])
        if !(current_folder["title"].as_s.empty? || current_folder["title"].as_s == "unfiled")
          output += "\n#{"#" * depth} #{current_folder["title"].as_s}\n"
        end
        current_folder["children"].as_a.each do |child|
          if child.as_h.has_key? "children"
            output += parse_data(depth + 1, child)
          elsif child.as_h.has_key?("uri") && !@ignored.match_urls(child["uri"])
            output += "- [#{child["title"].as_s}](#{child["uri"].as_s})\n"
          end
        end
      end
      output
    end
  end

  # parses command line options
  option_parser = OptionParser.parse do |parser|
    parser.banner = "Simple CLI to convert your bookmarks to organized and readable markdown."

    parser.on "--file-path PATH", "Path of bookmarks file." do |path|
      bookmarks_path = path
    end

    parser.on "-i PATH", "--ignored PATH", "Path of patterns to ignore." do |path|
      ignored_path = path
    end

    parser.on "-o PATH", "--output-path PATH", "Path to store output. Default: attic.md" do |path|
      output_path = path
    end

    parser.on "-h", "--help", "Show help" do
      puts parser
      exit
    end
  end

  bookmark_data = JSON.parse(File.read(bookmarks_path.not_nil!))
  ignored = Ignored.new(ignored_path)
  parsed = BookmarkParser.new(ignored, bookmark_data).parse_data(0, bookmark_data)

  if output_path
    File.write(output_path.not_nil!, parsed)
    puts "Successfully parsed bookmarks and saved the markdown to #{output_path}!"
  else
    puts parsed
  end
end
