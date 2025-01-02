import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget createTextField(
    {
      GlobalKey<FormFieldState>? formKey,
      TextEditingController? controller,
      String title = '',
      double titleSize = 15.0,
      Color titleColor = Colors.black87,
      String hint = '',
      String text = '',
      double textSize = 15.0,
      double? width,
      double? height,
      double? paddingHorizontal,
      Color backgroundColor = Colors.white70,
      Color? color,
      TextInputAction action = TextInputAction.done,
      TextInputType inputType = TextInputType.text,
      FocusNode? node,
      Function? validator,
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
        Container(
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
              maxLines: 1,
              textAlign: TextAlign.end,
              readOnly: !enable,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: textSize,
                  color: Colors.grey,
                ),
                fillColor: backgroundColor,
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
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
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),

              ],
              style: TextStyle(
                  fontSize: textSize,
                  color: color
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
    padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 20.0),
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
