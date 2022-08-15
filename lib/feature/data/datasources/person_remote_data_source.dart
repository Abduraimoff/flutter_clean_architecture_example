import 'dart:convert';

import 'package:http/http.dart ' as http;

import '../../../core/error/exception.dart';
import '../models/person_model.dart';

abstract class PersonRemoteDataSource {
  Future<List<PersonModel>> getAllPerson(int page);
  Future<List<PersonModel>> searchPerson(String query);
}

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  final http.Client client;

  PersonRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PersonModel>> getAllPerson(int page) => _getPersonFromUrl(
      'https://rickandmortyapi.com/api/character/?page=$page');

  @override
  Future<List<PersonModel>> searchPerson(String query) => _getPersonFromUrl(
      'https://rickandmortyapi.com/api/character/?name=$query');

  Future<List<PersonModel>> _getPersonFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final person = json.decode(response.body);
      return (person['results'] as List)
          .map((p) => PersonModel.fromJson(p))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
