import 'package:flutter/material.dart';
import 'package:pulmonary/Utils/player.dart';
import 'Services/entry.dart';
import 'Services/entryDB.dart';

class Tile extends StatefulWidget {
  final Entry entry;
  final VoidCallback refresher;
  const Tile({super.key, required this.entry, required this.refresher});

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  String audioPath = '';
  String name = '';
  String result = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.entry.name;
    result = widget.entry.result;
    audioPath = widget.entry.url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 206, 240, 255),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
            ),
            width: 100,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Player(path: audioPath),
          ),
          SizedBox(width: 20),
          Container(
            alignment: Alignment.center,
            child: Text(
              result.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
            ),
            width: 100,
          ),
          SizedBox(width: 24),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.black87,
              size: 16,
            ),
            onSelected: (String choice) {
              if (choice == 'Delete') {
                delete();
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Delete',
                  child: Text(
                    'Delete',
                    style: subTextDecoration,
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  delete() async {
    var db = EntryDBProvider.db;
    db.deleteEntry(widget.entry.id!.toInt());
    widget.refresher();
  }

  var subTextDecoration = const TextStyle(
    fontSize: 14,
    color: Colors.black87,
    fontWeight: FontWeight.w400,
  );
}
