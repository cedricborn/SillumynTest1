gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

util.no_globals()

local video = nil
local show_square_start = nil  -- Timestamp for when the square should start showing
local VIDEO_DURATION = 20     -- Fixed video duration in seconds
local EVENT_DURATION = 4     -- Fixed video duration in seconds
local EVENT_TIMING = 10     -- Fixed video duration in seconds



-- Watch for changes in node.json
util.json_watch("config.json", function(config)
    if video then
        video:dispose()  -- Dispose of the old video
    end
    
    -- Extract values from the options array
    local video_file = config.video.asset_name
    local audio_enabled = config.audio
	VIDEO_DURATION = config.video_duration
	EVENT_DURATION = config.event_duration
	EVENT_TIMING = config.event_timing

    -- Load the video resource
    video = resource.load_video{
        file = video_file,
        looped = true,
        audio = audio_enabled,
        raw = true,
    }
end)

function node.render()
    gl.clear(0, 0, 0, 1)  -- Clear the screen with black

    if video then
        local state, w, h = video:state()
        if state == "loaded" then
            local progress = video:progress() % VIDEO_DURATION  -- Get current video progress
            
            -- Check if the video progress is at the middle
            if progress >= EVENT_TIMING and progress < (EVENT_TIMING + EVENT_DURATION) then
                -- Show red square for 4 seconds
                gl.clear(0, 1, 0, 1)
            else
              
				print("Hello world NONNNNNN" )
            end

            -- Place the video
            local x1, y1, x2, y2 = util.scale_into(NATIVE_WIDTH, NATIVE_HEIGHT, w, h)
            video:place(x1, y1, x2, y2):layer(1)

            -- Render the red square if the condition is met
            if show_square_start then
                local square_x = (NATIVE_WIDTH - 200) / 2
                local square_y = (NATIVE_HEIGHT - 200) / 2
                gl.color(1, 0, 0, 1) -- Set color to red
                gl.rect(square_x, square_y, square_x + 200, square_y + 200):layer(2)
            end
        end
    end
end