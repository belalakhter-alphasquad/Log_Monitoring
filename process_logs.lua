local last_timestamp
local last_log

function process_line(tag, timestamp, record)
    local log = record["log"]
    local new_record = record
    local year, month, day, hour, min, sec, msec, rest = log:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+),(%d+) (.*)")

    if year then
        -- A new log entry with a timestamp is found
        -- Convert the timestamp to Fluent Bit's format (nanoseconds resolution)
        local fluent_bit_timestamp = string.format("%s-%s-%s %s:%s:%s.%s000000", year, month, day, hour, min, sec, msec)
        -- Update last_timestamp and last_log with the new log entry
        last_timestamp = fluent_bit_timestamp
        last_log = log
        -- Update the log with the new timestamp
        new_record["log"] = fluent_bit_timestamp .. " " .. rest
    elseif last_log then
        -- If the line doesn't start with a timestamp, append it to the last log
        last_log = last_log .. " " .. log
        -- Use the last known timestamp
        new_record["log"] = last_timestamp .. " " .. last_log
    else
        -- If there's no last_log, this line is an orphan and we'll discard it
        return -1, timestamp, record
    end

    -- Return the timestamp (unchanged) and the modified log record
    return 1, timestamp, new_record
end
