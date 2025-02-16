import 'package:elmasroof/modules/create_auth_screen.dart';
import 'package:elmasroof/modules/home_screen.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class CreatePasswordScreen extends StatefulWidget {
  CreatePasswordScreen({super.key, required this.isSupported, required this.availableBiometric});

  bool isSupported;
  List<BiometricType> availableBiometric;

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormFieldState> passwordKey = GlobalKey();
  GlobalKey<FormFieldState> confirmPasswordKey = GlobalKey();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El masroof'),
        elevation: 5,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          createTextField(
            title: 'كلمة المرور',
            hint: 'أدخل كلمة المرور',
            formKey: passwordKey,
            controller: passwordController,
            node: passwordNode,
            action: TextInputAction.next,
            submit: (value){
              if(passwordKey.currentState!.validate()) {
                FocusScope.of(context).requestFocus(confirmPasswordNode);
              }
            },
            validator: (String value){
              if(value.isEmpty) {
                return 'أدخل كلمة المرور أولاً';
              }
              return null;
            }
          ),
          createTextField(
            title: 'تأكيد كلمة المرور',
            hint: 'أكد كلمة المرور',
            formKey: confirmPasswordKey,
            controller: confirmPasswordController,
            node: confirmPasswordNode,
            submit: (value) => _submit(),
            validator: (String value){
              if(value.isEmpty) {
                return 'أكد كلمة المرور أولاً';
              }
              if(value.compareTo(passwordController.text) != 0){
                return 'غير مطابق لكلمة المرور';
              }
              return null;
            }
          ),
          createButton(
            text: 'دخول',
            onPressed: () => _submit(),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if(passwordKey.currentState!.validate() && confirmPasswordKey.currentState!.validate()){
      SharedManager.putData(key: SharedManager.LOGIN_PASSWORD, value: passwordController.text);
      if(widget.isSupported){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAuthScreen(isSupported: widget.isSupported, availableBiometric: widget.availableBiometric,)));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }
  }
}
