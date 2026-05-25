/// نموذج بيانات المراجعة
class ReviewModel {
  final String? id;
  final String? userName;
  final String? userImage;
  final double? rating;
  final String? title;
  final String? comment;
  final DateTime? date;
  final int? helpful;

  ReviewModel({
    this.id,
    this.userName,
    this.userImage,
    this.rating,
    this.title,
    this.comment,
    this.date,
    this.helpful,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      userName: json['reviewerName'] ?? json['userName'],
      userImage: json['userImage'],
      rating: json['rating']?.toDouble(),
      title: json['title'],
      comment: json['comment'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      helpful: json['helpful'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewerName': userName,
      'userImage': userImage,
      'rating': rating,
      'title': title,
      'comment': comment,
      'date': date?.toIso8601String(),
      'helpful': helpful,
    };
  }
}