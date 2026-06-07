import 'package:carousel_slider/carousel_slider.dart';
import 'package:elmasroof/cubit/home_cubit/home_cubit.dart';
import 'package:elmasroof/cubit/home_cubit/home_states.dart';
import 'package:elmasroof/layouts/alerts/add_child_alert.dart';
import 'package:elmasroof/layouts/alerts/change_sticker_alert.dart';
import 'package:elmasroof/models/child_model.dart';
import 'package:elmasroof/modules/history_screen.dart';
import 'package:elmasroof/shared/components/components.dart';
import 'package:elmasroof/shared/components/value_listenable.dart';
import 'package:elmasroof/shared/constants/const_asset_images.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context: context),
      body: SingleChildScrollView(
        child: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            _cubit = HomeCubit.get(context);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                childrenSlider(),
                if(_cubit.selectedIndex == _cubit.childrenNames.length)
                  addChildPage(context),
                if(_cubit.selectedIndex < _cubit.childrenNames.length)
                  childPage(context),
              ]
            );
          },
        ),
      ),
    );
  }

  Widget oldDesign() => Column(
      children: (_cubit.childrenNames.isNotEmpty) ? [
        createButton(
          text: 'إضافة إبن/بنت',
          onPressed: () =>
              showAddChildAlert(context: context, cubit: _cubit),
          icon: Icons.add,
        ),
        const SizedBox(
          height: 5,
        ),
        Image.asset(ConstAssetImages.saveMoney.path),
        Stack(
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
                SizedBox(height: 10,),
                DropdownMenu(
                  dropdownMenuEntries: List.generate(
                    _cubit.childrenNames.length,
                        (index) => DropdownMenuEntry(
                      value: index,
                      label: _cubit.childrenNames[index],
                    ),
                  ),
                  initialSelection: _cubit.selectedIndex,
                  onSelected: (index) {
                    _cubit.changeChild(index!);
                  },
                  controller: TextEditingController()..text = _cubit.childrenNames[_cubit.selectedIndex],
                  menuStyle: const MenuStyle(
                    backgroundColor:
                    WidgetStatePropertyAll(Colors.white),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  textAlign: TextAlign.end,
                ),
                SizedBox(height: 70,),
                createTitle(title: 'المبلغ الحالى', titleSize: 18, color: Colors.white),
                Container(
                  width: 140,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey,
                  ),
                  child: ValueListenableBuilder(
                      valueListenable: ListenOnValue.expensesNotifier,
                      builder: (context, value, child) {
                        return Text(
                          (hiveStorage.get(_cubit.childrenNames[_cubit.selectedIndex]) ?? 0.0).toString(),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        );
                      }
                  ),
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(4),
                      onPressed: () {
                        if(_expensesChangeKey.currentState!.validate()) {
                          double value = double.parse(_expensesChangeController.text);
                          _expensesChangeController.text = '0';
                          _cubit.addToName(-value);
                        }
                      },
                      icon: const CircleAvatar(
                        backgroundColor: Colors.lightBlue,
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    createTextField(
                        width: 80,
                        paddingHorizontal: 0,
                        backgroundColor: Colors.grey,
                        controller: _expensesChangeController,
                        formKey: _expensesChangeKey,
                        alignment: TextAlign.center,
                        inputType: TextInputType.number,
                        formatter: PositiveFormatter(),
                        validator: (String value){
                          if(value.isEmpty){
                            return 'أدخل الرقم أولاً';
                          }
                          if(!PositiveFormatter().patternFormatter().hasMatch(value)) {
                            return 'أدخل رقم صحيح';
                          }
                          return null;
                        }
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(4),
                      onPressed: () {
                        if(_expensesChangeKey.currentState!.validate()) {
                          double value = double.parse(_expensesChangeController.text);
                          _expensesChangeController.text = '0';
                          _cubit.addToName(value);
                        }
                      },
                      icon: const CircleAvatar(
                        backgroundColor: Colors.lightBlue,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                createButton(
                  text: 'تاريخ المعاملات',
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
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        createButton(
          text: 'حذف',
          onPressed: () {
            _cubit.removeChild();
          },
          icon: Icons.delete_outline,
        ),
      ] : [
        Image.asset(ConstAssetImages.richChildren.path),
        const SizedBox(
          height: 25,
        ),
        createButton(
          text: 'إضافة إبن/بنت',
          onPressed: () =>
              showAddChildAlert(context: context, cubit: _cubit),
          icon: Icons.add,
        ),
      ],
    );

  Widget childrenSlider() => CarouselSlider(
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

  Widget childrenCard(String name, bool isAddCard) => Card.outlined(
    color: isAddCard ? null : Colors.lightBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: isAddCard ? BorderSide(
        color: Colors.lightBlue,
        width: 2,
      ) : BorderSide.none,
    ),
    margin: EdgeInsets.all(24),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(!isAddCard)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onLongPress: () => showChangeStickerAlert(context: context, onChoose: (index) => _cubit.changeChildSticker(index)),
                child: Container(
                  decoration: ShapeDecoration(shape: CircleBorder(side: BorderSide(color: Colors.white, width: 2)), color: Colors.white12),
                  padding: const EdgeInsets.all(16.0),
                  child: SvgPicture.asset(_cubit.hiveStorage.get(name)!.stickerPath, fit: BoxFit.contain, width: 40, height: 40,),
                ),
              ),
            ),
          Text(
            name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  Widget addChildPage(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20,),
        const Text('أضف ملصقاً جديداً', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        GestureDetector(
          onTap: () => showChangeStickerAlert(context: context, onChoose: (index) => _cubit.changeSticker(index)),
          child: Container(
            decoration: ShapeDecoration(shape: CircleBorder(), color: Colors.grey.shade300),
            padding: const EdgeInsets.all(20.0),
            child: SvgPicture.asset(_cubit.stickerPath, fit: BoxFit.contain, width: 40, height: 40,),
          ),
        ),
        createTextField(
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
        ),
        createTextField(
            title: 'يملك الآن:',
            hint: 'أدخل المبلغ',
            controller: initExpensesController,
            formKey: initExpensesKey,
            node: initExpensesNode,
            inputType: TextInputType.number,
            formatter: DecimalFormatter(),
            submit: (value) => _addChild(context: context),
            prefixIcon: Icons.currency_pound,
            validator: (String value){
              if(value.isEmpty) {
                return 'يجب إدخال المبلغ';
              }
              if(!DecimalFormatter().patternFormatter().hasMatch(value)){
                return 'أدخل الرقم أولاً';
              }
              return null;
            }
        ),
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
      _cubit.addChild(nameController.text, ChildModel(name: nameController.text, expenses: value, stickerPath: _cubit.stickerPath));
    }
  }

  Widget childPage(BuildContext context) => Column(
    children: [
      Stack(
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
              Container(
                width: 140,
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey,
                ),
                child: ValueListenableBuilder(
                    valueListenable: ListenOnValue.expensesNotifier,
                    builder: (context, value, child) {
                      return Text(
                        (hiveStorage.get(_cubit.childrenNames[_cubit.selectedIndex])?.expenses ?? 0.0).toString(),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      );
                    }
                ),
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(4),
                    onPressed: () {
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
                        _cubit.addToName(-value);
                      }
                    },
                    icon: const CircleAvatar(
                      backgroundColor: Colors.lightBlue,
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  createTextField(
                      width: 80,
                      paddingHorizontal: 0,
                      backgroundColor: Colors.white.withAlpha(210),
                      controller: _expensesChangeController,
                      formKey: _expensesChangeKey,
                      alignment: TextAlign.center,
                      inputType: TextInputType.number,
                      formatter: PositiveFormatter(),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(4),
                    onPressed: () {
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
                        _cubit.addToName(value);
                      }
                    },
                    icon: const CircleAvatar(
                      backgroundColor: Colors.lightBlue,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      createButton(
        text: 'تاريخ المعاملات',
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
      ),
      const SizedBox(
        height: 5,
      ),
      createButton(
        text: 'حذف',
        onPressed: () {
          _cubit.removeChild();
        },
        icon: Icons.delete_outline,
      ),
    ],
  );
}
