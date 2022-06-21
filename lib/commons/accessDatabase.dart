import 'package:app_balance_sheet/views/models/balance.dart';
import 'package:app_balance_sheet/commons/dbConnect.dart';

class AcessDatabase{

  Future<dynamic> SelectIncomeData() async{
    var _selectResults;

    var conn = await DbConnect().connectDb();
    try{
      _selectResults = await conn.query(''
          'SELECT * '
          'FROM '
          ' tbl_income '
          'ORDER BY IncomeNo'
      );
    }
    catch(e){
      print("Unable to select IncomeData."+e.toString());
    }
    conn.close();
    return _selectResults;
  }

  Future<dynamic> SelectSubjectData() async{
    var _selectResults;

    var conn = await DbConnect().connectDb();
    try{
      _selectResults = await conn.query(''
          'SELECT * '
          'FROM '
          ' tbl_subject '
          'ORDER BY SubjectNo'
      );
    }
    catch(e){
      print("Unable to select IncomeData."+e.toString());
    }
    conn.close();
    return _selectResults;
  }

  Future<List<Balance>> SelectBalanceData() async{
    List<Balance> _texts = [];

    var conn = await DbConnect().connectDb();
    try{
      var selectResults = await conn.query(''
          'SELECT A.*,B.*,C.* '
          'FROM '
          'tbl_balance_sheet as A'
          ',tbl_income as B'
          ',tbl_subject as C '
          'WHERE '
          'A.IncomeNo = B.IncomeNo '
          'AND A.SubjectNo = C.SubjectNo '
          'ORDER BY A.Year,A.Month,A.Day,A.Number'
      );
      for (var row in selectResults) {
        _texts.add(Balance(
          row['Number'],
          row['Year'],
          row['Month'],
          row['Day'],
          row['IncomeNo'],
          row['IncomeName'],
          row['SubjectNo'],
          row['SubjectName'],
          row['Amount'],
        ));
      }
    }
    catch(e){
      print("Unable to select data."+e.toString());
    }
    conn.close();

    return _texts;
  }

  Future<void> RemoveData(int number) async{
    var conn = await DbConnect().connectDb();
    try{
      var result = await conn.query('DELETE FROM tbl_balance_sheet WHERE Number = (?)', [number]);
    }
    catch(e){
      print("Unable to delete data."+e.toString());
    }
    conn.close();
  }

  Future<void> UpdateData(Balance balance) async{
    var conn = await DbConnect().connectDb();
    try{
      var result = await conn.query(''
          'UPDATE tbl_balance_sheet '
          'SET '
            'Year = (?), '
            'Month = (?), '
            'Day = (?), '
            'IncomeNo = (?), '
            'SubjectNo = (?), '
            'Amount = (?) '
          'WHERE Number = (?)'
          , [
            balance.year,
            balance.month,
            balance.day,
            balance.incomeNo,
            balance.subjectNo,
            balance.amount,
            balance.number,
          ]);
    }
    catch(e){
      print("Unable to update data."+e.toString());
    }
    conn.close();
  }

  Future<void> InsertData(Balance balance) async{
    var conn = await DbConnect().connectDb();
    try{
      var result = await conn.query(''
          'INSERT INTO tbl_balance_sheet '
            '(Year, Month, Day, IncomeNo, SubjectNo, Amount) '
          'VALUES (?, ?, ?, ?, ?, ?)'
          , [
            balance.year,
            balance.month,
            balance.day,
            balance.incomeNo,
            balance.subjectNo,
            balance.amount
          ]);
    }
    catch(e){
      print("Unable to insert data."+e.toString());
    }
    conn.close();
  }

}