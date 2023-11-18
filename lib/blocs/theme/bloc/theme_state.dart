part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final bool switchValue;
  const ThemeState(this.switchValue);

  @override
  List<Object> get props => [switchValue];
}

// class ThemeInitial extends ThemeState {
//   const ThemeInitial(bool switchValue) : super(switchValue);
// }
