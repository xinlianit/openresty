---
--- Redis set get
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by jirry.
--- DateTime: 2019/7/5 14:30
---
---

local redis = require("resty.redis")

-- 连接信息
local host = '192.168.134.215'
local port = 6379
local timeout = 1000
local auth = '123456'
local pool_max_idle_timeout = 10000      -- 连接池连接最大空闲时间; (单位: ms毫秒)
local pool_size = 100   -- 连接池大小

-- Redis 连接关闭
local function close_redis(redisObj)
    if not redisObj then
        return
    end

    --local ok, err = redisObj:close()  -- 关闭连接
    local ok, err = redisObj:set_keepalive(pool_max_idle_timeout, pool_size)    -- 连接池
    if not ok then
        ngx.say("redis close error: ", err)
    end
end

-- 创建Redis实例
local redisObj = redis:new()

-- 设置超时(单位：ms毫秒)
redisObj:set_timeout(timeout)

-- 连接
local ok, err = redisObj:connect(host, port)

-- 连接失败
if not ok then
    ngx.say("connect to redis error: ", err)
    return close_redis(redisObj)
end

-- 认证
local ok, err = redisObj:auth(auth)
if not ok then
    ngx.say("redis auth error: ", err)
    return close_redis(redisObj)
end

-- 设置缓存
local ok, err = redisObj:set('test', 123456)
if not ok then
    ngx.say("redis set error: ", err)
    return close_redis(redisObj)
end

-- 读取缓存
local res, err = redisObj:get('test')
if not res then
    ngx.say("redis get error: ", err)
    return close_redis(redisObj)
end

-- 关闭Redis连接
close_redis(redisObj)

-- 输出缓存
ngx.say("redis get result: ", res)
