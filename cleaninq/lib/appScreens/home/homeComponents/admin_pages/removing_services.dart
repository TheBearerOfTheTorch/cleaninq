// import 'package:cleaninq/services/middlewares/admin_add.dart';
// import 'package:flutter/material.dart';
//
// class RemovingServices extends StatefulWidget {
//   const RemovingServices({Key? key}) : super(key: key);
//
//   @override
//   _RemovingServicesState createState() => _RemovingServicesState();
// }
//
// class _RemovingServicesState extends State<RemovingServices> {
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
//     _otherController = TextEditingController();
//
//     super.initState();
//   }
//
//   @override
//   void dispose()
//   {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _otherController.dispose();
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
//                       Center(child: Text("Removing Cleaning services")),
//                       SizedBox(height:40),
//                       TextFormField(
//                           controller:_titleController,
//                           validator: (val)=>
//                           val!.isNotEmpty ? null:"Enter service UID to Remove",
//                           decoration:InputDecoration(
//                               hintText: "service UID",
//                               prefixIcon:Icon(Icons.mail),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               )
//                           )
//                       ),
//                       SizedBox(height:400),
//                       MaterialButton(
//                           onPressed:() async{
//                             if(_formKey.currentState!.validate()) {
//                               await add.addService(
//                                 _titleController.text.trim(),
//                                 _descriptionController.text.trim(),
//                                 _otherController.text.trim(),
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
//                               Text("Remove CLEANING service" ,
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
