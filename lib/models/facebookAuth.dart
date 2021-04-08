class FacebookAuthModel{
  String userName;
  String profileUrl;
  String fullName;
  String emailAddress;
  DateTime birthDate;

  FacebookAuthModel({this.emailAddress,this.fullName,this.profileUrl,this.userName,this.birthDate});
  factory FacebookAuthModel.fromJson(Map<String, dynamic> json){
    var birthday = json['birthday'];
     var formattedDate;
    if(birthday != null){
      var month = birthday.substring(0,2);
      var day = birthday.substring(3,5);
      var year = birthday.substring(6,10);
      formattedDate = DateTime.parse("$year-$month-$day");
    }
    return FacebookAuthModel(
      userName : json['first_name'],
      profileUrl : json['picture']['data']['url'],
      fullName : json['name'],
      emailAddress : json['email'],
      birthDate: formattedDate,
    );
  }
}

// picture: {
// data:{
// height: 100, url: https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3956076464467532&height=100&width=100&ext=1595701973&hash=AeS1bsrKlF-HR4XJ,
//  width: 100, is_silhouette: false
// }}, 
// first_name: Bhushan, 
// id:3956076464467532, 
// name: Bhushan Porob,
// email: porobbhushan@gmail.com, 
// birthday: 06/21/1995, 
// last_name: Porob 