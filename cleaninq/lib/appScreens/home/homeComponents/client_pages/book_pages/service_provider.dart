import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cleaninq/services/middlewares/client_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WithServiceProvider extends StatefulWidget {
  final provider;
  WithServiceProvider({Key? key, this.provider}) : super(key: key);

  @override
  _WithServiceProviderState createState() => _WithServiceProviderState();
}

class _WithServiceProviderState extends State<WithServiceProvider> {
  TextEditingController _titleController = TextEditingController() ;
  TextEditingController _descriptionController = TextEditingController() ;
  TextEditingController _locationController = TextEditingController() ;
  TextEditingController _anotherDateController = TextEditingController() ;

  ClientBook book = ClientBook();
  final _dateController = TextEditingController() ;
  final _formKey = GlobalKey<FormState>();

  //variable
  String? valueChoose;
  var serviceValue;
  var date;
  bool _isLoading = false;
  bool _done = false;
  bool checkingServiceProvider = false;

  @override
  void initState()
  {
    _titleController = TextEditingController();
    _anotherDateController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    super.initState();
  }

  @override
  void dispose()
  {
    _titleController.dispose();
    _descriptionController.dispose();
    _anotherDateController.dispose();
    _locationController.dispose();
    super.dispose();
  }
  final Stream<QuerySnapshot> _serviceProvider = FirebaseFirestore.instance.collection('servicesProvider').snapshots();
  @override
  Widget build(BuildContext context) {
    return checkingServiceProvider?_isLoading?Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height/2,),
        Center(child: CircularProgressIndicator(),)
      ],
    ):_done?DoneWidget():Container(
      alignment: FractionalOffset.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/1.25,
      child:Form(
          key:_formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              children: [
                SizedBox(height: 30,),
                StreamBuilder<QuerySnapshot>(
                    stream: _serviceProvider,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator(),);
                      }
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Icon(
                              FontAwesomeIcons.servicestack,
                              size: 25.0,
                              color: Color(0xff11b719),
                            ),
                            SizedBox(width: 50,),
                            DropdownButton(
                              value: serviceValue,
                              onChanged: (service){
                                setState(() {
                                  serviceValue = service;
                                });
                              },
                              items: snapshot.data!.docs.map((DocumentSnapshot document) {
                                return DropdownMenuItem<String>(
                                    value: document.get("serviceName").toString(),
                                    child: new Container(
                                      decoration: new BoxDecoration(
                                          borderRadius: new BorderRadius.circular(5.0)
                                      ),
                                      padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
                                      //color: primaryColor,
                                      child: Text(document.get("serviceName",),
                                        style: TextStyle(
                                            color: Color(0xff11b719),
                                            fontSize: 20
                                        ),
                                      ),
                                    )
                                );
                              }).toList(),
                              isExpanded: false,
                              hint: Text(
                                'Select cleaning service',
                                style: TextStyle(color: Color(0xff11b719)),
                              ),
                            )
                          ]
                      );
                    }),
                SizedBox(height: 120,),
                RaisedButton(
                    color: Color(0xff11b719),
                    textColor: Colors.white,
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: _isLoading?Center(child: CircularProgressIndicator(
                          color: Colors.white,
                        ),):Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            Text("Submit", style: TextStyle(fontSize: 24.0)),
                          ],
                        )),
                    onPressed: () async{

                      if(_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        var loading = await book.addCustomerBook(
                            _anotherDateController.text.trim(),
                            _locationController.text.trim(),
                            _descriptionController.text.trim(),
                            serviceValue
                        );
                        Timer(Duration(seconds: 5), (){
                          setState(() {
                            _isLoading = loading;
                            _done = true;
                          });
                        });

                      }
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0))),

              ],
            ),
          )
      ),
    ):NoServiceProvider();
  }
}


class DoneWidget extends StatelessWidget {
  const DoneWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      color: Colors.green,
      child: Column(
        children: [
          SizedBox(height:50),
          Image.asset("assets/images/OIP.jpg",width:2000,height: 265,),
          SizedBox(
            width: 300.0,
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 40.0,
                fontFamily: 'Bobbers',
              ),
              child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText('You booked successfully,'),
                    TyperAnimatedText('please stand by as we process your request'),
                    TyperAnimatedText('Upon completion we will notify you'),
                    TyperAnimatedText('Your visitation to our app is always appreciatted'),
                    TyperAnimatedText('Find out more about a service by pressing the icon in '
                        'the right corner of the services display'),
                    TyperAnimatedText('THANK YOU...'),
                  ]
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NoServiceProvider extends StatelessWidget {
  const NoServiceProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      color: Colors.green,
      child: Column(
        children: [
          SizedBox(height:20),
          Image.asset("assets/images/failed.jpg",width:2000,height: 220,),
          SizedBox(
            width: 300.0,
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 40.0,
                fontFamily: 'Bobbers',
              ),
              child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText('There are no service providers found at the moment!'),
                    TyperAnimatedText('Or no provider for the cleaning service you chose!'),
                    TyperAnimatedText('You can always book with the other option '
                         'and we will assign you any service provider when available'),
                  ]
              ),
            ),
          )
        ],
      ),
    );
  }
}


