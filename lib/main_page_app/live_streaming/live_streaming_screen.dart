import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp1/shop.dart';
//
// import 'live_streaming_home_page.dart';
//
// class LiveStreamScreen extends StatefulWidget {
//   LiveStreamScreen({Key key, this.title, this.shop}) : super(key: key);
//   final String title;
//   final Shop shop;
//   @override
//   _LiveStreamScreenState createState() => _LiveStreamScreenState();
// }
//
// class _LiveStreamScreenState extends State<LiveStreamScreen> {
//
//   TextEditingController urlEditingController = new TextEditingController();
//   TextEditingController nameEditingController = new TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//
//   Future<bool> getData() async {
//
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Form(
//           key: formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               ShaderMask(
//                 shaderCallback: (rect) {
//                   return LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFFf5c3ff),
//                       Color(0xFF0047ff),
//                     ],
//                   ).createShader(rect);
//                 },
//                 child: Icon(
//                   Icons.camera,
//                   color: Colors.white,
//                   size: 100.0,
//                 ),
//               ),
//               const SizedBox(height: 64.0),
//               Container(
//                 margin: const EdgeInsets.symmetric(
//                   horizontal: 48.0,
//                 ),
//                 height: 50.0,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 6.0),
//                   child: Center(
//                     child: TextFormField(
//                       controller: urlEditingController,
//                       decoration: InputDecoration.collapsed(
//                         hintText: "Custom HLS/RTP URL",
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(
//                   horizontal: 48.0,
//                   vertical: 12.0,
//                 ),
//                 height: 50.0,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 6.0),
//                   child: Center(
//                     child: TextFormField(
//                       validator: (val) => (val != null && val.isNotEmpty)
//                           ? null
//                           : "Please enter a name",
//                       controller: nameEditingController,
//                       decoration: InputDecoration.collapsed(
//                         hintText: "Nickname",
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 18.0),
//               ValueListenableBuilder<TextEditingValue>(
//                 valueListenable: urlEditingController,
//                 builder: (context, controller, _) {
//                   if (controller.text.isEmpty) {
//                     return Align(
//                       child: ElevatedButton(
//                         style: ButtonStyle(
//                           shadowColor: MaterialStateColor.resolveWith(
//                                 (states) =>
//                                 const Color(0xff4d7bfe).withOpacity(0.2),
//                           ),
//                           backgroundColor: MaterialStateColor.resolveWith(
//                                 (states) => const Color(0xff4d7bfe),
//                           ),
//                         ),
//                         onPressed: ()  {
//                           // go to home
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => LiveStreamHomePage()),
//                           );
//                         },
//                         child: Text("Continue to home"),
//                       ),
//                     );
//                   } else {
//                     return Align(
//                       child: ElevatedButton(
//                         style: ButtonStyle(
//                           shape: MaterialStateProperty.all(
//                             CircleBorder(),
//                           ),
//                           shadowColor: MaterialStateColor.resolveWith(
//                                 (states) =>
//                                 const Color(0xff4d7bfe).withOpacity(0.2),
//                           ),
//                           backgroundColor: MaterialStateColor.resolveWith(
//                                 (states) => const Color(0xff4d7bfe),
//                           ),
//                         ),
//                         //onPressed: onCustomUrlGoPressed, // TODO: Implement
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Icon(
//                             Icons.arrow_forward,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// }