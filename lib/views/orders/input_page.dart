import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_balance_sheet/commons/general.dart';
import 'package:app_balance_sheet/commons/accessDatabase.dart';
import 'package:app_balance_sheet/views/models/balance.dart';
import 'package:app_balance_sheet/views/orders/list_display_page.dart';

class InputPage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => InputPage());
  }
}

class _MyHomePageState extends State<InputPage> {
  var result;
  //var number = 5;
  var _yearController = TextEditingController();
  var _monthController = TextEditingController();
  var _dayController = TextEditingController();
  var _AmountController = TextEditingController();
  var _year = '';

  List<DropdownMenuItem<int>> _incomeItems = [];
  List<DropdownMenuItem<int>> _subjectItems = [];
  int _selectIncomeItem = 0;
  int _selectSubjectItem = 0;

  // フォーカス管理用のFocusNode
  final yearfocus = FocusNode();
  final monthfocus = FocusNode();
  final dayfocus = FocusNode();
  final amountfocus = FocusNode();

  int day = 0;
  var balance;
  List<Balance> _texts = [];

  @override
  void initState() {
    super.initState();
    _yearController.text = DateTime.now().year.toString();
    _monthController.text = DateTime.now().month.toString();
    _dayController.text = DateTime.now().day.toString();

    Future(() async {
      // 収入/支出データ取得、設定
      await AcessDatabase().SelectIncomeData().then((incomeValue) => {
        setState(() {
          incomeValue.forEach((addValue) {
            _incomeItems
              ..add(DropdownMenuItem(
                child: Text(addValue['IncomeName'], style: TextStyle(fontSize: 20.0),),
                value: addValue['IncomeNo'],
              ));
          });
        }),
      });
      _selectIncomeItem = _incomeItems[0].value!;

      // 科目データ取得、設定
      await AcessDatabase().SelectSubjectData().then((subjectValue) => {
        setState(() {
          subjectValue.forEach((addValue) {
            _subjectItems
              ..add(DropdownMenuItem(
                child: Text(addValue['SubjectName'], style: TextStyle(fontSize: 20.0),),
                value: addValue['SubjectNo'],
              ));
          });
        }),
      });
      _selectSubjectItem = _subjectItems[0].value!;

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
        padding: EdgeInsets.all(32.0),
        child: SingleChildScrollView( //スクロールする
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 12.0)), // 間を空ける
              _line1(context,yearfocus),  // №、年
              Padding(padding: EdgeInsets.only(top: 12.0)), // 間を空ける
              _line2(context,monthfocus,dayfocus),  // 月、日
              Padding(padding: EdgeInsets.only(top: 12.0)), // 間を空ける
              _line3(context),  // 収入、支出
              Padding(padding: EdgeInsets.only(top: 12.0)), // 間を空ける
              _line4(context),  // 科目
              Padding(padding: EdgeInsets.only(top: 12.0)), // 間を空ける
              _line5(context,amountfocus),  // 金額
              // 上下の間を空ける
              //Spacer(),
              Padding(padding: EdgeInsets.only(top: 15.0)),
              _line6(context,monthfocus,dayfocus),  // 登録
              Padding(padding: EdgeInsets.only(top: 13.0)),
              _line7(context),  // キャンセル
            ],
          ),
        ),
      ),


    );

  }

  Widget _line1(BuildContext context,yearfocus){
    return Row(
      children: <Widget>[
        Container(
          width: 50,
          child: TextField(
            style: new TextStyle(
                fontSize: 20.0,
                height: 1.5,
                color: Colors.black
            ),
            keyboardType: TextInputType.number,
            focusNode:yearfocus,
            textAlign:TextAlign.center,
            autofocus: true,
            controller: _yearController,
            onChanged: (value) {
              _year = value;
              print('_yearController::' + _yearController.text);
              print('_year::' + _year);
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: Text('年',style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }

  Widget _line2(BuildContext context,monthfocus,dayfocus){
    return Row(
      children: <Widget>[
        Container(
          width: 30,
          child: TextField(
            style: new TextStyle(
                fontSize: 20.0,
                height: 1.5,
                color: Colors.black
            ),
            keyboardType: TextInputType.number,
            focusNode:monthfocus,
            textAlign: TextAlign.center,
            controller: _monthController,
          ),
        ),
        //Expanded(
        Container(
          //flex: 3,
          child: Text('月',style: TextStyle(fontSize: 20)),
        ),
        General().wSpacer(50),
        Container(
          width: 30,
          child: TextField(
            style: new TextStyle(
                fontSize: 20.0,
                height: 1.5,
                color: Colors.black
            ),
            keyboardType: TextInputType.number,
            focusNode:dayfocus,
            textAlign: TextAlign.center,
            controller: _dayController,
          ),
        ),
        Container(
          //flex: 3,
          child: Text('日',style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }

  Widget _line3(BuildContext context,){
    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            //border: Border.all(color: Colors.black, width: 9),
            //borderRadius: BorderRadius.circular(12)
          ),
          padding: EdgeInsets.all(10),
          child: DropdownButton(
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
            items: _incomeItems,
            value: _selectIncomeItem,
            onChanged: (value) => {
              setState(() {
                _selectIncomeItem = int.parse(value.toString());
              }),
            },
          ),
        ),
      ],
    );
  }

  Widget _line4(BuildContext context,){
    return Row(
        children: <Widget>[
          Text('科目',style: TextStyle(fontSize: 20)),
          General().wSpacer(30),
          Container(
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.black, width: 9),
              //borderRadius: BorderRadius.circular(12)
            ),
            padding: EdgeInsets.all(10),
            child: DropdownButton(
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 30,
              items: _subjectItems,
              value: _selectSubjectItem,
              onChanged: (value) => {
                setState(() {
                  _selectSubjectItem = int.parse(value.toString());
                }),
              },
            ),
          ),
        ]
    );
  }

  Widget _line5(BuildContext context,amountfocus){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Text('金額',style: TextStyle(fontSize: 20)),
        ),
        Container(
          width: 200,
          child: TextField(
            style: new TextStyle(
                fontSize: 20.0,
                height: 1.5,
                color: Colors.black
            ),
            keyboardType: TextInputType.number,
            focusNode:amountfocus,
            textAlign: TextAlign.right,
            controller: _AmountController,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text('円',style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }

  Widget _line6(BuildContext context,monthfocus,dayfocus){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonTheme(
          minWidth: 100.0,
          height: 50.0,
          buttonColor: Colors.amberAccent,
          child: RaisedButton(
            child: Text('登録'),
            /*onPressed: () => setState(
                  () {
                String _text = _yearController.text;
                _text += ':';
                _text += _AmountController.text;
                print(_text);
              },
            ),*/
            onPressed: () async =>{
              result = await General().showAlartDialog(context,'登録を行いますか？'),
              if (result == 1){// Ok
                if (int.parse(_monthController.text)<0 || int.parse(_monthController.text)>12){
                  FocusScope.of(context).requestFocus(monthfocus), // フォーカス設定
                  General().showInfo(context,'正しい月を入力してください。'),
                }else{
                  // 末日を取得
                  day = DateTime(int.parse(_yearController.text), int.parse(_monthController.text)+1, 1).add(Duration(days: -1)).day,
                  if (int.parse(_dayController.text)<1 || int.parse(_dayController.text)>day){
                    FocusScope.of(context).requestFocus(dayfocus), // フォーカス設定
                    General().showInfo(context,'正しい日付を入力してください。'),
                  }else{
                    // 登録対象データを取得
                    balance = Balance(0,
                        _yearController.text,
                        _monthController.text,
                        _dayController.text,
                        _selectIncomeItem,
                        '',
                        _selectSubjectItem,
                        '',
                        double.parse(_AmountController.text)),
                    await AcessDatabase().InsertData(balance),  // 登録処理
                    setState(() {
                      // 初期値設定（画面初期化）
                      _yearController.text = DateTime.now().year.toString();
                      _monthController.text = DateTime.now().month.toString();
                      _dayController.text = DateTime.now().day.toString();
                      _AmountController.text = '';
                      _selectIncomeItem = _incomeItems[0].value!;
                      _selectSubjectItem = _subjectItems[0].value!;
                    }),
                    General().showInfo(context,'登録を完了しました。'),
                  },
                },

              } else
                {
                  // Cancel
                  Navigator.pop, //ダイアログを閉じる
                }
            },

          ),
        ),
      ],
    );
  }

  Widget _line7(BuildContext context,){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonTheme(
          minWidth: 100.0,
          height: 50.0,
          buttonColor: Colors.amberAccent,
          child: RaisedButton(
              child: Text('キャンセル'),
              onPressed: () async =>
                  await AcessDatabase().SelectBalanceData().then((value) => {
                    _texts = [],
                    value.forEach((addValue) {
                      _texts.add(addValue);
                    }),
                    Navigator.of(context).pop(_texts),
                  }),
          ),
        ),
      ],
    );
  }

}