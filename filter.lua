local buffer = {}
local last_timestamp

function main(tag, timestamp, record)
    local log = record["log"]
    local year, month, day, hour, min, sec, msec, rest = log:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+),(%d+) (.*)")

    if year then
        local fluent_bit_timestamp = string.format("%s-%s-%s %s:%s:%s.%s", year, month, day, hour, min, sec, msec)
        if #buffer > 0 then
            local concatenated_log = last_timestamp and (last_timestamp .. " " .. table.concat(buffer, " ")) or table.concat(buffer, " ")

            buffer = {}

            table.insert(buffer, rest)
            last_timestamp = fluent_bit_timestamp
            return 1, last_timestamp, {log=concatenated_log}
        else
            last_timestamp = fluent_bit_timestamp
            table.insert(buffer, rest)
            return -1, timestamp, record
        end
    else
        table.insert(buffer, log)
        return -1, timestamp, record
    end
end
