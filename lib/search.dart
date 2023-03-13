import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Search extends SearchDelegate {
  final List data;

  Search({required this.data});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.close), onPressed: () {
        query = '';
      },)
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return
      IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {
        Navigator.pop(context);
      },);
  }


  @override
  Widget buildResults(BuildContext context) {
    List results = [];
    if (query.isNotEmpty) {
      results = data.where((element) =>
          element['aya_text_emlaey'].toString().contains(query.trim()))
          .toList();

      return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/', arguments: [
                results[index]['page'],
                results[index]['id']
              ]);
            },
            title: Text(
              results[index]['aya_text'],
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: 'Hafs'),
              textAlign: TextAlign.right,
            ),
            subtitle: Text(
              results[index]['sura_name_ar'],
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            leading: Column(
              children: [
                Text('الصفحة'),
                Text(
                  results[index]['page'].toString(),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                )
              ],
            ),
          );
        },
        itemCount: results.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      );
    }
    else {
      return Column(
        children: [],
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Search result'),
    );
  }
}