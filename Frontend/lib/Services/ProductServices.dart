
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/DTO.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadToObjectStorage() async
{
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  String downloadurl='';
  if (result != null) {
    Uint8List? fileBytes = result.files.first.bytes;
    String fileName = result.files.first.name;

    await FirebaseStorage.instance.ref('profileimages/$fileName').putData(fileBytes!);

    downloadurl=await FirebaseStorage.instance.ref('profileimages/$fileName').getDownloadURL();
  }

  return downloadurl;
}

Future<List<ProductModel>> getProductsFromServerForCache() async
{

  final prefs = await SharedPreferences.getInstance();
  String? token=await prefs.getString("jwttoken");
  List<ProductModel> products=[];
  final response =await http.get(Uri.parse("https://ecommerceappamal.store/product-service/products?popular=true"),
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "charset":"UTF-8",
      'Authorization': 'Bearer $token'
    },
  );

  if(response.statusCode==200)
  {
    final List prodlist=await jsonDecode(response.body);
    for(var product in prodlist)
      products.add(ProductModel.fromJson(product));
  }
  else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.body);
  }

  return products;
}



Future<List<ProductModel>> getProductsFromServer(int choice,{String? search,String? category}) async
{
  String url="";

  if(choice==1)
    url="https://ecommerceappamal.store/product-service/products";
  else if(choice==2)
   url="https://ecommerceappamal.store/product-service/products?category=$category";
  else if (choice==3)
  url="https://ecommerceappamal.store/product-service/products?search=$search";


  final prefs = await SharedPreferences.getInstance();
  String? token=await prefs.getString("jwttoken");
  List<ProductModel> products=[];
  final response =await http.get(Uri.parse(url),
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "charset":"UTF-8",
      'Authorization': 'Bearer $token'
    },
  );

  if(response.statusCode==200)
  {
     final List prodlist=(choice==1)?await jsonDecode(response.body)['content'] : await jsonDecode(response.body);
     for(var product in prodlist)
     products.add(ProductModel.fromJson(product));
  }
  else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.body);
  }

  return products;
}


Future<ProductModel> getProductFromServer(int productid) async
{
  final prefs = await SharedPreferences.getInstance();
  String? token=await prefs.getString("jwttoken");
  ProductModel? product;
  final response =await http.get(Uri.parse("https://ecommerceappamal.store/product-service/products/$productid" ),
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "charset":"UTF-8",
      'Authorization': 'Bearer $token'
    },
  );
  if(response.statusCode==200){
    product=await ProductModel.fromJson( jsonDecode(response.body));
  }
  else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.body);
  }

  return product;
}




void updateProductToServer(ProductModel product) async{
  final prefs = await SharedPreferences.getInstance();
  String? token=await prefs.getString("jwttoken");
  final response =await http.put(Uri.parse("https://ecommerceappamal.store/product-service/products" ),
    body: product,
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "charset":"UTF-8",
      'Authorization': 'Bearer $token'
    },
  );
}










