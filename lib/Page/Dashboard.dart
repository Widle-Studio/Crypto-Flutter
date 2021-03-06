import 'package:cryptomarket/Page/AddCoin.dart';
import 'package:cryptomarket/Page/Home.dart';
import 'package:cryptomarket/Page/Markets.dart';
import 'package:cryptomarket/Page/News.dart';
import 'package:cryptomarket/Page/Settings.dart';
import 'package:cryptomarket/Theme/fab_bottom_app_bar.dart';
import 'package:cryptomarket/Util/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return dashbord();
  }
}

class dashbord extends State<Dashboard>  {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoinsList();
  }

  getCoinsList()async{

    List coins = await SharedPreferencesHelper.getCoinList();
    if(coins.length == 0){

      coins.add('BTC');
      coins.add('XRP');
      coins.add('ETH');

    }

    List news = await SharedPreferencesHelper.getNewsList();
    if(coins.length == 0){

      coins.add('BTC');
      coins.add('XRP');
      coins.add('ETH');

    }

  }
  final List<Widget> pages = [
    Home(
      key: PageStorageKey('home'),
    ),
    Markets_Screen(
      key: PageStorageKey('markets'),
    ),

    News_screen(
      key: PageStorageKey('news'),
    ),
    Settings(
      key: PageStorageKey('setting'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;





  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

    body: PageStorage(
      child: pages[_selectedIndex],
      bucket: bucket,
    ),
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(
          context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _bottomNavigationBar(int selectedIndex) => FABBottomAppBar(
  centerItemText: 'Add Coin',
  color: Colors.grey,
  selectedColor: Colors.black,
  notchedShape: CircularNotchedRectangle(),
  onTabSelected: _selectedTab,
  items: [
  FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
  FABBottomAppBarItem(iconData: Icons.multiline_chart, text: 'Markets'),
  FABBottomAppBarItem(iconData: Icons.assignment, text: 'News'),
  FABBottomAppBarItem(iconData: Icons.settings, text: 'Settings'),
  ],
  );

  void _selectedTab(int index) async{
   await SharedPreferencesHelper.getCurrency();
    setState(() {
      _selectedIndex = index;
    });
  }


  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(

      onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddCoin()));
      },
      //onPressed: _selectedFab,
      tooltip: 'Increment',
      child: Icon(Icons.add),
      elevation: 2.0,
    );
  }
}
