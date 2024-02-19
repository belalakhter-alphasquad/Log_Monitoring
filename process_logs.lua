-- local last_timestamp
-- local buffer = {}

-- function process_line(tag, timestamp, record)
--     local log = record["log"]
--     local year, month, day, hour, min, sec, msec, rest = log:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+),(%d+) (.*)")

--     -- If the current line starts with a timestamp, it's the start of a new log entry
--     if year then
--         -- If there's something in the buffer, we need to flush it as a single log entry
--         if #buffer > 0 then
--             -- Concatenate all the buffered lines
--             local flushed_log = table.concat(buffer, " ")
--             -- Clear the buffer
--             buffer = {}
--             -- Return the concatenated log entry
--             return 1, timestamp, {["log"] = flushed_log}
--         end
--         -- Store the current timestamped line in the buffer
--         table.insert(buffer, log)
--         -- Update last timestamp
--         last_timestamp = string.format("%s-%s-%s %s:%s:%s.%s000000", year, month, day, hour, min, sec, msec)
--     else
--         -- If the line does not start with a timestamp, it's a continuation of the previous log entry
--         if last_timestamp then
--             -- Append the line to the buffer
--             table.insert(buffer, log)
--         end
--     end

--     -- If this is the end of the log or there's nothing to process, do nothing
--     return -1, timestamp, record
-- end

-- -- Flush any remaining log entries when the script ends
-- function on_exit(tag, timestamp, record)
--     if #buffer > 0 then
--         local flushed_log = table.concat(buffer, " ")
--         buffer = {}
--         return 1, timestamp, {["log"] = flushed_log}
--     end
-- end

local last_timestamp
local current_log = {}

function process_line(tag, timestamp, record)
    local line = record["log"]
    local year, month, day, hour, min, sec, msec, rest = line:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+),(%d+) (.*)")

    -- Check if this is a line starting with a timestamp
    if year and month and day and hour and min and sec and msec then
        -- A new log entry starts
        -- Convert the timestamp to Fluent Bit's format
        local fluent_bit_timestamp = string.format("%s-%s-%sT%s:%s:%s.%s000000Z", year, month, day, hour, min, sec, msec)
        last_timestamp = fluent_bit_timestamp

        -- If there is a log message being constructed, send it out before starting a new one
        if next(current_log) then
            local full_message = table.concat(current_log, " ")
            current_log = {} -- reset for the next message
            table.insert(current_log, line) -- start the new message
            -- Send out the full message that was constructed
            return 1, fluent_bit_timestamp, {["log"] = full_message}
        else
            -- This is the first line of a new message
            table.insert(current_log, line)
            return -1, timestamp, record
        end
    else
        -- This line is a continuation of the current log message
        table.insert(current_log, line)
        return -1, timestamp, record
    end
end
