import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tugas_modul5/main.dart';

import 'post_test.mock.mocks.dart'; // Adjust the import according to your file structure

// Import the generated mock file

@GenerateMocks([http.Client])
void main() {
  group('fetchPosts', () {
    test('returns a Posts object if the http call completes successfully',
        () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the provided http.Client
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1')))
          .thenAnswer((_) async => http.Response(
                jsonEncode({
                  "userId": 1,
                  "id": 1,
                  "title": "Sample Title",
                  "body": "Sample Body",
                }),
                200,
              ));

      expect(await fetchPosts(client), isA<Posts>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an error response when it calls the provided http.Client
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchPosts(client), throwsException);
    });
  });
}
