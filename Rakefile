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
