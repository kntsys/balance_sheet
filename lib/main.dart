import 'package:flutter/material.dart';
import 'package:app_balance_sheet/views/orders/list_display_page.dart';
import 'package:app_balance_sheet/commons/general.dart';
import 'package:path_provider/path_provider.dart';  // getApplicationDocumentsDirectoryに使用
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: MyHomePage(title: "バランスシートメニュー")
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // メニューボタンを表示
            _buttonArea(),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // メニューボタン
  Widget _buttonArea(){
    Future<String> loadData;
    return Container(
        child: Column(
            children: <Widget>[
              SizedBox(height: 16), // 間をあける

              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5.0),
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push<dynamic>(ListDisplay.route(),);
                  },
                  child: Text("一覧",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),),
                ),
              ),

              /*ButtonTheme(
                minWidth: 250.0,
                height: 70.0,
                buttonColor: Colors.amberAccent,
                child: RaisedButton(
                  onPressed: () => {
                    Navigator.of(context).push<dynamic>(ListDisplay.route(),),
                  }, child: Text('一覧'),
                ),
              ),*/

              SizedBox(height: 16), // 間をあける

              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5.0),
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () async {
                    await General().outputCsv(context); // CSV出力処理
                    //final directory = (await getApplicationDocumentsDirectory()).path;
                    //General().showInfo(context,directory);
                  },
                  child: Text("CSVへ出力",
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),),
                ),
              ),

              /*ButtonTheme(
                minWidth: 250.0,
                height: 70.0,
                buttonColor: Colors.amberAccent,
                child: RaisedButton(
                  onPressed: () async => {
                    result = await General().showAlartDialog(context,'CSV出力を行いますか？'),
                    //print(List.generate(10,(i)=> i + 3)),
                    if (result == 1){
                      // Ok
                      print('CSV出力処理を行う'),
                      // データの取得
                      await AcessDatabase().SelectBalanceData().then((value) => {
                        _texts = [],
                        value.forEach((addValue) {
                          _texts.add(addValue);
                        }),
                      }),
                      //　ファイルの出力処理
                      General().getFilePath(_fileName).then((File file){
                        for (int i = 0; i < _texts.length; i++) {
                          file.writeAsString(
                              _texts[i].number.toString() +
                                  _texts[i].year +
                                  _texts[i].month +
                                  _texts[i].day +
                                  _texts[i].income +
                                  _texts[i].subject +
                                  _texts[i].amount.toString() +
                                  '\n',
                              mode: FileMode.append, flush: true);
                        };
                      }),
                      General().showInfo(context,'CSV出力が完了しました。'),
                    } else
                      {
                        // Cancel
                        Navigator.pop, //ダイアログを閉じる
                      },

                  }, child: Text('CSVへ出力'),
                ),

              ),*/

            ]
        )
    );
  }

}
