// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/product.dart';

// class DBHelper {
//   static Database? _db;

//   Future<Database> get db async {
//     return _db ??= await initDB();
//   }

//   Future<Database> initDB() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'epos.db');

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//   CREATE TABLE products (
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     name TEXT,
//     price REAL,
//     isVat INTEGER,
//     category TEXT
//   )
// ''');

// // Full Grill Corner Menu
// await db.insert('products', {'name': 'Chicken Tikka on Naan', 'price': 8.99, 'isVat': 1, 'category': 'Grill'});
// await db.insert('products', {'name': 'Chicken Seekh on Naan (2Pcs)', 'price': 4.49, 'isVat': 1, 'category': 'Grill'});
// await db.insert('products', {'name': 'Tray of Donner Meat (Large)', 'price': 4.99, 'isVat': 1, 'category': 'Grill'});
// await db.insert('products', {'name': 'Grilled Donner on Naan/Fries', 'price': 6.49, 'isVat': 1, 'category': 'Grill'});
// await db.insert('products', {'name': 'Chicken Tikka Pieces (8Pcs)', 'price': 6.99, 'isVat': 1, 'category': 'Grill'});
// await db.insert('products', {'name': 'Donner & Seekh Mix on Naan/Fries', 'price': 6.99, 'isVat': 1, 'category': 'Grill'});

// await db.insert('products', {'name': 'Mint Sauce', 'price': 0.00, 'isVat': 0, 'category': 'Dips'});
// await db.insert('products', {'name': 'Garlic Mayo', 'price': 0.00, 'isVat': 0, 'category': 'Dips'});
// await db.insert('products', {'name': 'Peri Peri Sauce', 'price': 0.40, 'isVat': 0, 'category': 'Dips'});
// await db.insert('products', {'name': 'BBQ Sauce', 'price': 0.00, 'isVat': 0, 'category': 'Dips'});

// await db.insert('products', {'name': 'Pepsi Can', 'price': 1.00, 'isVat': 0, 'category': 'Drinks'});
// await db.insert('products', {'name': 'Fruit Shoot', 'price': 1.00, 'isVat': 0, 'category': 'Drinks'});
// await db.insert('products', {'name': 'Rubicon Mango', 'price': 1.25, 'isVat': 0, 'category': 'Drinks'});
// await db.insert('products', {'name': 'Tango Orange Can', 'price': 1.25, 'isVat': 0, 'category': 'Drinks'});
// await db.insert('products', {'name': 'San Pellegrino Lemon', 'price': 1.50, 'isVat': 0, 'category': 'Drinks'});

// await db.insert('products', {'name': 'Cheese & Tomato 12"', 'price': 8.49, 'isVat': 1, 'category': 'Pizza'});
// await db.insert('products', {'name': 'Vegetarian Supreme 12"', 'price': 9.99, 'isVat': 1, 'category': 'Pizza'});
// await db.insert('products', {'name': 'Hot & Spicy 12"', 'price': 10.99, 'isVat': 1, 'category': 'Pizza'});
// await db.insert('products', {'name': 'Meat Feast 12"', 'price': 11.99, 'isVat': 1, 'category': 'Pizza'});
// await db.insert('products', {'name': 'BBQ Deluxe 12"', 'price': 11.09, 'isVat': 1, 'category': 'Pizza'});

// await db.insert('products', {'name': 'Chicken Tikka Wrap', 'price': 4.99, 'isVat': 1, 'category': 'Wraps'});
// await db.insert('products', {'name': 'Grilled Peri Peri Wrap', 'price': 4.99, 'isVat': 1, 'category': 'Wraps'});
// await db.insert('products', {'name': 'Donner Wrap', 'price': 4.49, 'isVat': 1, 'category': 'Wraps'});

// await db.insert('products', {'name': 'Classic Fried Chicken Burger', 'price': 2.99, 'isVat': 1, 'category': 'Burger'});
// await db.insert('products', {'name': 'Zinger Fried Burger', 'price': 4.49, 'isVat': 1, 'category': 'Burger'});
// await db.insert('products', {'name': 'Double Cheese Burger', 'price': 5.49, 'isVat': 1, 'category': 'Burger'});
// await db.insert('products', {'name': 'Veggie Burger', 'price': 4.49, 'isVat': 1, 'category': 'Burger'});

// await db.insert('products', {'name': 'Peri Peri Wings (5pcs)', 'price': 4.99, 'isVat': 1, 'category': 'Wings'});
// await db.insert('products', {'name': 'Buffalo Wings (5pcs)', 'price': 4.99, 'isVat': 1, 'category': 'Wings'});
// await db.insert('products', {'name': 'Fried Chicken Wings (5pcs)', 'price': 4.99, 'isVat': 1, 'category': 'Wings'});

// await db.insert('products', {'name': '9" Pizza Meal', 'price': 7.99, 'isVat': 1, 'category': 'Meals'});
// await db.insert('products', {'name': 'Chicken Wrap Meal', 'price': 5.99, 'isVat': 1, 'category': 'Meals'});
// await db.insert('products', {'name': 'Chicken Nuggets Meal', 'price': 5.99, 'isVat': 1, 'category': 'Meals'});

