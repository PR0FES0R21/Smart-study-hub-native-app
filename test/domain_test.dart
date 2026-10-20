import 'package:flutter_test/flutter_test.dart';
import 'package:smart_study_hub/domain.dart';

void main() {
  late Candidate a, b;
  late ExamRoom room;
  setUp(() {
    a = Candidate('a', 'A', 'X');
    b = Candidate('b', 'B', 'X');
    room = ExamRoom(id: 'r', candidates: [a, b], normalSeconds: 100);
  });
  test('Opening required; origin never reset', () {
    room.advance(50);
    expect(a.usedSeconds, 0);
    expect(room.state(a), AttemptState.ready);
    final start = DateTime(2026);
    room.open(start);
    room.advance(10);
    room.pause();
    room.open(DateTime(2027));
    expect(room.firstOpenedAt, start);
    expect(a.usedSeconds, 10);
  });
  test('Overlapping room and personal pauses', () {
    room.open(DateTime(2026));
    room.advance(10);
    room.hold(a, true);
    room.advance(20);
    room.pause();
    room.advance(30);
    room.open(DateTime(2026));
    room.advance(10);
    expect(a.usedSeconds, 10);
    expect(b.usedSeconds, 40);
    expect(room.state(a), AttemptState.paused);
    room.hold(a, false);
    room.advance(5);
    expect(a.usedSeconds, 15);
  });
  test('Exhaustion nonfinal; grant preserves hold', () {
    room.open(DateTime(2026));
    room.advance(101);
    expect(room.state(a), AttemptState.exhausted);
    expect(a.isFinal, false);
    room.hold(a, true);
    room.grant(a, 20, 'g');
    expect(room.state(a), AttemptState.paused);
    room.hold(a, false);
    room.advance(10);
    expect(room.extraConsumed(a), 10);
    expect(room.normalSeconds, 100);
  });
  test('Grant idempotent per participant', () {
    room.grant(a, 10, 'g');
    room.grant(a, 10, 'g');
    room.grant(b, 10, 'g');
    expect(a.extraSeconds, 10);
    expect(b.extraSeconds, 10);
  });
  test('Offline does not pause time', () {
    room.open(DateTime(2026));
    a.connection = 'Offline';
    room.advance(25);
    expect(a.usedSeconds, 25);
  });
  test('Final cannot resume or receive changes', () {
    room.open(DateTime(2026));
    room.finish(a);
    expect(() => room.hold(a, false), throwsStateError);
    expect(() => room.grant(a, 10, 'g'), throwsStateError);
    expect(room.acceptAnswer(a, 1, 'q', 'a'), false);
    room.advance(50);
    expect(a.usedSeconds, 0);
  });
  test('Violation needs reason and separate final state', () {
    expect(() => room.finish(a, violation: true), throwsArgumentError);
    room.finish(a, violation: true, reason: 'Tinjauan selesai');
    expect(room.state(a), AttemptState.terminated);
  });
  test('Transfer consent, ACK preservation and revoked epoch', () {
    room.open(DateTime(2026));
    room.acceptAnswer(a, 1, 'q1', 'b');
    expect(
      () => room.transfer(a, destination: 'new', syncCertain: false),
      throwsStateError,
    );
    expect(a.deviceEpoch, 1);
    room.transfer(a, destination: 'new', syncCertain: false, consent: true);
    expect(a.acknowledgedAnswers['q1'], 'b');
    expect(room.acceptAnswer(a, 1, 'q1', 'c'), false);
    expect(room.acceptAnswer(a, 2, 'q1', 'd'), true);
  });
  test('Essay disables immediate release permanently until chosen again', () {
    final e = Assessment(title: 't', subject: 's', essayCount: 0);
    e.setImmediate(true);
    expect(e.immediate, true);
    e.setEssays(1);
    expect(e.immediate, false);
    e.setEssays(0);
    expect(e.immediate, false);
  });
  test('Grading and publication separate with correct authority', () {
    final e = Assessment(title: 't', subject: 's', essayCount: 1);
    expect(() => e.publish('Admin'), throwsStateError);
    e.graded = true;
    expect(e.published, false);
    expect(() => e.publish('Guru'), throwsStateError);
    e.publish('Admin');
    expect(e.published, true);
    final quiz = Assessment(
      title: 't',
      subject: 's',
      essayCount: 1,
      official: false,
    )..graded = true;
    expect(() => quiz.publish('Admin'), throwsStateError);
    quiz.publish('Guru');
    expect(quiz.published, true);
  });
  test('Access separate from completion and prerequisite respected', () {
    final l1 = Lesson(id: 'a', title: 'a', summary: '');
    final l2 = Lesson(
      id: 'b',
      title: 'b',
      summary: '',
      access: AccessMode.conditional,
      prerequisite: 'a',
    );
    final all = [l1, l2];
    expect(l1.accessible(all), true);
    expect(l1.complete, false);
    expect(l2.accessible(all), false);
    l1.complete = true;
    expect(l2.accessible(all), true);
    expect(l2.complete, false);
    l2.access = AccessMode.locked;
    expect(l2.accessible(all), false);
  });
  test('Class revision retains author and isolated source', () {
    final source = Lesson(id: 's', title: 't', summary: '');
    final asset = Lesson(id: 'c', title: 't', summary: '');
    asset.revise('Pengganti');
    expect(asset.originalAuthor, 'Nadia Putri');
    expect(asset.lastEditor, 'Pengganti');
    expect(asset.version, 2);
    expect(source.version, 1);
  });
}
