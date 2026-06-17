import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupLocator() {

  sl.registerLazySingleton(() => ProductRemoteDataSource());
  

  sl.registerLazySingleton(() => ProductRepository(remoteDataSource: sl()));
}