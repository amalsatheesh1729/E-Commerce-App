import 'package:json_annotation/json_annotation.dart';

part 'DTO.g.dart';

@JsonSerializable()
class AuthModel{
  String email;
  String password;

  AuthModel({required this.email,required this.password});

  factory AuthModel.fromJson(Map<String,dynamic> data) => _$AuthModelFromJson(data);

  Map<String,dynamic> toJson() => _$AuthModelToJson(this);
}

@JsonSerializable()
class UserModel{

  int? userId;
  String email;
  String password;
  String name;
  String address;
  String role;
  String profileimage;
  String phonenumber;
  String? jwttoken;

  UserModel({this.userId,required this.email,required this.password,required this.name,required this.address,this.role='user',required this.profileimage,
    required this.phonenumber,this.jwttoken});

  factory UserModel.fromJson(Map<String,dynamic> data) => _$UserModelFromJson(data);

  Map<String,dynamic> toJson() => _$UserModelToJson(this);

}

@JsonSerializable()
class ProductModel{

   int? productId;
   String productCategory;
   int  price;
   String name;
   String description;
   String url;
   String ownerId;
   int availablequantity;
   int quantity;
   int amount;


  ProductModel({this.productId,required this.productCategory,required this.price,required this.name,required this.description,required this.url,required this.ownerId,required this.availablequantity,this.quantity=0,this.amount=0});

  factory ProductModel.fromJson(Map<String,dynamic> data) => _$ProductModelFromJson(data);

  Map<String,dynamic> toJson() => _$ProductModelToJson(this);

}

enum OrderStatus{
  Placed,
  Shipped,
  OutForDelivery,
  Completed,
}

enum PaymentStatus{
 Unpaid,
 Pending,
 Paid
}

@JsonSerializable()
class OrderModel{
  int? orderId;
  int? userid;
  String? userName;
  String? dateTime;
  String? details;
  String ?orderstatus;
  String? paymentinfo;
  int? totalordervalue;

  OrderModel({ this.userName,this.userid, this.dateTime, this.details,
     this.orderstatus, this.paymentinfo, this.totalordervalue});

  factory OrderModel.fromJson(Map<String,dynamic> data) => _$OrderModelFromJson(data);

  Map<String,dynamic> toJson() => _$OrderModelToJson(this);

}

@JsonSerializable()
class NotificationModel{
  int? notifId;
  int? userId;
  bool? read;
  String? notification;

  NotificationModel({ this.notifId,this.userId,this.read,this.notification});

  factory NotificationModel.fromJson(Map<String,dynamic> data) => _$NotificationModelFromJson(data);

  Map<String,dynamic> toJson() => _$NotificationModelToJson(this);

}

@JsonSerializable()
class CartModel{

  int? cartId;
  int? userId;
  List<int>? productids;
  int? total;

  CartModel({this.cartId, this.userId, this.productids, this.total});

  factory CartModel.fromJson(Map<String,dynamic> data) => _$CartModelFromJson(data);

  Map<String,dynamic> toJson() => _$CartModelToJson(this);
}


@JsonSerializable()
 class CartDTO
{

  CartModel? cart;
  List<ProductModel>? products;


  CartDTO({this.cart,this.products});

  factory CartDTO.fromJson(Map<String,dynamic> data) => _$CartDTOFromJson(data);

  Map<String,dynamic> toJson() => _$CartDTOToJson(this);

}