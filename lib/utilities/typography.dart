import 'package:flutter/material.dart';

import 'colors.dart';

class AppTypography {
  static const TextStyle heading = TextStyle(
    fontFamily: 'Axiforma',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -2,
  );
  static const TextStyle headingLogin = TextStyle(
    fontFamily: 'Axiforma',
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -2,
  );
  static const TextStyle headingModal = TextStyle(
    fontFamily: 'Axiforma',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -2,
  );
  static const TextStyle headingCard = TextStyle(
    fontFamily: 'Axiforma',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -2,
  );
  static const TextStyle body = TextStyle(
    fontFamily: 'Axiforma',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );
   static const TextStyle idDevice= TextStyle(
    fontFamily: 'Axiforma',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
  );
  static final TextStyle inputHint = TextStyle(
    fontFamily: 'Axiforma',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.text.withOpacity(0.4),
  );
  static const TextStyle text = TextStyle(
    fontFamily: 'Axiforma',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );
  static const TextStyle label = TextStyle(
    fontFamily: 'Axiforma',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );
  static const TextStyle informationAnimal = TextStyle(
    fontFamily: 'Axiforma',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );

  static const TextStyle extraBold = TextStyle(
    fontFamily: 'Axiforma',
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
  );
}
