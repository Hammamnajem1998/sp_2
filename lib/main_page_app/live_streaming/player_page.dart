import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gcloud/datastore.dart' ;//as dataStore;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yoyo_player/yoyo_player.dart';
//
// class PlayerPage extends StatefulWidget {
//   const PlayerPage({
//     Key key,
//     @required this.streamUrl,
//   }) : super(Key: key);
//
//   static Route<dynamic> route(String url) {
//     return MaterialPageRoute<dynamic>(
//       builder: (BuildContext context) {
//         return PlayerPage(streamUrl: url);
//       },
//     );
//   }
//
//   final String streamUrl;
//
//   @override
//   _PlayerPageState createState() => _PlayerPageState();
// }
//
// class _PlayerPageState extends State<PlayerPage> {
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: BackButton(
//           color: Colors.black,
//         ),
//         title: Text(
//           "Video",
//           style: GoogleFonts.inter(color: Colors.black),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               flex: 3,
//               child: YoYoPlayer(
//                 aspectRatio: 16 / 9,
//                 url: widget.streamUrl,
//                 videoStyle: VideoStyle(),
//                 videoLoadingStyle: VideoLoadingStyle(),
//               ),
//             ),
//             Expanded(
//               flex: 4,
//               child: Container(), // TODO: Replace with chat
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }