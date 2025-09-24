// invite_sent_to_runner_entity.dart
import 'package:equatable/equatable.dart';

class InviteSentToRunnerEntity extends Equatable {
  final String? runnerId; // keep if you need internally, but don’t send

  const InviteSentToRunnerEntity({this.runnerId});

  @override
  List<Object?> get props => [runnerId];
}