// await db.insert('products', {'name': 'Ferrero Rocher Milkshake', 'price': 5.49, 'isVat': 0, 'category': 'Milkshakes'});
// await db.insert('products', {'name': 'Nutella Milkshake', 'price': 5.49, 'isVat': 0, 'category': 'Milkshakes'});
// await db.insert('products', {'name': 'Bubblegum Milkshake', 'price': 5.49, 'isVat': 0, 'category': 'Milkshakes'});

// await db.insert('products', {'name': 'Oreo Cake', 'price': 2.49, 'isVat': 0, 'category': 'Cakes'});
// await db.insert('products', {'name': 'Rainbow Cake', 'price': 2.49, 'isVat': 0, 'category': 'Cakes'});
// await db.insert('products', {'name': 'Apple Pie', 'price': 1.99, 'isVat': 0, 'category': 'Cakes'});

// await db.insert('products', {'name': 'Family Offer 1', 'price': 26.99, 'isVat': 1, 'category': 'Offers'});
// await db.insert('products', {'name': 'Family Offer 2', 'price': 32.99, 'isVat': 1, 'category': 'Offers'});

//         await db.execute('''
//   CREATE TABLE orders (
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     items TEXT,
//     total REAL,
//     vat REAL,
//     net REAL,
//     date TEXT
//   )
// ''');

//         // Add more as needed
//       },
//     );
//   }

// Future<List<Product>> getProducts() async {
//   final dbClient = await db;
//   final maps = await dbClient.query('products');
//   return maps.map((e) => Product(
//     id: e['id'] as int,
//     name: e['name'] as String,
//     price: e['price'] as double,
//     isVat: e['isVat'] == 1,
//     category: e['category'] as String,
//   )).toList();
// }
// Future<void> saveOrder(String items, double total, double vat, double net, String date) async {
//   final dbClient = await db;
//   await dbClient.insert('orders', {
//     'items': items,
//     'total': total,
//     'vat': vat,
//     'net': net,
//     'date': date,
//   });
// }

// Future<List<Map<String, dynamic>>> getOrders() async {
//   final dbClient = await db;
//   return await dbClient.query('orders', orderBy: 'id DESC');
// }


// }


