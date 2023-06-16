// ignore_for_file: sized_box_for_whitespace, library_private_types_in_public_api

import 'package:flutter_svg/svg.dart';
import 'package:iomoo/utilities/colors.dart';
import 'package:iomoo/utilities/typography.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// ignore: must_be_immutable
class Input extends StatefulWidget {
  final String label;
  final TextInputType type;
  final SvgPicture icon;
  final String hint;

  // ignore: prefer_typing_uninitialized_variables
  var value;

  bool isObscured;
  bool mandatory;

  Input({
    Key? key,
    required this.label,
    required this.type,
    required this.icon,
    required this.hint,
    required this.value,
    this.isObscured = false,
    this.mandatory = true,
    String? initialValue,
  }) : super(key: key);

  @override
  _Input createState() => _Input();
}

class _Input extends State<Input> {
  final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
  final RegExp weightRegExp =
      RegExp(r'^(?:0*(?:\d{1,2}(?:\.\d+)?|1000(?:\.0+)?))$');

  var maskFormatter = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  String? validateEmail(String? value) {
    if (!emailRegExp.hasMatch(value!)) {
      return 'Por favor, insira um email válido.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value != null && value.length < 6) {
      return 'Por favor, insira uma senha válida.';
    }
    return null;
  }

  String? validateWeight(String? value) {
    if (!weightRegExp.hasMatch(value!)) {
      return 'Por favor, insira um peso válido entre 0,1 e 1000.';
    }
    return null;
  }

  String? validateInput(String? value) {
    if (widget.mandatory) {
      if (value == null || value.isEmpty) {
        return '${widget.label} não pode ser vazio.';
      }

      if (widget.type == TextInputType.emailAddress) {
        return validateEmail(value);
      } else if (widget.type == TextInputType.visiblePassword) {
        return validatePassword(value);
      } else if (widget.type == TextInputType.number) {
        return validateWeight(value);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 304,
          height: 25,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            widget.label,
            style: AppTypography.label,
          ),
        ),
        Container(
          width: 304,
          height: 70,
          margin: const EdgeInsets.only(bottom: 16.0),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validateInput,
            onSaved: widget.value,
            inputFormatters:
                widget.type == TextInputType.datetime ? [maskFormatter] : null,
            keyboardType: widget.type,
            cursorColor: AppColors.primaryColor, // Define a cor do cursor
            obscureText: widget.isObscured,
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: widget.icon,
              ),
              hintText: widget.hint,
              hintStyle: AppTypography.inputHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(156),
              ),
              focusedBorder: OutlineInputBorder(
                // Configuração da cor da borda quando o TextField está com foco
                borderSide: const BorderSide(
                  color: AppColors
                      .primaryColor, // Define a cor da borda quando o TextField está com foco
                  width:
                      2.0, // Define a largura da borda quando o TextField está com foco
                ),
                borderRadius: BorderRadius.circular(156),
              ),
              suffixIcon: widget.type == TextInputType.visiblePassword ||
                      widget.type == TextInputType.text
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.isObscured = !widget.isObscured;
                          });
                        },
                        icon: Icon(
                          widget.isObscured
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.text.withOpacity(0.6),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        )
      ],
    );
  }
}
