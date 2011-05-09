#!/usr/bin/env ruby

path = ENV["BB_DOC_PATH"]

original_counterpart_path = `dirname #{path}`.rstrip
counterpart_path = ""
counterpart_filename = ENV["BB_DOC_NAME"].dup
alternative_filepath = ""

if original_counterpart_path =~ /app\//
  # TODO: check to see if the path exists. If it does not, try test/functionals or test/models

  spec_folder_path = original_counterpart_path + "/../../spec"
  if File.exists?(spec_folder_path) # using RSPEC
    counterpart_path = original_counterpart_path.gsub(/.+?app\//, "../../spec/")
    new_counterpart_path = original_counterpart_path.gsub(/\/app\//, "/spec/")
    counterpart_filename = counterpart_filename.gsub(/.rb/, "_spec.rb")

    alternative_filepath = "#{counterpart_path}/#{counterpart_filename}"
  else
    counterpart_path = original_counterpart_path.gsub(/.+?app\//, "../../test/")
    counterpart_filename = counterpart_filename.gsub!(/.rb/, "_test.rb")
    if counterpart_filename =~ /controller/
      counterpart_path.gsub!(/controllers/, "functional")
      alternative_filepath = "#{counterpart_path}/#{counterpart_filename}"
    end

    if original_counterpart_path =~ /models/
      counterpart_path = original_counterpart_path.gsub(/.+?app\//, "../../test/")
      counterpart_path.gsub!(/models/, "unit")
      alternative_filepath = "#{counterpart_path}/#{counterpart_filename}"
    end
  end
else

  # TODO: support TestUnit here too
  if counterpart_path =~ /\/spec\//
    counterpart_path.gsub!(/.+?spec\//, "../../app/")
    counterpart_filename = counterpart_filename.gsub(/_spec.rb/, ".rb")
  #else
  end
end


puts "#-*- tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true; x-counterpart: #{alternative_filepath}; x-typographers-quotes: false; -*-"
puts
puts ARGF.read
