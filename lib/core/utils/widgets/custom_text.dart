import 'package:sharpvendor/core/utils/exports.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customText(String text,
    {Color? color,
      double fontSize = 14,
      double? letterSpacing,
      FontStyle? fontStyle,
      double? height,
      TextAlign? textAlign,
      int? maxLines,
      TextOverflow overflow = TextOverflow.ellipsis,
      TextDecoration? decoration,
      FontWeight? fontWeight,
      String? fontFamily,
      bool blur = false}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    softWrap: true,
    style: fontFamily != null
        ? TextStyle(
            fontFamily: fontFamily,
            fontStyle: FontStyle.normal,
            color: color,
            letterSpacing: letterSpacing,
            fontSize: fontSize,
            height: height,
            fontWeight: fontWeight,
            decoration: decoration,
          )
        : GoogleFonts.roboto(
            fontStyle: FontStyle.normal,
            color: color,
            letterSpacing: letterSpacing,
            fontSize: fontSize,
            height: height,
            fontWeight: fontWeight,
            decoration: decoration,
          ),
  );
}