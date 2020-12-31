import 'package:flutter/material.dart';
import 'package:sqljocky5/sqljocky.dart';
import 'package:zhizhang/utils/types.dart';

class RankPage extends StatefulWidget {
  @override
  _RankPageState createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  var users = List<User>();
  User _use = User(0, '0', -1, '0');
  int _rank = 0;
  int _flag = 0;

  _body() {
    List<Widget> list = new List();
    if (_flag == 1) {
      if (_use.rank == 1) {
        list.add(ListTile(
          leading: Icon(IconData(0xe928, fontFamily: 'MyIcons')),
          title: Text(_use.name),
          subtitle: Text(
            '${_use.medal}',
            style: TextStyle(fontSize: 12),
          ),
          trailing: Text(
            '${_use.num}',
            style: TextStyle(fontSize: 16),
          ),
        ));
      } else if (_use.rank == 2) {
        list.add(ListTile(
          leading: Icon(IconData(0xe929, fontFamily: 'MyIcons')),
          title: Text(_use.name),
          subtitle: Text('${_use.medal}', style: TextStyle(fontSize: 12)),
          trailing: Text('${_use.num}', style: TextStyle(fontSize: 16)),
        ));
      } else if (_use.rank == 3) {
        list.add(ListTile(
          leading: Icon(IconData(0xe92a, fontFamily: 'MyIcons')),
          title: Text(_use.name),
          subtitle: Text('${_use.medal}', style: TextStyle(fontSize: 12)),
          trailing: Text('${_use.num}', style: TextStyle(fontSize: 16)),
        ));
      } else {
        list.add(ListTile(
          leading: Text('${_use.rank}'),
          title: Text(_use.name),
          subtitle: Text('${_use.medal}', style: TextStyle(fontSize: 12)),
          trailing: Text('${_use.num}', style: TextStyle(fontSize: 16)),
        ));
      }
    }
    list.add(
            Container(
              width: MediaQuery.of(context).size.width,
              height: 0.2,
              color: Colors.grey,
            ),
          );
    list.add(SizedBox(
      height: 50,
    ));
    list.add(
            Container(
              width: MediaQuery.of(context).size.width,
              height: 0.2,
              color: Colors.grey,
            ),
          );
    for (var i = 0; i < users.length; i++) {
      if (i >= 100) {
        break;
      }

      if (i == 0) {
        list.add(ListTile(
          leading: Icon(IconData(0xe928, fontFamily: 'MyIcons')),
          title: Text(users[i].name),
          subtitle: Text('${users[i].medal}', style: TextStyle(fontSize: 12)),
          trailing: Text('${users[i].num}', style: TextStyle(fontSize: 16)),
        ));
      } else if (i == 1) {
        list.add(ListTile(
          leading: Icon(IconData(0xe929, fontFamily: 'MyIcons')),
          title: Text(users[i].name),
          subtitle: Text('${users[i].medal}', style: TextStyle(fontSize: 12)),
          trailing: Text('${users[i].num}', style: TextStyle(fontSize: 16)),
        ));
      } else if (i == 2) {
        list.add(ListTile(
          leading: Icon(IconData(0xe92a, fontFamily: 'MyIcons')),
          title: Text(users[i].name),
          subtitle: Text('${users[i].medal}', style: TextStyle(fontSize: 12)),
          trailing: Text('${users[i].num}', style: TextStyle(fontSize: 16)),
        ));
      } else {
        list.add(ListTile(
          leading: Text('\t\t${i + 1}'),
          title: Text(users[i].name),
          subtitle: Text('${users[i].medal}', style: TextStyle(fontSize: 12)),
          trailing: Text('${users[i].num}', style: TextStyle(fontSize: 16)),
        ));
      }
      list.add(
            Container(
              width: MediaQuery.of(context).size.width,
              height: 0.2,
              color: Colors.grey,
            ),
          );
    }
    return list;
  }

  _getUsers() async {
    _rank = 0;
    users.clear();
    var conn = await MySqlConnection.connect(connect);
    Results results = await (await conn
            .execute('select userId,userName,num from user ORDER BY num DESC'))
        .deStream();
    results.forEach((element) {
      setState(() {
        _flag = 1;
        _rank++;
        int _id = element.byName('userId');
        String _name = element.byName('userName');
        int _num = element.byName('num');
        String _medal;
        if (_num < 10) {
          _medal = '初进记账';
        } else if (_num < 100) {
          _medal = '停不下来';
        } else if (_num < 200) {
          _medal = '记账能手';
        } else if (_num < 300) {
          _medal = '记账小将';
        } else if (_num < 600) {
          _medal = '记账高手';
        } else if (_num < 1000) {
          _medal = '记账大师';
        } else if (_num < 2000) {
          _medal = '记账至尊';
        } else {
          _medal = '高处不胜寒';
        }

        if (userId == _id) {
          _use = User(_id, _name, _num, _medal);
          _use.rank = _rank;
        }
        User _user = User(_id, _name, _num, _medal);
        users.add(_user);
      });
    });
    conn.close();
  }

//初始化
  @override
  initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: Key('rankback'),
          icon: Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 200, 0),
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
        title: Text("排行榜", style: TextStyle(color: Colors.black)),
      ),
      body: ListView(
        children: _body(),
      ),
    );
  }
}
