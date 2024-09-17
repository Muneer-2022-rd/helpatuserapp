import 'package:get/get.dart';


import 'category_model.dart';
// import 'tag_model.dart';
import 'e_provider_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class Event extends Model {
  String? id;
  String? title;
  String? details;
  String? place;
  String? from;
  String? to;
  String? title_btn;
  String? link;
  List<Media>? images;
  bool? featured;


  Event(
      {

        this.id,
        this.title,
        this.details,
        this.place,
        this.from,
        this.to,
        this.title_btn,
        this.link,
        this.images,

        this.featured,
});

  Event.fromJson(Map<String, dynamic>? json) {

    title = transStringFromJson(json, 'title');
    details = transStringFromJson(json, 'details');
    place = transStringFromJson(json, 'place');
    from = transStringFromJson(json, 'from');
    to = transStringFromJson(json, 'to');
    link = transStringFromJson(json, 'link');
    title_btn = transStringFromJson(json, 'title_btn');
    images = mediaListFromJson(json, 'images');

    featured = boolFromJson(json, 'featured');
    super.fromJson(json);

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (title != null) data['title'] = this.title;
    if (this.place != null) data['place'] = this.place;
    if (this.from != null) data['from'] = this.from;
    if (this.to != null) data['to'] = this.to;
    if (this.link != null) data['link'] = this.to;
    if (featured != null) data['featured'] = this.featured;
    if (title_btn != null) data['title_btn'] = this.title_btn;
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
    return id != null && title != null && place != null  && from != null && to != null && title_btn != null && link != null  ;
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
              other is Event &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              title == other.title &&
              link == other.link &&
              featured == other.featured &&
              from == other.from &&
              to == other.to &&
              title_btn == other.title_btn &&
              place == other.place ;


  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ title.hashCode ^ place.hashCode  ^ from.hashCode   ^ to.hashCode  ^ title_btn.hashCode  ^ link.hashCode   ;
}
