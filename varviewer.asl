// Zero 3 Shisei No Koe Game time and variable viewer
// Autor: Sena (twitch.tv/sena_ttv; github.com/senattv)
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

  // film (Rei)
  byte type_7_rei = memory.ReadValue<byte>((IntPtr) 0x203207F0);
  byte type_14_rei = memory.ReadValue<byte>((IntPtr) 0x203207F2);
  byte type_61_rei = memory.ReadValue<byte>((IntPtr) 0x203207F4);
  byte type_90_rei = memory.ReadValue<byte>((IntPtr) 0x203207F6);
  byte type_0_rei = memory.ReadValue<byte>((IntPtr) 0x203207F8);
    
  // film (Miku)
  byte type_7_miku = memory.ReadValue<byte>((IntPtr) 0x2032087A);
  byte type_14_miku = memory.ReadValue<byte>((IntPtr) 0x2032087C);
  byte type_61_miku = memory.ReadValue<byte>((IntPtr) 0x2032087E);
  byte type_90_miku = memory.ReadValue<byte>((IntPtr) 0x20320880);
  byte type_0_miku = memory.ReadValue<byte>((IntPtr) 0x20320882);  

  // film (Kei)
  byte type_7_kei = memory.ReadValue<byte>((IntPtr) 0x20320904);
  byte type_14_kei = memory.ReadValue<byte>((IntPtr) 0x20320906);
  byte type_61_kei = memory.ReadValue<byte>((IntPtr) 0x20320908);
  byte type_90_kei = memory.ReadValue<byte>((IntPtr) 0x20320910);
  byte type_0_kei = memory.ReadValue<byte>((IntPtr) 0x20320912);  

  vars.points = points;
  vars.hours = hours;
  vars.minutes = minutes;
  vars.seconds = seconds;
  vars.the_hour = the_hour;
  
  vars.film_rei = type_7_rei.ToString() + " | " + type_14_rei.ToString() + " | " + type_61_rei.ToString() + " | " + type_90_rei.ToString() + " | " + type_0_rei.ToString();
  
  vars.film_miku = type_7_miku.ToString() + " | " + type_14_miku.ToString() + " | " + type_61_miku.ToString() + " | " + type_90_miku.ToString() + " | " + type_0_miku.ToString();
  
  vars.film_kei = type_7_kei.ToString() + " | " + type_14_kei.ToString() + " | " + type_61_kei.ToString() + " | " + type_90_kei.ToString() + " | " + type_0_kei.ToString();
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