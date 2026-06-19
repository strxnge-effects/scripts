#!/usr/bin/env ruby
require "paru/filter"

Paru::Filter.run do
  with "Header" do |header|
    if metadata["title"]
      metadata["title"] = "#{metadata["title"]} ⬩ trans-neptunian object"
      stop!
      
    else
      if header.level == 1
        # set first h1 / top level header as title
        metadata["title"] = "#{header.inner_markdown} ⬩ trans-neptunian object"
        stop!
      end
    end
  end
end
