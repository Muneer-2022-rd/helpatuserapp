import 'package:helpat/common/Functions/stutsrequest.dart';

 handlingData(response){
  if(response is StatusRequest){
    return response ;
  }else{
    return StatusRequest.success;
  }
}