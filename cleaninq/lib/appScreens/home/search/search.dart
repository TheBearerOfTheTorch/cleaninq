import 'package:cleaninq/appScreens/home/search/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'category_card.dart';
import 'constants.dart';
import 'details_screen.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        //padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height / 1.22,
        child: Stack(
          children: [
            Container(
              // Here the height of the container is 45% of our total height
              height: size.height * .45,
              decoration: BoxDecoration(
                color: Color(0xFF92EA87),
                image: DecorationImage(
                  alignment: Alignment.centerLeft,
                  image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Approved services and  \nPayments",
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 8,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 4 - 5,
                      child: Flex(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Container(
                                    // padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 17),
                                          blurRadius: 17,
                                          spreadRadius: -23,
                                          color: kShadowColor,
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildPopupDialog(context,
                                                    title: "Services",
                                                    content:
                                                        "There are no pending Services"),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            children: [
                                              Spacer(),
                                              SvgPicture.asset(
                                                  "assets/icons/Hamburger.svg"),
                                              Spacer(),
                                              Text(
                                                "Pending Services",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(fontSize: 15),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Container(
                                    // padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 17),
                                          blurRadius: 17,
                                          spreadRadius: -23,
                                          color: kShadowColor,
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildPopupDialog(context,
                                                    title: "Payments",
                                                    content:
                                                        "There are no pending payments"),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            children: [
                                              Spacer(),
                                              SvgPicture.asset(
                                                  "assets/icons/Excrecises.svg"),
                                              Spacer(),
                                              Text(
                                                "Pending Payments",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(fontSize: 15),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                        direction: Axis.horizontal,
                      ),
                    ),
                    //SizedBox(height: 1),
                    Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      child: Flex(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width / 5,
                              ),
                              Text(
                                "Approved and Paid",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width / 20,
                              ),
                              StreamBuilder(builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  AlertDialog(
                                    backgroundColor: Colors.red,
                                    title: Text(
                                      "An error has Occurred",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return AlertDialog(
                                    content: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasData) {
                                  return Card(
                                    child: ListTile(
                                      title: Text("hey"),
                                    ),
                                  );
                                }
                                return Center(
                                  child: Text("There are no payments found!"),
                                );
                              })
                            ],
                          )),
                        ],
                        direction: Axis.horizontal,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildPopupDialog(BuildContext context, {title, content}) {
    return new AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(content),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text('Close'),
        ),
      ],
    );
  }
}
