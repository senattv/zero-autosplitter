// Zero 3 Shisei No Koe Game time and variable viewer
// Autor: Sena (twitch.tv/sena_ttv; github.com/sena_ttv)
// A tool to visualize in-game time on LiveSplit, as well
// as useful variables you need to open the menu to check
// (points and film).
//
// Select "Game Time" when loading this ASL file to see
// the IGT. To view the other variables, install ASL
// var viewer as instructed here:
// https://github.com/hawkerm/LiveSplit.ASLVarViewer

state("pcsx2") {
  uint test: 0; // dummy variable so that ASL var viewer can see the "variables"
}

startup {
  refreshRate = 5; // more than enough to keep all up-to-date
  vars.hour_watcher = new MemoryWatcher<byte>((IntPtr) 0x2031EDB2);
  vars.reset_watcher = new MemoryWatcher<byte>((IntPtr) 0x20324D53);
}

update {
  vars.hour_watcher.Update(game);
  vars.reset_watcher.Update(game);

  // points  
  uint points = memory.ReadValue<uint>((IntPtr) 0x2031EDB8);

  // IGT
  byte seconds = memory.ReadValue<byte>((IntPtr) 0x2031EDC8);
  byte minutes = memory.ReadValue<byte>((IntPtr) 0x2031EDC4);
  uint hours = memory.ReadValue<uint>((IntPtr) 0x2031EDC0);
  
  // Just to show on ASL var viewer
  byte the_hour = memory.ReadValue<byte>((IntPtr) 0x2031EDB2);

  // film
  byte type_7 = memory.ReadValue<byte>((IntPtr) 0x203207F0);
  byte type_14 = memory.ReadValue<byte>((IntPtr) 0x203207F2);
  byte type_61 = memory.ReadValue<byte>((IntPtr) 0x203207F4);
  byte type_90 = memory.ReadValue<byte>((IntPtr) 0x203207F6);
  byte type_0 = memory.ReadValue<byte>((IntPtr) 0x203207F8);
    
  vars.points = points;
  vars.hours = hours;
  vars.minutes = minutes;
  vars.seconds = seconds;
  vars.the_hour = the_hour;
  
  vars.film = type_7.ToString() + " | " + type_14.ToString() + " | " + type_61.ToString() + " | " + type_90.ToString() + " | " + type_0.ToString();
}

split {
  return vars.hour_watcher.Old != vars.hour_watcher.Current;
}

start {
  return vars.reset_watcher.Old == 0 && vars.reset_watcher.Current == 1;
}

reset  {
  return vars.reset_watcher.Old == 1 && vars.reset_watcher.Current == 0;
}

gameTime {
  return TimeSpan.FromSeconds(3600*vars.hours + 60*vars.minutes + vars.seconds);
}