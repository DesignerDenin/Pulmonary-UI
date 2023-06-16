import 'package:flutter/material.dart';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:pulmonary/newPatient.dart';
import 'package:pulmonary/tile.dart';
import 'Services/entryDB.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double h_padding = pow(1.03, screenWidth * 0.11) + 60;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Container(
        height: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color.fromARGB(255, 206, 240, 255),
                  width: 1,
                ),
              ),
              padding:
                  EdgeInsets.symmetric(vertical: 40, horizontal: h_padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Pulmonary Disease \nDiagnosis",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 48,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 32),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                        onPressed: () => pickAudio(),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 20, 12, 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Upload Audio',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      IconButton(
                        onPressed: () => modelSheet(),
                        icon: Icon(
                          Icons.more_horiz,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: FutureBuilder(
                    future: EntryDBProvider.db.getAllEntry(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data != null &&
                          snapshot.connectionState != ConnectionState.waiting) {
                        print(snapshot.data.length);
                        return Column(
                          children: [
                            SizedBox(height: 24),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: h_padding, vertical: 8),
                                  child: Tile(
                                    entry: snapshot.data[index],
                                    refresher: () => refresher(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 32),
                          ],
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.all(100),
                          child: Center(
                            child: Container(
                              height: 56,
                              width: 56,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  modelSheet() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Settings(),
        );
      },
    );
  }

  Future pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );

    if (result != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: NewPatient(
              file: result.files.first,
              refresher: refresher,
            ),
          );
        },
      );
    }
  }

  refresher() async {
    setState(() {
      EntryDBProvider.db.getAllEntry();
    });
    return Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
