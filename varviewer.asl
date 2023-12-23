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
}

update {
  uint points = 0;
  byte seconds = 0;
  byte minutes = 0;
  uint hours = 0;
  
  byte type_7 = 0;
  byte type_14 = 0;
  byte type_61 = 0;
  byte type_90 = 0;
  byte type_0 = 0;

  // points  
  memory.ReadValue<uint>((IntPtr) 0x2031EDB8, out points);

  // IGT
  memory.ReadValue<byte>((IntPtr) 0x2031EDC8, out seconds);
  memory.ReadValue<byte>((IntPtr) 0x2031EDC4, out minutes);
  memory.ReadValue<uint>((IntPtr) 0x2031EDC0, out hours);

  // film
  memory.ReadValue<byte>((IntPtr) 0x203207F0, out type_7);
  memory.ReadValue<byte>((IntPtr) 0x203207F2, out type_14);
  memory.ReadValue<byte>((IntPtr) 0x203207F4, out type_61);
  memory.ReadValue<byte>((IntPtr) 0x203207F6, out type_90);
  memory.ReadValue<byte>((IntPtr) 0x203207F8, out type_0);
   
  vars.points = points;
  vars.hours = hours;
  vars.minutes = minutes;
  vars.seconds = seconds;
  
  vars.type_7 = type_7;
  vars.type_14 = type_14;
  vars.type_61 = type_61;
  vars.type_90 = type_90;
  vars.type_0 = type_0;
}

gameTime {
  return TimeSpan.FromSeconds(3600*vars.hours + 60*vars.minutes + vars.seconds);
}


