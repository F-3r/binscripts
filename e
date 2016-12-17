#!/usr/bin/env ruby
#
# Emacs wrapper script to allow copy pasting backtrace locations, like:
#
# ```bash
#
# e file:line_no other_file:line_no
#
#```

args = ARGV.map { |file| file.split(":") }
           .map { |(file, line)|
             line ? %Q(+#{line} "#{file}") : %Q("#{file}") }
           .join(" ")

exec "emacs #{args}"
