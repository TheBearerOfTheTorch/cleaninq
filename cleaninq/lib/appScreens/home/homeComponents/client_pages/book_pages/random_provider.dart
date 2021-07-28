import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cleaninq/services/middlewares/client_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WithOutProvider extends StatefulWidget {
  final provider;
  WithOutProvider({Key? key, this.provider}) : super(key: key);

  @override
  _WithOutProviderState createState() => _WithOutProviderState();
}

class _WithOutProviderState extends State<WithOutProvider> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _anotherDateController = TextEditingController();
  TextEditingController timeCtl = TextEditingController();

  ClientBook book = ClientBook();
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //variable
  String? valueChoose;
  var serviceValue;
  var date;
  bool _isLoading = false;
  bool _done = false;

  @override
  void initState() {
    _titleController = TextEditingController();
    _anotherDateController = TextEditingController();
    timeCtl = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    timeCtl.dispose();
    _anotherDateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  final Stream<QuerySnapshot> _cleaningServices =
      FirebaseFirestore.instance.collection('services').snapshots();
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
              ),
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          )
        : _done
            ? DoneWidget()
            : Container(
                alignment: FractionalOffset.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.25,
                child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        children: [
                          SizedBox(height: 30.0),
                          TextFormField(
                            readOnly: true,
                            validator: (val) =>
                                val!.isNotEmpty ? null : "Please select date",
                            controller: _anotherDateController,
                            decoration: const InputDecoration(
                              icon: Icon(
                                FontAwesomeIcons.calendarDay,
                              ),
                              hintText: 'Select your book date',
                              labelText: 'Date',
                            ),
                            onTap: () async {
                              final initialDate = DateTime.now();
                              var nedate = await showDatePicker(
                                  context: context,
                                  initialDate: date ?? initialDate,
                                  firstDate: DateTime(DateTime.now().year),
                                  lastDate: DateTime(DateTime.now().year + 1));

                              if (nedate == null) return;

                              setState(() {
                                date = nedate;
                              });
                              _anotherDateController.text =
                                  date.toString().substring(0, 10);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: timeCtl, // add this line.
                            decoration: InputDecoration(
                              icon: Icon(
                                FontAwesomeIcons.userClock,
                              ),
                              hintText: 'Select your book time',
                              labelText: 'Time',
                            ),
                            onTap: () async {
                              TimeOfDay time = TimeOfDay.now();
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              TimeOfDay? picked = await showTimePicker(
                                  context: context, initialTime: time);
                              if (picked != null && picked != time) {
                                timeCtl.text =
                                    picked.toString(); // add this line.
                                setState(() {
                                  time = picked;
                                });
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'cant be empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(
                                FontAwesomeIcons.addressBook,
                              ),
                              hintText: "Location/ward/plot/city",
                              labelText: 'Full Address',
                            ),
                            controller: _locationController,
                            validator: (val) => val!.isNotEmpty
                                ? null
                                : "Please enter Your location location/ward/plot/city",
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(
                                FontAwesomeIcons.audioDescription,
                              ),
                              hintText: "Describe your prefered service",
                              labelText: 'Description',
                            ),
                            controller: _descriptionController,
                            validator: (val) => val!.isNotEmpty
                                ? null
                                : "Please we need to know how to do the work",
                          ),
                          SizedBox(height: 40.0),
                          StreamBuilder<QuerySnapshot>(
                              stream: _cleaningServices,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.servicestack,
                                        size: 25.0,
                                        color: Color(0xff11b719),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      DropdownButton(
                                        value: serviceValue,
                                        onChanged: (service) {
                                          setState(() {
                                            serviceValue = service;
                                          });
                                        },
                                        items: snapshot.data!.docs
                                            .map((DocumentSnapshot document) {
                                          return DropdownMenuItem<String>(
                                              value: document
                                                  .get("serviceName")
                                                  .toString(),
                                              child: new Container(
                                                decoration: new BoxDecoration(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0)),
                                                padding: EdgeInsets.fromLTRB(
                                                    10.0, 2.0, 10.0, 0.0),
                                                //color: primaryColor,
                                                child: Text(
                                                  document.get(
                                                    "serviceName",
                                                  ),
                                                  style: TextStyle(
                                                      color: Color(0xff11b719),
                                                      fontSize: 20),
                                                ),
                                              ));
                                        }).toList(),
                                        isExpanded: false,
                                        hint: Text(
                                          'Select Service',
                                          style: TextStyle(
                                              color: Color(0xff11b719)),
                                        ),
                                      )
                                    ]);
                              }),
                          SizedBox(
                            height: 120,
                          ),
                          RaisedButton(
                              color: Color(0xff11b719),
                              textColor: Colors.white,
                              child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: _isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text("Submit",
                                                style:
                                                    TextStyle(fontSize: 24.0)),
                                          ],
                                        )),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  var loading = await book.addCustomerBook(
                                      _anotherDateController.text.trim(),
                                      _locationController.text.trim(),
                                      _descriptionController.text.trim(),
                                      serviceValue,
                                      time: timeCtl.text.trim());
                                  Timer(Duration(seconds: 5), () {
                                    setState(() {
                                      _isLoading = loading;
                                      _done = true;
                                    });
                                  });
                                }
                              },
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(20.0))),
                        ],
                      ),
                    )),
              );
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
          SizedBox(height: 50),
          Image.asset(
            "assets/images/OIP.jpg",
            width: 2000,
            height: 265,
          ),
          SizedBox(
            width: 300.0,
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 40.0,
                fontFamily: 'Bobbers',
              ),
              child: AnimatedTextKit(animatedTexts: [
                TyperAnimatedText('You booked successfully,'),
                TyperAnimatedText('please stand by as we process your request'),
                TyperAnimatedText('Upon completion we will notify you'),
                TyperAnimatedText(
                    'Your visitation to our app is always appreciatted'),
                TyperAnimatedText(
                    'Find out more about a service by pressing the icon in '
                    'the right corner of the services display'),
                TyperAnimatedText('THANK YOU...'),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
