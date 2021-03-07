import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String name;

  /// Url for the current user's photo.
  final String photo;

  const UserInfo({this.email, this.id, this.name, this.photo})
      : assert(email != null),
        assert(id != null);

  @override
  // TODO: implement props
  List<Object> get props => [email, id, name, photo];

  static const empty = UserInfo(email: '', id: '', name: null, photo: null);
}
