import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elmasroof/cubit/home_cubit/home_cubit.dart';
import 'package:elmasroof/cubit/home_cubit/home_states.dart';
import 'package:elmasroof/layouts/alerts/add_description_alert.dart';
import 'package:elmasroof/layouts/alerts/choose_currency_alert.dart';
import 'package:elmasroof/layouts/alerts/choose_sticker_alert.dart';
import 'package:elmasroof/layouts/alerts/remove_alert.dart';
import 'package:elmasroof/layouts/alerts/success_dialog.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/modules/history_screen.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/components/value_listenable.dart';
import 'package:elmasroof/shared/constants/const_asset_images.dart';
import 'package:elmasroof/shared/constants/const_asset_sounds.dart';
import 'package:elmasroof/shared/enum/reward.dart';
import 'package:elmasroof/shared/formatter/decimal_formatter.dart';
import 'package:elmasroof/shared/formatter/positive_formatter.dart';
import 'package:elmasroof/shared/network/local/hive/hive_storage.dart';
import 'package:elmasroof/shared/network/local/sqflite/sqflite_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, });


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _expensesChangeController = TextEditingController()
    ..text = '0';
  final GlobalKey<FormFieldState> _expensesChangeKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController initExpensesController = TextEditingController()..text = '0';
  GlobalKey<FormFieldState> nameKey = GlobalKey();
  GlobalKey<FormFieldState> initExpensesKey = GlobalKey();
  FocusNode nameNode = FocusNode();
  FocusNode initExpensesNode = FocusNode();
  late HiveStorage hiveStorage = HiveStorage();
  late HomeCubit _cubit;
  final _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context: context),
      body: SingleChildScrollView(
        child: BlocConsumer<HomeCubit, HomeStates>(
          listener: (_context, state) => _handleStates(_context, state),
          builder: (context, state) {
            _cubit = HomeCubit.get(context);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _childrenSlider(),
                if(_cubit.selectedIndex == _cubit.childrenNames.length)
                  _addChildPage(context),
                if(_cubit.selectedIndex < _cubit.childrenNames.length)
                  _childPage(context),
              ]
            );
          },
        ),
      ),
    );
  }

  Widget _childrenSlider() => CarouselSlider(
    options: CarouselOptions(
      height: 200.0,
      enableInfiniteScroll: false,
      onPageChanged: (index, reason) {
        _cubit.changeChild(index);
      },
    ),
    items: _cubit.childrenNames.map((name) {
      return childrenCard(name, false);
    }).toList() + [ childrenCard('إضافة\nإبن/بنت\n+', true), ],
  );

  Widget childrenCard(String name, bool isAddCard) {
    var child = _cubit.hiveStorage.get(name);
    return Card.outlined(
      color: isAddCard ? null : Colors.lightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: isAddCard
            ? BorderSide(color: Colors.lightBlue, width: 2,)
            : BorderSide.none,
      ),
      margin: EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(!isAddCard)
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                        onPressed: () => null,
                        icon: Icon(Icons.add, color: Colors.lightBlue,)
                    ),
                  ),
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: IconButton(
                        onPressed: () => null,
                        icon: Icon(Icons.not_interested, color: Colors.white,)
                    ),
                  ),
                ],
              ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(!isAddCard)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onLongPress: () =>
                            showChooseStickerAlert(
                            context: context, onChoose: (index) =>
                            _cubit.changeChildSticker(index)),
                        child: Container(
                          decoration: ShapeDecoration(shape: CircleBorder(
                              side: BorderSide(color: Colors.white, width: 2)),
                              color: Colors.white12),
                          padding: const EdgeInsets.all(16.0),
                          child: SvgPicture.asset(child!.stickerPath, fit: BoxFit.contain,
                            width: 40,
                            height: 40,),
                        ),
                      ),
                    ),
                  Text(
                    name, textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold,),
                  ),
                ],
              ),
            ),
            if(!isAddCard)
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Tooltip(
                        message: Reward.master.name,
                        triggerMode: TooltipTriggerMode.longPress,
                        waitDuration: const Duration(milliseconds: 500),
                        showDuration: const Duration(seconds: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        preferBelow: false,
                        child: SvgPicture.asset(
                          Reward.master.iconPath,
                          colorFilter: (child!.rewards[Reward.master]?.$2 ?? false)
                              ? null
                              : ColorFilter.mode(Colors.grey.withAlpha(200), BlendMode.srcIn),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 3.0,
                          mainAxisSpacing: 2.0,
                          children: Reward.values.map((reward) =>
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Tooltip(
                                  message: reward.name,
                                  triggerMode: TooltipTriggerMode.longPress,
                                  waitDuration: const Duration(milliseconds: 500),
                                  showDuration: const Duration(seconds: 2),
                                  preferBelow: false,
                                  child: SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: SvgPicture.asset(
                                      reward.iconPath,
                                      colorFilter: (child.rewards[reward]?.$2 ?? false)
                                          ? null
                                          : ColorFilter.mode(Colors.grey.withAlpha(200), BlendMode.srcIn),
                                    ),
                                  ),
                                ),
                              ),
                          ).toList()..removeLast(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _addChildPage(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20,),
        const Text('أضف ملصقاً جديداً', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        _createStickerButton(),
        _createChildNameField(),
        _createSavingsField(),
        createButton(
          text: 'إضافة',
          onPressed: () => _addChild(
            context: context,
          ),
          icon: Icons.add,
        ),
      ],
    ),
  );

  void _addChild({
    required BuildContext context,
  }){
    if(nameKey.currentState!.validate() && initExpensesKey.currentState!.validate()) {
      double value = double.parse(initExpensesController.text);
      _cubit.addChild(
          nameController.text,
          ChildModel(
            name: nameController.text,
            expenses: {_cubit.addChildCurrency: value},
            stickerPath: _cubit.stickerPath,
            increment: {},
            rewards: {},
          )
      );
    }
  }

  Widget _childPage(BuildContext context) => Column(
    children: [
      _createCoinsBank(),
      _createTransactionsHistoryButton(context),
      const SizedBox(height: 5,),
      _createRemoveChildButton(context),
    ],
  );

  void _handleStates(BuildContext context, HomeStates state) {
    if(state is AddChildState) {
      nameController.text = '';
      initExpensesController.text = '0';
      showSuccessDialog(context: context, message: 'تمت الإضافة بنجاح');
    } else if(state is RemoveChildState) {
      showSuccessDialog(context: context, message: 'تم الحذف بنجاح');
    } else if(state is AddToNameState) {
      showAddDescriptionAlert(
        context: context,
        onUpdateDescription: (id, description) => _cubit.updateDescriptionOfTransaction(id, description),
        child: state.child,
      );
    }
  }

  Widget _createStickerButton() => GestureDetector(
    onTap: () => showChooseStickerAlert(context: context, onChoose: (index) => _cubit.changeSticker(index)),
    child: Container(
      decoration: ShapeDecoration(shape: CircleBorder(), color: Colors.grey.shade300),
      padding: const EdgeInsets.all(20.0),
      child: SvgPicture.asset(_cubit.stickerPath, fit: BoxFit.contain, width: 40, height: 40,),
    ),
  );

  Widget _createChildNameField() => createTextField(
      title: 'إسم الإبن/البنت',
      hint: 'أدخل الإسم',
      controller: nameController,
      formKey: nameKey,
      node: nameNode,
      action: TextInputAction.next,
      suffixIcon: Icons.person,
      validator: (String value){
        if(value.isEmpty) {
          return 'أدخل الإسم أولاً';
        }
        return null;
      },
      submit: (String value){
        if(nameKey.currentState!.validate()) {
          FocusScope.of(context).requestFocus(initExpensesNode);
        }
      }
  );

  Widget _createSavingsField() => createTextField(
      title: 'يملك الآن:',
      hint: 'أدخل المبلغ',
      controller: initExpensesController,
      formKey: initExpensesKey,
      node: initExpensesNode,
      inputType: TextInputType.number,
      formatter: DecimalFormatter(),
      submit: (value) => _addChild(context: context),
      prefixWidget: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundColor: Colors.black12,
            child: SvgPicture.asset(_cubit.addChildCurrency.icon),
          ),
        ),
        onTap: () => showChooseCurrencyAlert(
          context: context,
          onChoose: (currency) => _cubit.changeAddChildCurrency(currency),
        ),
      ),
      validator: (String value){
        if(value.isEmpty) {
          return 'يجب إدخال المبلغ';
        }
        if(!DecimalFormatter().patternFormatter().hasMatch(value)){
          return 'أدخل الرقم أولاً';
        }
        return null;
      }
  );

  Widget _createCoinsBank() => Stack(
    alignment: AlignmentGeometry.center,
    children: [
      Padding(
        padding: EdgeInsets.all(24.0),
        child: SvgPicture.asset(
          ConstAssetImages.coinsBank.path,
          fit: BoxFit.fill,
        ),
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 60,),
          createTitle(title: 'المبلغ الحالى', titleSize: 18, color: Colors.white),
          _createExpensesText(),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _decreaseButton(),
              _changedValueText(),
              _increaseButton(),
            ],
          ),
        ],
      ),
    ],
  );

  Widget _createExpensesText() => Container(
    width: 140,
    height: 35,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: Colors.grey,
    ),
    child: Row(
      children: [
        InkWell(
          child: CircleAvatar(
            child: SvgPicture.asset(_cubit.childCurrency.icon),
            backgroundColor: Colors.black12,
          ),
          onTap: () => showChooseCurrencyAlert(
            context: context,
            onChoose: (currency) => _cubit.changeChildCurrency(currency),
          ),
        ),
        Spacer(),
        ValueListenableBuilder(
            valueListenable: ListenOnValue.expensesNotifier,
            builder: (context, value, child) {
              return Text(
                (hiveStorage.get(_cubit.childrenNames[_cubit.selectedIndex])?.expenses[_cubit.childCurrency] ?? 0.0).toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              );
            }
        ),
        Spacer(),
      ],
    ),
  );

  Widget _changeExpensesButton({
    required IconData icon,
    required bool isPositive,
  }) => IconButton(
    padding: const EdgeInsets.all(4),
    onPressed: () async {
      if(_expensesChangeKey.currentState!.validate()) {
        if(_expensesChangeController.text.isEmpty || _expensesChangeController.text == '0'){
          _expensesChangeController.text = '0';
          showDialog(context: context,
              builder: (context) => AlertDialog(title: Text('أدخل الرقم أولاً'), icon: Icon(Icons.error_outline, color: Colors.black, size: 80,),)
          );
          return;
        }
        if(!PositiveFormatter().patternFormatter().hasMatch(_expensesChangeController.text)) {
          showDialog(context: context,
              builder: (context) => AlertDialog(title: Text('أدخل رقم صحيح'), icon: Icon(Icons.error_outline, color: Colors.black, size: 80,),)
          );
          return;
        }
        double value = double.parse(_expensesChangeController.text);
        _expensesChangeController.text = '0';
        await _audioPlayer.setVolume(0.2);
        await _audioPlayer.play(AssetSource((isPositive) ? ConstAssetSounds.increaseMoney.path : ConstAssetSounds.decreaseMoney.path));
        _cubit.addToName(_cubit.childCurrency, (isPositive) ? value : -value);
      }
    },
    icon: CircleAvatar(
      backgroundColor: Colors.lightBlue,
      child: Icon(
        icon,
        color: Colors.white,
      ),
    ),
  );

  Widget _decreaseButton() => _changeExpensesButton(
    icon: Icons.remove,
    isPositive: false
  );

  Widget _increaseButton() => _changeExpensesButton(
      icon: Icons.add,
      isPositive: true
  );

  Widget _changedValueText() => createTextField(
    width: 80,
    paddingHorizontal: 0,
    backgroundColor: Colors.white.withAlpha(210),
    controller: _expensesChangeController,
    formKey: _expensesChangeKey,
    alignment: TextAlign.center,
    inputType: TextInputType.number,
    formatter: PositiveFormatter(),
  );

  Widget _createTransactionsHistoryButton(BuildContext context) => createButton(
    text: 'سجل المعاملات',
    onPressed: () {
      String name = _cubit.childrenNames[_cubit.selectedIndex];
      SqfliteDB().getChildTransactions(name)
          .then((list) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HistoryScreen(
              name: name,
              transactionList: list,
            ),
          )
      ).catchError((e) => print(e.toString()))
      );
    },
    icon: Icons.date_range,
  );

  Widget _createRemoveChildButton(BuildContext context) => createButton(
    text: 'حذف',
    backgroundColor: Colors.redAccent,
    onPressed: () {
      showRemoveAlert(
          context: context,
          onSuccess: () => _cubit.removeChild()
      );
    },
    icon: Icons.delete_outline,
  );
}
