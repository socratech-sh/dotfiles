local mp = require("core.messagepack")


local kv_store = {}

local function isFile(path)
    local f = io.open(path, "r")
    if f then
        f:close()
        return true
    end
    return false
end

local function isDir(path)
    local ok, err, code = os.rename(path, path)
    if ok or code == 13 then
        return true
    end
    return false
end

local function load_page(path)
    print("Loading page from path:", path)
    local ret
    local f = io.open(path, "rb")
    if not f then
        return nil
    else
        local content = f:read("*a")
        f:close()
        ret = mp.unpack(content)
    end
    return ret
end

local function store_page(path, page)
    if type(page) == "table" then
        local f = io.open(path, "wb")
        if f then
            f:write(mp.pack(page))
            f:close()
            return true
        end
    end
    return false
end

local pool = {}

local db_funcs = {
    save = function(db, p)
        if p then
            if type(p) == "string" and type(db[p]) == "table" then
                return store_page(pool[db] .. "/" .. p, db[p])
            else
                return false
            end
        end
        for p, page in pairs(db) do
            if not store_page(pool[db] .. "/" .. p, page) then
                return false
            end
        end
        return true
    end,
}

local mt = {
    __index = function(db, k)
        print("Accessing key:", k)
        if db_funcs[k] then
            return db_funcs[k]
        end

        local page_path = pool[db] .. "/" .. k

        if isFile(page_path) then
            db[k] = load_page(page_path)
        else
            print("File does not exist for key:", k)
        end

        return rawget(db, k)
    end,
}

-- return setmetatable(pool, {
-- 	__mode = "kv",
-- 	__call = function(pool, path)
-- 		assert(isDir(path), path .. " is not a directory.")
-- 		if pool[path] then
-- 			return pool[path]
-- 		end
-- 		local db = {}
-- 		setmetatable(db, mt)
-- 		pool[path] = db
-- 		pool[db] = path
-- 		return db
-- 	end,
-- })
--
kv_store.create = function(path)
    assert(isDir(path), path .. " is not a directory.")
    if pool[path] then
        return pool[path]
    end
    local db = {}
    setmetatable(db, mt)
    pool[path] = db
    pool[db] = path
    return db
end

kv_store.load_page = load_page
kv_store.store_page = store_page


return kv_store
