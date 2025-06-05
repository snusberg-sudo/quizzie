import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

class UserData {
  final String userId, token, email, name;
  UserData({
    required this.userId,
    required this.token,
    required this.email,
    required this.name,
  });
}

class UserDataState {
  final bool isLoading;
  final UserData? user;

  UserDataState({required this.isLoading, this.user});

  UserDataState copyWith({bool? isLoading, UserData? user}) {
    return UserDataState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}

class UserDataNotifier extends StateNotifier<UserDataState> {
  final FlutterSecureStorage storage;

  UserDataNotifier(this.storage)
    : super(UserDataState(isLoading: true, user: null)) {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    state = state.copyWith(isLoading: true);
    final userId = await storage.read(key: 'userId');
    final token = await storage.read(key: 'token');
    final email = await storage.read(key: 'email');
    final name = await storage.read(key: 'name');

    state = state.copyWith(
      isLoading: false,
      user:
          (userId != null && token != null && email != null && name != null)
              ? UserData(userId: userId, token: token, email: email, name: name)
              : null,
    );
  }

  Future<void> saveUserData(
    String userId,
    String token,
    String email,
    String name,
  ) async {
    state = state.copyWith(isLoading: true);
    await storage.write(key: 'userId', value: userId);
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'name', value: name);
    state = state.copyWith(
      isLoading: false,
      user: UserData(userId: userId, token: token, email: email, name: name),
    );
  }

  Future<void> clearUserData() async {
    state = state.copyWith(isLoading: true);
    await storage.deleteAll();
    state = state.copyWith(isLoading: false, user: null);
  }
}

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserDataState>(
  (ref) {
    final storage = ref.watch(secureStorageProvider);
    return UserDataNotifier(storage);
  },
);
