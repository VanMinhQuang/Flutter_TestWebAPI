import 'package:bai5/Model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<User>> data;

  Future<List<User>> fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      final List<dynamic> userJson = jsonDecode(response.body);
      return userJson.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('hihi')),
        body: FutureBuilder(
          future: data,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                {
                  final models = snapshot.data!;
                  return ListView.builder(
                    itemCount: models.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(models[index].title),
                        subtitle: Text(models[index].body),
                      );
                    },
                  );
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
