util = {}

function string:split(sep, n)
	n = n or 1/0
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	local itail = 1
	for str in string.gmatch(self, "([^"..sep.."]+)") do
		t[i] = str
		itail = itail + #str
		if i == n-1 then
			tail = self:sub(itail+i, -1)
			if tail ~= "" then
				t[i+1] = tail
			end
			break
		end
		i = i + 1
	end
	return t
end

function util.clamp(x, min, max)
	return math.min(math.max(x, min), max)
end

function util.round(n, d)
	return math.floor(n*10*d+0.5)/(10*d)
end

function util.safeIndex(t, ...)
	local arg = {...}
	if #arg == 0 then return t end
	local k = table.remove(arg, 1)
	if t[k] then return util.safeIndex(t[k], unpack(arg)) else return nil end
end

function util.printr(tbl, indent)
    if type(tbl) ~= "table" then print(tbl) return end
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            util.printr(v, indent+1)
        else
          print(formatting .. tostring(v))
        end
    end
end

return util