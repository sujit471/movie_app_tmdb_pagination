class ApiConstant {
  static Map<String, dynamic> errorMap = {
    "StatusCode": 0123456789,
    "Message": "Something goes wrong."
  };
  static Map<String, dynamic> errorNetworkMap = {
    "StatusCode": 9876543210,
    "Message": "No Internet Connection."
  };

  static String baseUrl = "https://api.themoviedb.org/";

  static String apiKey = "e1ae1cedd0acd7b612ca50ad0f738114";

  static String imageUrl = "https://image.tmdb.org/t/p/w500";
}