class ReviewData {
  String id, name, review;
  ReviewData(this.id, this.name, this.review);

  Map<String, String> toJson() {
    return {"id": id, "name": name, "review": review};
  }
}

class CustomerReview {
  String? name, review, date;

  CustomerReview(this.name, this.review, this.date);

  CustomerReview.fromJson(Map data) {
    name = data["name"];
    review = data["review"];
    date = data["date"];
  }
}
