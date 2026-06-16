import 'package:elmasroof/models/child_expenses_changing_model.dart';
import 'package:elmasroof/models/child_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class AddChildState extends HomeStates {
  ChildModel childModel;
  AddChildState(this.childModel);
}
class ChangeChildState extends HomeStates {}
class AddToNameState extends HomeStates {
  ChildExpensesChangingModel child;
  ChildModel childModel;
  AddToNameState(this.child, this.childModel);
}
class RemoveChildState extends HomeStates {}
class ChangeStickerState extends HomeStates {}
class ChangeChildStickerState extends HomeStates {}
class ChangeAddChildCurrencyState extends HomeStates {}
class ChangeChildCurrencyState extends HomeStates {}
class UpdateDescriptionState extends HomeStates {}
