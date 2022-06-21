import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_balance_sheet/views/orders/input_page.dart';
import 'package:app_balance_sheet/views/orders/edit_delete_page.dart';
import 'dart:io'; // File関係ライブラリ
import 'package:app_balance_sheet/commons/general.dart';
import 'package:app_balance_sheet/commons/accessDatabase.dart';
import 'package:app_balance_sheet/views/models/balance.dart';

class ListDisplay extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => ListDisplay());
  }
}

class _MyHomePageState extends State<ListDisplay> {
  var result;
  List<bool> _isChecked = [false];
  List<Balance> _texts = [];
  var resultValue = [];
  Balance? _editData;

  @override
  void initState() {
    super.initState();

    Future(() async {
      AcessDatabase().SelectBalanceData().then((value) =>
      {
        setState(() {
          value.forEach((addValue) {
            _texts.add(addValue);
          });
          _isChecked = List<bool>.filled(_texts.length, false);
        }),
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編集（削除）'),
        centerTitle: true,
      ),
      endDrawer: _drawer(context),

      body: _listView()

    );
  }

  Widget _listView(){
    return Container(
      child: SingleChildScrollView( //スクロールする
        child: new Column(
          children: <Widget>[
            new SizedBox(
              height: 500,
              child: new ListView.builder(
                itemCount: _texts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () async =>{
                          //print('_texts[index].number: ${_texts[index].number}'),
                          //EditDeletePage().number = _texts[index].number,
                          //print('EditDeletePage().number:${EditDeletePage().number}'),

                          _editData = Balance(
                            _texts[index].number,
                            _texts[index].year,
                            _texts[index].month,
                            _texts[index].day,
                            _texts[index].incomeNo,
                            _texts[index].income,
                            _texts[index].subjectNo,
                            _texts[index].subject,
                            _texts[index].amount,
                          ),

                          Navigator.of(context).push<dynamic>(EditDeletePage.route(_editData!))
                              .then((value) => {
                              _texts = [],
                              setState(() {
                                value.forEach((addValue) {
                                  _texts.add(addValue);
                                });
                                _isChecked = List<bool>.filled(_texts.length, false);
                              }),
                            }),
                        },
                        leading: Checkbox(
                            value: _isChecked[index],
                            onChanged: (newValue) {
                              setState(() {
                                _isChecked[index] = newValue!;
                                print(index.toString() + _isChecked[index].toString()+_texts[index].number.toString());
                              });
                            }),
                        title:Text('№:' + _texts[index].number.toString() + ' ' +
                                _texts[index].year + '/' + _texts[index].month + '/'+ _texts[index].day + ' ' +
                                _texts[index].income + ' ' + _texts[index].subject + ' ' + _texts[index].amount.toString()),
                        //subtitle: Text(''),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
            // キャンセルボタン表示
            _buttonArea(context),
          ],
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context,) {
    return Drawer( // endDrawerで右上に配置
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('選択'),
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
          ),
          ListTile(
            title: Text("新規画面"),
            //trailing: Icon(Icons.arrow_forward),
            onTap: () async =>
            {
                Navigator.of(context).push<dynamic>(InputPage.route(), ).then((value) => {
                  _texts = [],
                  setState(() {
                    value.forEach((addValue) {
                      _texts.add(addValue);
                    });
                    _isChecked = List<bool>.filled(_texts.length, false);
                  }),
                }),
            },
          ),
          ListTile(
            title: Text("一括削除"),
            //trailing: Icon(Icons.arrow_forward),
            onTap: () async =>
            {
              result = await General().showAlartDialog(context,'削除を行いますか？'),
              if (result == 1){
                // Ok
                for (int i = 0; i < _isChecked.length; i++) {
                  if (_isChecked[i]){
                    print(_texts[i].number.toString()+'の削除を行う'),
                    /*setState((){
                      _RemoveData(_texts[i].number);
                    }),*/
                    await AcessDatabase().RemoveData(_texts[i].number),
                  },
                },
                // 最新データを取得する
                _texts = [],
                await AcessDatabase().SelectBalanceData().then((value) => {
                  setState(() {
                    value.forEach((addValue) {
                      _texts.add(addValue);
                    });
                    _isChecked = List<bool>.filled(_texts.length, false);
                  }),
                }),

                General().showInfo(context,'削除を完了しました。'),
              } else
              {
                // Cancel
                Navigator.pop, //ダイアログを閉じる
              },
            },
          ),
          ListTile(
            title: Text("CSV出力"),
            //trailing: Icon(Icons.arrow_forward),
            onTap: () async {
              await General().outputCsv(context); // CSV出力処理
            },
          ),
        ],
      ),
    );
  }

  Widget _buttonArea(BuildContext context,) {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: <Widget>[
          ButtonTheme(
            minWidth: 100.0,
            height: 50.0,
            buttonColor: Colors.amberAccent,
            child: RaisedButton(
                child: Text('キャンセル'),
                onPressed: () =>
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : SystemNavigator.pop()
            ),
          ),
        ],
      ),
    );
  }

}
