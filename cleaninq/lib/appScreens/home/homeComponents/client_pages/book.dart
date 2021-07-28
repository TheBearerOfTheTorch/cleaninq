import 'package:cleaninq/appScreens/home/homeComponents/client_pages/book_pages/random_provider.dart';
import 'package:cleaninq/appScreens/home/homeComponents/client_pages/book_pages/service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookServices extends StatefulWidget {
  String? service;
  BookServices({Key? key,this.service}) : super(key: key);

  @override
  _BookServicesState createState() => _BookServicesState();
}

class _BookServicesState extends State<BookServices> {
  //loading progress
  bool _isLoading = false;

  int _currentIndex = 0;
  String? passOn;

  final tabs = [
    WithOutProvider(),
    WithServiceProvider(),
  ];

  String? passItOn(){
    return passOn;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Text("Book for ${widget.service} services"),
        ),
      ),
      body: SingleChildScrollView(child: tabs[_currentIndex],),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(
              Icons.cleaning_services,
            ),
              label:'${widget.service} service',
            ),
            BottomNavigationBarItem(icon: Icon(
              Icons.clean_hands_sharp,
            ),
              label:'${widget.service} service provider',
            )
          ],
          onTap: (index)
          {
            setState(() {
              _currentIndex = index;
            });
          }
      ),
    );
  }
}


