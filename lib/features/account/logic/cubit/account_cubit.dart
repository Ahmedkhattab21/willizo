import 'package:bloc/bloc.dart';
import 'package:willizo/core/services/cache_helper.dart';
import 'package:willizo/core/utils/constant_keys.dart';
import 'package:willizo/features/account/data/models/account_resonse.dart';
import 'package:willizo/features/account/data/models/update_profile_request_model.dart';
import 'package:willizo/features/account/data/repo/account_repo.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this._accountRepo) : super(AccountInitial());
  final AccountRepo _accountRepo;
  AccountResponseModel? _accountData;

  Future<void> getAccountData() async {
    emit(FetchAccountLoadingState());
    final result = await _accountRepo.getAccountData();
    result.fold(
      (failure) => emit(FetchAccountErrorState(message: failure.message)),
      (data) {
        _accountData = data;
        emit(FetchAccountLoadedState(accountData: data));
      },
    );
  }

  Future<void> logout({required AccountActionType actionType}) async {
    emit(
      AccountActionLoadingState(
        actionType: actionType,
        accountData: _accountData,
      ),
    );
    final result = await _accountRepo.logout();
    await result.fold(
      (failure) async {
        emit(
          AccountActionErrorState(
            message: failure.message,
            accountData: _accountData,
          ),
        );
      },
      (response) async {
        await _clearAuthData();
        emit(
          AccountActionSuccessState(
            message: response.message ?? 'Logged out successfully',
            actionType: actionType,
          ),
        );
      },
    );
  }

  Future<void> updateProfile(UpdateProfileRequestModel requestModel) async {
    emit(UpdateProfileLoadingState(accountData: _accountData));
    final result = await _accountRepo.updateProfile(requestModel);
    result.fold(
      (failure) {
        emit(
          UpdateProfileErrorState(
            message: failure.message,
            accountData: _accountData,
          ),
        );
      },
      (data) {
        _accountData = data;
        emit(UpdateProfileSuccessState(accountData: data));
      },
    );
  }

  Future<void> updateProfilePhoto(String imagePath) async {
    emit(UpdateProfilePhotoLoadingState(accountData: _accountData));
    final result = await _accountRepo.updateProfilePhoto(imagePath);
    result.fold(
      (failure) {
        emit(
          UpdateProfilePhotoErrorState(
            message: failure.message,
            accountData: _accountData,
          ),
        );
      },
      (data) {
        _accountData = data;
        emit(UpdateProfilePhotoSuccessState(accountData: data));
      },
    );
  }

  Future<void> _clearAuthData() async {
    await CacheHelper.removeSecureData(ConstantKeys.saveTokenToShared);
    await CacheHelper.removeSecureData(ConstantKeys.saveRefreshTokenToShared);
    await CacheHelper.removeSecureData(ConstantKeys.saveNameToShared);
    await CacheHelper.removeSecureData(ConstantKeys.saveEmailToShared);
    await CacheHelper.removeSecureData(ConstantKeys.savePhoneToShared);
  }
}
