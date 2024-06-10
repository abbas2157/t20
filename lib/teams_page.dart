import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:squadify/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squadify/splash_page.dart';

import 'package:squadify/team_squad_page.dart';
import 'package:squadify/teams.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SplashScreen splashScreen = SplashScreen();
  final FocusNode _searchFieldFocusNode = FocusNode();
  final TextEditingController _searchFieldController = TextEditingController();

  List<Team> filteredTeams = [];
  List<Team> teams = [];

  bool isSearching = false;
  void doSearch(String value) {
    filteredTeams = teams
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    print(filteredTeams[0].name);
  }

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? teamsData = prefs.getString('teamsData');

    if (teamsData != null) {
      final teamsList = jsonDecode(teamsData);
      for (Map<String, dynamic> item in teamsList) {
        teams.add(Team.fromJson(item));
      }
      setState(() {});
    } else {
      await _fetchAndSaveTeamsData();
    }
  }

  Future<void> _fetchAndSaveTeamsData() async {
    try {
      final response = await http.get(Uri.parse("https://demo.sops.pk/teams"));
      if (response.statusCode == 200) {
        final teamsList = jsonDecode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('teamsData', jsonEncode(teamsList));

        for (Map<String, dynamic> item in teamsList) {
          teams.add(Team.fromJson(item));
        }
        setState(() {});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _searchFieldFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text(
            "Squadify",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: kPadding(context)),
          child: Column(
            children: [
              SizedBox(
                height: kPadding(context),
              ),
              TextFormField(
                controller: _searchFieldController,
                focusNode: _searchFieldFocusNode,
                cursorColor: mainColor,
                onChanged: (value) {
                  isSearching = value.isNotEmpty;
                  doSearch(value);
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search teams',
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: _searchFieldController.text.isEmpty
                      ? const Icon(Icons.search, color: Colors.grey)
                      : Icon(Icons.search, color: mainColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: mainColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                ),
              ),
              SizedBox(
                height: kPadding(context),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Explore the squads of your favorite teams:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: kPadding(context),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: isSearching ? filteredTeams.length : teams.length,
                  itemBuilder: (context, index) {
                    return TeamCard(
                        team:
                            isSearching ? filteredTeams[index] : teams[index]);
                  },
                  padding: const EdgeInsets.all(0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final Team team;

  const TeamCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamPlayesPage(
              players: team.players,
              teamName: team.name,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        // borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(
              height: 80,
              team.imageUrl,
              fit: BoxFit.fitWidth,
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    Text(
                      team.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white),
                    ),
                    Text(
                      'Players: ${team.players.length}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
