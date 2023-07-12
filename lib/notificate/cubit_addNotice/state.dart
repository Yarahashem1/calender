abstract class AddNoticetates {}

class AddNoticeInitialState extends AddNoticetates {}

class AddNoticeLoadingState extends AddNoticetates {}

class CreateNoticeSuccessState extends AddNoticetates{}

class CreateNoticeErrorState extends AddNoticetates
{
  final String error;

 CreateNoticeErrorState(this.error);
}

class categorySuccessState extends AddNoticetates{}

class AddFoodUserUpdateLoadingState extends AddNoticetates {}
class updateFood extends AddNoticetates {}