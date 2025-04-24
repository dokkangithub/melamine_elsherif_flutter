import 'package:melamine_elsherif/domain/entities/country.dart';

class CountryModel extends Country {
  const CountryModel({
    required String id,
    required String iso2,
    required String iso3,
    required String numCode,
    required String name,
    required String displayName,
    required String regionId,
  }) : super(
          id: id,
          iso2: iso2,
          iso3: iso3,
          numCode: numCode,
          name: name,
          displayName: displayName,
          regionId: regionId,
        );

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      iso2: json['iso_2'],
      iso3: json['iso_3'],
      numCode: json['num_code'],
      name: json['name'],
      displayName: json['display_name'],
      regionId: json['region_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'iso_2': iso2,
      'iso_3': iso3,
      'num_code': numCode,
      'name': name,
      'display_name': displayName,
      'region_id': regionId,
    };
  }
} 