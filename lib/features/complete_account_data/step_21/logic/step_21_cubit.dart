import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:willizo/core/utils/assets_manager.dart';
import 'package:willizo/features/complete_account_data/data/models/complete_account_data_request.dart';
import 'package:willizo/features/complete_account_data/data/repo/complete_account_repo.dart';
import 'package:willizo/features/complete_account_data/step_21/logic/step_21_state.dart';

class Step21Cubit extends Cubit<Step21State> {
  final CompleteAccountRepo _completeAccountRepo;

  Step21Cubit(this._completeAccountRepo) : super(InitialState());

  List<SocialItem> socialItems = [
    SocialItem(id: 1, name: 'YouTube', image: ImageAsset.youtubeIcon),
    SocialItem(id: 2, name: 'Friends', image: ImageAsset.friendsIcon),
    SocialItem(id: 3, name: 'Facebook', image: ImageAsset.facebook2Icon),
    SocialItem(id: 4, name: 'Instagram', image: ImageAsset.instagramIcon),
    SocialItem(id: 5, name: 'App Store', image: ImageAsset.appStoreIcon),
  ];

  int selectedItem = 1;

  changeSelectedGender(int value) {
    selectedItem = value;
    emit(OnChangeSelectedState());
  }

  Future<void> sendStep() async {
    emit(Step21LoadingState());
    final whereDidYouHearAboutUs = socialItems.firstWhere((item) => item.id == selectedItem).name;
    final result = await _completeAccountRepo.sendSteps(
      parameter: StepsRequestModel(
        stepNumber: 21,
        whereDidYouHearAboutUs: whereDidYouHearAboutUs,
      ),
    );
    result.fold(
      (failure) => emit(Step21ErrorState(message: failure.message)),
      (data) => emit(Step21SuccessState()),
    );
  }

  static Step21Cubit get(context) => BlocProvider.of(context);
}

class SocialItem {
  int id;
  String name;
  String image;

  SocialItem({required this.id, required this.name, required this.image});
}
