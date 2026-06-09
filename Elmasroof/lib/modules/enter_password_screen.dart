import 'package:elmasroof/cubit/auth_cubit/auth_cubit.dart';
import 'package:elmasroof/cubit/auth_cubit/auth_states.dart';
import 'package:elmasroof/modules/home_screen.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/constants/const_asset_images.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

class EnterPasswordScreen extends StatefulWidget {
  EnterPasswordScreen({super.key, required this.isSupported, required this.availableBiometric});

  bool isSupported;
  List<BiometricType> availableBiometric;

  @override
  State<EnterPasswordScreen> createState() => _EnterPasswordScreenState();
}

class _EnterPasswordScreenState extends State<EnterPasswordScreen> {

  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormFieldState> passwordKey = GlobalKey();
  FocusNode passwordNode = FocusNode();

  late AuthCubit authCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authCubit = AuthCubit.get(context);
    if (widget.isSupported
        && (SharedManager.getData(key: SharedManager.LOGIN_BIOMETRIC) ?? false)) {
      authBiometric();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(ConstAssetImages.balance.path),
              SizedBox(height: 10,),
              passwordField(),
              _handleBiometricButton(),
              SizedBox(height: 10,),
              createButton(
                text: 'دخول',
                onPressed: () => _submit(),
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if(passwordKey.currentState!.validate()){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  Widget passwordField() => createTextField(
      title: 'كلمة المرور',
      hint: 'أدخل كلمة المرور',
      formKey: passwordKey,
      controller: passwordController,
      node: passwordNode,
      submit: (value) => _submit(),
      validator: (String value){
        if(value.isEmpty) {
          return 'أدخل كلمة المرور أولاً';
        }
        if(SharedManager.getData(key: SharedManager.LOGIN_PASSWORD) != passwordController.text) {
          return 'كلمة المرور غير صحيحة';
        }
        return null;
      }
  );

  Widget _handleBiometricButton() => BlocConsumer<AuthCubit, AuthStates>(
    listener: (context, state) {},
    builder: (context, state) {
      authCubit = AuthCubit.get(context);
      return (widget.isSupported
          && (SharedManager.getData(key: SharedManager.LOGIN_BIOMETRIC) ?? false))
          ? _biometricButton() : Container();
    },
  );

  Widget _biometricButton() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Column(
      children: [
        createTitle(title: 'أو'),
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
                Text('الدخول ببصمة الإصبع'),
              ],
            ),
          ),
        )
      ],
    ),
  );

  void authBiometric() {
    authCubit.authenticateWithBiometrics().then((authenticated) {
      if(authenticated) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    });
  }
}
