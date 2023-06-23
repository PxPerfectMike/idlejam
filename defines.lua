local defines = {}

function get_define(key)
    local msg = "define dosen't exist"
    assert(defines[key], msg)
    return defines[key]
end

function add_define(key, value)
    local msg = "define already exist"
    --assert(defines[key] == nil, msg)
    if (defines[key] == nil) defines[key] = value
end