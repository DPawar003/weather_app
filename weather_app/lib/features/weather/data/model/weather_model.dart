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
  final int? visibility; // Made nullable
  final Sys sys;
  final int? timezone; // Made nullable

  WeatherModel({
    required this.name,
    required this.coord,
    required this.weather,
    required this.main,
    required this.wind,
    required this.clouds,
    this.visibility,
    required this.sys,
    this.timezone,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => _$WeatherModelFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);
}

@JsonSerializable()
class Coord {
  final double? lon; // Made nullable
  final double? lat; // Made nullable

  Coord({this.lon, this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
  Map<String, dynamic> toJson() => _$CoordToJson(this);
}

@JsonSerializable()
class Weather {
  final int? id; // Added missing id field
  final String main;
  final String description;
  final String icon;

  Weather({
    this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}

@JsonSerializable()
class Main {
  @JsonKey(fromJson: _tempFromJson)
  final double temp;
  
  @JsonKey(name: 'feels_like', fromJson: _tempFromJson)
  final double feelsLike;
  
  @JsonKey(name: 'temp_min', fromJson: _tempFromJson)
  final double tempMin;
  
  @JsonKey(name: 'temp_max', fromJson: _tempFromJson)
  final double tempMax;
  
  @JsonKey(fromJson: _intFromJson)
  final int pressure;
  
  @JsonKey(fromJson: _intFromJson)
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
  Map<String, dynamic> toJson() => _$MainToJson(this);
  
  // Helper methods to safely convert nullable values
  static double _tempFromJson(dynamic value) => 
    value == null ? 0.0 : (value is int ? value.toDouble() : value as double);
    
  static int _intFromJson(dynamic value) => 
    value == null ? 0 : (value is double ? value.toInt() : value as int);
}

@JsonSerializable()
class Wind {
  @JsonKey(fromJson: _speedFromJson)
  final double speed;
  
  @JsonKey(fromJson: _intFromJson)
  final int deg;
  
  @JsonKey(fromJson: _doubleFromJson)
  final double? gust; // Added optional gust field

  Wind({
    required this.speed,
    required this.deg,
    this.gust,
  });

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
  Map<String, dynamic> toJson() => _$WindToJson(this);
  
  // Helper methods to safely convert nullable values
  static double _speedFromJson(dynamic value) => 
    value == null ? 0.0 : (value is int ? value.toDouble() : value as double);
    
  static int _intFromJson(dynamic value) => 
    value == null ? 0 : (value is double ? value.toInt() : value as int);
    
  static double? _doubleFromJson(dynamic value) => 
    value == null ? null : (value is int ? value.toDouble() : value as double);
}

@JsonSerializable()
class Clouds {
  @JsonKey(fromJson: _intFromJson)
  final int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) => _$CloudsFromJson(json);
  Map<String, dynamic> toJson() => _$CloudsToJson(this);
  
  // Helper method to safely convert nullable value
  static int _intFromJson(dynamic value) => 
    value == null ? 0 : (value is double ? value.toInt() : value as int);
}

@JsonSerializable()
class Sys {
  final int? type; // Added optional type field
  final int? id; // Added optional id field
  final String country;
  @JsonKey(fromJson: _intFromJson)
  final int sunrise;
  @JsonKey(fromJson: _intFromJson)
  final int sunset;

  Sys({
    this.type,
    this.id,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);
  Map<String, dynamic> toJson() => _$SysToJson(this);
  
  // Helper method to safely convert nullable value
  static int _intFromJson(dynamic value) => 
    value == null ? 0 : (value is double ? value.toInt() : value as int);
}