import 'package:get/get.dart';


import 'category_model.dart';
import 'e_provider_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class City extends Model {
  String? id;
  String? name;
  String? bio;
  List<Media>? images;
  bool? feature;


  City(
      {this.id,
        this.name,
        this.bio,
        this.images,

        this.feature,
});

  City.fromJson(Map<String, dynamic>? json) {

    name = transStringFromJson(json, 'name');
    bio = transStringFromJson(json, 'bio');
    images = mediaListFromJson(json, 'images');

    feature = boolFromJson(json, 'feature');
    super.fromJson(json);

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    if (this.bio != null) data['bio'] = this.bio;
    if (feature != null) data['feature'] = this.feature;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }




  String get firstImageUrl => this.images?.first?.url ?? '';

  String get firstImageThumb => this.images?.first?.thumb ?? '';

  String get firstImageIcon => this.images?.first?.icon ?? '';

  @override
  bool get hasData {
    return id != null && name != null && bio != null;
  }

  /*
  * Get the real price of the service
  * when the discount not set, then it return the price
  * otherwise it return the discount price instead
  * */


  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
          super == other &&
              other is City &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              feature == other.feature &&
              bio == other.bio ;


  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ name.hashCode ^ bio.hashCode;
}
