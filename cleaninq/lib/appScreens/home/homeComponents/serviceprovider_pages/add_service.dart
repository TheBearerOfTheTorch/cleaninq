import 'dart:async';
import 'package:cleaninq/appScreens/home/homeComponents/serviceprovider_pages/user_preferences.dart';
import 'package:cleaninq/services/middlewares/service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddServices extends StatefulWidget {
  @override
  _AddServicesState createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  TextEditingController _serviceNameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  //variable
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  //objects
  ProviderAddService _provider = ProviderAddService();


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _aboutController = TextEditingController();
    _serviceNameController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _serviceNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;

    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 32),
                children: [
                  SizedBox(height:MediaQuery.of(context).size.width/7),
                  Text("Add Services",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(height:MediaQuery.of(context).size.width/12),
                  TextFormField(
                    validator: (val)=>
                    val!.isNotEmpty ? null:"Please fill in the name field",
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Organization Name",
                      labelText: 'Organization',
                      prefixIcon:Icon(FontAwesomeIcons.building),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusColor: Colors.white,
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(12),
                      // ),
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    validator: (val)=>
                    val!.isNotEmpty?null:"Please fill the service name field",
                    controller: _serviceNameController,
                    decoration: InputDecoration(
                      hintText: "Service Name",
                      labelText: 'Service',
                      prefixIcon:Icon(FontAwesomeIcons.servicestack),
                      focusColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (val)=>
                    val!.isNotEmpty?null:"Please fill the price field",
                    controller: _priceController,
                    decoration: InputDecoration(
                      hintText: "Price for service",
                      labelText: 'Price',
                      prefixIcon:Icon(FontAwesomeIcons.moneyBill),
                      focusColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    validator: (val)=>
                    val!.isNotEmpty?null:"Please fill service description field",
                    controller: _aboutController,
                    decoration: InputDecoration(
                      hintText: "Description of service",
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width/2.8-100),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: _isLoading?Center(child: CircularProgressIndicator(
                      color: Colors.white,
                    ),):
                    Text("Add Service"),
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          _isLoading = true;
                        });
                        var loading = await _provider.addServices(
                            _nameController.text.trim(),
                            _serviceNameController.text.trim(),
                            _priceController.text.trim(),
                            _aboutController.text.trim()
                        );
                        final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        setState(() {
                          Timer(Duration(seconds: 3), (){
                            setState(() {
                              _isLoading = loading;
                            });
                          });
                        });

                      }
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              child: _isLoading ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
                color: Colors.white.withOpacity(0.7),
              ) : Container(),
            )
          ],
        )
    );
  }
}