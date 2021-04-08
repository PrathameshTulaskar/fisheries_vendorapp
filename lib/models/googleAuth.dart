class GoogleAuthModel{
  String userName;
  String profileUrl;
  String fullName;
  String emailAddress;
  GoogleAuthModel({this.emailAddress,this.fullName,this.profileUrl,this.userName});
  GoogleAuthModel.fromJson(Map<String, dynamic> json):
  userName = json['given_name'],
  profileUrl = json['picture'],
  fullName = json['name'],
  emailAddress = json['email'];
}
// given_name: WEBLOZEE, 
// picture: https://lh3.googleusercontent.com/a-/AOh14GjME6zu-Ahn84TelnGsm-K4TgfFiPOyGVyyUOOi=s96-c, 
// name: WEBLOZEE web-development, 
// email: weblozee@gmail.com,  