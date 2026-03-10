import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UnlockResult', () {
    late SkillNode<void> testNode;

    setUp(() {
      testNode = SkillNode<void>(
        id: 'test_node',
        name: 'Test Node',
        tier: 0,
        costs: [2],
      );
    });

    group('success factory', () {
      test('creates a successful result', () {
        final result = UnlockResult<void>.success(
          node: testNode,
          pointsSpent: 2,
          newLevel: 1,
        );

        expect(result.success, isTrue);
        expect(result.failed, isFalse);
        expect(result.node, equals(testNode));
        expect(result.pointsSpent, equals(2));
        expect(result.newLevel, equals(1));
        expect(result.reason, isNull);
      });
    });

    group('failure factory', () {
      test('creates a failed result with reason', () {
        final result = UnlockResult<void>.failure(
          reason: UnlockFailureReason.insufficientPoints,
          node: testNode,
        );

        expect(result.success, isFalse);
        expect(result.failed, isTrue);
        expect(result.reason, equals(UnlockFailureReason.insufficientPoints));
        expect(result.node, equals(testNode));
        expect(result.pointsSpent, equals(0));
        expect(result.newLevel, equals(0));
      });

      test('creates a failed result without node', () {
        final result = UnlockResult<void>.failure(
          reason: UnlockFailureReason.nodeNotFound,
        );

        expect(result.success, isFalse);
        expect(result.node, isNull);
        expect(result.reason, equals(UnlockFailureReason.nodeNotFound));
      });

      test('creates failure for prerequisitesNotMet', () {
        final result = UnlockResult<void>.failure(
          reason: UnlockFailureReason.prerequisitesNotMet,
          node: testNode,
        );

        expect(result.reason, equals(UnlockFailureReason.prerequisitesNotMet));
      });

      test('creates failure for alreadyMaxed', () {
        final result = UnlockResult<void>.failure(
          reason: UnlockFailureReason.alreadyMaxed,
          node: testNode,
        );

        expect(result.reason, equals(UnlockFailureReason.alreadyMaxed));
      });

      test('creates failure for lockedByExclusive', () {
        final result = UnlockResult<void>.failure(
          reason: UnlockFailureReason.lockedByExclusive,
          node: testNode,
        );

        expect(result.reason, equals(UnlockFailureReason.lockedByExclusive));
      });
    });

    group('equality', () {
      test('equal success results are equal', () {
        final a = UnlockResult<void>.success(
          node: testNode,
          pointsSpent: 2,
          newLevel: 1,
        );
        final b = UnlockResult<void>.success(
          node: testNode,
          pointsSpent: 2,
          newLevel: 1,
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('equal failure results are equal', () {
        final a = UnlockResult<void>.failure(
          reason: UnlockFailureReason.insufficientPoints,
          node: testNode,
        );
        final b = UnlockResult<void>.failure(
          reason: UnlockFailureReason.insufficientPoints,
          node: testNode,
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different results are not equal', () {
        final success = UnlockResult<void>.success(
          node: testNode,
          pointsSpent: 2,
          newLevel: 1,
        );
        final failure = UnlockResult<void>.failure(
          reason: UnlockFailureReason.insufficientPoints,
          node: testNode,
        );

        expect(success, isNot(equals(failure)));
      });

      test('results with different pointsSpent are not equal', () {
        final a = UnlockResult<void>.success(
          node: testNode,
          pointsSpent: 2,
          newLevel: 1,
        );
        final b = UnlockResult<void>.success(
          node: testNode,
          pointsSpent: 3,
          newLevel: 1,
        );

        expect(a, isNot(equals(b)));
      });

      test('results with different newLevel are not equal', () {
        final a = UnlockResult<void>.success(
          node: testNode,
          pointsSpent: 2,
          newLevel: 1,
        );
        final b = UnlockResult<void>.success(
          node: testNode,
          pointsSpent: 2,
          newLevel: 2,
        );

        expect(a, isNot(equals(b)));
      });

      test('failures with different reasons are not equal', () {
        final a = UnlockResult<void>.failure(
          reason: UnlockFailureReason.insufficientPoints,
        );
        final b = UnlockResult<void>.failure(
          reason: UnlockFailureReason.alreadyMaxed,
        );

        expect(a, isNot(equals(b)));
      });
    });

    group('toString', () {
      test('success toString contains node id and details', () {
        final result = UnlockResult<void>.success(
          node: testNode,
          pointsSpent: 2,
          newLevel: 1,
        );

        final str = result.toString();
        expect(str, contains('success'));
        expect(str, contains('test_node'));
        expect(str, contains('2'));
        expect(str, contains('1'));
      });

      test('failure toString contains reason and node id', () {
        final result = UnlockResult<void>.failure(
          reason: UnlockFailureReason.insufficientPoints,
          node: testNode,
        );

        final str = result.toString();
        expect(str, contains('failure'));
        expect(str, contains('insufficientPoints'));
        expect(str, contains('test_node'));
      });

      test('failure toString handles null node', () {
        final result = UnlockResult<void>.failure(
          reason: UnlockFailureReason.nodeNotFound,
        );

        final str = result.toString();
        expect(str, contains('failure'));
        expect(str, contains('nodeNotFound'));
        expect(str, contains('null'));
      });
    });
  });

  group('UnlockFailureReason', () {
    test('has all expected values', () {
      expect(
        UnlockFailureReason.values,
        containsAll([
          UnlockFailureReason.insufficientPoints,
          UnlockFailureReason.prerequisitesNotMet,
          UnlockFailureReason.alreadyMaxed,
          UnlockFailureReason.nodeNotFound,
          UnlockFailureReason.lockedByExclusive,
        ]),
      );
    });

    test('has exactly 5 values', () {
      expect(UnlockFailureReason.values.length, equals(5));
    });
  });
}
