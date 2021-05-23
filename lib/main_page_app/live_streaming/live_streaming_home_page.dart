import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//
// class LiveStreamHomePage extends StatefulWidget {
//   static Route<dynamic> route() {
//     return MaterialPageRoute<dynamic>(
//       builder: (BuildContext context) {
//         return LiveStreamHomePage();
//       },
//     );
//   }
//
//   @override
//   _LiveStreamHomePageState createState() => _LiveStreamHomePageState();
// }
//
// class _LiveStreamHomePageState extends State<LiveStreamHomePage> {
//   PageController pageController;
//
//   @override
//   void initState() {
//     super.initState();
//     pageController = PageController(viewportFraction: 0.9);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     pageController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () async {
//             // TODO: Handle refresh
//           },
//           child: CustomScrollView(
//             slivers: [
//               CupertinoSliverNavigationBar(
//                 largeTitle: Text(
//                   "Live Flutter",
//                   style: GoogleFonts.inter(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: 200.0,
//                   child: PageView.builder(
//                     controller: pageController,
//                     itemCount: 3,
//                     itemBuilder: (BuildContext context, int index) {
//                       return FeaturedStreamCard(
//                         thumbnailUrl: "https://source.unsplash.com/random/1920x1080",
//                         onTap: () => onFeatureCardPressed(context, item),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               SliverPadding(
//                 padding: const EdgeInsets.only(left: 24.0, top: 42.0),
//                 sliver: SliverToBoxAdapter(
//                   child: Text(
//                     "Browse",
//                     style: GoogleFonts.inter(
//                       color: Colors.black,
//                       fontSize: 32.0,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ),
//               SliverPadding(
//                 padding: const EdgeInsets.only(top: 20.0, left: 12.0, right: 12.0),
//                 sliver: SliverGrid(
//                   delegate: SliverChildBuilderDelegate(
//                         (context, index) {
//                       return FeaturedStreamCard(
//                         thumbnailUrl: "https://source.unsplash.com/random/1920x1080",
//                         onTap: () => onFeatureCardPressed(context, item),
//                       );
//                     },
//                     childCount: 4,
//                   ),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 1.7,
//                     crossAxisSpacing: 12.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void onFeatureCardPressed(BuildContext context, Video item) {
//     // TODO: Configure Channel
//     Navigator.of(context).push(
//       PlayerPage.route(item.playbackUrl),
//     );
//   }
//
// }
//
// class FeaturedStreamCard extends StatelessWidget {
//   const FeaturedStreamCard({
//     Key key,
//     @required this.onTap,
//     this.thumbnailUrl,
//   }) : super(key: key);
//   final VoidCallback onTap;
//   final String thumbnailUrl;
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 16 / 9,
//       child: Card(
//         clipBehavior: Clip.hardEdge,
//         child: InkWell(
//           onTap: onTap,
//           child: Image.network(
//             thumbnailUrl,
//             errorBuilder: (context, _, __){
//               return Image.asset("assets/logo.png");
//             },
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }