import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';


@JsonSerializable()
class WeatherModel {
  final String name;
  final Coord coord;
  final List<Weather> weather;
  final Main main;
  final Wind wind;
  final Clouds clouds;
  final int visibility;
  final Sys sys;
  final int timezone;

  WeatherModel({
    required this.name,
    required this.coord,
    required this.weather,
    required this.main,
    required this.wind,
    required this.clouds,
    required this.visibility,
    required this.sys,
    required this.timezone,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => _$WeatherModelFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);
}

@JsonSerializable()
class Coord {
  final double lon;
  final double lat;
  Coord({required this.lon, required this.lat});
  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
}

@JsonSerializable()
class Weather {
  final String main;
  final String description;
  final String icon;
  Weather({required this.main, required this.description, required this.icon});
  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
}

@JsonSerializable()
class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
}

@JsonSerializable()
class Wind {
  final double speed;
  final int deg;
  Wind({required this.speed, required this.deg});
  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
}

@JsonSerializable()
class Clouds {
  final int all;
  Clouds({required this.all});
  factory Clouds.fromJson(Map<String, dynamic> json) => _$CloudsFromJson(json);
}

@JsonSerializable()
class Sys {
  final String country;
  final int sunrise;
  final int sunset;
  Sys({required this.country, required this.sunrise, required this.sunset});
  factory Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);
}
