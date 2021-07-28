// import 'package:cleaninq/services/authentication_services/auth_services.dart';
// import 'package:cleaninq/services/middlewares/admin_add.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class UpdatingServices extends StatefulWidget {
//   const UpdatingServices({Key? key}) : super(key: key);
//
//   @override
//   _UpdatingServicesState createState() => _UpdatingServicesState();
// }
//
// class _UpdatingServicesState extends State<UpdatingServices> {
//   TextEditingController _titleController = TextEditingController() ;
//   TextEditingController _descriptionController = TextEditingController() ;
//   TextEditingController _otherController = TextEditingController() ;
//   AdminServices  add = AdminServices();
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState()
//   {
//     _titleController = TextEditingController();
//     _descriptionController = TextEditingController();
//
//     super.initState();
//   }
//
//   @override
//   void dispose()
//   {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(child: Scaffold(
//       body: SingleChildScrollView(
//           child:Form(
//               key:_formKey,
//               child: Padding(
//                 padding: const EdgeInsets.all(.0),
//                 child: Container(
//                   margin:EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           Icons.arrow_back_ios,
//                           color:Theme.of(context).primaryColor,
//                         ),
//                         onPressed: (){
//                           this.dispose();
//                         },
//                       ),
//                       Center(child: Text("Updating cleaning services")),
//                       SizedBox(height:20),
//                       TextFormField(
//                           controller:_titleController,
//                           validator: (val)=>
//                           val!.isNotEmpty ? null:"Please enter the name of the service",
//                           decoration:InputDecoration(
//                               hintText: "Service UID to update",
//                               prefixIcon:Icon(Icons.mail),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               )
//                           )
//                       ),
//                       SizedBox(height:20),
//                       TextFormField(
//                           controller:_descriptionController,
//                           validator: (val)=>
//                           val!.isNotEmpty ? null:"Please update description",
//                           decoration:InputDecoration(
//                               hintText: "update Description",
//                               prefixIcon:Icon(Icons.zoom_out_map_rounded),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               )
//                           )
//                       ),
//                       SizedBox(height:340),
//                       MaterialButton(
//                           onPressed:() async{
//                             if(_formKey.currentState!.validate()) {
//                               await add.addService(
//                                 _titleController.text.trim(),
//                                 _descriptionController.text.trim(),
//                                 _otherController.text.trim()
//                               );
//                             }
//                           },
//                           height:70,
//                           minWidth: double.infinity,
//                           color: Theme.of(context).primaryColor,
//                           textColor:Colors.white,
//                           shape:RoundedRectangleBorder(
//                             borderRadius:BorderRadius.circular(10),
//                           ),
//                           child:Center(
//                               child:
//                               Text("Update Services" ,
//                                   style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,)
//                               )
//                           )),
//                     ],
//                   ),
//                 ),
//               )
//           )
//       ),
//     ));
//   }
// }
