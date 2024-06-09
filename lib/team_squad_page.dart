import 'package:flutter/material.dart';
import 'package:squadify/constants.dart';
import 'package:squadify/teams.dart';

class TeamPlayesPage extends StatefulWidget {
  const TeamPlayesPage(
      {super.key, required this.players, required this.teamName});
  final List<Player> players;
  final String teamName;
  @override
  State<TeamPlayesPage> createState() => _TeamPlayesPageState();
}

class _TeamPlayesPageState extends State<TeamPlayesPage> {
  final FocusNode _searchFieldFocusNode = FocusNode();

  final TextEditingController _searchFieldController = TextEditingController();

  List<Player> filteredPlyers = [];
  bool isSearching = false;

  void doSearch(String value) {
    filteredPlyers = widget.players
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _searchFieldFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actionsIconTheme: IconThemeData(color: Colors.white),
          backgroundColor: mainColor,
          title: Text(
            widget.teamName,
            style: const TextStyle(
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
                  hintText: 'Search player',
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
                    "Squad Members:",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
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
                  itemCount: isSearching
                      ? filteredPlyers.length
                      : widget.players.length,
                  itemBuilder: (context, index) {
                    return PlayerCard(
                        player: isSearching
                            ? filteredPlyers[index]
                            : widget.players[index]);
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

class PlayerCard extends StatelessWidget {
  final Player player;

  const PlayerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      // borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Container(
                clipBehavior: Clip.antiAlias,
                height: 150,
                // width: double.infinity,

                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10), // color: Colors.amber,

                    image: DecorationImage(
                        image: NetworkImage(player.imageUrl),
                        fit: BoxFit.contain))),
          ),

          // Container(
          //   color: Colors.red,
          //   child: Image.asset(
          //     height: 100,
          //     player.imageUrl,
          //     fit: BoxFit.fitWidth,
          //   ),
          // ),
          //const Spacer(),
          Container(
            decoration: BoxDecoration(
                color: mainColor,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Text(
                    player.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11.0,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
