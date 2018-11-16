class Contact {
  String first;
  String last;
  String image;
  String mediumText;
  String longText;

  Contact({this.first, this.last, this.image});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact()
      ..first = json['first']
      ..last = json['last']
      ..image = json['image']
      ..mediumText = json['mediumText']
      ..longText = json['longText'];
  }
}
