import 'package:elmasroof/models/child_expenses_changing_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class AddChildState extends HomeStates {}
class ChangeChildState extends HomeStates {}
class AddToNameState extends HomeStates {
  ChildExpensesChangingModel child;
  AddToNameState(this.child);
}
class RemoveChildState extends HomeStates {}
class ChangeStickerState extends HomeStates {}
class ChangeChildStickerState extends HomeStates {}
class ChangeAddChildCurrencyState extends HomeStates {}
class ChangeChildCurrencyState extends HomeStates {}
class UpdateDescriptionState extends HomeStates {}
