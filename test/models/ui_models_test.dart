import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sirenapp_flutter_inbox/sirenapp_flutter_inbox.dart';
import 'package:sirenapp_flutter_inbox/src/data/siren_data_provider.dart';

class MockSirenDataProvider extends Mock implements SirenDataProvider {
  @override
  String apiDomain = '';
  @override
  Future<void> initialize() async {
    apiDomain = 'https://example.com';
  }
}

void main() {
  group('SirenDataProvider', () {
    test('initialize should set apiDomain from environment', () async {
      final mockSirenDataProvider = MockSirenDataProvider();
      const expectedApiDomain = 'https://example.com';

      await mockSirenDataProvider.initialize();
      expect(mockSirenDataProvider.apiDomain, expectedApiDomain);
    });
  });

  group('CardProps', () {
    test('constructor should initialize properties with provided values', () {
      const cardProps = CardProps(hideAvatar: true,);

      expect(cardProps.hideAvatar, true);
    });
  });

  group('IconStyle', () {
    test('constructor should initialize size property with provided value', () {
      const iconStyle = IconStyle(size: 24);

      expect(iconStyle.size, 24.0);
    });
  });

  group('DefaultIconStyle', () {
    test('iconSize should return default size for the notification icon', () {
      final defaultFontSize = DefaultIconStyle.defaultFontSize;
      final defaultSize = DefaultIconStyle.defaultSize;
      final defaultTop = DefaultIconStyle.defaultTop;
      final defaultRight = DefaultIconStyle.defaultRight;
      final iconSize = DefaultIconStyle.iconSize;

      expect(defaultFontSize, 10);
      expect(defaultSize, 20);
      expect(defaultTop, 0);
      expect(defaultRight, 2);
      expect(iconSize, 35);
    });
  });

  group('BadgeStyle', () {
    test('constructor should initialize properties with provided values', () {
      const badgeStyle = BadgeStyle(fontSize: 16, size: 20);

      expect(badgeStyle.fontSize, 16.0);
      expect(badgeStyle.size, 20.0);
    });
  });

  group('SirenStyleProps', () {
    test('constructor should initialize properties with provided values', () {
      final sirenStyleProps = SirenStyleProps(
        cardContainer:
            ContainerStyle(decoration: const BoxDecoration(color: Colors.blue)),
        iconStyle: const IconStyle(size: 24),
        badgeStyle: const BadgeStyle(fontSize: 16),
      );

      expect(sirenStyleProps.cardContainer!.decoration!.color, Colors.blue);
      expect(sirenStyleProps.iconStyle!.size, 24.0);
      expect(sirenStyleProps.badgeStyle!.fontSize, 16.0);
    });
  });

  group('CustomThemeColors', () {
    test('constructor should initialize properties with provided values', () {
      final customThemeColors = CustomThemeColors(
        backgroundColor: Colors.white,
        primary: Colors.grey,
        badgeColor: Colors.red,
      );

      expect(customThemeColors.backgroundColor, Colors.white);
      expect(customThemeColors.primary, Colors.grey);
      expect(customThemeColors.badgeColor, Colors.red);
    });
  });

  test('Card Params', () {
    const hideAvatar = true;
    const Widget deleteWidget = Icon(Icons.delete);

    const cardParams = CardProps(
      hideAvatar: hideAvatar,
      deleteWidget: deleteWidget,
    );

    expect(cardParams.hideAvatar, hideAvatar);
    expect(cardParams.deleteWidget, deleteWidget);
  });
}
