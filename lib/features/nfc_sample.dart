// import 'package:flutter/material.dart';
// import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

// class NfcSample extends StatefulWidget {
//   const NfcSample({super.key});

//   @override
//   State<NfcSample> createState() => _NfcSampleState();
// }

// class _NfcSampleState extends State<NfcSample> {
//   String nfcData = 'No Data';
//   String nfcDatas = 'No Data';
//   bool isListening = false;

//   @override
//   void initState() {
//     super.initState();
//     initNFC(); // check NFC availability on app start
//   }

//   Future<void> initNFC() async {
//     var availability = await FlutterNfcKit.nfcAvailability;
//     if (availability == NFCAvailability.not_supported) {
//       setState(() {
//         nfcData = 'NFC not supported on this device';
//       });
//     } else if (availability == NFCAvailability.not_supported) {
//       setState(() {
//         nfcData = 'NFC not available';
//       });
//     } else if (availability == NFCAvailability.disabled) {
//       setState(() {
//         nfcData = 'NFC disabled, please enable NFC';
//       });
//     } else if (availability == NFCAvailability.available) {
//       setState(() {
//         nfcData = 'NFC available';
//       });
//     }
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(nfcData),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           const SizedBox(height: 50),
//             InkWell(
//               splashFactory: NoSplash.splashFactory,
//               highlightColor: Colors.transparent,
//               onTap: () {
//                 toggleListening();
//               },
//               child: Container(
//                 height: 50,
//                 margin: const EdgeInsets.only(right: 20, left: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.green,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     isListening ? 'Stop Listening' : 'Start Listening',
//                     style: const TextStyle(
//                         color: Colors.black, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Future<void> toggleListening() async {
//     setState(() {
//       isListening =
//           !isListening; // Toggle the listening state immediately when the button is pressed
//     });

//     if (isListening) {
//       var availability = await FlutterNfcKit.nfcAvailability;
//       if (availability == NFCAvailability.available) {
//         while (isListening) {
//           try {
//             final NFCTag tag = await FlutterNfcKit.poll();
//             setState(() {
//               nfcDatas = tag.id;
//               print(tag);
//             });
//           } on Exception catch (e) {
//             setState(() {
//               nfcDatas = 'Error reading NFC: $e';
//               isListening = false; // Stop listening if there's an error
//             });
//           }
//         }
//       } else {
//         setState(() {
//           nfcDatas = 'NFC not available';
//         });
//       }
//     } else {
//       // If the user wants to stop listening
//       FlutterNfcKit.finish();
//     }
//   }
// }
