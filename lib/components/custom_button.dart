// ignore_for_file: sized_box_for_whitespace, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:iomoo/utilities/colors.dart';
import 'package:iomoo/utilities/typography.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Function()? function;

  const CustomButton({
    Key? key,
    required this.text,
    required this.function,
  }) : super(key: key);

  @override
  _CustomButton createState() => _CustomButton();
}

class _CustomButton extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;
    Color backgroundColor;

    if (widget.text == 'Cancelar') {
      textStyle = AppTypography.text.copyWith(color: AppColors.primaryColor);
      backgroundColor = AppColors.modalBackground;
    } else if (widget.text == 'Finalizar Cadastro') {
      textStyle = AppTypography.text.copyWith(color: AppColors.modalBackground);
      backgroundColor = AppColors.secondColor;
    } else if (widget.text == 'Excluir Animal') {
      textStyle = AppTypography.text.copyWith(color: AppColors.modalBackground);
      backgroundColor = Color(0xFFdc2626);
    } else {
      textStyle = AppTypography.text.copyWith(color: AppColors.modalBackground);
      backgroundColor = AppColors.primaryColor;
    }

    return Container(
      width: 304,
      height: 65,
      child: ElevatedButton(
        onPressed: widget.function,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(72.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
          elevation: 0,
        ),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}
