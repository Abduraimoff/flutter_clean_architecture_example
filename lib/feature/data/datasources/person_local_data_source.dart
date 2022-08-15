import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exception.dart';
import '../models/person_model.dart';

abstract class PersonLocalDataSource {
  Future<List<PersonModel>> getLastPeopleFromCache();
  Future<void> peopleToCache(List<PersonModel> people);
}

class PersonLocalDataSourceImp implements PersonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PersonLocalDataSourceImp({required this.sharedPreferences});

  @override
  Future<List<PersonModel>> getLastPeopleFromCache() {
    final jsonPeople = sharedPreferences.getStringList('CACHED_PEOPLE');
    if (jsonPeople!.isNotEmpty) {
      print('Get Persons from Cache: ${jsonPeople.length}');

      return Future.value(jsonPeople
          .map((person) => PersonModel.fromJson(jsonDecode(person)))
          .toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future peopleToCache(List<PersonModel> people) {
    final List<String> jsonPeople =
        people.map((person) => jsonEncode(person.toJson())).toList();

    sharedPreferences.setStringList('CACHED_PEOPLE', jsonPeople);

    print('People to write Cache: ${jsonPeople.length}');

    return Future.value(jsonPeople);
  }
}
