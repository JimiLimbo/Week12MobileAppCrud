class User {
  String _id;
  String Username;
  String Password;
  String Email;
  String AuthLevel;

  User(this._id, this.Username, this.Password, this.Email, this.AuthLevel);

  // Getter for _id
  String get id => _id;
}
