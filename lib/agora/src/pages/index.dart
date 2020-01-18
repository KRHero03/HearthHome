// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import './call.dart';

// class IndexPage extends StatefulWidget {
// //   final String code;
// //   IndexPage(this.code);
// //   @override
// //   State<StatefulWidget> createState() => IndexState();
// // }

// // class IndexState extends State<IndexPage> {
// //   /// create a channelController to retrieve text value
// //   final _channelController = TextEditingController();

// //   /// if channel textField is validated to have error
// //   bool _validateError = false;

// //   @override
// //   void dispose() {
// //     // dispose input controller
// //     _channelController.dispose();
// //     super.dispose();
// //   }

// //   @override
//   Widget build(BuildContext context) {
//     //   _channelController.text = widget.code;

//     //   return
//     //   // return Scaffold(
//     //   appBar: AppBar(
//     //     title: Text('Agora Flutter QuickStart'),
//     //   ),
//     //   body: Center(
//     //     child: Container(
//     //       padding: const EdgeInsets.symmetric(horizontal: 20),
//     //       height: 400,
//     //       child: Column(
//     //         children: <Widget>[
//     //           Row(
//     //             children: <Widget>[
//     //               Expanded(
//     //                   child: TextField(
//     //                 controller: _channelController,
//     //                 decoration: InputDecoration(
//     //                   errorText:
//     //                       _validateError ? 'Channel name is mandatory' : null,
//     //                   border: UnderlineInputBorder(
//     //                     borderSide: BorderSide(width: 1),
//     //                   ),
//     //                   hintText: 'Channel name',
//     //                 ),
//     //               ))
//     //             ],
//     //           ),
//     //           Padding(
//     //             padding: const EdgeInsets.symmetric(vertical: 20),
//     //             child: Row(
//     //               children: <Widget>[
//     //                 Expanded(
//     //                   child: RaisedButton(
//     //                     onPressed: onJoin,
//     //                     child: Text('Join'),
//     //                     color: Colors.blueAccent,
//     //                     textColor: Colors.white,
//     //                   ),
//     //                 )
//     //               ],
//     //             ),
//     //           )
//     //         ],
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }

//   Future<void> onJoin(String code) async {
//     // update input validation
//     if (code.isNotEmpty) {
//       // await for camera and mic permissions before pushing video page
//       await _handleCameraAndMic();
//       // push video page with given channel name
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CallPage(
//             channelName: code,
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> _handleCameraAndMic() async {
//     await PermissionHandler().requestPermissions(
//       [PermissionGroup.camera, PermissionGroup.microphone],
//     );
//   }
// }
