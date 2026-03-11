import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await sharedPreferences.setString(
        StorageKeys.userData,
        user.toJsonString(),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to cache user data.');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonStr = sharedPreferences.getString(StorageKeys.userData);
      if (jsonStr == null) return null;
      return UserModel.fromJsonString(jsonStr);
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve cached user data.');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await sharedPreferences.remove(StorageKeys.userData);
    } catch (e) {
      throw CacheException(message: 'Failed to clear user data.');
    }
  }
}
