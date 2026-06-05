import 'package:elmasroof/cubit/radio_group_cubit/radio_group_cubit.dart';
import 'package:elmasroof/cubit/radio_group_cubit/radio_group_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnChangeRadioCallBack<T> = void Function(T? value);

abstract class ElmasroofRadioGroup<T> extends StatefulWidget {
  OnChangeRadioCallBack<T> callBack;
  late RadioGroupCubit _cubit;

  ElmasroofRadioGroup({
    super.key,
    required this.callBack,
  });

  Widget createRadioGroup(RadioGroupCubit cubit);

  Widget buildWidget(BuildContext context){
    return BlocProvider(
        create: (context) => _cubit = RadioGroupCubit(),
        child: BlocConsumer<RadioGroupCubit, RadioGroupStates>(
            listener: (context, state){},
            builder: (context, state) {
              _cubit = BlocProvider.of<RadioGroupCubit>(context);
              return createRadioGroup(_cubit);
            }
        )
    );
  }
}