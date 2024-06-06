import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tugas_modul5/main.dart';
import 'post_test.mock.mocks.dart';

// Generate a MockClient using the Mockito package
@GenerateMocks([http.Client])
void main() {
  testWidgets('Displays post data when fetched successfully',
      (WidgetTester tester) async {
    final client = MockClient();

    // Use Mockito to return a successful response when it calls the provided http.Client
    when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1')))
        .thenAnswer((_) async => http.Response(
              jsonEncode({
                "userId": 1,
                "id": 1,
                "title": "Sample Title",
                "body": "Sample Body",
              }),
              200,
            ));

    // Build the widget
    await tester.pumpWidget(MaterialApp(home: MyApp(client: client)));

    // Verify that the CircularProgressIndicator is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Allow the FutureBuilder to complete
    await tester.pumpAndSettle();

    // Verify that the data is displayed
    expect(find.text('Title: Sample Title\nBody: Sample Body'), findsOneWidget);
  });

  testWidgets('Displays error message when fetching fails',
      (WidgetTester tester) async {
    final client = MockClient();

    // Use Mockito to return an error response when it calls the provided http.Client
    when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1')))
        .thenAnswer((_) async => http.Response('Not Found', 404));

    // Build the widget
    await tester.pumpWidget(MaterialApp(home: MyApp(client: client)));

    // Verify that the CircularProgressIndicator is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Allow the FutureBuilder to complete
    await tester.pumpAndSettle();

    // Verify that the error message is displayed
    expect(find.text('Error: Exception: Failed to load post'), findsOneWidget);
  });
}
