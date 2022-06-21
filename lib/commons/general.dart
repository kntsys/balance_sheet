import 'package:flutter/material.dart';
import 'dart:io'; // Fileに使用
import 'package:path_provider/path_provider.dart';  // getApplicationDocumentsDirectoryに使用
import 'package:app_balance_sheet/commons/accessDatabase.dart';
import 'package:app_balance_sheet/views/models/balance.dart';
import 'dart:io' as io; // File関係ライブラリ

class General{

  Widget wSpacer(double width) {
    return SizedBox(
      width: width,
    );
  }

 /* List<DropdownMenuItem<int>> setIncomeItems(){
    List<DropdownMenuItem<int>> _incomeItems = [];

    _incomeItems
      ..add(DropdownMenuItem(
        child: Text('収入', style: TextStyle(fontSize: 20.0),),
        value: 1,
      ))
      ..add(DropdownMenuItem(
        child: Text('支出', style: TextStyle(fontSize: 20.0),),
        value: 2,
      ));

    return _incomeItems;
  }

  // 科目設定
  List<DropdownMenuItem<int>> setSubjectItems() {
    List<DropdownMenuItem<int>> _subjectItems = [];

    _subjectItems
      ..add(DropdownMenuItem(
        child: Text('雑費', style: TextStyle(fontSize: 20.0),),
        value: 1,
      ))
      ..add(DropdownMenuItem(
        child: Text('通信費', style: TextStyle(fontSize: 20.0),),
        value: 2,
      ))
      ..add(DropdownMenuItem(
        child: Text('福利厚生費', style: TextStyle(fontSize: 20.0),),
        value: 3,
      ))
      ..add(DropdownMenuItem(
        child: Text('事務用品費', style: TextStyle(fontSize: 20.0),),
        value: 4,
      ))
      ..add(DropdownMenuItem(
        child: Text('接待費', style: TextStyle(fontSize: 20.0),),
        value: 5,
      ))
      ..add(DropdownMenuItem(
        child: Text('収入', style: TextStyle(fontSize: 20.0),),
        value: 6,
      ));
    return _subjectItems;
  }*/

  Future<void> showInfo(BuildContext context,String submit) {
    return showDialog(context: context, builder: (_)=>dialog(context,submit));
  }
  Dialog dialog(BuildContext context,String submit){
    return Dialog(
      backgroundColor: Colors.white,
      child: SizedBox(
        height: 70,
        width: 70,
        child: Text(submit),
      ),
    );
  }

  Future<dynamic> showAlartDialog(BuildContext context,String _title) async{
    return  showDialog<int>(
        context: context,
        barrierDismissible: false,  //背景タップFalse
        builder: (_) => alartDialog(context,_title)
    );
  }
  AlertDialog alartDialog(BuildContext context,String _title) {
    return AlertDialog(
      title: Text('確認'),
      content: Text(_title),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(0),
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop(1),
        ),
      ],
    );
  }

  //テキストファイルを保存するパスを取得する
  Future<File> getFilePath(String _fileName) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    //final directory = (await getTemporaryDirectory()).path;
    //final directory ="/strage/emulated/0/Android/data/com.balancesheet.test";
    print('directory:${directory}');
    return File(directory + '/' + _fileName);
  }

  /*Future<String> get getFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }    */

  Future<void> outputCsv(BuildContext context) async{
    List<Balance> _texts = [];
    var result;

    result = await General().showAlartDialog(context,'CSV出力を行いますか？');
    //print(List.generate(10,(i)=> i + 3)),
    if (result == 1){
      try {
          // Ok
          print('CSV出力処理を行う');
          // データの取得
          await AcessDatabase().SelectBalanceData().then((value) => {
          _texts = [],
          value.forEach((addValue) {
          _texts.add(addValue);
          }),
        });

        //　ファイルの出力処理
        final _fileName = 'balanceSheet.csv'; //出力するテキストファイル名
        //final _fileName = 'balanceSheet_' + DateTime.now().toString() + '.csv';  //出力するテキストファイル名
        String outputString = ''; //CSV出力用
        await General().getFilePath(_fileName).then((File file) {
          Future(() async {
            for (int i = 0; i < _texts.length; i++) {
              outputString = outputString + _texts[i].number.toString() + ',' +
                  _texts[i].year + ',' +
                  _texts[i].month + ',' +
                  _texts[i].day + ',' +
                  _texts[i].income + ',' +
                  _texts[i].subject + ',' +
                  _texts[i].amount.toString() +
                  '\n';

              /*await file.writeAsString(
                _texts[i].number.toString() + ',' +
                    _texts[i].year + ',' +
                    _texts[i].month + ',' +
                    _texts[i].day + ',' +
                    _texts[i].income + ',' +
                    _texts[i].subject + ',' +
                    _texts[i].amount.toString() +
                    '\n',
                mode: FileMode.append, flush: false);*/
          };

            await file.writeAsString(outputString);

            showInfo(context, "出力内容  ${outputString}");

            var syncPath = file.path;
            if (await io.File(syncPath).existsSync() == true) {
              await showInfo(context, "存在しているPath  ${syncPath}");
            } else {
              await showInfo(context, "存在してないPath  ${syncPath}");
            }

            await General().getFilePath(_fileName).then((File file) {
              Future(() async {
                await file.readAsString().then((String value) {
                  String test = value;
                  showInfo(context, "保存されている値；  ${test}");
                });
              });
            });


          });
        });

      } catch(e){
        await showInfo(context, "error  ${e}");
      }
      await General().showInfo(context,'CSV出力が完了しました。');
    } else
    {
      // Cancel
      Navigator.pop; //ダイアログを閉じる
    };
  }

}
