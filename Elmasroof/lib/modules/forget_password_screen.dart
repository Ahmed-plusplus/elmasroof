import 'package:elmasroof/cubit/auth_cubit/auth_cubit.dart';
import 'package:elmasroof/layouts/ads/banner_ad_widget.dart';
import 'package:elmasroof/layouts/alerts/success_dialog.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/constants/const_asset_images.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormFieldState> oldPasswordKey = GlobalKey();
  GlobalKey<FormFieldState> newPasswordKey = GlobalKey();
  GlobalKey<FormFieldState> confirmPasswordKey = GlobalKey();
  FocusNode oldPasswordNode = FocusNode();
  FocusNode newPasswordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: Column(
        children: [
          Image.asset(ConstAssetImages.saveMoney.path),
          SizedBox(height: 8,),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(!(SharedManager.getData(key: SharedManager.LOGIN_BIOMETRIC) ?? false))
                      _oldPasswordField(),
                    _newPasswordField(),
                    _reNewPasswordField(),
                    createButton(
                      text: 'تغيير كلمة المرور',
                      onPressed: () => _submit(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8,),
          BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _oldPasswordField() => createTextField(
      title: 'كلمة المرور القديمة',
      hint: 'أدخل كلمة المرور',
      formKey: oldPasswordKey,
      controller: oldPasswordController,
      node: oldPasswordNode,
      hideText: true,
      action: TextInputAction.next,
      submit: (value){
        if(oldPasswordKey.currentState!.validate()) {
          FocusScope.of(context).requestFocus(newPasswordNode);
        }
      },
      validator: (String value){
        if(value.isEmpty) {
          return 'أدخل كلمة المرور أولاً';
        }
        if(value.compareTo(SharedManager.getData(key: SharedManager.LOGIN_PASSWORD)) != 0){
          return 'كلمة المرور غير صحيحة';
        }
        return null;
      },
  );

  Widget _newPasswordField() => createTextField(
      title: 'كلمة المرور الجديدة',
      hint: 'أدخل كلمة المرور',
      formKey: newPasswordKey,
      controller: newPasswordController,
      node: newPasswordNode,
      hideText: true,
      action: TextInputAction.next,
      submit: (value){
        if(newPasswordKey.currentState!.validate()) {
          FocusScope.of(context).requestFocus(confirmPasswordNode);
        }
      },
      validator: (String value){
        if(value.isEmpty) {
          return 'أدخل كلمة المرور أولاً';
        }
        return null;
      },
  );

  Widget _reNewPasswordField() => createTextField(
      title: 'تأكيد كلمة المرور الجديدة',
      hint: 'أكد كلمة المرور',
      formKey: confirmPasswordKey,
      controller: confirmPasswordController,
      node: confirmPasswordNode,
      hideText: true,
      action: TextInputAction.next,
      submit: (value){
        if(confirmPasswordKey.currentState!.validate()) {
          _submit();
        }
      },
      validator: (String value){
        if(value.isEmpty) {
          return 'أدخل كلمة المرور أولاً';
        }
        if(value.compareTo(newPasswordController.text) != 0){
          return 'غير مطابق لكلمة المرور';
        }
        return null;
      },
  );

  void _submit() {
    if((oldPasswordKey.currentState?.validate() ?? true) && newPasswordKey.currentState!.validate() && confirmPasswordKey.currentState!.validate()){
      SharedManager.putData(key: SharedManager.LOGIN_PASSWORD, value: newPasswordController.text);
      showSuccessDialog(context: context, message: 'تم تغيير كلمة المرور بنجاح', onDismiss: () => Navigator.of(context).pop());
    }
  }
}
