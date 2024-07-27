class Weather5daysModel {
  Weather5daysModel({
    this.cod,
    this.cnt,
    this.list,
    this.city,
  });

  Weather5daysModel.fromJson(dynamic json) {
    cod = json['cod'];
    cnt = json['cnt'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list?.add(WeatherList.fromJson(v));
      });
    }
    city = json['city'] != null ? City.fromJson(json['city']) : null;
  }
  String? cod;
  int? cnt;
  List<WeatherList>? list;
  City? city;
}

class City {
  City({
    this.id,
    this.name,
    this.coord,
    this.country,
    this.sunrise,
    this.sunset,
  });

  City.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    coord = json['coord'] != null ? Coord.fromJson(json['coord']) : null;
    country = json['country'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }
  int? id;
  String? name;
  Coord? coord;
  String? country;
  int? sunrise;
  int? sunset;
}

class Coord {
  Coord({
    this.lat,
    this.lon,
  });

  Coord.fromJson(dynamic json) {
    lat = json['lat'];
    lon = json['lon'];
  }
  double? lat;
  double? lon;
}

class WeatherList {
  WeatherList({
    this.dt,
    this.main,
    this.weather,
    this.clouds,
    this.sys,
    this.dtTxt,
  });

  WeatherList.fromJson(dynamic json) {
    dt = json['dt'];
    main = json['main'] != null ? Main.fromJson(json['main']) : null;
    if (json['weather'] != null) {
      weather = [];
      json['weather'].forEach((v) {
        weather?.add(Weather.fromJson(v));
      });
    }
    clouds = json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null;
    sys = json['sys'] != null ? Sys.fromJson(json['sys']) : null;
    dtTxt = json['dt_txt'];
  }
  int? dt;
  Main? main;
  List<Weather>? weather;
  Clouds? clouds;
  Sys? sys;
  String? dtTxt;
}

class Sys {
  Sys({
    this.pod,
  });

  Sys.fromJson(dynamic json) {
    pod = json['pod'];
  }
  String? pod;
}


class Clouds {
  Clouds({
    this.all,
  });

  Clouds.fromJson(dynamic json) {
    all = json['all'];
  }
  int? all;
}

class Weather {
  Weather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  Weather.fromJson(dynamic json) {
    id = json['id'];
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }
  int? id;
  String? main;
  String? description;
  String? icon;
}

class Main {
  Main({
    this.temp,
    this.humidity,
  });

  Main.fromJson(dynamic json) {
    temp = json['temp'];
    humidity = json['humidity'];
  }
  double? temp;
  int? humidity;
}
