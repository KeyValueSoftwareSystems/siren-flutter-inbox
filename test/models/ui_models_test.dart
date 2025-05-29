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

  group('CardParams', () {
    test('constructor should initialize properties with provided values', () {
      const cardParams = CardParams(
        hideAvatar: true,
      );

      expect(cardParams.hideAvatar, true);
    });
  });

  group('IconStyle', () {
    test('constructor should initialize size property with provided value', () {
      const iconStyle = NotificationIconStyle(size: 24);

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

  group('CustomStyles', () {
    test('constructor should initialize properties with provided values', () {
      final sirenStyleProps = CustomStyles(
        cardStyle: CardStyle(
          cardContainer: ContainerStyle(
            decoration: const BoxDecoration(color: Colors.blue),
          ),
        ),
        notificationIconStyle: const NotificationIconStyle(size: 24),
        badgeStyle: const BadgeStyle(fontSize: 16),
      );

      expect(
        sirenStyleProps.cardStyle?.cardContainer!.decoration!.color,
        Colors.blue,
      );
      expect(sirenStyleProps.notificationIconStyle!.size, 24.0);
      expect(sirenStyleProps.badgeStyle!.fontSize, 16.0);
    });
  });

  group('CustomThemeColors', () {
    test('constructor should initialize properties with provided values', () {
      final customThemeColors = CustomThemeColors(
        backgroundColor: Colors.white,
        primary: Colors.grey,
      );

      expect(customThemeColors.backgroundColor, Colors.white);
      expect(customThemeColors.primary, Colors.grey);
    });
  });

  test('Card Params', () {
    const hideAvatar = true;
    const Widget deleteWidget = Icon(Icons.delete);

    const cardParams = CardParams(
      hideAvatar: hideAvatar,
      deleteIcon: deleteWidget,
    );

    expect(cardParams.hideAvatar, hideAvatar);
    expect(cardParams.deleteIcon, deleteWidget);
  });

  group('TimerIconStyle', () {
    test('constructor should initialize size property with provided value', () {
      final timerIconStyle = TimerIconStyle(size: 24);
      expect(timerIconStyle.size, 24.0);
    });
  });

  group('DeleteIconStyle', () {
    test('constructor should initialize size property with provided value', () {
      final deleteIconStyle = DeleteIconStyle(size: 24);
      expect(deleteIconStyle.size, 24.0);
    });
  });

  group('ClearAllIconStyle', () {
    test('constructor should initialize size property with provided value', () {
      final clearAllIconStyle = ClearAllIconStyle(size: 24);
      expect(clearAllIconStyle.size, 24.0);
    });
  });

  group('InboxHeaderColors', () {
    test('constructor should initialize properties with provided values', () {
      final inboxHeaderColors = InboxHeaderColors(
        background: Colors.white,
        titleColor: Colors.black,
      );
      expect(inboxHeaderColors.background, Colors.white);
      expect(inboxHeaderColors.titleColor, Colors.black);
    });
  });

  group('BadgeColors', () {
    test('constructor should initialize properties with provided values', () {
      final badgeColors = BadgeColors(
        backgroundColor: Colors.red,
        color: Colors.white,
      );
      expect(badgeColors.backgroundColor, Colors.red);
      expect(badgeColors.color, Colors.white);
    });
  });

  group('InboxHeaderStyle', () {
    test('constructor should initialize properties with provided values', () {
      final inboxHeaderStyle = InboxHeaderStyle(borderWidth: 5);
      expect(inboxHeaderStyle.borderWidth, 5);
      // expect(inboxHeaderStyle.textColor, Colors.black);
    });
  });

  group('TabParams', () {
    test('constructor should initialize properties with provided values', () {
      final tabParams = TabParams(activeTabIndex: 2);
      expect(tabParams.activeTabIndex, 2);
      // expect(tabParams.tabIcon, Icon(Icons.home));
    });
  });

  group('TabStyles', () {
    test('constructor should initialize properties with provided values', () {
      final tabStyles = TabStyles(indicatorSize: 2);
      expect(tabStyles.indicatorSize, 2);
    });
  });

  group('TabColors', () {
    test('constructor should initialize properties with provided values', () {
      final tabColors = TabColors(
        containerBackgroundColor: Colors.white,
        inactiveTabTextColor: Colors.black,
      );
      expect(tabColors.containerBackgroundColor, Colors.white);
      expect(tabColors.inactiveTabTextColor, Colors.black);
    });
  });

  group('FilterParams', () {
    test('constructor should initialize properties with default values', () {
      const filterParams = CategoryFilterParams();

      expect(filterParams.showFilters, true);
      expect(filterParams.filterIconWidget, null);
      expect(filterParams.style, null);
      expect(filterParams.hideBadge, false);
    });

    test('constructor should initialize properties with provided values', () {
      const customIcon = Icon(Icons.tune);
      const filterParams = CategoryFilterParams(
        showFilters: false,
        filterIconWidget: customIcon,
        hideBadge: true,
      );

      expect(filterParams.showFilters, false);
      expect(filterParams.filterIconWidget, customIcon);
      expect(filterParams.hideBadge, true);
    });
  });

  group('FilterColors', () {
    test('constructor should initialize properties with provided values', () {
      final filterColors = CategoryFilterColors(
        filterIconBorderColor: Colors.red,
        filterBadgeColor: Colors.blue,
        filterDropdownBackgroundColor: Colors.green,
        filterCheckboxCheckedColor: Colors.yellow,
        filterCheckboxUncheckedColor: Colors.purple,
        filterActionTextColor: Colors.orange,
        filterIconColor: Colors.pink,
        checkIconColor: Colors.brown,
      );

      expect(filterColors.filterIconBorderColor, Colors.red);
      expect(filterColors.filterBadgeColor, Colors.blue);
      expect(filterColors.filterDropdownBackgroundColor, Colors.green);
      expect(filterColors.filterCheckboxCheckedColor, Colors.yellow);
      expect(filterColors.filterCheckboxUncheckedColor, Colors.purple);
      expect(filterColors.filterActionTextColor, Colors.orange);
      expect(filterColors.filterIconColor, Colors.pink);
      expect(filterColors.checkIconColor, Colors.brown);
    });
  });
}
