local M = {}

M.setup = function() end

-- @class present.Slides
-- @fields slides string[]: The slides of the file.

-- Takes some lines and parse them.
--@param lines string[]: The lines in the buffer.
--@return present.Slides
local parse_slides = function(lines)
	local slides = { slides = {} }
	local current_slide = {}

	local separator = "^#"

	for _, line in ipairs(lines) do
		print(line, "find:", line:find(separator), "|")
		if line:find(separator) then
			if #current_slide > 0 then
				table.insert(slides.slides, current_slide)
			end
		end
	end
	return slides
end

--testing

vim.print(parse_slides({
	"# Hello",
	"this is awesome",
	"# world",
}))

return M
