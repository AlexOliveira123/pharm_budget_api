import 'package:injectable/injectable.dart';

import '../../../entities/user.dart';
import '../data/i_user_repository.dart';
import '../view_models/user_save_input_view_model.dart';
import './i_user_service.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  final IUserRepository _userRepository;

  UserService(this._userRepository);

  @override
  Future<User> createUser(UserSaveInputViewModel user) {
    final userEntity = User(
      fullName: user.fullName,
      email: user.email,
      cellphone: user.cellphone,
      password: user.password,
    );
    return _userRepository.createUser(userEntity);
  }

  @override
  Future<User> loginWithEmailAndPassword(String email, String password) {
    return _userRepository.loginWithEmailAndPassword(email, password);
  }
}
