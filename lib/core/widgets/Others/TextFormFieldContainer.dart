import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldContainer extends StatelessWidget {
  var onChange =
      (newValue) {}; //**`onChange`**: دالة تُنفَّذ عند تغيير نص الحقل (مبدئيًا فارغة).
  var validator = (String? newValue) {
    return newValue;
  }; //- **`validator`**: دالة للتحقق من صحة الإدخال (تُرجع `String?` كرسالة خطأ أو `null` إذا كان الإدخال صالحًا).
  late String hint, icon_name, initialValue;
  bool autofocus, obscureText, enable;
  TextInputType textInputType;

  int maxLength;
  bool withInitialValue;

  late double mediaHeight, mediaWidth;
  ScreenUtil screenUtil = ScreenUtil();
  TextFormFieldContainer(
      {required this.hint,
      this.textInputType = TextInputType.text,
      required this.onChange,
      required this.validator,
      this.autofocus = false,
      this.obscureText = false,
      this.maxLength = 100,
      this.enable = true,
      this.withInitialValue = false,
      this.initialValue = ''});

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);

    //TODO:we should add the spinners of cities and brand of service
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: screenUtil.screenHeight / 15,
      /* screenUtil.orientation==Orientation.portrait?screenUtil.screenHeight / 15:screenUtil.screenWidth/15,*/
      child: TextFormField(
        enabled: enable,
        initialValue: withInitialValue ? initialValue : null,
        textAlign: TextAlign.right,
        style: TextStyle(
            color: AppTheme.primaryColor, fontFamily: AppTheme.fontFamily),
        keyboardType: textInputType,
        validator: validator,
        textDirection: TextDirection.rtl,
        autofocus: autofocus,
        obscureText: obscureText,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
        ],
        decoration: InputDecoration(
          alignLabelWithHint: true,
          border: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                  color: AppTheme.primaryColor,
                  style: BorderStyle.solid,
                  width: 1)),
          focusedBorder: OutlineInputBorder(
              gapPadding: 0, //empty space from the begin and end
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                  color: AppTheme.primaryColor,
                  style: BorderStyle.solid,
                  width: 1)),
          contentPadding: EdgeInsets.only(top: -10, right: 15, left: 35),
          /*screenUtil.orientation == "landSpace"
              ? EdgeInsets.only(top: -4)
              : EdgeInsets.only(top: -10, right: 15, left: 35),*/
          hintTextDirection: TextDirection.rtl,
          hintStyle: TextStyle(color: kMyGrey, fontFamily: AppTheme.fontFamily),
          hintText: hint,
        ),
        onChanged: onChange,
      ),
    );
  }
}
