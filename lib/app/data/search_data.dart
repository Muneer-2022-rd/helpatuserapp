import 'package:helpat/common/class/curd.dart';

class SearchData{
  Crud crud ;
  SearchData(this.crud);

  searchEserviceWithCategories(String categories , String query , int page)async{
    print("Select Categories :  $categories");
    print("query: $query");
    if((categories !=null || categories.isNotEmpty) && query.isNotEmpty){
      var response  = await crud.getData("https://helpatapp.com/api/e_services?search=categories.id:$categories;name:$query&with=eProvider;eProvider.addresses;categories&searchJoin=and&searchFields=categories.id:in;name:like&page=$page");
      return response.fold((l) => l, (r) => r);
    }else if((categories ==null || categories.isEmpty) && query.isNotEmpty){
      var response  = await crud.getData("https://helpatapp.com/api/e_services?search=categories.id:$categories;name:$query&with=eProvider;eProvider.addresses;categories&searchJoin=and&searchFields=categories.id:in;name:like&page=$page");
      return response.fold((l) => l, (r) => r);
    }

  }
}