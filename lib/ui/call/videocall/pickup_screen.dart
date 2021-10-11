// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:flutter/material.dart';
// // import 'package:livetraxdigitl/ui/VideoCall/call.dart';
// // import 'package:livetraxdigitl/ui/call/videocall/callModel.dart';
// // import 'package:livetraxdigitl/ui/call/videocall/call_methods.dart';
// //
// // class PickupScreen extends StatelessWidget {
// //   final callModel call;
// //
// //   // final CallMethods callMethods = CallMethods();
// //
// //   PickupScreen({
// //     @required this.call,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         alignment: Alignment.center,
// //         padding: EdgeInsets.symmetric(vertical: 100),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Text(
// //               "Incoming...",
// //               style: TextStyle(
// //                 fontSize: 30,
// //               ),
// //             ),
// //             SizedBox(height: 50),
// //             Container(
// //                 width: 80,
// //                 height: 80,
// //                 margin: EdgeInsets.only(right: 5),
// //                 child: Image(
// //                     image: AssetImage('assets/images/sample.png'),
// //                     fit: BoxFit.fill,
// //                     alignment: Alignment.topCenter)),
// //             // CachedNetworkImageProvider(
// //             //   call.callerPic,
// //             //   isRound: true,
// //             //   radius: 180,
// //             // ),
// //             SizedBox(height: 15),
// //             Text(
// //               "ABCD",
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 20,
// //               ),
// //             ),
// //             SizedBox(height: 75),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: <Widget>[
// //                 IconButton(
// //                   icon: Icon(Icons.call_end),
// //                   color: Colors.redAccent,
// //                   onPressed: () async {
// //                     // await callMethods.endCall(call: call);
// //                   },
// //                 ),
// //                 SizedBox(width: 25),
// //                 IconButton(
// //                     icon: Icon(Icons.call),
// //                     color: Colors.green,
// //                     onPressed: () async =>
// //                         // await Permissions.cameraAndMicrophonePermissionsGranted()
// //                         //     ?
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => CallPage(),
// //                           ),
// //                         )
// //                     // : {},
// //                     ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:livetraxdigitl/ui/VideoCall/call.dart';
// import 'package:livetraxdigitl/ui/call/videocall/callModel.dart';
// import 'package:livetraxdigitl/ui/call/videocall/call_methods.dart';
//
// class PickupScreen extends StatelessWidget {
//   final callModel call;
//   final CallMethods callMethods = CallMethods();
//
//   PickupScreen({
//     @required this.call,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//         padding: EdgeInsets.symmetric(vertical: 100),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               "Incoming...",
//               style: TextStyle(
//                 fontSize: 30,
//               ),
//             ),
//             SizedBox(height: 50),
//             // CachedImage(
//             //   call.callerPic,
//             //   isRound: true,
//             //   radius: 180,
//             // ),
//             SizedBox(height: 15),
//             Text(
//               call.callerName,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//             SizedBox(height: 75),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.call_end),
//                   color: Colors.redAccent,
//                   onPressed: () async {
//                     await callMethods.endCall(call: call);
//                   },
//                 ),
//                 SizedBox(width: 25),
//                 IconButton(
//                   icon: Icon(Icons.call),
//                   color: Colors.green,
//                   onPressed: () async =>
//                   // await Permissions.cameraAndMicrophonePermissionsGranted()
//                   //     ?
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CallPage(),
//                     ),
//                   )
//                       // : {},
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
