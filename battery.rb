info_file = '/proc/acpi/battery/BAT0/info'
state_file = '/proc/acpi/battery/BAT0/state'
warning_level = 100.0
ohshit_level = 5.0

display = `ps -aux | grep /usr/bin/X | grep -oP ' :[^ ]+' | grep -oP ':[^ ]+' | head -1`

def screen_red display
  red_cmd = "DISPLAY=#{display.chomp} xrandr --output eDP1 --gamma 2:1:1"
  system red_cmd
end

def screen_reset display
  reset_cmd = "DISPLAY=#{display.chomp} xrandr --output eDP1 --gamma 1:1:1"
    system reset_cmd
end

def flash times, display

  gap = 0.5

  (1..times).each do
    screen_red display
    sleep gap
    screen_reset display
    sleep gap
  end
end

info = File.read info_file
state = File.read state_file

m = /last full capacity:\s*(\d+)/.match info

if not m then
  puts "[!] Could not read full capacity from #{info_file}"
  exit 1
end

full = m[1]

m = /remaining capacity:\s*(\d+)/.match state
if not m then
  puts "[!] Could not read current capacity from #{state_file}"
  exit 1
end

now = m[1]

percent = (now.to_f / full.to_f) * 100

if percent < warning_level then
  flash 3, display
end

if percent < ohshit_level then
  screen_red display
end
