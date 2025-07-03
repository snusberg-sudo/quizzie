import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quizzie/api/api_service.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

class UserData {
  final String userId, token, email, name;
  final String? avatar;
  UserData({
    required this.userId,
    required this.token,
    required this.email,
    required this.name,
    this.avatar,
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
  final Ref ref;

  UserDataNotifier(this.storage, this.ref)
    : super(UserDataState(isLoading: true, user: null)) {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    state = state.copyWith(isLoading: true);
    final userId = await storage.read(key: 'userId');
    final token = await storage.read(key: 'token');
    final email = await storage.read(key: 'email');
    final name = await storage.read(key: 'name');
    final avatar = await storage.read(key: 'avatar');

    state = state.copyWith(
      isLoading: false,
      user:
          (userId != null &&
                  token != null &&
                  email != null &&
                  name != null &&
                  avatar != null)
              ? UserData(
                userId: userId,
                token: token,
                email: email,
                name: name,
                avatar: avatar,
              )
              : null,
    );
  }

  Future<void> saveUserData(
    String userId,
    String token,
    String email,
    String name,
    String avatar,
  ) async {
    state = state.copyWith(isLoading: true);
    await storage.write(key: 'userId', value: userId);
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'name', value: name);
    await storage.write(key: 'avatar', value: avatar);
    state = state.copyWith(
      isLoading: false,
      user: UserData(
        userId: userId,
        token: token,
        email: email,
        name: name,
        avatar: avatar,
      ),
    );
  }

  Future<void> clearUserData() async {
    state = state.copyWith(isLoading: true);
    await storage.deleteAll();
    state = state.copyWith(isLoading: false, user: null);
  }

  void selectNewAvatar(String avatarFileName) {
    final currentUser = state.user;
    if (currentUser == null) return;

    state = state.copyWith(
      isLoading: false,
      user: UserData(
        userId: currentUser.userId,
        token: currentUser.token,
        email: currentUser.email,
        name: currentUser.name,
        avatar: avatarFileName,
      ),
    );
  }

  Future<void> updateAvatar() async {
    final apiService = ref.read(apiServiceProvider);
    final currentUser = state.user;
    try {
      final response = await apiService.patch('/user', {
        'avatar': currentUser?.avatar,
      });
      print(response.data['data']);
    } catch (error) {
      print(error);
    }
  }
}

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserDataState>(
  (ref) {
    final storage = ref.watch(secureStorageProvider);
    return UserDataNotifier(storage, ref);
  },
);
