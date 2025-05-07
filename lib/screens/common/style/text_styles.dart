import 'package:flutter/material.dart';

class AppTextStyle {
  static const TextStyle semibold30 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 30,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle semibold25 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 25,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle semibold20 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle semibold18 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle medium18 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle medium16 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle medium12 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle regular16 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle light16 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle regular14 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle light14 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle light12 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle regular12 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle getResponsiveStyle(
      BuildContext context, TextStyle baseStyle) {
    double screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = 1.0;

    if (screenWidth > 1200) {
      scaleFactor = 1.2;
    } else if (screenWidth > 768) {
      scaleFactor = 1.1;
    }

    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14) * scaleFactor,
    );
  }
}
