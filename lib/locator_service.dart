import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/platform/network_info.dart';
import 'feature/data/datasources/person_local_data_source.dart';
import 'feature/data/datasources/person_remote_data_source.dart';
import 'feature/data/repositories/person_repository_impl.dart';
import 'feature/domain/repositories/person_repository.dart';
import 'feature/domain/usecases/get_all_person.dart';
import 'feature/domain/usecases/search_person.dart';
import 'feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'feature/presentation/bloc/seach_bloc/search_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async{
  // BloC && Cubit

  sl.registerFactory(() => PersonListCubit(getAllPerson: sl()));
  sl.registerFactory(() => PersonSearchBloc(searchPeople: sl()));

  // UseCase

  sl.registerLazySingleton(() => GetAllPerson(sl()));
  sl.registerLazySingleton(() => SearchPerson(sl()));

  // Repository
  sl.registerLazySingleton<PersonRepository>(() => PersonRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ));

  sl.registerLazySingleton<PersonRemoteDataSource>(
    () => PersonRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<PersonLocalDataSource>(
    () => PersonLocalDataSourceImp(sharedPreferences: sl()),
  );

  // Core

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl()),
  );
  
  // External

  final sharedPreferences = await SharedPreferences.getInstance(); 

   sl.registerLazySingleton(() => http.Client());
   sl.registerLazySingleton(() => InternetConnectionChecker());
   sl.registerLazySingleton(() =>  sharedPreferences);

}
