#!/usr/bin/env ruby

unless ARGV.length == 1 || ARGV.length == 2
  puts "USAGE: ./update-pgroonga-upgrade-page.rb compatible"
  puts "or"
  puts "USAGE: ./update-pgroonga-upgrade-page.rb incompatible \"a reason of incompatible\""
  exit 1
end

COMPATIBLE_OR_NOT = ARGV[0]

system("git clone git@github.com:pgroonga/pgroonga.git")
Dir.chdir("pgroonga") do
  latest_version = `git tag --sort version:refname | tail -n 2 | sed -n '2p'`.strip
  previous_version = `git tag --sort version:refname | tail -n 2 | sed -n '1p'`.strip
end
system("rm -rf pgroonga")

Dir.chdir("../")

if COMPATIBLE_OR_NOT == "compatible"
  contents = <<-CONTENTS
    * #{previous_version} -> #{latest_version}: o
  CONTENTS

  `sed -ie "/^Here is a list of compatibility/r /dev/stdin" upgrade/index.md`, stdin_data: contents
else
  INCOMPATIBLE_REASON = ARGV[1]
  contents = <<-CONTENTS
    * #{previous_version} -> #{latest_version}: x
      * #{INCOMPATIBLE_REASON}
  CONTENTS

  `sed -ie "/^Here is a list of compatibility/r /dev/stdin" upgrade/index.md`, stdin_data: contents
end

# TODO: I'll remove translation.
# Because contents of this page doesn't need to translate.
system("rake jekyll:i18n:translate")
system("git add _po/ja/upgrade/index.po")
system("git add ja/upgrade/index.md")
system("git add upgrade/index.md")

system("git commit -m \"upgrade: add #{previous_version} -> #{latest_version}\"")
# system("git push")
