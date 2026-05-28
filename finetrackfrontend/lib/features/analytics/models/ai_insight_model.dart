class AIInsightModel {
  final List<String> insights;

  AIInsightModel({required this.insights});

  factory AIInsightModel.fromJson(Map<String, dynamic> json) {
    return AIInsightModel(insights: List<String>.from(json["insights"]));
  }
}
