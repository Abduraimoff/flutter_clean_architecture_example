import 'package:bloc/bloc.dart';
import 'package:flutter_clean_architecture/feature/domain/entities/person_entity.dart';

import 'package:flutter_clean_architecture/feature/domain/usecases/get_all_person.dart';

import '../../../../core/error/failure.dart';
import 'person_list_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class PersonListCubit extends Cubit<PersonState> {
  final GetAllPerson getAllPerson;

  PersonListCubit({required this.getAllPerson}) : super(PersonEmpty());

  int page = 1;

  void loadPerson() async {
    if (state is PersonLoading) return;

    final currentState = state;

    var oldPerson = <PersonEntity>[];

    if (currentState is PersonLoaded) {
      oldPerson = currentState.personList;
    }

    emit(PersonLoading(oldPerson, isFirstFetch: page == 1));

    final failureOrPerson = await getAllPerson(PagePersonParams(page: page));

    failureOrPerson.fold(
      (error) => emit(PersonError(message: _mapFailureToMessage(error))),
      (character) {
        page++;

        final people = (state as PersonLoading).oldPersonList;
        people.addAll(character);
        print('List length: ${people.length}');

        emit(PersonLoaded(people));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
