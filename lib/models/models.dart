class UserData {
  String uid;
  String userName;
  String email;
  String imageUrl;

  UserData({
    required this.uid,
    required this.userName,
    required this.email,
    required this.imageUrl,
  });
}

class Asset {
  final String name;
  final String symbol;
  final double amount;
  final double buyingPrice;

  Asset({
    required this.name,
    required this.symbol,
    required this.amount,
    required this.buyingPrice,
  });
}
