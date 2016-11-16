# -*- ruby -*-

require "bundler/setup"
require "jekyll/task/i18n"

Jekyll::Task::I18n.define do |task|
  task.locales = ["ja"]
  task.files = Rake::FileList["**/*.md"]
  task.files -= Rake::FileList["_*/**/*.md"]
  task.locales.each do |locale|
    task.files -= Rake::FileList["#{locale}/**/*.md"]
  end
end

plot = Pathname.new("data/pgroonga-textsearch-pg-trgm/search.gnuplot")
svgs = []
plot.open do |plot_file|
  plot_file.each_line do |line|
    case line.chomp
    when /\Aset output "(.*?)"\z/
      svgs << "images/pgroonga-textsearch-pg-trgm/#{$1}"
    end
  end
end

key_svg = svgs.first
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

task :default => ["jekyll:i18n:translate", key_svg]
