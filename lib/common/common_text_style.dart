import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextUtil {
  TextUtil._();

  static late TextStyle base;

  static init(BuildContext context) {
    base = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(fontFamily: 'NotoSansSc');
  }
}

extension TextStyleAttr on TextStyle {
  // 粗细
  TextStyle get w100 =>
      this.copyWith(fontWeight: FontWeight.w100); // Thin, the least thick
  TextStyle get w200 =>
      this.copyWith(fontWeight: FontWeight.w200); // Extra-light
  TextStyle get w300 => this.copyWith(fontWeight: FontWeight.w300); // Light
  TextStyle get w400 =>
      this.copyWith(fontWeight: FontWeight.w400); // Normal / regular / plain
  TextStyle get w500 => this.copyWith(fontWeight: FontWeight.w500); // Medium
  TextStyle get w600 => this.copyWith(fontWeight: FontWeight.w600); // Semi-bold
  TextStyle get w700 => this.copyWith(fontWeight: FontWeight.w700); // Bold
  TextStyle get w800 =>
      this.copyWith(fontWeight: FontWeight.w800); // Extra-bold
  TextStyle get w900 =>
      this.copyWith(fontWeight: FontWeight.w900); // Black, the most thick
  TextStyle get regular => w400;

  TextStyle get medium => w500;

  TextStyle get bold => w700;

  // 颜色
  TextStyle customColor(Color c) => this.copyWith(color: c);

  TextStyle get white => this.copyWith(color: Colors.white);

  TextStyle get whiteFC => this.copyWith(color: const Color(0xFFFCFCFC));

  TextStyle get mainOrange => this.copyWith(color: const Color(0xFFF9BE46));

  TextStyle get mainYellow => this.copyWith(color: const Color(0xFFFABC35));

  TextStyle get mainGrey => this.copyWith(color: const Color(0xFFB6B2AF));

  TextStyle get mainBlue => this.copyWith(color: const Color(0xFF00B7C2));

  TextStyle get ren60 => this.copyWith(color: const Color(0xFFFD7360));

  TextStyle get greyEB => this.copyWith(color: const Color(0xFFEBEBEB));

  TextStyle get greyF8 => this.copyWith(color: const Color(0xFFF8F8F8).withOpacity(0.8));

  TextStyle get greyAA => this.copyWith(color: const Color(0xFFAAAAAA));

  TextStyle get greyA8 => this.copyWith(color: const Color(0xFFA8A8A8));

  TextStyle get greyA6 => this.copyWith(color: const Color(0xFFA6A6A6));

  TextStyle get grey6C => this.copyWith(color: const Color(0xFF6C6C6C));

  TextStyle get black4E => this.copyWith(color: const Color(0xFF4E4E4E));

  TextStyle get black4E60 => this.copyWith(color: const Color(0x994E4E4E));

  TextStyle get black2A => this.copyWith(color: const Color(0xFF2A2A2A));

  TextStyle get black00 => this.copyWith(color: const Color(0xFF000000));

  TextStyle get transparent => this.copyWith(color: Colors.transparent);

  // 字体
  TextStyle get NotoSansSc => this.copyWith(fontFamily: 'NotoSansSc');

  /// TODO: 替换字体文件
  TextStyle get PingFangSc => this.copyWith(fontFamily: 'NotoSansSc');

  TextStyle get HanSansCN => this.copyWith(fontFamily: 'NotoSansSc');

  // 以下为非枚举属性
  TextStyle sp(double s) => this.copyWith(fontSize: s.sp);

  TextStyle h(double h) => this.copyWith(height: h.h);

  TextStyle space({double? wordSpacing, double? letterSpacing}) =>
      this.copyWith(wordSpacing: wordSpacing, letterSpacing: letterSpacing);

  TextStyle dc(TextDecoration dc) => this.copyWith(decoration: dc);

  TextStyle dcColor(Color color) => this.copyWith(decorationColor: color);
}

final commonLyricWhiteTextStyle = TextUtil.base.sp(16).white; //;.h(2);
final strongLyricWhiteTextStyle = TextUtil.base.sp(16.5).white; //.h(2);
final commonLyricBlueTextStyle = TextUtil.base.sp(16).mainBlue; //.h(2);
final strongLyricBlueTextStyle = TextUtil.base.sp(16.5).mainBlue; //.h(2);
final commonLyricGrayTextStyle = TextUtil.base.sp(16).mainGrey; //.h(2);
final commonLyricWhite70TextStyle =
    TextUtil.base.sp(16).customColor(Colors.white70); //.h(2);

// final commonLyricWhiteTextStyle = TextUtil.base.sp(16).white.h(2);
// final strongLyricWhiteTextStyle = TextUtil.base.sp(16.5).white.h(2);
// final commonLyricBlueTextStyle = TextUtil.base.sp(16).mainBlue.h(2);
// final strongLyricBlueTextStyle = TextUtil.base.sp(16.5).mainBlue.h(2);
// final commonLyricGrayTextStyle = TextUtil.base.sp(16).mainGrey.h(2);
// final commonLyricWhite70TextStyle =
//     TextUtil.base.sp(16).customColor(Colors.white70).h(2);

final common14WhiteTextStyle = TextStyle(fontSize: 14, color: Colors.white);
final common16WhiteTextStyle = TextStyle(fontSize: 16, color: Colors.white);
final common12White70TextStyle = TextStyle(fontSize: 12, color: Colors.white70);