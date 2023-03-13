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
        query = '' ;
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
    return ListView.builder(
        itemCount: data.length, //data?.length,
        itemBuilder: (context, index) {
          if(!(data[index]["text"].toString().contains(query))){
            return const SizedBox.shrink();
          }
          return ListTile(
            title: Row(
              children: [
                Expanded (
                  child: InkWell (
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 8),
                    decoration: BoxDecoration(
                    color: Colors.white60,

                    borderRadius: BorderRadius.circular(20),
                    ),
                    child:  Text(data[index]["aya_text"].toString(),style: const TextStyle(
                    fontFamily: 'Kitab',
                    color: Colors.black,
                    fontSize: 24,
                    ),
                    maxLines: 4,
                      textDirection: TextDirection.rtl,
                    )
                    ,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Search result'),
    );
  }

}