import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();
  bool isLoading = false;
  List posts = [];
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(_scrollLister);
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(12),
          itemCount: isLoading ?  posts.length + 1 : posts.length,
          itemBuilder: (context, index) {
            if(index < posts.length){
              final post = posts[index];
              final title = post['title']['rendered'];
              final description = post['primary_category']['description'];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    '$title',
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    '$description',
                    maxLines: 2,
                  ),
                ),
              );
            }else{
              return const Center(child: CircularProgressIndicator(),);
            }
          }),
    );
  }

  Future<void> fetchPosts() async {
    final url =
        'https://techcrunch.com/wp-json/wp/v2/posts?context=embed&per_page=15&page=$page';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      setState(() {
        posts = posts + json;
      });
    } else {

    }
  }

  Future<void> _scrollLister() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
      page = page + 1;
      await fetchPosts();
      setState(() {
        isLoading = false;
      });

    } else {
    }
  }
}
