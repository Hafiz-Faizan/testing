import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Language {
  final String name;
  final String subTitle;

  Language(this.name, this.subTitle);
}

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  List<Language> languages = [
    Language('Afrikaans', ''),
    Language('Bahasa Indonesia', 'Indonesian'),
    Language('Deutsch', 'German'),
    Language('English (UK)', ''),
    Language('Filipino', ''),
    Language('Italiano', 'Italian'),
    Language('Magyar', 'Hungarian'),
    Language('Polski', 'Polish'),
    Language('Suomi', 'Finnish'),
    Language('Svenska', 'Swedish'),
    Language('Romana', 'Romanian'),
  ];

  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'English (UK)';
    });
  }

  Future<void> _saveSelectedLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLanguage', language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Languages', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  languages = languages
                      .where((language) =>
                  language.name.toLowerCase().contains(value.toLowerCase()) ||
                      language.subTitle
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(languages[index].name),
                  subtitle: languages[index].subTitle.isNotEmpty
                      ? Text(languages[index].subTitle)
                      : null,
                  trailing: selectedLanguage == languages[index].name
                      ? Icon(Icons.check, color: Colors.purple)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedLanguage = languages[index].name;
                    });
                    _saveSelectedLanguage(languages[index].name);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
