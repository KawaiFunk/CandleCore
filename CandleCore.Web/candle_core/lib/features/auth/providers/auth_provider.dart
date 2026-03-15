import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_model.dart';
import '../data/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final currentUserProvider =
    NotifierProvider<CurrentUserNotifier, UserModel?>(CurrentUserNotifier.new);

class CurrentUserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() => null;

  void setUser(UserModel? user) => state = user;
}
