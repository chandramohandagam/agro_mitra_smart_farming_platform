class WeatherData {
  final CurrentWeather current;
  final String aiInsight;
  final List<RainProb> rainProbability;
  final List<ForecastDay> forecast;
  final List<AgriAdvice> agriAdvice;

  WeatherData({
    required this.current,
    required this.aiInsight,
    required this.rainProbability,
    required this.forecast,
    required this.agriAdvice,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      current: CurrentWeather.fromJson(json['current']),
      aiInsight: json['ai_insight'] ?? '',
      rainProbability: (json['rain_probability'] as List).map((e) => RainProb.fromJson(e)).toList(),
      forecast: (json['forecast'] as List).map((e) => ForecastDay.fromJson(e)).toList(),
      agriAdvice: (json['agri_advice'] as List).map((e) => AgriAdvice.fromJson(e)).toList(),
    );
  }
}

class CurrentWeather {
  final int temp;
  final String condition;
  final int high;
  final int low;
  final int humidity;
  final String uvIndex;
  final String windSpeed;

  CurrentWeather({
    required this.temp,
    required this.condition,
    required this.high,
    required this.low,
    required this.humidity,
    required this.uvIndex,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temp: json['temp'] ?? 0,
      condition: json['condition'] ?? '',
      high: json['high'] ?? 0,
      low: json['low'] ?? 0,
      humidity: json['humidity'] ?? 0,
      uvIndex: json['uv_index'] ?? '',
      windSpeed: json['wind_speed'] ?? '',
    );
  }
}

class RainProb {
  final String time;
  final double prob;

  RainProb({required this.time, required this.prob});

  factory RainProb.fromJson(Map<String, dynamic> json) {
    return RainProb(
      time: json['time'] ?? '',
      prob: (json['prob'] ?? 0.0).toDouble(),
    );
  }
}

class ForecastDay {
  final String day;
  final String icon;
  final String tempRange;
  final double progress;

  ForecastDay({required this.day, required this.icon, required this.tempRange, required this.progress});

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      day: json['day'] ?? '',
      icon: json['icon'] ?? 'cloud',
      tempRange: json['temp_range'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
    );
  }
}

class AgriAdvice {
  final String title;
  final String subtitle;
  final String content;
  final String type;

  AgriAdvice({required this.title, required this.subtitle, required this.content, required this.type});

  factory AgriAdvice.fromJson(Map<String, dynamic> json) {
    return AgriAdvice(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? 'info',
    );
  }
}
