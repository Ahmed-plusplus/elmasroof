import 'package:elmasroof/modules/settings_screen.dart';
import 'package:elmasroof/shared/formatter/custom_pattern_formatter.dart';
import 'package:elmasroof/shared/formatter/formatter.dart';
import 'package:elmasroof/shared/formatter/general_formatter.dart';
import 'package:flutter/material.dart';

Widget createTextField(
    {
      GlobalKey<FormFieldState>? formKey,
      TextEditingController? controller,
      String title = '',
      double titleSize = 15.0,
      Color titleColor = Colors.black87,
      String hint = '',
      double textSize = 15.0,
      TextAlign alignment = TextAlign.end,
      double? width,
      double? height,
      double? paddingHorizontal,
      Color backgroundColor = Colors.black12,
      Color? color,
      TextInputAction action = TextInputAction.done,
      TextInputType inputType = TextInputType.text,
      Formatter? formatter,
      FocusNode? node,
      Function? validator,
      Function? onChanged,
      Function? submit,
      Function? preValidate,
      IconData? prefixIcon,
      IconData? suffixIcon,
      Widget? prefixWidget,
      Widget? suffixWidget,
      Function? onPrefix,
      Function? onSuffix,
      bool hideText = false,
      bool enable = true,
      bool expand = false,
    }
    ){
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: paddingHorizontal ?? 30.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if(title.isNotEmpty)
          createTitle(
            title: title,
            titleSize: titleSize,
            color: titleColor,
          ),
        SizedBox(
          height: height ?? 70.0,
          width: width ?? 300.0,
          child: Focus(
            onFocusChange: (focus) async {
              if(!focus) {
                if (preValidate != null && controller != null) {
                  await preValidate(controller.text);
                }
                if (formKey != null) {
                  formKey.currentState!.validate();
                }
              }
            },
            child: TextFormField(
              key: formKey,
              controller: controller,
              focusNode: node,
              textInputAction: action,
              keyboardType: inputType,
              maxLines: expand ? null : 1,
              expands: expand,
              textAlign: alignment,
              readOnly: !enable,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: textSize,
                  color: Colors.grey,
                ),
                fillColor: backgroundColor,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(expand ? 20.0 : 50.0),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: const BorderSide(color: Color(0xFFC62828),),
                ),
                prefixIcon: (onPrefix==null)
                    ? (prefixIcon==null)
                    ? (prefixWidget==null) ? null
                    : prefixWidget
                    : Icon(prefixIcon)
                    : IconButton(onPressed: () => onPrefix(), icon: (prefixIcon == null) ? prefixWidget! : Icon(prefixIcon)),
                suffixIcon: (onSuffix==null)
                    ? (suffixIcon==null)
                    ? (suffixWidget==null) ? null
                    : suffixWidget
                    : Icon(suffixIcon)
                    : IconButton(onPressed: () => onSuffix(), icon: (suffixIcon == null) ? suffixWidget! : Icon(suffixIcon)),
              ),
              inputFormatters: [
                if(inputType == TextInputType.number)
                  CustomPatternInputFormatter(formatter??GeneralFormatter()),

              ],
              style: TextStyle(
                fontSize: textSize,
                color: color,
              ),
              obscureText: hideText,
              validator: (val){
                if(validator != null){
                  return validator(val);
                }else {
                  return null;
                }
              },
              onFieldSubmitted: (val) async{
                if(preValidate != null){
                  await preValidate(val);
                }
                if(submit != null){
                  await submit(val);
                }
              },
              onChanged: (val) async{
                if(onChanged != null){
                  await onChanged(val);
                }
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget createTitle({
  required String title,
  double titleSize = 20.0,
  Color? color,
  bool bold = true,
}){
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, ),
    child: Text(
      title,
      style: TextStyle(
        fontSize: titleSize,
        color: color,
        fontWeight: bold?FontWeight.bold:null,
      ),
      textDirection: TextDirection.rtl,
    ),
  );
}

Widget createButton({
  required String text,
  required Function onPressed,
  double? width,
  double verticalPadding = 8.0,
  double horizontalPadding = 30.0,
  Color backgroundColor = Colors.lightBlue,
  Color color = Colors.white,
  IconData? icon,
}){
  return TextButton(
    onPressed: () => onPressed(),
    child: Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if(icon != null)
            Icon(icon, color: color,),
          if(icon != null)
            const SizedBox(width: 10,),
          Text(text, style: TextStyle(color: color, fontSize: 20.0),),
        ],
      ),
    ),
  );
}

AppBar appBarWidget({BuildContext? context}) => AppBar(
  title: const Text('El masroof'),
  elevation: 5,
  actions: (context == null)?[]:[
    IconButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) => const SettingsScreen()),
      ),
      icon: const Icon(Icons.settings),
    ),
  ],
);
