
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:helpat/common/Functions/stutsrequest.dart';
import 'package:http/http.dart' as http;

class Crud{
 Future<Either<StatusRequest , Map?>>postData(String url , Map  data , {Map? headers})async{
   try{
     var response = await http.post(Uri.parse(url) , body: data , headers: headers as Map<String, String>?);
     print(response.statusCode);
     if(response.statusCode ==200 || response.statusCode ==201){
       Map? responseBody = jsonDecode(response.body);
       return Right(responseBody);
     }else{
       return Left(StatusRequest.serverFailure);
     }
   }catch(error){
     print(error.toString());
     return Left(StatusRequest.failure);
   }
 }

 Future<Either<StatusRequest, Map?>> postDataWithFile(
     String linkeUrl, Map<String, String> data, File file , String fileNameApi) async {
   Uri uri = Uri.parse(linkeUrl);
   var fileStream = http.ByteStream(DelegatingStream.typed(file.openRead()));
   var length = await file.length();

   var request = http.MultipartRequest("POST", uri);
   request.fields.addAll(data);

   var multipartFile = http.MultipartFile(fileNameApi, fileStream, length,
       filename: file.path.split('/').last);
   request.files.add(multipartFile);
   var response = await request.send();
   //do whatever you want with the response
   if (response.statusCode == 200 || response.statusCode == 201) {
     var responseBody = await response.stream.bytesToString();
     Map? decodeMap= json.decode(responseBody);
     print(decodeMap) ;
     return Right(decodeMap);
   } else {
     return const Left(StatusRequest.serverFailure);
   }
 }



 Future<Either<StatusRequest,Map?>>getData(String url)async{
   try{
     var response = await http.get(Uri.parse(url));
     print(response.statusCode);
     if(response.statusCode ==200 || response.statusCode ==201){
       Map? responseBody = jsonDecode(response.body);
       return Right(responseBody);
     }else{
       print("server Error");
       return Left(StatusRequest.serverFailure);
     }
   }catch(error){
     print(error.toString());
     return Left(StatusRequest.failure);
   }
 }

//

 //
 // Future<Either<StatusRequest , Map>>postDataWithFile(String url , Map  data)async{
 //   try{
 //     var response = await http.MultipartRequest("POST" , Uri.parse(url));
 //     print(response.statusCode);
 //     if(response.statusCode ==200 || response.statusCode ==201){
 //       Map responseBody = jsonDecode(response.body);
 //       return Right(responseBody);
 //     }else{
 //       return Left(StatusRequest.serverFailure);
 //     }
 //   }catch(error){
 //     print(error.toString());
 //     return Left(StatusRequest.failure);
 //   }
 // }
}
