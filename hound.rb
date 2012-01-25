require 'rubygems'
require 'nokogiri'
require 'json'

def search(keyword)
	plurks = Dir.new('plurks')
	result = {}
	plurks.each do |f|
		if f.end_with? '.html' 
			fobj = File.open(File.join(plurks.path, f))
			doc = Nokogiri::XML(fobj)
			content = doc.xpath("//xmlns:div[@class='bigplurk']").inner_html.to_s
			m = content.match(/<a.*>(.+)<\/a>\s*(<span.*>.*<\/span>)?\s*(.*)\s*<div class="meta">([0-9\-\ :]+),*.*<\/div>\s*/m)
			original_author = m[1]
			content = m[3]
			datetime = m[4]
			if content.include? keyword
				p original_author, content,datetime
			end
		end
	end
end
