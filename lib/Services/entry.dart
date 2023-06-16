class Entry {
  int? id;
  String name = "";
  String url = "";
  String result = "";

  Entry({
    int? id,
    String? name,
    String? url,
    String? result,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'url': this.url,
      'result': this.result,
    };
  }

  Entry.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    url = map['url'];
    result = map['result'];
  }
}
