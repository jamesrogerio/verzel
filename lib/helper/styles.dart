import 'package:flutter/material.dart';

import 'colors.dart';

class AppStyle {
  static final verySmallText = TextStyle(
    fontStyle: FontStyle.normal,
    fontSize: 10.0,
    color: AppColors.textDark,
  );

  static final smallText = TextStyle(
    fontStyle: FontStyle.normal,
    fontSize: 14.0,
    color: AppColors.textDark,
  );

  static final smallText12 = TextStyle(
    fontStyle: FontStyle.normal,
    fontSize: 10.0,
    color: AppColors.textDark,
  );

  static final mediumText = TextStyle(
    fontStyle: FontStyle.normal,
    fontSize: 18.0,
    color: AppColors.textDark,
  );

  static final infoMediumText = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
    color: Colors.grey[700],
  );

  static final smallMediumText = TextStyle(
    fontStyle: FontStyle.normal,
    fontSize: 16.0,
    color: AppColors.textDark,
  );

  static final largeText = TextStyle(
    fontStyle: FontStyle.normal,
    fontSize: 22.0,
    color: AppColors.textDark,
  );

  static final normalText = TextStyle(fontStyle: FontStyle.normal);
}
