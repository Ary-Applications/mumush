class ApiConstants {
  static const String baseUrl = "https://api.mumush.world/";
  static const String performances = "performances?include=stages,days,artists,performanceDescriptions&filter[year]=2023&order[day]=asc&order[start]=asc";
}


enum BaseResponseType {
  // Response with all the scheduled performances
  performancesResponse
}