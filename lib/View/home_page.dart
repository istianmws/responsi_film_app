import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Services/film_model.dart';
import 'search_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 // String apiKey = '46539e83';
  String title = 'The Avengers';
  String baseurl = 'http://www.omdbapi.com/?i=tt3896198&apikey=311570e5';


  List<Movie> movies = [];

  Future<void> fetchMovies() async {
    final url = '$baseurl?t=$title';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> movieList = data['Search'];

      setState(() {
        movies = movieList.map((json) => Movie.fromJson(json)).toList();
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Homepage'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: SearchPage());
              },
            ),
          ],
        ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          Movie movie = movies[index];
          return ListTile(
            title: Text(movie.title ?? ''),
            subtitle: Text(movie.year ?? ''),
            onTap: () {
              // Aksi yang ingin dilakukan ketika item list diklik
              // Misalnya, menampilkan detail film atau navigasi ke halaman lain
              print('IMDB ID: ${movie.imdbID}');
            },
          );
        },
      ),
    );
  }
}
