import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:quran_app_multi_way/search.dart';
import 'package:flutter/material.dart' as material;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
        path: 'assets',

        fallbackLocale: const Locale('ar', 'SA'),
        child: const MyApp(),),
  );
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget  {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 1;
  bool isLoading = false;
  dynamic data;
  List item = [];

  PageController pageController = PageController();

  Future<void> getData() async {
    String response = await rootBundle.loadString('assets/hafs_smart_v8.json');
    var result = await jsonDecode(response);
    print(result);
    setState(() {
      item = result["sura"];
    });
  }


  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran App'),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: Search(data: item));
              },
              icon: const Icon(Icons.search, size: 35,)),
        ],
      ),
      body:PageView.builder(
        controller: pageController,
        reverse: true,
        itemBuilder: (BuildContext context, int index) {
          if (item.isNotEmpty) {
            String byPage = '';
            String surahName = '';
            int jozzNum = 0;
            bool isBasmalahShown = false;

            for (Map ayahData in item) {
              if (ayahData['page'] == index + 1) {
                byPage = byPage + ' ${ayahData['aya_text']}';
              }
            }

            for (Map ayahData in item) {
              if (ayahData['page'] == index + 1) {
                surahName = ayahData['sura_name_ar'];
              }
            }

            for (Map ayahData in item) {
              if (ayahData['page'] == index + 1) {
                jozzNum = ayahData['jozz'];
              }
            }

            for (Map ayahData in item) {
              if (ayahData['page'] == index + 1) {
                if (ayahData['aya_no'] == 1 &&
                    ayahData['sura_name_ar'] != 'الفَاتِحة' &&
                    ayahData['sura_name_ar'] != 'التوبَة') {
                  isBasmalahShown = true;
                  break;
                }
              }
            }

            return SafeArea(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'الجزء $jozzNum',
                                  style: const TextStyle(
                                      fontFamily: 'Kitab', fontSize: 20),
                                  textAlign: TextAlign.center,
                                  textDirection: material.TextDirection.rtl,
                                ),
                                Text(
                                  surahName,
                                  style: const TextStyle(
                                      fontFamily: 'Kitab', fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isBasmalahShown
                                  ? const Text(
                                "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
                                textDirection: material.TextDirection.rtl,
                                style: TextStyle(
                                    fontFamily: 'Hafs', fontSize: 22),
                                textAlign: TextAlign.center,
                              )
                                  : Container(),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                byPage,
                                textDirection: material.TextDirection.rtl,
                                style: const TextStyle(
                                    fontFamily: 'Hafs', fontSize: 22),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                  fontFamily: 'Kitab', fontSize: 18),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xffbce0c5),
                ));
          }
        },
      ),

    );
  }
}