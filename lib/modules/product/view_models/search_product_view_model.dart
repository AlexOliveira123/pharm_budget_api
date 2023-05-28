import '../../../application/helpers/request_mapping.dart';

class SearchProductViewModel extends RequestMapping {
  late String name;

  SearchProductViewModel(String dataRequest) : super(dataRequest);

  @override
  void map() {
    name = data['name'];
  }
}
