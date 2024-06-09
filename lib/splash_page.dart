import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:squadify/constants.dart';
import 'package:squadify/teams_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? teamsData = prefs.getString('teamsData');

    if (teamsData == null) {
      // Data not available locally, fetch from API
      await _fetchAndSaveTeamsData();
    }

    // Navigate to HomePage after loading data
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  Future<void> _fetchAndSaveTeamsData() async {
    try {
      final response = await http.get(Uri.parse("https://demo.sops.pk/teams"));
      if (response.statusCode == 200) {
        final teamsList = jsonDecode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('teamsData', jsonEncode(teamsList));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        color: mainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.14,
            ),
            const Text(
              "ICC Men's",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text(
              "T20 World Cup",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(
                "2024",
                style: TextStyle(
                    color: mainColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/splash_image.png",
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Teams Squads",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.delayed(Duration(seconds: 2), () {
//       Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const HomePage()));
//     });
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: MediaQuery.sizeOf(context).width,
//         height: MediaQuery.sizeOf(context).height,
//         color: mainColor,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: MediaQuery.sizeOf(context).height * 0.14,
//             ),
//             const Text(
//               "ICC Men's",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const Text(
//               "T20 World Cup",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Container(
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(2)),
//                 color: Colors.white,
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//               child: Text(
//                 "2024",
//                 style: TextStyle(
//                     color: mainColor,
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Image.asset(
//                 "assets/splash_image.png",
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             const Text(
//               "Teams Squads",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 40,
//                   fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
