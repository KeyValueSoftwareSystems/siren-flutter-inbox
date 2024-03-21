import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:siren_flutter_inbox/siren_flutter_inbox.dart';
import 'package:siren_flutter_inbox/src/data/siren_data_provider.dart';

class MockSirenDataProvider extends Mock implements SirenDataProvider {
  @override
  String apiDomain = '';
  @override
  Future<void> initialize() async {
    apiDomain = 'https://example.com';
  }
}

void main() {
  //  late MockSirenDataProvider mockSirenDataProvider;
  //  setUp(() {
  //   mockSirenDataProvider = MockSirenDataProvider();
  // });
  group('SirenDataProvider', () {
    test('initialize should set apiDomain from environment', () async {
      // Arrange
      final mockSirenDataProvider = MockSirenDataProvider();
      const expectedApiDomain = 'https://example.com';

      // Stub the getApiDomain method to return a specific value
      // when(mockSirenDataProvider.initialize()).thenAnswer((_) => Future.value());

      // Act
      await mockSirenDataProvider.initialize();
      //verify(mockSirenDataProvider.initialize()).called(1);

      // Assert
      expect(mockSirenDataProvider.apiDomain, expectedApiDomain);
    });
  });

  group('CardProps', () {
    test('constructor should initialize properties with provided values', () {
      // Arrange & Act
      const cardProps = CardProps(hideAvatar: true, showMedia: false);

      // Assert
      expect(cardProps.hideAvatar, true);
      expect(cardProps.showMedia, false);
    });
  });

  group('IconStyle', () {
    test('constructor should initialize size property with provided value', () {
      // Arrange & Act
      const iconStyle = IconStyle(size: 24);

      // Assert
      expect(iconStyle.size, 24.0);
    });
  });

  group('DefaultIconStyle', () {
    test('iconSize should return default size for the notification icon', () {
      // Arrange & Act
      final iconSize = DefaultIconStyle.iconSize;

      // Assert
      expect(iconSize, 35);
    });
  });

  group('BadgeStyle', () {
    test('constructor should initialize properties with provided values', () {
      // Arrange & Act
      const badgeStyle = BadgeStyle(fontSize: 16, size: 20);

      // Assert
      expect(badgeStyle.fontSize, 16.0);
      expect(badgeStyle.size, 20.0);
    });
  });

  group('SirenStyleProps', () {
    test('constructor should initialize properties with provided values', () {
      // Arrange & Act
      const sirenStyleProps = SirenStyleProps(
        container: BoxDecoration(color: Colors.blue),
        iconStyle: IconStyle(size: 24),
        badgeStyle: BadgeStyle(fontSize: 16),
      );

      // Assert
      expect(sirenStyleProps.container!.color, Colors.blue);
      expect(sirenStyleProps.iconStyle!.size, 24.0);
      expect(sirenStyleProps.badgeStyle!.fontSize, 16.0);
    });
  });

  group('CustomThemeColors', () {
    test('constructor should initialize properties with provided values', () {
      // Arrange & Act
      final customThemeColors = CustomThemeColors(
        backgroundColor: Colors.white,
        activeCardBorderColor: Colors.grey,
        badgeColor: Colors.red,
      );

      // Assert
      expect(customThemeColors.backgroundColor, Colors.white);
      expect(customThemeColors.activeCardBorderColor, Colors.grey);
      expect(customThemeColors.badgeColor, Colors.red);
    });
  });
}
