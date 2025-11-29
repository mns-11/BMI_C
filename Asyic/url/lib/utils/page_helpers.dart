import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageHelpers {
  static double getFontSize(int pageNumber) {
    var _20_9_pages = [
      42,
      50,
      56,
      356,
      368,
      371,
      409,
      444,
      527,
      565,
      566,
      567,
      568,
      569,
      574,
      583,
      587,
      590,
      593,
      595,
      597,
      598,
      600,
    ];
    var _21_3_pages = [355, 481, 492];
    var _20_7_pages = [34, 575, 576, 577, 578];
    if (_20_9_pages.contains(pageNumber)) {
      return 20.9.sp;
    } else if (_21_3_pages.contains(pageNumber)) {
      return 21.3.sp;
    } else if (_20_7_pages.contains(pageNumber)) {
      return 20.7.sp;
    } else {
      //496,
      return 21.1.sp;
    }
  }

  static bool isCenter(int pageNumber) {
    var centeredPages = [528, 534, 545, 593, 594, 600, 602, 603, 604];
    if (centeredPages.contains(pageNumber)) {
      return true;
    }
    return false;
  }
}
