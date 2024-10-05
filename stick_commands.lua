local math_sin = math.sin
local math_cos = math.cos
local pi = math.pi
local index = 1
local display_limit = 5   -- Number of items to display at once
local scroll_offset = 0   -- Offset for scrolling the list




-- Load objects table from the separate file
local objects = {
  {
      title = "STICK COMMAND:",
      s1 = "S1",
      s2 = "S2"
  },
  {
      title = "Bypass NAV Arm:",
      s1 = "SE - ",
      s2 = "C"
  },
  {
      title = "Calibrate Gryo:",
      s1 = "SW - ",
      s2 = "S"
  },
  {
      title = "Calibrate ACC:",
      s1 = "NW - ",
      s2 = "S"
  },
  {
      title = "Calibrate Comp:",
      s1 = "NE - ",
      s2 = "S"
  },
  {
      title = "Trim Forard:",
      s1 = "N - ",
      s2 = "N"
  },
  {
      title = "Trim Right:",
      s1 = "N - ",
      s2 = "E"
  },
  {
      title = "Trim Back:",
      s1 = "N - ",
      s2 = "S"
  },
  {
      title = "Trim Left:",
      s1 = "N - ",
      s2 = "W"
  },
  {
      title = "Save Settings:",
      s1 = "SW - ",
      s2 = "SE"
  },
  {
      title = "",
      s1 = "",
      s2 = ""
  },
}

-- Function to rotate a point (x, y) around a center point (cx, cy) by angle 
theta
local function rotatePoint(x, y, cx, cy, theta)
    local cos_theta = math_cos(theta)
    local sin_theta = math_sin(theta)

    local x_new = cx + (x - cx) * cos_theta - (y - cy) * sin_theta
    local y_new = cy + (x - cx) * sin_theta + (y - cy) * cos_theta

    return x_new, y_new
end

-- Function to draw a rotated arrow
local function drawRotatedArrow(x, y, size, angle)
    local x1, y1 = rotatePoint(x, y, x, y, angle)                 -- Start 
of line
    local x2, y2 = rotatePoint(x + size * 2, y, x, y, angle)       -- End of 
main line

    -- Draw main line
    lcd.drawLine(x1, y1, x2, y2, SOLID, 0)

    -- Calculate arrowhead points
    local x3, y3 = rotatePoint(x + size, y - 3, x, y, angle)       -- Top 
arrowhead
    local x4, y4 = rotatePoint(x + size, y + 3, x, y, angle)       -- Bottom 
arrowhead

    -- Draw arrowhead
    lcd.drawLine(x3, y3, x2, y2, SOLID, 0)    -- Top diagonal of arrowhead
    lcd.drawLine(x4, y4, x2, y2, SOLID, 0)    -- Bottom diagonal of 
arrowhead
end

local function draw()
  local space = 6
  local gap = 6
  local s1_x, s2_x = 97, 110

  -- Display only a portion of the objects, based on scroll offset
  for i = 1, display_limit do
    local idx = scroll_offset + i
    if idx > #objects then
        break
    end

    local obj = objects[idx]
    local text = obj["title"]

    lcd.drawText(5, (space * i) + (gap * i), text, LEFT)
    lcd.drawText(94, (space * i) + (gap * i), obj["s1"], LEFT)
    lcd.drawText(115, (space * i) + (gap * i), obj["s2"], LEFT)

  end
end

local function run(event)
    -- Handle scroll events
    if event == EVT_ROT_LEFT then
        scroll_offset = scroll_offset - 1
        if scroll_offset < 0 then
            scroll_offset = 0  -- Don't allow negative scrolling
        end
    end

    if event == EVT_ROT_RIGHT then
        scroll_offset = scroll_offset + 1
        if scroll_offset > #objects - display_limit then
            scroll_offset = #objects - display_limit  -- Prevent scrolling 
beyond the list
        end
    end

    lcd.clear()
    draw()

    return 0
end

-- Main function that EdgeTX calls
return { run = run }

