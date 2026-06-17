import 'package:elmasroof/cubit/auth_cubit/auth_cubit.dart';
import 'package:elmasroof/cubit/auth_cubit/auth_states.dart';
import 'package:elmasroof/layouts/custom_widget/radio_group/custom_radio_group.dart';
import 'package:elmasroof/modules/home_screen.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/enum/parent_type.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late AuthCubit authCubit;
  ParentType parentType = ParentType.father;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  _title(),
                  const SizedBox(height: 20,),
                  _parentTypeWidget(),
                  const SizedBox(height: 20,),
                  _passwordField(),
                  _repasswordField(),
                  _handleBiometricButton(),
                  createButton(
                    text: 'دخول',
                    onPressed: () => _submit(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if(passwordKey.currentState!.validate() && confirmPasswordKey.currentState!.validate()){
      SharedManager.putData(key: SharedManager.LOGIN_PASSWORD, value: passwordController.text);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  Widget _passwordField() => createTextField(
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
      },
      onChanged: (String value) {
        if(value.isNotEmpty && value == confirmPasswordController.text){
          if(!authCubit.isPasswordReady) {
            authCubit.showBiometricAuth();
          }
        } else {
          if(authCubit.isPasswordReady) {
            authCubit.hideBiometricAuth();
          }
        }
      }
  );

  Widget _repasswordField() => createTextField(
      title: 'تأكيد كلمة المرور',
      hint: 'أكد كلمة المرور',
      formKey: confirmPasswordKey,
      controller: confirmPasswordController,
      node: confirmPasswordNode,
      validator: (String value){
        if(value.isEmpty) {
          return 'أكد كلمة المرور أولاً';
        }
        if(value.compareTo(passwordController.text) != 0){
          return 'غير مطابق لكلمة المرور';
        }
        return null;
      },
      onChanged: (String value) {
        if(value.isNotEmpty && value == passwordController.text){
          if(!authCubit.isPasswordReady) {
            authCubit.showBiometricAuth();
          }
        } else {
          if(authCubit.isPasswordReady) {
            authCubit.hideBiometricAuth();
          }
        }
      }
  );

  Widget _handleBiometricButton() => BlocConsumer<AuthCubit, AuthStates>(
    listener: (context, state) {
      if(state is AuthSuccessState){
        SharedManager.putData(key: SharedManager.LOGIN_BIOMETRIC, value: true);
        _submit();
      }
    },
    builder: (context, state) {
      authCubit = AuthCubit.get(context);
      return (widget.isSupported //&& widget.availableBiometric.isNotEmpty
          && authCubit.isPasswordReady) ?
      _biometricButton()
          : Container();
    },
  );

  Widget _biometricButton() => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        TextButton(
          onPressed: () => authBiometric(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(color: Colors.lightBlue),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.tag_faces_outlined),
                SizedBox(width: 2.0,),
                Text('أو الوجه'),
                SizedBox(width: 4.0,),
                Icon(Icons.fingerprint),
                SizedBox(width: 2.0,),
                Text('التسجيل ببصمة الإصبع'),
              ],
            ),
          ),
        )
      ],
    ),
  );

  Widget _title() => const Text(
    'إنشاء كلمة مرور\nلحفظ مصروف أبنائك',
    style: TextStyle(
      color: Colors.lightBlue,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  );

  void authBiometric() {
    authCubit.authenticateWithBiometrics();
  }

  Widget _parentTypeWidget() => Padding(
    padding: const EdgeInsets.all(8.0),
    child: CustomRadioGroup<ParentType>(
      list: ParentType.values,
      icons: ParentType.values.map((parent) => parent.icon).toList(),
      callBack: (value) {
        parentType = value ?? parentType;
      },
    ),
  );

}
