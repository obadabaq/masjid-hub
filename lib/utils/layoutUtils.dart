import 'enums/deviceScale.dart';

class LayoutUtils {
  DeviceScale getShrinkScale(double deviceHeight) {
    final double optimumHeight = 870;
    final double adhanListItemHeight = 50;
    final double adhanItemsCliping =
        (optimumHeight - deviceHeight) / adhanListItemHeight;

    final int itemsCliping = adhanItemsCliping.round();

    if (adhanItemsCliping.isNegative) {
      return DeviceScale.normal;
    } else if (itemsCliping == 1) {
      return DeviceScale.small;
    } else if (itemsCliping == 2) {
      return DeviceScale.extraSmall;
    } else {
      return DeviceScale.superSmall;
    }
  }

  double getPrayerDialHeight(DeviceScale scale, double normalHeight) {
    switch (scale) {
      case DeviceScale.small:
        return normalHeight - 30;
      case DeviceScale.extraSmall:
        return normalHeight - 50;
      case DeviceScale.superSmall:
        return normalHeight - 100;

      default:
        return normalHeight;
    }
  }


  double getPrayerDialFontSize(DeviceScale scale, double normalFontSize) {
    switch (scale) {
      case DeviceScale.superSmall:
        return normalFontSize - 5;
      default:
        return normalFontSize;
    }
  }

  double getCalendarIconHeigt(DeviceScale scale, double normalHeight) {
    switch (scale) {
      case DeviceScale.small:
        return normalHeight - 7;
      case DeviceScale.extraSmall:
      case DeviceScale.superSmall:
        return normalHeight - 14;
      default:
        return normalHeight;
    }
  }

  double getCalendarTextFontSize(DeviceScale scale, double normalFontSize) {
    switch (scale) {
      case DeviceScale.small:
        return normalFontSize - 3;
      case DeviceScale.extraSmall:
      case DeviceScale.superSmall:
        return normalFontSize - 5;

      default:
        return normalFontSize;
    }
  }
}
