import 'package:flutter/material.dart';
import 'package:google_translate/services/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  TextEditingController langController = TextEditingController();
  String _currentLanguage = 'en';
  String _requiredLanguage = 'en';
  List<String> _languages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    _languages = await Api().fetchLanguages();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    langController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TransLateMe'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _showLanguageModal(context, true);
                  setState(() {});
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.15,
                    width: MediaQuery.of(context).size.width * 0.5,
                    color: Colors.grey,
                    child: Center(
                      child: Text(
                        _currentLanguage,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Icon(Icons.compare_arrows_sharp),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showLanguageModal(context, false);
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.15,
                    width: MediaQuery.of(context).size.width * 0.5,
                    color: Colors.grey,
                    child: Center(
                      child: Text(
                        _requiredLanguage,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Current Language: $_currentLanguage',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: langController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter text to translate',
                  ),
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final value = await Api().translateText(
                    langController.text,
                    _currentLanguage,
                    _requiredLanguage,
                  );

                  setState(() {
                    if (value != "(())") {
                      controller.text = value;
                    } else {
                      controller.text = "API Error Occurred";
                    }
                    isLoading = false;
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.15,
                    width: MediaQuery.of(context).size.width * 0.5,
                    color: Colors.grey,
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Translate',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Required Language: $_requiredLanguage',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: controller,
                  enabled: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Translated text',
                  ),
                  maxLines: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageModal(BuildContext context, bool isCurrentLanguage) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search language',
                  ),
                  onChanged: (value) {
                    // Code to filter the list of languages based on the search query
                    setState(() {
                      _languages = _languages
                          .where((language) => language
                              .toLowerCase()
                              .startsWith(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _languages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_languages[index]),
                        onTap: () {
                          setState(() {
                            if (isCurrentLanguage) {
                              _currentLanguage = _languages[index];
                            } else {
                              _requiredLanguage = _languages[index];
                            }
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    ).then((value) {
      setState(() {});
    });
  }
}
