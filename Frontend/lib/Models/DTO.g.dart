// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DTO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) => AuthModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userId: json['userId'] as int?,
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      role: json['role'] as String? ?? 'user',
      profileimage: json['profileimage'] as String,
      phonenumber: json['phonenumber'] as String,
      jwttoken: json['jwttoken'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'address': instance.address,
      'role': instance.role,
      'profileimage': instance.profileimage,
      'phonenumber': instance.phonenumber,
      'jwttoken': instance.jwttoken,
    };

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      productId: json['productId'] as int?,
      productCategory: json['productCategory'] as String,
      price: json['price'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      ownerId: json['ownerId'] as String,
      availablequantity: json['availablequantity'] as int,
      quantity: json['quantity'] as int? ?? 0,
      amount: json['amount'] as int? ?? 0,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productCategory': instance.productCategory,
      'price': instance.price,
      'name': instance.name,
      'description': instance.description,
      'url': instance.url,
      'ownerId': instance.ownerId,
      'availablequantity': instance.availablequantity,
      'quantity': instance.quantity,
      'amount': instance.amount,
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      userName: json['userName'] as String?,
      userid: json['userid'] as int?,
      dateTime: json['dateTime'] as String?,
      details: json['details'] as String?,
      orderstatus: json['orderstatus'] as String?,
      paymentinfo: json['paymentinfo'] as String?,
      totalordervalue: json['totalordervalue'] as int?,
    )..orderId = json['orderId'] as int?;

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'userid': instance.userid,
      'userName': instance.userName,
      'dateTime': instance.dateTime,
      'details': instance.details,
      'orderstatus': instance.orderstatus,
      'paymentinfo': instance.paymentinfo,
      'totalordervalue': instance.totalordervalue,
    };

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      notifId: json['notifId'] as int?,
      userId: json['userId'] as int?,
      read: json['read'] as bool?,
      notification: json['notification'] as String?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'notifId': instance.notifId,
      'userId': instance.userId,
      'read': instance.read,
      'notification': instance.notification,
    };

CartModel _$CartModelFromJson(Map<String, dynamic> json) => CartModel(
      cartId: json['cartId'] as int?,
      userId: json['userId'] as int?,
      productids:
          (json['productids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      total: json['total'] as int?,
    );

Map<String, dynamic> _$CartModelToJson(CartModel instance) => <String, dynamic>{
      'cartId': instance.cartId,
      'userId': instance.userId,
      'productids': instance.productids,
      'total': instance.total,
    };

CartDTO _$CartDTOFromJson(Map<String, dynamic> json) => CartDTO(
      cart: json['cart'] == null
          ? null
          : CartModel.fromJson(json['cart'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CartDTOToJson(CartDTO instance) => <String, dynamic>{
      'cart': instance.cart,
      'products': instance.products,
    };
