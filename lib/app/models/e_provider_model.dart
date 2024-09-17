/*
 * Copyright (c) 2020 .
 */

import 'dart:core';

import 'address_model.dart';
import 'availability_hour_model.dart';
import 'e_provider_type_model.dart';
import 'media_model.dart';
import 'parents/model.dart';
import 'review_model.dart';
import 'tax_model.dart';
import 'user_model.dart';

class EProvider extends Model {
  String? id;
  String? name;
  String? description;
  String? pic;
  List<Media>? images;
  List<Media>? gallery;
  String? phoneNumber;
  String? mobileNumber;
  EProviderType? type;
  List<AvailabilityHour>? availabilityHours;
  double? availabilityRange;
  int? available;
  bool? featured;
  List<Address>? addresses;
  List<Tax>? taxes;
  int? price_level;
  List<User>? employees;
  double? rate;
  List<Review>? reviews;
  int? totalReviews;
  bool? verified;
  int? bookingsInProgress;

  EProvider(
      {this.id,
        this.name,
        this.description,
        this.images,
        this.gallery,
        this.pic,
        this.phoneNumber,
        this.mobileNumber,
        this.type,
        this.availabilityHours,
        this.availabilityRange,
        this.available,
        this.featured,
        this.addresses,
        this.price_level,
        this.employees,
        this.rate,
        this.reviews,
        this.totalReviews,
        this.verified,
        this.bookingsInProgress});

  EProvider.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description');
    images = mediaListFromJson(json, 'images');
    gallery = galleryListFromJson(json, 'gallery');
    pic = transStringFromJson(json, 'e_provider_main_picture');
    phoneNumber = stringFromJson(json, 'phone_number');
    mobileNumber = stringFromJson(json, 'mobile_number');
    type = objectFromJson(json, 'e_provider_type', (v) => EProviderType.fromJson(v));
    availabilityHours = listFromJson(json, 'availability_hours', (v) => AvailabilityHour.fromJson(v));
    availabilityRange = doubleFromJson(json, 'availability_range');
    available = intFromJson(json, 'availabel');
    featured = boolFromJson(json, 'featured');
    addresses = listFromJson(json, 'addresses', (v) => Address.fromJson(v));
    taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    employees = listFromJson(json, 'users', (v) => User.fromJson(v));
    rate = doubleFromJson(json, 'rate');
    reviews = listFromJson(json, 'e_provider_reviews', (v) => Review.fromJson(v));
    totalReviews = reviews!.isEmpty ? intFromJson(json, 'total_reviews') : reviews!.length;
    price_level = intFromJson(json, 'price_level');
    verified = boolFromJson(json, 'verified');
    bookingsInProgress = intFromJson(json, 'bookings_in_progress');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['e_provider_main_picture'] = this.pic;
    data['description'] = this.description;
    data['availabel'] = this.available;
    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['rate'] = this.rate;
    data['total_reviews'] = this.totalReviews;
    data['price_level'] = this.price_level;
    data['verified'] = this.verified;
    data['bookings_in_progress'] = this.bookingsInProgress;
    return data;
  }

  String get firstImageUrl => this.images?.first.url ?? '';

  String get firstGalleryUrl => this.gallery?.first.url ?? '';

  String get firstGalleryThumb => this.gallery?.first.thumb ?? '';

  String get firstImageThumb => this.images?.first.thumb ?? '';



  String get firstImageIcon => this.images?.first.icon ?? '';

  String? get firstAddress {
    if (this.addresses!.isNotEmpty) {
      return this.addresses!.first.address;
    }
    return '';
  }

  @override
  bool get hasData {
    return id != null && name != null && description != null;
  }

  Map<String?, List<String>> groupedAvailabilityHours() {
    Map<String?, List<String>> result = {};
    this.availabilityHours!.forEach((element) {
      if (result.containsKey(element.day)) {
        result[element.day]!.add(element.startAt! + ' - ' + element.endAt!);
      } else {
        result[element.day] = [element.startAt! + ' - ' + element.endAt!];
      }
    });
    return result;
  }

  List<String?> getAvailabilityHoursData(String? day) {
    List<String?> result = [];
    this.availabilityHours!.forEach((element) {
      if (element.day == day) {
        result.add(element.data);
      }
    });
    return result;
  }

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
          super == other &&
              other is EProvider &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              pic == other.pic &&
              description == other.description &&
              images == other.images &&
              gallery == other.gallery &&
              phoneNumber == other.phoneNumber &&
              mobileNumber == other.mobileNumber &&
              type == other.type &&
              availabilityRange == other.availabilityRange &&
              available == other.available &&
              featured == other.featured &&
              addresses == other.addresses &&
              rate == other.rate &&
              reviews == other.reviews &&
              totalReviews == other.totalReviews &&
              price_level == other.price_level &&
              verified == other.verified &&
              bookingsInProgress == other.bookingsInProgress;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      images.hashCode ^
      gallery.hashCode ^
      phoneNumber.hashCode ^
      mobileNumber.hashCode ^
      type.hashCode ^
      pic.hashCode ^
      availabilityRange.hashCode ^
      available.hashCode ^
      featured.hashCode ^
      addresses.hashCode ^
      rate.hashCode ^
      reviews.hashCode ^
      totalReviews.hashCode ^
      price_level.hashCode ^
      verified.hashCode ^
      bookingsInProgress.hashCode;
}
