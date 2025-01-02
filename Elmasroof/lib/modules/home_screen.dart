import 'package:elmasroof/layouts/alerts/add_child_alert.dart';
import 'package:elmasroof/modules/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Box<dynamic> _box;
  List<dynamic> _childrenNames = [];
  TextEditingController _expensesChangeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Hive.openBox('Elmasroof').then((box) {
      setState(() {
        _box = box;
        _childrenNames.addAll(_box.toMap().keys);
      });
    });
    _expensesChangeController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El masroof'),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: (){
                showAddChildAlert(context: context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white,),
                    SizedBox(width: 3,),
                    Text('اضافة ابن/بنت', style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
            ),
            if(_childrenNames.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 25,),
                  DropdownMenu(
                    dropdownMenuEntries: List.generate(_childrenNames.length,
                          (index) => DropdownMenuEntry(
                              value: _childrenNames[index], label: _childrenNames[index]
                          )
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(_box.get(_childrenNames[0])!),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      IconButton(onPressed: (){}, icon: const Icon(Icons.remove),),
                      const SizedBox(width: 5,),
                      TextFormField(
                        controller: _expensesChangeController,
                      ),
                      const SizedBox(width: 5,),
                      IconButton(onPressed: (){}, icon: const Icon(Icons.add),),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  TextButton(onPressed: (){}, child: Text('تاريخ المعاملات')),
                  const SizedBox(height: 5,),
                  TextButton(onPressed: (){}, child: Row(
                    children: [
                      Icon(Icons.delete_outline),
                      Text('حذف'),
                    ],
                  )),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
