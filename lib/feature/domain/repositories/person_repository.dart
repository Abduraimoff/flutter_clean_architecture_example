import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/feature/domain/entities/person_entity.dart';

import '../../../core/error/failure.dart';

abstract class PersonRepository {
  Future<Either<Failure, List<PersonEntity>>> getAllPerson(int page);
  
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query); 
  
}