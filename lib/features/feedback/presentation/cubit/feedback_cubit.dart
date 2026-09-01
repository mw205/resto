import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/network/mock_resto_api.dart';
import '../../data/models/feedback_model.dart';
import 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final MockRestoApi _api;
  final _uuid = const Uuid();

  FeedbackCubit(this._api) : super(const FeedbackState());

  Future<void> submitOrderRating({
    required String orderId,
    required double rating,
    required List<String> selectedTags,
    required String comment,
  }) async {
    emit(state.copyWith(status: FeedbackStatus.loading, errorMessage: null));
    try {
      final feedback = OrderFeedbackModel(
        id: _uuid.v4(),
        orderId: orderId,
        rating: rating,
        selectedTags: selectedTags,
        comment: comment,
        createdAt: DateTime.now(),
      );
      await _api.submitFeedback(feedback);
      emit(state.copyWith(
        status: FeedbackStatus.success,
        successMessage: 'شكراً لمشاركتك! تم تسجيل تقييمك بنجاح',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FeedbackStatus.error,
        errorMessage: 'تعذر إرسال التقييم، يرجى المحاولة لاحقاً',
      ));
    }
  }

  Future<void> submitComplaint({
    String? orderId,
    required String subject,
    required String message,
  }) async {
    emit(state.copyWith(status: FeedbackStatus.loading, errorMessage: null));
    try {
      final complaint = ComplaintModel(
        id: _uuid.v4(),
        orderId: orderId,
        subject: subject,
        message: message,
        createdAt: DateTime.now(),
      );
      await _api.submitComplaint(complaint);
      emit(state.copyWith(
        status: FeedbackStatus.success,
        successMessage: 'تم إرسال رسالتك إلى إدارة ريستو وسيتم الرد عليك في أقرب وقت',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FeedbackStatus.error,
        errorMessage: 'تعذر إرسال الشكوى، يرجى المحاولة لاحقاً',
      ));
    }
  }

  void resetStatus() {
    emit(const FeedbackState());
  }
}
