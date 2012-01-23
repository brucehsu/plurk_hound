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
			content = doc.xpath("//xmlns:div[@class='bigplurk']").inner_html.to_s.split '</a>',2
			original_author = content[0]
			content = content[1]
			content, datetime = content.split('<div class="meta">',2)[0], content.split('<div class="meta">',2)[1]
			datetime = datetime.split('</div>')[0]
			datetime = datetime.split(',')[0]
			content = content.split('</span>',2)[1] if content.split('</span>',2).size==2
			content = content.split("\n",2)[1] if content.split("\n",2).size==2
			if content.include? keyword
				p content, datetime
			end
		end
	end
end
