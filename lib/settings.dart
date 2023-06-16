import 'package:flutter/material.dart';

import 'Utils/global.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (apiURL.isEmpty) {
      apiURL = defaultURL;
    }
    urlController.text = apiURL;
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
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "API Source:",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                child: Text("Reset"),
                onPressed: () => setState(() {
                  urlController.text = defaultURL;
                }),
              ),
            ],
          ),
          SizedBox(height: 16),
          TextField(
            controller: urlController,
            style: formTextDecoration,
            cursorColor: Colors.lightBlue,
            decoration: formFieldDecoration(),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 64,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.lightBlue[400],
              ),
              onPressed: () {
                setState(() {
                  apiURL = urlController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  formFieldDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0)),
      filled: true,
      focusColor: Colors.lightBlue,
      fillColor: Colors.lightBlue[50],
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
