## Script to separate CSS and JS part from HTML Page and save in Assets folder
## Ensure that common stylesheets are moved to common folder inside assets/stylesheets
## Ensure that require_tree . is replaced by require_tree ./common in assets/stylesheets/application.css file
##
##
## Usage=>  ruby separator.rb <full_path> 
## Works for Linux machines
full_file_path = ARGV[0]
if full_file_path.include? "/home/"
	if full_file_path.include? ".erb"
		if full_file_path.include? "layouts/"
			puts "Error: Does not work on Layouts file"
		else
			if File.exists?(full_file_path)
				puts "EXECUTING"
				full_file = File.read(full_file_path)
				full_file_dir = full_file_path.gsub(/views.*/, "")
				assets_dir = full_file_dir + "assets/"
				extn = File.extname  full_file_path
				comp = File.basename full_file_path, extn
				style_count= 0
				style_regex = Regexp.new(/\<style\>.*?\<\/style\>/im)
				style_array =  full_file.scan(style_regex)
				script_regex =  Regexp.new(/\<script\>.*?\<\/script\>/im)
				script_array =  full_file.scan(script_regex)
				check_style_path = File.join(assets_dir,"stylesheets/application.css")
				if File.readlines(check_style_path).grep(/.*tree\s\.\/common/).size > 0
					style_array.each do |style|
						style_count = style_count + 1
						style_sheet = comp + style_count.to_s + ".css"
						style_sheet_path = File.join(assets_dir, "stylesheets", style_sheet)
						full_file = full_file.gsub(style, '<%=stylesheet_link_tag "'+ style_sheet +'" %>')
						style = style.gsub(/\<style\>/, "")
						style = style.gsub(/\<\/style\>/, "")
						File.write(style_sheet_path, style )
						
					end
				else
					puts "Error: Place the common style sheets to Common folder, Change 'require_tree .' in application.css to 'require_tree ./common' "

				end
				File.open(full_file_path, "w") do |f|
				  f.write(full_file)
				end
				puts "Success: Execution Complete"
				puts "Files saved in app/assets/stylesheets"
			else
				puts "Error: file dint exists"
			end
		end
	else
		puts "Error: Only Ruby HTML files"
	end
else
	puts "Error:  Please give full path"
end


