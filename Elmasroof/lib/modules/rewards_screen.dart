import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/enums/reward.dart';
import 'package:elmasroof/shared/formatter/positive_formatter.dart';
import 'package:elmasroof/shared/network/local/shared_preferences/shared_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef CallbackSubmission = Function(BuildContext context);

class RewardsScreen extends StatefulWidget {
  RewardsScreen({super.key, required this.callback});

  CallbackSubmission callback;

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {

  late List<Reward> rewards;
  late List<TextEditingController> controllers;
  late List<GlobalKey<FormFieldState>> keys;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rewards = List.generate(Reward.values.length, (index) => Reward.values[index]);
    rewards.sort((a, b) => a.id.compareTo(b.id));
    controllers = List.generate(rewards.length, (index) => TextEditingController()..text = '0');
    keys = List.generate(rewards.length, (index) => GlobalKey());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('قيم الجوائز'), centerTitle: true,),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(rewards.length, (index) {
                  return _createCardItem(index);
                },),
              ),
            ),
          ),
          SizedBox(height: 8,),
          _createConfirmButton(),
          SizedBox(height: 16,),
        ],
      ),
    );
  }

  Widget _createCardItem(int index) => Card.outlined(
    color: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.black87, width: 2,)
    ),
    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    child: Row(
      children: [
        SizedBox(width: 8,),
        SvgPicture.asset(rewards[index].iconPath, width: 32, height: 32,),
        SizedBox(width: 4,),
        Expanded(
          child: createTextField(
            title: '${rewards[index].name} (${rewards[index].description})',
            controller: controllers[index],
            formKey: keys[index],
            inputType: TextInputType.number,
            formatter: PositiveFormatter(),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'يجب إضافة القيمة أولاً';
              }
              return null;
            },
          ),
        ),
      ],
    ),
  );

  Widget _createConfirmButton() => createButton(
      text: 'تأكيد',
      onPressed: () {
        bool valid = true;
        for (var key in keys) {
          if(!key.currentState!.validate()){
            valid = false;
          }
        }
        if(!valid){
          return;
        }
        for(int i = 0; i < rewards.length; i++){
          Reward reward = rewards[i];
          TextEditingController controller = controllers[i];
          SharedManager.putData(key: SharedManager.getRewardId(reward), value: double.parse(controller.text));
        }
        widget.callback(context);
      }
  );
}
