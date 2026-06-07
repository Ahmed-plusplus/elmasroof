import 'package:elmasroof/models/child_expenses_changing_model.dart';
import 'package:elmasroof/shared/enum/currency.dart';
import 'package:elmasroof/shared/network/local/sqflite/transaction_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDB {
  static late Database _database;
  static const String _DATABAS_NAME = 'Elmasroof.db';

  static Future<Database> createDB() async => _database = await openDatabase(
      join(await getDatabasesPath(), _DATABAS_NAME),
      version: 3,
      onCreate: (database, version) async {
        try {
          await database.execute(_createOperationTable());
        } catch (e) {
          print(e.toString());
        }
      },
      onOpen: (database) {},
      onUpgrade: (database, oldVersion, newVersion) async {
        if(oldVersion <= 2){
          try {
            await database.execute('DROP TABLE IF EXISTS ${TransactionConstants.TRANSACTION_TABLE}');
            await database.execute(_createOperationTable());
          } catch (e) {
            print(e.toString());
          }
        }
      },
    );

  static String _createOperationTable() {
    return 'CREATE TABLE ${TransactionConstants.TRANSACTION_TABLE} ('
        '${TransactionConstants.ID_ATTR} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${TransactionConstants.NAME_ATTR} TEXT,'
        '${TransactionConstants.CURRENCY_ATTR} TEXT,'
        '${TransactionConstants.AMOUNT_ATTR} REAL,'
        '${TransactionConstants.DATE_ATTR} INTEGER,'
        '${TransactionConstants.DESCRIPTION_ATTR} TEXT,'
        '${TransactionConstants.TOTAL_AMOUNT_ATTR} REAL'
        ')';
  }

  Future<List<Map<String, dynamic>>> getData(String query, List<Object?> args) async {
    return await _database.rawQuery(query, args);
  }

  void insertChildData(ChildExpensesChangingModel child) {
    _database.transaction((txn) {
      return txn
          .rawInsert('INSERT INTO ${TransactionConstants.TRANSACTION_TABLE} ('
              '${TransactionConstants.NAME_ATTR},'
              '${TransactionConstants.CURRENCY_ATTR},'
              '${TransactionConstants.AMOUNT_ATTR},'
              '${TransactionConstants.DATE_ATTR},'
              '${TransactionConstants.DESCRIPTION_ATTR},'
              '${TransactionConstants.TOTAL_AMOUNT_ATTR}'
              ') VALUES ('
              '"${child.name}",'
              '"${child.expenses.$1.name}",'
              '${child.expenses.$2},'
              '${child.dateTime!.millisecondsSinceEpoch},'
              '"${child.description}",'
              '${child.total.$2}'
              ')')
          .then((value) {})
          .catchError((error) => print(error.toString()));
    });
  }

  Future<List<ChildExpensesChangingModel>> getChildTransactions(String name) async {
    List<Map<String, dynamic>> list = await getData(
        'SELECT * FROM "${TransactionConstants.TRANSACTION_TABLE}" WHERE ${TransactionConstants.NAME_ATTR} = ?',
        [name],
    );
    return list.reversed
        .map(
          (map) => ChildExpensesChangingModel(
            id: map[TransactionConstants.ID_ATTR],
            name: map[TransactionConstants.NAME_ATTR],
            expenses: (Currency.values.where((currency) => currency.name == map[TransactionConstants.CURRENCY_ATTR]).first, map[TransactionConstants.AMOUNT_ATTR]),
            dateTime: DateTime.fromMillisecondsSinceEpoch(map[TransactionConstants.DATE_ATTR]),
            description: map[TransactionConstants.DESCRIPTION_ATTR],
            total: (Currency.values.where((currency) => currency.name == map[TransactionConstants.CURRENCY_ATTR]).first, map[TransactionConstants.TOTAL_AMOUNT_ATTR]),
          ),
        )
        .toList();
  }

  Future<int> updateDescription(int id, String description) async {
    return await _database.rawUpdate(
      'UPDATE ${TransactionConstants.TRANSACTION_TABLE} SET ${TransactionConstants.DESCRIPTION_ATTR} = ? WHERE ${TransactionConstants.ID_ATTR} = ?',
      [description, id],
    );
  }

  Future<int> removeChild(String name) async {
    return await _database.rawDelete(
      'DELETE FROM ${TransactionConstants.TRANSACTION_TABLE} WHERE ${TransactionConstants.NAME_ATTR} = ?',
      [name],
    );
  }
}
