import 'dart:ui';

import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SkillConnection', () {
    group('construction', () {
      test('creates with required fields only', () {
        const connection = SkillConnection(
          fromId: 'node_a',
          toId: 'node_b',
        );

        expect(connection.fromId, 'node_a');
        expect(connection.toId, 'node_b');
        expect(connection.type, ConnectionType.required);
        expect(connection.bidirectional, isFalse);
        expect(connection.color, isNull);
        expect(connection.thickness, isNull);
        expect(connection.style, ConnectionStyle.solid);
      });

      test('creates with all optional fields', () {
        const connection = SkillConnection(
          fromId: 'node_a',
          toId: 'node_b',
          type: ConnectionType.optional,
          bidirectional: true,
          color: Color(0xFF00FF00),
          thickness: 2.5,
          style: ConnectionStyle.animated,
        );

        expect(connection.fromId, 'node_a');
        expect(connection.toId, 'node_b');
        expect(connection.type, ConnectionType.optional);
        expect(connection.bidirectional, isTrue);
        expect(connection.color, const Color(0xFF00FF00));
        expect(connection.thickness, 2.5);
        expect(connection.style, ConnectionStyle.animated);
      });
    });

    group('copyWith', () {
      test('creates a copy with updated fields', () {
        const original = SkillConnection(
          fromId: 'a',
          toId: 'b',
          type: ConnectionType.required,
        );

        final copy = original.copyWith(
          type: ConnectionType.optional,
          thickness: 3.0,
        );

        expect(copy.fromId, 'a');
        expect(copy.toId, 'b');
        expect(copy.type, ConnectionType.optional);
        expect(copy.thickness, 3.0);
      });

      test('preserves unchanged fields', () {
        const original = SkillConnection(
          fromId: 'a',
          toId: 'b',
          color: Color(0xFFFF0000),
          style: ConnectionStyle.dashed,
        );

        final copy = original.copyWith(bidirectional: true);

        expect(copy.fromId, 'a');
        expect(copy.toId, 'b');
        expect(copy.color, const Color(0xFFFF0000));
        expect(copy.style, ConnectionStyle.dashed);
        expect(copy.bidirectional, isTrue);
      });
    });

    group('JSON serialization', () {
      test('toJson includes all serializable fields', () {
        const connection = SkillConnection(
          fromId: 'node_a',
          toId: 'node_b',
          type: ConnectionType.exclusive,
          bidirectional: true,
          color: Color(0xFF00FF00),
          thickness: 2.0,
          style: ConnectionStyle.animated,
        );

        final json = connection.toJson();

        expect(json['fromId'], 'node_a');
        expect(json['toId'], 'node_b');
        expect(json['type'], 'exclusive');
        expect(json['bidirectional'], isTrue);
        expect(json['color'], 0xFF00FF00);
        expect(json['thickness'], 2.0);
        expect(json['style'], 'animated');
      });

      test('toJson omits null optional fields', () {
        const connection = SkillConnection(
          fromId: 'a',
          toId: 'b',
        );

        final json = connection.toJson();

        expect(json.containsKey('color'), isFalse);
        expect(json.containsKey('thickness'), isFalse);
      });

      test('fromJson creates equivalent connection', () {
        const original = SkillConnection(
          fromId: 'a',
          toId: 'b',
          type: ConnectionType.optional,
          bidirectional: true,
          color: Color(0xFFFF0000),
          thickness: 1.5,
          style: ConnectionStyle.dashed,
        );

        final json = original.toJson();
        final restored = SkillConnection.fromJson(json);

        expect(restored, equals(original));
      });

      test('fromJson uses defaults for missing fields', () {
        final json = {
          'fromId': 'a',
          'toId': 'b',
        };

        final connection = SkillConnection.fromJson(json);

        expect(connection.type, ConnectionType.required);
        expect(connection.bidirectional, isFalse);
        expect(connection.color, isNull);
        expect(connection.thickness, isNull);
        expect(connection.style, ConnectionStyle.solid);
      });

      test('JSON round-trip preserves all data', () {
        const original = SkillConnection(
          fromId: 'skill_1',
          toId: 'skill_2',
          type: ConnectionType.exclusive,
          bidirectional: false,
          color: Color(0xFF123456),
          thickness: 3.5,
          style: ConnectionStyle.animated,
        );

        final json = original.toJson();
        final restored = SkillConnection.fromJson(json);

        expect(restored.fromId, original.fromId);
        expect(restored.toId, original.toId);
        expect(restored.type, original.type);
        expect(restored.bidirectional, original.bidirectional);
        expect(restored.color, original.color);
        expect(restored.thickness, original.thickness);
        expect(restored.style, original.style);
      });
    });

    group('equality', () {
      test('equal connections are equal', () {
        const conn1 = SkillConnection(
          fromId: 'a',
          toId: 'b',
          type: ConnectionType.required,
        );
        const conn2 = SkillConnection(
          fromId: 'a',
          toId: 'b',
          type: ConnectionType.required,
        );

        expect(conn1, equals(conn2));
        expect(conn1.hashCode, equals(conn2.hashCode));
      });

      test('different connections are not equal', () {
        const conn1 = SkillConnection(fromId: 'a', toId: 'b');
        const conn2 = SkillConnection(fromId: 'a', toId: 'c');

        expect(conn1, isNot(equals(conn2)));
      });

      test('connections with different types are not equal', () {
        const conn1 = SkillConnection(
          fromId: 'a',
          toId: 'b',
          type: ConnectionType.required,
        );
        const conn2 = SkillConnection(
          fromId: 'a',
          toId: 'b',
          type: ConnectionType.optional,
        );

        expect(conn1, isNot(equals(conn2)));
      });
    });

    group('toString', () {
      test('produces readable output', () {
        const connection = SkillConnection(
          fromId: 'slash',
          toId: 'power_slash',
          type: ConnectionType.required,
        );

        expect(
          connection.toString(),
          'SkillConnection(from: slash, to: power_slash, type: required)',
        );
      });
    });
  });

  group('ConnectionType', () {
    test('contains all expected values', () {
      expect(ConnectionType.values, [
        ConnectionType.required,
        ConnectionType.optional,
        ConnectionType.exclusive,
      ]);
    });
  });

  group('ConnectionStyle', () {
    test('contains all expected values', () {
      expect(ConnectionStyle.values, [
        ConnectionStyle.solid,
        ConnectionStyle.dashed,
        ConnectionStyle.animated,
      ]);
    });
  });
}