import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/customer.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    return _db ??= await initDB();
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'epos.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL,
            isVat INTEGER,
            category TEXT
          )
        ''');

        await db.execute('''
        CREATE TABLE orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  items TEXT,
  total REAL,
  vat REAL,
  net REAL,
  date TEXT,
  orderType TEXT,
  paymentMethod TEXT,
  address TEXT
)


        ''');

        await db.execute('''
          CREATE TABLE customers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            phone TEXT UNIQUE,
            name TEXT,
            address TEXT,
            postcode TEXT,
            notes TEXT
          )
        ''');
        // Customer Database
        await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '01204465283',
  'address': '£1 DELIVERY TIP 29 Taywood Road',
  'postcode': 'BL1 5HB'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07562591416',
  'address': '1 Alberta Street',
  'postcode': 'BL3 4SJ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07880274434',
  'address': '1 Forfar Street',
  'postcode': 'BL3 5JD'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07596160048',
  'address': '1 Forfar Street',
  'postcode': 'BL1 6RN'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07368657761',
  'address': '1 Glencoyne Drive',
  'postcode': 'BL1 7DP'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07490571632',
  'address': '1 Orchard Avenue',
  'postcode': 'BL1 8PZ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07555635522',
  'address': '1 Orchard Avenue',
  'postcode': 'BL1 8PZ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07917914401',
  'address': '1 Ornatus Street',
  'postcode': 'BL1 8GQ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07429143367',
  'address': '1 Stonyhurst Avenue',
  'postcode': 'BL1 7ES'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07564975202',
  'address': '1 Stonyhurst Avenue',
  'postcode': 'BL1 7ES'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '01204480034',
  'address': '1 Whitehill Lane',
  'postcode': 'BL1 7DS'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07361537822',
  'address': '1 Wilton Road',
  'postcode': 'BL1 6RS'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07565343174',
  'address': '1 Windermere Street',
  'postcode': 'BL1 8LS'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07404474121',
  'address': '10 41 DAWSON HOUSE Chapeltown Road',
  'postcode': 'BL7 9LY'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07708039421',
  'address': '10 Barnston Close',
  'postcode': 'BL1 8TF'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07890175460',
  'address': '10 Belmont View',
  'postcode': 'BL2 3QJ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '747474747474',
  'address': '10 Bowland Drive',
  'postcode': 'BL1 5TX'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07869837406',
  'address': '10 Cottingley Close',
  'postcode': 'BL1 7BF'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '88',
  'address': '10 Cressingham Road',
  'postcode': 'BL3 4QT'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07857350575',
  'address': '10 Masbury Close',
  'postcode': 'BL1 7LU'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07988822967',
  'address': '10 Masbury Close',
  'postcode': 'BL1 7LU'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07541185845',
  'address': '10 Norton Street',
  'postcode': 'BL1 8PN'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07926537527',
  'address': '10 Ollerton Street',
  'postcode': 'BL1 7JU'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07310243641',
  'address': '10 Rushlake Drive',
  'postcode': 'BL3 1RL'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07803250891',
  'address': '10 Silverdale Road',
  'postcode': 'BL1 4RR'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07799818510',
  'address': '10 Thorns Close',
  'postcode': 'BL1 6PE'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07538938680',
  'address': '102 Cotton Meadows',
  'postcode': 'BL1 8GA'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07427509155',
  'address': '103 Cloister Street',
  'postcode': 'BL1 3HA'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07867068463',
  'address': '105 Athlone Avenue',
  'postcode': 'BL1 6QZ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07906821813',
  'address': '105 Tetbury Drive',
  'postcode': 'BL2 5NR'
});
await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07999975180',
  'address': '107 Wilkinson Road',
  'postcode': 'BL1 7BE'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07713497649',
  'address': '109 Mackenzie Street',
  'postcode': 'BL1 6RH'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07522140854',
  'address': '109 Wilkinson Road',
  'postcode': 'BL1 7BE'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07714419915',
  'address': '11 Amblethorn Drive',
  'postcode': 'BL1 7BP'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07548014808',
  'address': '11 Chapelfield Street',
  'postcode': 'BL1 8ER'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07565742099',
  'address': '11 Glaisdale Street',
  'postcode': 'BL2 2JX'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07446940884',
  'address': '11 Old Road',
  'postcode': 'BL1 6NJ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07833227983',
  'address': '11 Orchard Avenue',
  'postcode': 'BL1 8PZ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07903184578',
  'address': '11 Orchard Avenue',
  'postcode': 'BL1 8PZ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07985231964',
  'address': '110 Ramwells Brow',
  'postcode': 'BL7 9LQ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07931170668',
  'address': '12 Castle Croft',
  'postcode': 'BL2 3QT'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07739920614',
  'address': '12 Dimple Park',
  'postcode': 'BL7 9QE'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07407409347',
  'address': '12 Forfar Street',
  'postcode': 'BL1 6RN'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07539956106',
  'address': '12 Longden Street',
  'postcode': 'BL1 4HT'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07586086765',
  'address': '12 Moss Bank Close',
  'postcode': 'BL1 6PH'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07436965208',
  'address': '15 LINWOOD HOUSE Seymour Road',
  'postcode': 'BL1 8JW'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07387231362',
  'address': '15 Nevis Grove',
  'postcode': 'BL1 6RP'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07908418854',
  'address': '15 Newbury Walk',
  'postcode': 'BL1 2XL'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07967491279',
  'address': '15 Thorns Close',
  'postcode': 'BL1 6PE'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07778262960',
  'address': '15 Tillington Close',
  'postcode': 'BL1 8XD'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07706541614',
  'address': '15 Tong Head Avenue',
  'postcode': 'BL1 8SZ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07889921338',
  'address': '16 Dales Brow',
  'postcode': 'BL1 7RU'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07894705455',
  'address': '16 Dales Brow',
  'postcode': 'BL1 7RU'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07391532367',
  'address': '16 Dearncamme Close',
  'postcode': 'BL2 3FT'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07511116871',
  'address': '16 Highgrove Close',
  'postcode': 'BL1 8QE'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07488242671',
  'address': '16 Redcar Road',
  'postcode': 'BL1 6LG'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07796649608',
  'address': '169 Darwen Road',
  'postcode': 'BL7 9BR'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '000',
  'address': '17 Links Road',
  'postcode': 'BL2 4EN'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07887560201',
  'address': '17 Meadland Grove',
  'postcode': 'BL1 8TQ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07969515523',
  'address': '17 Meadland Grove',
  'postcode': 'BL1 8TQ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07769015115',
  'address': '2 Rushford Grove',
  'postcode': 'BL1 8TD'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07749525297',
  'address': '20 Aylesford Walk',
  'postcode': 'BL1 2UT'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07897000933',
  'address': '20 Greystoke Drive',
  'postcode': 'BL1 7DW'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07842379675',
  'address': '20 Huxley Street',
  'postcode': 'BL1 3JY'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07738109248',
  'address': '20 Lindean Close',
  'postcode': 'BL1 7GD'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07907804382',
  'address': '20 The Hall Coppice',
  'postcode': 'BL7 9UE'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07453472538',
  'address': '20A Templecombe Drive',
  'postcode': 'BL1 7LT'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07521342113',
  'address': '21 Brightmeadow Close',
  'postcode': 'BL2 6GE'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07534318485',
  'address': '21 Eden Street',
  'postcode': 'BL1 6NL'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07851375266',
  'address': '21 Eden Street',
  'postcode': 'BL1 6NL'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07897932422',
  'address': '21 Pemberton Street',
  'postcode': 'BL1 7HU'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07897940126',
  'address': '21 Pemberton Street',
  'postcode': 'BL1 7HU'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07873768734',
  'address': '21 Tarvin Walk',
  'postcode': 'BL1 8EB'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07775888280',
  'address': '211 Halliwell Road',
  'postcode': 'BL1 3NT'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07868305884',
  'address': '22 Ashworth Lane',
  'postcode': 'BL1 8RA'
});


await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07485016479',
  'address': '31 Oldhams Terrace',
  'postcode': 'BL1 6RD'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07983270303',
  'address': '36 Lindean Close',
  'postcode': 'BL1 7GD'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07851661972',
  'address': '37 Brightmeadow Close',
  'postcode': 'BL2 6GE'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07725830358',
  'address': '38 Langham Close',
  'postcode': 'BL1 7RA'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07594350411',
  'address': '39 Selkirk Road',
  'postcode': 'BL1 7BH'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07533003066',
  'address': '4 Callthorpe Close',
  'postcode': 'BL1 2UZ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07835858132',
  'address': '4 Drysdale View',
  'postcode': 'BL1 6SA'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07741894833',
  'address': '4 Helsby Gardens',
  'postcode': 'BL1 8SG'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07970798829',
  'address': '4 Helsby Gardens',
  'postcode': 'BL1 8SG'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07397971075',
  'address': '4 Holly Street',
  'postcode': 'BL1 8QR'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07740089998',
  'address': '4 Nevis Grove',
  'postcode': 'BL1 6RP'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07791230757',
  'address': '4 Sweetloves Grove',
  'postcode': 'BL1 7EE'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07936849258',
  'address': '4 The Crescent',
  'postcode': 'BL7 9JP'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07905272459',
  'address': '40 Athlone Avenue',
  'postcode': 'BL1 6RA'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07759937102',
  'address': '40 Chelburn Place',
  'postcode': 'BL1 3DB'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07713005010',
  'address': '41 Eastgrove Avenue',
  'postcode': 'BL1 7EZ'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07366695316',
  'address': '41 Hawarden Street',
  'postcode': 'BL1 7HY'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07744998097',
  'address': '41 Hawarden Street',
  'postcode': 'BL1 7HY'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07802755552',
  'address': '41 Hawarden Street',
  'postcode': 'BL1 7HY'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07824154899',
  'address': '41 Hawarden Street',
  'postcode': 'BL1 7HY'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '01204456633',
  'address': '41 Heatherfield',
  'postcode': 'BL1 7QG'
});

await db.insert('customers', {
  'name': 'Delivery Customer',
  'phone': '07873830121',
  'address': '41 Kermoor Avenue',
  'postcode': 'BL1 7HW'
});






// Pizza
await db.insert('products', {'name': 'Cheese & Tomato', 'price': 5.99, 'isVat': 1, 'category': 'Pizza'});
await db.insert('products', {'name': 'Vegetarian Supreme', 'price': 7.99, 'isVat': 1, 'category': 'Pizza'});
await db.insert('products', {'name': 'Vegetarian Hot', 'price': 7.99, 'isVat': 1, 'category': 'Pizza'});
await db.insert('products', {'name': 'Hawaiian', 'price': 7.99, 'isVat': 1, 'category': 'Pizza'});
await db.insert('products', {'name': 'Mexican Heatwave', 'price': 7.99, 'isVat': 1, 'category': 'Pizza'});
await db.insert('products', {'name': 'BBQ Deluxe', 'price': 7.99, 'isVat': 1, 'category': 'Pizza'});
await db.insert('products', {'name': 'Hot & Spicy', 'price': 7.99, 'isVat': 1, 'category': 'Pizza'});
await db.insert('products', {'name': 'Meat Feast', 'price': 8.99, 'isVat': 1, 'category': 'Pizza'});
await db.insert('products', {'name': 'Meat Feast Deluxe', 'price': 8.99, 'isVat': 1, 'category': 'Pizza'});
await db.insert('products', {'name': 'Pepperoni Special', 'price': 8.99, 'isVat': 1, 'category': 'Pizza'});
await db.insert('products', {'name': 'Grill Corner Special', 'price': 8.99, 'isVat': 1, 'category': 'Pizza'});


// Garlic Bread
await db.insert('products', {'name': 'Garlic Bread', 'price': 3.50, 'isVat': 1, 'category': 'Garlic Bread'});
await db.insert('products', {'name': 'Garlic Bread With Cheese', 'price': 4.99, 'isVat': 1, 'category': 'Garlic Bread'});
await db.insert('products', {'name': 'Garlic Bread With Cheese & Tomato Sauce', 'price': 4.99, 'isVat': 1, 'category': 'Garlic Bread'});
await db.insert('products', {'name': 'Garlic Bread Cheese & Mushrooms', 'price': 5.49, 'isVat': 1, 'category': 'Garlic Bread'});
await db.insert('products', {'name': 'Garlic Bread Cheese & Onions', 'price': 5.49, 'isVat': 1, 'category': 'Garlic Bread'});
await db.insert('products', {'name': 'Garlic Bread Cheese & Donner After', 'price': 5.99, 'isVat': 1, 'category': 'Garlic Bread'});
await db.insert('products', {'name': 'Garlic Bread Cheese & Donner Before', 'price': 5.99, 'isVat': 1, 'category': 'Garlic Bread'});

// Calzones
await db.insert('products', {'name': 'Mixed Grill Calzone', 'price': 10.99, 'isVat': 1, 'category': 'Calzone'});
await db.insert('products', {'name': 'Donner Calzone', 'price': 9.99, 'isVat': 1, 'category': 'Calzone'});
await db.insert('products', {'name': "Pick'n' Mix Calzone", 'price': 10.49, 'isVat': 1, 'category': 'Calzone'});

// donner and grill
await db.insert('products', {'name': 'Chicken Seekh Kebabs (2Pcs)', 'price': 3.49, 'isVat': 1, 'category': 'Grill'});
await db.insert('products', {'name': 'Chicken Seekh on Naan (2Pcs)', 'price': 4.49, 'isVat': 1, 'category': 'Grill'});
await db.insert('products', {'name': 'Tray of Donner Meat (Large)', 'price': 5.99, 'isVat': 1, 'category': 'Grill'});
await db.insert('products', {'name': 'Grilled Donner Meat', 'price': 7.49, 'isVat': 1, 'category': 'Grill'});
await db.insert('products', {'name': 'Chicken Tikka Pieces (8Pcs)', 'price': 6.49, 'isVat': 1, 'category': 'Grill'});
await db.insert('products', {'name': 'Chicken Tikka Pieces', 'price': 8.99, 'isVat': 1, 'category': 'Grill'});
await db.insert('products', {'name': 'Chicken Tikka, Donner & Seekh Mix', 'price': 11.99, 'isVat': 1, 'category': 'Grill'});

// 

await db.insert('products', {'name': 'Classic Fried Chicken Burger', 'price': 2.99, 'isVat': 1, 'category': 'Burger'});
await db.insert('products', {'name': 'Zinger Fried Burger', 'price': 4.49, 'isVat': 1, 'category': 'Burger'});
await db.insert('products', {'name': 'Grilled Peri Peri Burger', 'price': 5.49, 'isVat': 1, 'category': 'Burger'});
await db.insert('products', {'name': 'Grilled Buffalo Burger', 'price': 5.49, 'isVat': 1, 'category': 'Burger'});
await db.insert('products', {'name': 'Grilled Peri Peri Double Chicken Burger', 'price': 7.49, 'isVat': 1, 'category': 'Burger'});
await db.insert('products', {'name': 'Chicken Tikka Burger', 'price': 4.99, 'isVat': 1, 'category': 'Burger'});
await db.insert('products', {'name': 'Donner Burger', 'price': 2.99, 'isVat': 1, 'category': 'Burger'});
await db.insert('products', {'name': 'Cheese Burger', 'price': 4.49, 'isVat': 1, 'category': 'Burger'});
await db.insert('products', {'name': 'Double Cheese Burger', 'price': 5.49, 'isVat': 1, 'category': 'Burger'});
await db.insert('products', {'name': 'Fillet o Fish Burger', 'price': 4.49, 'isVat': 1, 'category': 'Burger'});
await db.insert('products', {'name': 'Veggie Burger', 'price': 4.49, 'isVat': 1, 'category': 'Burger'});
await db.insert('products', {'name': 'Deluxe Burger', 'price': 6.99, 'isVat': 1, 'category': 'Burger'});

await db.insert('products', {'name': 'Grilled Peri Peri Chicken Wrap', 'price': 4.99, 'isVat': 1, 'category': 'Wraps'});
await db.insert('products', {'name': 'Fried Chicken Wrap', 'price': 3.99, 'isVat': 1, 'category': 'Wraps'});
await db.insert('products', {'name': 'Chicken Tikka Wrap', 'price': 4.99, 'isVat': 1, 'category': 'Wraps'});
await db.insert('products', {'name': 'Donner Wrap', 'price': 3.49, 'isVat': 1, 'category': 'Wraps'});  
await db.insert('products', {'name': 'Half Peri Peri Chicken', 'price': 8.49, 'isVat': 1, 'category': 'Peri Peri Chicken'});
await db.insert('products', {'name': 'Full Peri Peri Chicken', 'price': 14.99, 'isVat': 1, 'category': 'Peri Peri Chicken'});
await db.insert('products', {'name': 'Half Lemon & Herb Peri Peri Chicken', 'price': 8.49, 'isVat': 1, 'category': 'Peri Peri Chicken'});
await db.insert('products', {'name': 'Full Lemon & Herb Peri Peri Chicken', 'price': 14.99, 'isVat': 1, 'category': 'Peri Peri Chicken'});
await db.insert('products', {'name': 'Half Garlic Peri Peri Chicken', 'price': 8.49, 'isVat': 1, 'category': 'Peri Peri Chicken'});
await db.insert('products', {'name': 'Full Garlic Peri Peri Chicken', 'price': 14.99, 'isVat': 1, 'category': 'Peri Peri Chicken'});
await db.insert('products', {'name': 'Half Buffalo Chicken', 'price': 8.49, 'isVat': 1, 'category': 'Peri Peri Chicken'});
await db.insert('products', {'name': 'Full Buffalo Chicken', 'price': 14.99, 'isVat': 1, 'category': 'Peri Peri Chicken'});
 

await db.insert('products', {'name': 'Grilled Chicken Tikka', 'price': 8.99, 'isVat': 1, 'category': 'Sizzlers'});
await db.insert('products', {'name': 'Mixed Chicken & Donner', 'price': 11.99, 'isVat': 1, 'category': 'Sizzlers'});
await db.insert('products', {'name': 'Mixed Grilled Chicken & Seekh Kebab', 'price': 11.99, 'isVat': 1, 'category': 'Sizzlers'});
await db.insert('products', {'name': 'Chicken Donner Seekh Kebab', 'price': 11.99, 'isVat': 1, 'category': 'Sizzlers'});
await db.insert('products', {'name': 'Grill Corner Special', 'price': 11.99, 'isVat': 1, 'category': 'Sizzlers'});
await db.insert('products', {'name': 'Beef Steak', 'price': 12.99, 'isVat': 1, 'category': 'Sizzlers'});  
await db.insert('products', {'name': 'Peri Peri Wings (5pcs)', 'price': 4.99, 'isVat': 1, 'category': 'Chicken Wings'});
await db.insert('products', {'name': 'Peri Peri Wings (10pcs)', 'price': 9.99, 'isVat': 1, 'category': 'Chicken Wings'});
await db.insert('products', {'name': 'Lemon & Herb Wings (5pcs)', 'price': 4.99, 'isVat': 1, 'category': 'Chicken Wings'});
await db.insert('products', {'name': 'Lemon & Herb Wings (10pcs)', 'price': 9.99, 'isVat': 1, 'category': 'Chicken Wings'});
await db.insert('products', {'name': 'Garlic Peri Peri Wings (5pcs)', 'price': 4.99, 'isVat': 1, 'category': 'Chicken Wings'});
await db.insert('products', {'name': 'Garlic Peri Peri Wings (10pcs)', 'price': 9.99, 'isVat': 1, 'category': 'Chicken Wings'});
await db.insert('products', {'name': 'Buffalo Wings (5pcs)', 'price': 4.99, 'isVat': 1, 'category': 'Chicken Wings'});
await db.insert('products', {'name': 'Buffalo Wings (10pcs)', 'price': 9.99, 'isVat': 1, 'category': 'Chicken Wings'});
await db.insert('products', {'name': 'Fried Chicken Wings (5pcs)', 'price': 4.99, 'isVat': 1, 'category': 'Chicken Wings'});
await db.insert('products', {'name': 'Fried Chicken Wings (10pcs)', 'price': 9.99, 'isVat': 1, 'category': 'Chicken Wings'});
await db.insert('products', {'name': 'Mixed Chicken tikka, Donner, Shish kebab & Beef Steak', 'price': 19.99, 'isVat': 1, 'category': 'Sizzlers'});



 await db.insert('products', {'name': 'Mozarella Cheese Sticks (6pcs)', 'price': 3.49, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Popcorn Chicken (10pcs)', 'price': 4.49, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Chicken Nuggets (10pcs)', 'price': 4.49, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Garlic Mushrooms (10pcs)', 'price': 4.49, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Onion Rings (8pcs)', 'price': 3.49, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Spicy Potato Wedges', 'price': 3.49, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Hash Brown (5pcs)', 'price': 2.99, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Chicken Samosa / Veg Samosa (V)', 'price': 2.99, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Fries Regular', 'price': 1.89, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Fries Large', 'price': 2.49, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Chips & Gravy', 'price': 2.99, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Chips, Gravy & Cheese', 'price': 3.99, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Curly Fries / Curly Cheesy', 'price': 3.49, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Cheesy Fries', 'price': 3.49, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Chicken Strippers (4pcs)', 'price': 3.99, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Jalapeno Bombers (8pcs)', 'price': 3.99, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Naan / Garlic Naan', 'price': 1.10, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Gravy', 'price': 0.99, 'isVat': 1, 'category': 'Extras'});
await db.insert('products', {'name': 'Salad / Coleslaw', 'price': 1.99, 'isVat': 0, 'category': 'Extras'});
await db.insert('products', {'name': 'Plain Rice / Peri Peri Rice / Masala Rice', 'price': 3.99, 'isVat': 1, 'category': 'Extras'});

await db.insert('products', {'name': 'Apple Pie', 'price': 1.99, 'isVat': 0, 'category': 'Cakes'});
await db.insert('products', {'name': 'Oreo Cake', 'price': 2.49, 'isVat': 0, 'category': 'Cakes'});
await db.insert('products', {'name': 'Chocolate Fudge Cake', 'price': 2.49, 'isVat': 0, 'category': 'Cakes'});
await db.insert('products', {'name': 'Rainbow Cake', 'price': 2.49, 'isVat': 0, 'category': 'Cakes'});
await db.insert('products', {'name': 'Snicker Fudge Cake', 'price': 2.49, 'isVat': 0, 'category': 'Cakes'});
await db.insert('products', {'name': 'Ferrero Cake', 'price': 2.49, 'isVat': 0, 'category': 'Cakes'});
await db.insert('products', {'name': 'Lindor Cake', 'price': 2.49, 'isVat': 0, 'category': 'Cakes'});


  
await db.insert('products', {'name': 'Mineral Water', 'price': 0.80, 'isVat': 1, 'category': 'Drinks'});
await db.insert('products', {'name': 'Fruit Shoot (200ml)', 'price': 1.00, 'isVat': 1, 'category': 'Drinks'});
await db.insert('products', {'name': 'Rubicon Mango Can', 'price': 1.25, 'isVat': 1, 'category': 'Drinks'});
await db.insert('products', {'name': 'Rubicon Passion Can', 'price': 1.25, 'isVat': 1, 'category': 'Drinks'});
await db.insert('products', {'name': 'Irn-Bru Can', 'price': 1.25, 'isVat': 1, 'category': 'Drinks'});
await db.insert('products', {'name': 'Irn-Bru Extra Can', 'price': 1.25, 'isVat': 1, 'category': 'Drinks'});
await db.insert('products', {'name': 'Barr D N B Can', 'price': 1.25, 'isVat': 1, 'category': 'Drinks'});
await db.insert('products', {'name': 'Tango Orange Can', 'price': 1.25, 'isVat': 1, 'category': 'Drinks'});
await db.insert('products', {'name': 'Sanpellegrino Orange', 'price': 1.50, 'isVat': 1, 'category': 'Drinks'});
await db.insert('products', {'name': 'Sanpellegrino Lemon', 'price': 1.50, 'isVat': 1, 'category': 'Drinks'});



 await db.insert('products', {'name': 'Peri Peri Dip', 'price': 0.40, 'isVat': 0, 'category': 'Dips'});
await db.insert('products', {'name': 'Lemon & Herb Dip', 'price': 0.40, 'isVat': 0, 'category': 'Dips'});
await db.insert('products', {'name': 'Garlic Peri Peri Dip', 'price': 0.40, 'isVat': 0, 'category': 'Dips'});
await db.insert('products', {'name': 'Mint Sauce', 'price': 0.40, 'isVat': 0, 'category': 'Dips'});
await db.insert('products', {'name': 'Chilli Sauce', 'price': 0.40, 'isVat': 0, 'category': 'Dips'});
await db.insert('products', {'name': 'BBQ Sauce', 'price': 0.40, 'isVat': 0, 'category': 'Dips'});
await db.insert('products', {'name': 'Ketchup', 'price': 0.40, 'isVat': 0, 'category': 'Dips'});
await db.insert('products', {'name': 'Mayonnaise', 'price': 0.40, 'isVat': 0, 'category': 'Dips'});  



await db.insert('products', {'name': 'B&J Cookie Dough (100ml)', 'price': 2.49, 'isVat': 1, 'category': 'Ice Cream'});
await db.insert('products', {'name': 'B&J Cookie Dough (465ml)', 'price': 5.49, 'isVat': 1, 'category': 'Ice Cream'});
await db.insert('products', {'name': 'B&J Choc Fudge Brownie (100ml)', 'price': 2.49, 'isVat': 1, 'category': 'Ice Cream'});
await db.insert('products', {'name': 'B&J Choc Fudge Brownie (465ml)', 'price': 5.49, 'isVat': 1, 'category': 'Ice Cream'});




 await db.insert('products', {'name': 'Ferrero Rocher', 'price': 5.49, 'isVat': 1, 'category': 'Milkshakes'});
await db.insert('products', {'name': 'Cookie Blast', 'price': 5.49, 'isVat': 1, 'category': 'Milkshakes'});
await db.insert('products', {'name': 'Bubble Gum', 'price': 5.49, 'isVat': 1, 'category': 'Milkshakes'});
await db.insert('products', {'name': 'Tropical Strawberry', 'price': 5.49, 'isVat': 1, 'category': 'Milkshakes'});
await db.insert('products', {'name': 'Bounty Hunter', 'price': 5.49, 'isVat': 1, 'category': 'Milkshakes'});
await db.insert('products', {'name': 'Belgian Chocolate', 'price': 5.49, 'isVat': 1, 'category': 'Milkshakes'});
await db.insert('products', {'name': 'Lotus Biscoff', 'price': 5.49, 'isVat': 1, 'category': 'Milkshakes'});
await db.insert('products', {'name': 'Nutella Milkshake', 'price': 5.49, 'isVat': 1, 'category': 'Milkshakes'});
await db.insert('products', {'name': 'Cookie Monster', 'price': 5.49, 'isVat': 1, 'category': 'Milkshakes'});
await db.insert('products', {'name': 'Snickers', 'price': 5.49, 'isVat': 1, 'category': 'Milkshakes'});
await db.insert('products', {'name': 'Dubai', 'price': 5.49, 'isVat': 1, 'category': 'Milkshakes'});


await db.insert('products', {'name': '7" Pizza Meal', 'price': 5.25, 'isVat': 1, 'category': 'Meals'});
await db.insert('products', {'name': '9" Pizza Meal', 'price': 7.99, 'isVat': 1, 'category': 'Meals'});
await db.insert('products', {'name': 'Popcorn Chicken Meal', 'price': 5.99, 'isVat': 1, 'category': 'Meals'});
await db.insert('products', {'name': 'Chicken Nuggets Meal', 'price': 5.99, 'isVat': 1, 'category': 'Meals'});
// await db.insert('products', {'name': 'Chicken Wrap Meal', 'price': 5.99, 'isVat': 1, 'category': 'Meals'});  



await db.insert('products', {'name': '12" Pizza Offer', 'price': 24.99, 'isVat': 1, 'category': 'Offers'});
await db.insert('products', {'name': '14" Pizza Offer', 'price': 29.99, 'isVat': 1, 'category': 'Offers'});
await db.insert('products', {'name': 'Family Offer 1', 'price': 26.99, 'isVat': 1, 'category': 'Offers'});
await db.insert('products', {'name': 'Family Offer 2', 'price': 32.99, 'isVat': 1, 'category': 'Offers'});
 
      },
    );
  }

  // Product Management
  Future<List<Product>> getProducts() async {
    final dbClient = await database;
    final maps = await dbClient.query('products');
    return maps.map((e) => Product(
      id: e['id'] as int,
      name: e['name'] as String,
      price: (e['price'] as num).toDouble(),
      isVat: e['isVat'] == 1,
      category: e['category'] as String,
    )).toList();
  }

  // Order Management
Future<void> saveOrder({
  required String items,
  required double total,
  required double vat,
  required double net,
  required String date,
  required String orderType,
  required String paymentMethod,
  required String address,
}) async {
  final dbClient = await database;
  await dbClient.insert('orders', {
    'items': items,
    'total': total,
    'vat': vat,
    'net': net,
    'date': date,
    'orderType': orderType,
    'paymentMethod': paymentMethod,
    'address': address,
  });
}

Future<List<Customer>> searchCustomersByPostcode(String postcode) async {
  final dbClient = await database;
  final cleanedInput = postcode.replaceAll(' ', '').toLowerCase();

  final result = await dbClient.rawQuery('''
    SELECT * FROM customers 
    WHERE REPLACE(LOWER(postcode), ' ', '') LIKE ?
  ''', ['%$cleanedInput%']);

  return result.map((e) => Customer.fromMap(e)).toList();
}





  Future<List<Map<String, dynamic>>> getOrders() async {
    final dbClient = await database;
    return await dbClient.query('orders', orderBy: 'id DESC');
  }

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final dbClient = await database;
    return await dbClient.query('orders', orderBy: 'date DESC');
  }

  Future<void> deleteOrder(int id) async {
    final dbClient = await database;
    await dbClient.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateOrder(int id, String items, double total, double vat, double net) async {
    final dbClient = await database;
    await dbClient.update(
      'orders',
      {
        'items': items,
        'total': total,
        'vat': vat,
        'net': net,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Customer Management
  Future<int> insertCustomer(Customer customer) async {
    final dbClient = await database;
    return await dbClient.insert(
      'customers',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Customer?> getCustomerByPhone(String phone) async {
    final dbClient = await database;
    final result = await dbClient.query(
      'customers',
      where: 'phone = ?',
      whereArgs: [phone],
    );

    if (result.isNotEmpty) {
      return Customer.fromMap(result.first);
    }
    return null;
  }

  Future<Customer?> findCustomer({String? phone, String? postcode}) async {
  final dbClient = await database;
  final result = await dbClient.query(
    'customers',
    where: 'phone = ? OR postcode = ?',
    whereArgs: [phone, postcode],
  );
  if (result.isNotEmpty) {
    return Customer.fromMap(result.first);
  }
  return null;
}

Future<void> deleteCustomer(String phone) async {
  final dbClient = await database;
  await dbClient.delete('customers', where: 'phone = ?', whereArgs: [phone]);
}
// Future<List<Customer>> searchCustomersByPostcode(String postcode) async {
//   final dbClient = await database;
//   final result = await dbClient.query(
//     'customers',
//     where: 'postcode LIKE ?',
//     whereArgs: ['%$postcode%'],
//   );
//   return result.map((e) => Customer.fromMap(e)).toList();
// }



}
