local buffer = {}
local last_timestamp

function main(tag, timestamp, record)
    local log = record["log"]
    local year, month, day, hour, min, sec, msec, rest = log:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+),(%d+) (.*)")

    if year then
        -- Format the timestamp to ISO 8601 format. The logs were in UTC.
        local iso_timestamp = string.format("%s-%s-%sT%s:%s:%s.%03dZ", year, month, day, hour, min, sec, tonumber(msec))

        if #buffer > 0 then
            local concatenated_log = last_timestamp and (last_timestamp .. " " .. table.concat(buffer, " ")) or table.concat(buffer, " ")

            buffer = {}

            table.insert(buffer, rest)
            last_timestamp = iso_timestamp
            return 1, timestamp, {log=concatenated_log, timestamp=iso_timestamp}
        else
            last_timestamp = iso_timestamp
            table.insert(buffer, rest)
            return -1, timestamp, record
        end
    else
        table.insert(buffer, log)
        return -1, timestamp, record
    end
end
