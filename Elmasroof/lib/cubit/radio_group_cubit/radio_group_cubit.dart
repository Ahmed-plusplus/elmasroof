import 'package:flutter_bloc/flutter_bloc.dart';

import 'radio_group_states.dart';

class RadioGroupCubit extends Cubit<RadioGroupStates> {
  RadioGroupCubit() : super(RadioGroupInitialState());

  int currentSelection = 0;

  void onChangeRadio(int select){
    currentSelection = select;
    emit(RadioGroupChangeState());
  }
}