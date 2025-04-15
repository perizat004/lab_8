import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'post_event.dart';
import 'post_state.dart';
import '../models/post.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<FetchPosts>((event, emit) async {
      emit(PostLoading());
      try {
        final response = await http
            .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
        if (response.statusCode == 200) {
          final List jsonData = json.decode(response.body);
          final posts = jsonData.map((e) => Post.fromJson(e)).toList();
          emit(PostLoaded(posts));
        } else {
          emit(PostError('Ошибка загрузки данных'));
        }
      } catch (e) {
        emit(PostError('Произошла ошибка: $e'));
      }
    });
  }
}
