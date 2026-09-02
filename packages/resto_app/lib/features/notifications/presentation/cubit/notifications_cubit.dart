import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/mock_resto_api.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final MockRestoApi _api;

  NotificationsCubit(this._api) : super(const NotificationsState()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    emit(state.copyWith(status: NotificationsStatus.loading, errorMessage: null));
    try {
      final list = await _api.getNotifications();
      emit(state.copyWith(status: NotificationsStatus.success, notifications: list));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: 'تعذر جلب الإشعارات',
      ));
    }
  }

  Future<void> markAllAsRead() async {
    await _api.markNotificationsAsRead();
    final list = await _api.getNotifications();
    emit(state.copyWith(notifications: list));
  }
}
