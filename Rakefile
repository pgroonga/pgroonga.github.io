# -*- ruby -*-

require "bundler/setup"

require "json"
require "open-uri"

require "jekyll/task/i18n"

Jekyll::Task::I18n.define do |task|
  task.locales = ["ja"]
  task.files = Rake::FileList["**/*.md"]
  task.files -= Rake::FileList["_*/**/*.md"]
  task.files -= Rake::FileList["vendor/**/*.md"]
  task.locales.each do |locale|
    task.files -= Rake::FileList["#{locale}/**/*.md"]
  end
end

namespace :release do
  namespace :version do
    desc "Update version"
    task :update do
      releases_uri = URI("https://api.github.com/repos/pgroonga/pgroonga/releases")
      latest_release = releases_uri.open do |releases_output|
        releases = JSON.parse(releases_output.read)
        releases[0]
      end

      # "PGroonga 3.2.4: 2024-10-03"
      release_name = latest_release["name"]
      # "3.2.4"
      version = release_name[/\d+\.\d+\.\d+/, 0]
      # "2024-10-03"
      release_date = Date.parse(release_name[/\d+-\d+-\d+/, 0])

      config_yml = "_config.yml"
      config_yml_content = File.read(config_yml)
      config_yml_content.gsub!(/^(pgroonga_version: ).+$/) do
        "#{$1}#{version}"
      end
      config_yml_content.gsub!(/^(pgroonga_release_date: ).+$/) do
        "#{$1}#{release_date}"
      end
      File.write(config_yml, config_yml_content)
      sh("git", "add", config_yml)
      message = "PGroonga #{version} has been released!!!"
      sh("git", "commit", "-m", message)
      sh("git", "tag", "-a", version, "-m", message)
      sh("git", "push")
      sh("git", "push", "--tags")
    end
  end
end

key_svgs = []
all_svgs = []
plots = Pathname.glob("data/**/*.gnuplot")
plots.each do |plot|
  output_base_dir = plot.dirname.to_s.gsub(/\Adata\//, "images/")
  svgs = []

  plot.open do |plot_file|
    plot_file.each_line do |line|
      case line.chomp
      when /\Aset output "(.*?)"\z/
        svgs << "#{output_base_dir}/#{$1}"
      end
    end
  end

  key_svg = svgs.first
  key_svgs << key_svg
  file key_svg => plot.to_s do
    cd(plot.dirname) do
      sh("gnuplot", plot.basename.to_s)
    end
    svgs.each do |svg|
      mkdir_p(File.dirname(svg))
      mv("#{plot.dirname}/#{File.basename(svg)}",
         svg)
    end
  end

  all_svgs.concat(svgs)
end

task :default => ["jekyll:i18n:translate", *key_svgs]
