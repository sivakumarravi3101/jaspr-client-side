class LookupOption {
  const LookupOption({required this.id, required this.name});

  final int id;
  final String name;

  factory LookupOption.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawName = json['name'];
    if (rawId is! num || rawName is! String) {
      throw const FormatException('Lookup option must contain a numeric id and a name.');
    }

    return LookupOption(id: rawId.toInt(), name: rawName);
  }
}
