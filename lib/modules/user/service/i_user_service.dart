import '../../../entities/user.dart';
import '../view_models/user_save_input_view_model.dart';

abstract class IUserService {
  Future<User> createUser(UserSaveInputViewModel user);
  Future<User> loginWithEmailAndPassword(String email, String password);
}
