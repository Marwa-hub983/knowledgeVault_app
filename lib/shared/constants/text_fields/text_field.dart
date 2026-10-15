
import 'package:flutter/material.dart';

import 'package:knowledge_vault_app/shared/constants/colors.dart';

import 'package:knowledge_vault_app/shared/constants/font_palette.dart';
import 'package:knowledge_vault_app/shared/constants/responsive/responsive_utils.dart';

class TextFeildWidget extends StatelessWidget {
  const TextFeildWidget({
    super.key,
    this.labelText,
    this.topLabelText,
    this.hintText,
    this.textStyle,
    this.hintStyle,
    this.textInputType,
    this.controller,
    this.validator,
    this.prefix,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.obscureText = false,
    this.fillColor,
    this.hight,
    this.width,
this.onChanged,
    // ✅ ADD THIS BACK
    this.inputBorder,
  });

  final String? labelText;
  final String? topLabelText;
  final String? hintText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? prefix;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final int maxLines;
  final bool obscureText;
  final Color? fillColor;
  final double? hight;
  final double? width;
  final Function(String)? onChanged;

  // ✅ NEW
  final InputBorder? inputBorder;

  OutlineInputBorder _border(BuildContext context, {Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        ResponsiveUtils.getBorderRadius(context, 12),
      ),
      borderSide: BorderSide(
        color: color ?? Colors.grey.shade300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.scaleH(context, 10);
    final fontSize = ResponsiveUtils.scaleW(context, 15);
    final hintSize = ResponsiveUtils.scaleW(context, 13);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (topLabelText != null) ...[
          Text(
            topLabelText!,
            style: FontPalette.hW500S13.copyWith(
              color: Colors.grey,
              fontSize: ResponsiveUtils.scaleW(context, 13),
            ),
          ),
          SizedBox(height: spacing / 2),
        ],

        SizedBox(
          height: hight,
          width: width,
          child: TextFormField(
            controller: controller,
            validator: validator,
            readOnly: readOnly,
            onTap: onTap,
            maxLines: maxLines,
            obscureText: obscureText,
            keyboardType: textInputType,
            style: textStyle ??
                FontPalette.hW500S13.copyWith(
                  fontSize: fontSize,
                  color: Colors.black,
                ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: hintStyle ??
                  TextStyle(
                    fontSize: hintSize,
                    color: Colors.grey,
                  ),
              filled: true,
              fillColor: fillColor ?? Colors.grey.shade100,
              prefixIcon: prefix,
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.scaleW(context, 14),
                vertical: ResponsiveUtils.scaleH(context, 14),
              ),

              // ✅ FIX HERE
              border: inputBorder ?? _border(context, color: Colors.transparent),
              enabledBorder: inputBorder ?? _border(context),
              focusedBorder: inputBorder ??
                  _border(context, color: kPrimaryColor),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}