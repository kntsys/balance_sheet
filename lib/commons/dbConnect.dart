import 'dart:async';
import 'package:mysql1/mysql1.dart';

class DbConnect{

  Future<dynamic> connectDb() async{
    var conn;

    var settings = await new ConnectionSettings(
        host:'192.168.0.113',
        port: 3306,
        user:'admin',
        password:'pass',
        db: 'balance_sheet',

/*        host:  '10.0.2.2',
        port: 3306,
        user: 'root',
        password: 'root',
        db: 'balance_sheet',
*/        //timeout: Duration(seconds: 30),
    );

    try {
      conn = await MySqlConnection.connect(settings);
    } catch(e) {
      print(e); //Bad state: the door is locked
    }
    return conn;
  }

}