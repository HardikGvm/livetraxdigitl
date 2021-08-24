
import 'package:livetraxdigitl/ui/server/mainwindowdata.dart';

List<CategoriesData> categories = [];

getCategoryName(String id){
  for (var item in categories)
    if (item.id == id)
      return item.name;
    return "";
}

