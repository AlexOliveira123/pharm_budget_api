import '../../../application/helpers/request_mapping.dart';

class UserSaveInputViewModel extends RequestMapping {
  late String fullName;
  late String email;
  late String cellphone;
  late String password;

  UserSaveInputViewModel(String dataRequest) : super(dataRequest);

  @override
  void map() {
    fullName = data['fullName'];
    email = data['email'];
    cellphone = data['cellphone'];
    password = data['password'];
  }
}
