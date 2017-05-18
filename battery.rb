require 'optparse'

$info_file = '/proc/acpi/battery/BAT0/info'
$state_file = '/proc/acpi/battery/BAT0/state'
$warning_level = 100.0
$ohshit_level = 5.0
$display = `ps -aux | grep /usr/bin/X | grep -oP ' :[^ ]+' | grep -oP ':[^ ]+' | head -1`

def screen_red
  red_cmd = "DISPLAY=#{$display.chomp} xrandr --output eDP1 --gamma 2:1:1"
  system red_cmd
end

def screen_reset
  reset_cmd = "DISPLAY=#{$display.chomp} xrandr --output eDP1 --gamma 1:1:1"
    system reset_cmd
end

def flash times

  gap = 0.5

  (1..times).each do
    screen_red
    sleep gap
    screen_reset
    sleep gap
  end
end

def get_full
  info = File.read $info_file

  m = /last full capacity:\s*(\d+)/.match info

  if not m then
    puts "[!] Could not read full capacity from #{info_file}"
    0
  else
    m[1]
  end
end

def get_now
  state = File.read $state_file

  m = /remaining capacity:\s*(\d+)/.match state
  if not m then
    puts "[!] Could not read current capacity from #{state_file}"
    0
  else
    now = m[1]
  end
end

def check_battery_level_and_flash_if_low
  full = get_full
  now = get_now

  percent = (now.to_f / full.to_f) * 100

  if percent <= $warning_level then
    flash 3
  end

  if percent < $ohshit_level then
    screen_red
  end
end

check = false
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0}"

  opts.on('-c', '--check', 'Check battery level and flash screen if it is low') do |p|
    check = true
  end
end

optparse.parse!

if check then
  check_battery_level_and_flash_if_low
end

