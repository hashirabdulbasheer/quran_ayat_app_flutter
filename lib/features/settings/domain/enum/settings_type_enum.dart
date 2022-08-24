/// dropdown - a dropdown with various options to select
/// onOff - on/off toggle switch
enum QuranSettingType { dropdown, onOff }

enum QuranSettingOnOff { on, off }

extension QuranSettingOnOffToString on QuranSettingOnOff {
  String rawString() {
    switch (this) {
      case QuranSettingOnOff.on:
        return "On";
      case QuranSettingOnOff.off:
        return "Off";
    }
  }
}
