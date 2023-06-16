import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'Services/api.dart';
import 'Services/entry.dart';
import 'Services/entryDB.dart';

class NewPatient extends StatefulWidget {
  final file;
  final VoidCallback refresher;
  NewPatient({super.key, required this.file, required this.refresher});

  @override
  State<NewPatient> createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {
  TextEditingController nameController = TextEditingController();
  String _validationMsg = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "File Chosen",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.lightBlue[300],
                ),
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      maxRadius: 24,
                      backgroundColor: Colors.lightBlue[200],
                      child: Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      widget.file.name,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ) ,
          const Text(
            "Patient Name:",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: nameController,
            style: formTextDecoration,
            cursorColor: Colors.lightBlue,
            decoration: formFieldDecoration(),
          ),
          _validationMsg != ''
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      _validationMsg,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                )
              : const SizedBox(height: 8),
          SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 64,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.lightBlue[400],
              ),
              onPressed: () => onPressedCreate(),
              child: !isLoading
                  ? const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Container(
                      height: 24,
                      width: 24,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  onPressedCreate() async {
    formValidator();

    if (_validationMsg == '') {
      setState(() {
        isLoading = true;
      });

      Uint8List bytes = widget.file.bytes;
      String name = nameController.text;
      final res = await Api.predict(bytes, name);

      if (res != null) {
        var entry = Entry();
        entry.name = name;
        entry.url = res["url"];
        entry.result = res["result"];

        var db = EntryDBProvider.db;
        db.newEntry(entry);

        await Future.delayed(Duration(seconds: 1));
        widget.refresher();
      }

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pop();
    }
  }

  formValidator() {
    setState(() {
      _validationMsg = '';
    });

    var text = nameController.text;

    if (text == null || text.isEmpty) {
      setState(() {
        _validationMsg = "* This is a required Field";
      });
      return;
    }
  }

  formFieldDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0)),
      filled: true,
      focusColor: Colors.lightBlue,
      fillColor: Colors.lightBlue[50],
      labelText: "Enter name",
      floatingLabelStyle: TextStyle(color: Colors.transparent),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
    );
  }

  var formTextDecoration = const TextStyle(
    fontSize: 16,
    color: Colors.black87,
    fontWeight: FontWeight.w500,
  );
}
