// SegmentedControl.tsx
import {
  Children,
  Fragment,
  cloneElement,
  isValidElement,
  ReactElement,
} from "react";
import {
  View,
  Pressable,
  StyleSheet,
  Text,
  ViewStyle,
  StyleProp,
  TextStyle,
  PixelRatio,
} from "react-native";
import { useTheme } from "@/context/ThemeContext";

interface SegmentedControlProps {
  values: ReactElement[];
  selectedIndices: number[];
  onTabPress: (index: number) => void;
  style?: StyleProp<ViewStyle>;
  tabStyle?: StyleProp<ViewStyle>;
  activeTabStyle?: StyleProp<ViewStyle>;
  inactiveTabStyle?: StyleProp<ViewStyle>;
  round?: boolean;
  disabled?: boolean;
}

const scaledSize = (baseSize: number) => {
  return Math.round(baseSize * PixelRatio.getFontScale());
};

const renderElement = (element: ReactElement, color: string): ReactElement => {
  if (element.type === Fragment) {
    const children = Children.map(element.props.children, (child) =>
      isValidElement(child) ? renderElement(child, color) : child,
    );
    return (
      <View
        style={{
          gap: 5,
          flexWrap: "wrap",
          flexDirection: "row",
          alignItems: "center",
          justifyContent: "center",
        }}
      >
        {children}
      </View>
    );
  } else if (element.type === Text) {
    const originalStyle = StyleSheet.flatten(element.props.style) || {};
    return cloneElement(element, {
      style: [originalStyle, { color: color }] as StyleProp<TextStyle>,
    });
  } else {
    return cloneElement(element, {
      color: element.props.color ?? color,
      size:
        (element.props.size && scaledSize(element.props.size)) ??
        scaledSize(24),
    });
  }
};

export const SegmentedControl = ({
  values,
  selectedIndices,
  onTabPress,
  style,
  tabStyle,
  activeTabStyle,
  inactiveTabStyle,
  round = false,
  disabled = false,
}: SegmentedControlProps) => {
  const { theme } = useTheme();

  const borderRadius = round ? 20 : 5;

  const colors = {
    selectedContent: disabled
      ? theme.colors.onBackgroundDisabled
      : theme.colors.onSecondaryContainer,
    unselectedContent: disabled
      ? theme.colors.onBackgroundDisabled
      : theme.colors.onBackground,
    border: disabled
      ? theme.colors.onBackgroundDisabled
      : theme.colors.secondary,
    activeTab: disabled
      ? theme.colors.backgroundDisabled
      : theme.colors.secondaryContainer,
  };

  return (
    <View style={[{ borderRadius: borderRadius }, styles.container, style]}>
      {values.map((valueElement, index) => {
        const isSelected = selectedIndices.includes(index);
        const isLastTab = index === values.length - 1;
        const currentTabBackgroundStyle = isSelected
          ? [{ backgroundColor: colors.activeTab }, activeTabStyle]
          : [styles.tabInactive, inactiveTabStyle];
        const tabBorderStyle = {
          borderRightWidth: isLastTab ? 1 : 0,
          borderTopLeftRadius: index === 0 ? borderRadius : 0,
          borderBottomLeftRadius: index === 0 ? borderRadius : 0,
          borderTopRightRadius: isLastTab ? borderRadius : 0,
          borderBottomRightRadius: isLastTab ? borderRadius : 0,
        };
        const contentColor = isSelected
          ? colors.selectedContent
          : colors.unselectedContent;
        const renderedContent = renderElement(valueElement, contentColor);
        return (
          <Pressable
            key={index}
            onPress={() => onTabPress(index)}
            style={[
              { borderColor: colors.border },
              styles.tabBase,
              tabStyle,
              tabBorderStyle,
              currentTabBackgroundStyle,
            ]}
            disabled={disabled}
          >
            {renderedContent}
          </Pressable>
        );
      })}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: "row",
    backgroundColor: "transparent",
  },
  tabBase: {
    flex: 1,
    padding: 5,
    justifyContent: "center",
    alignItems: "center",
    borderWidth: 1,
    borderRightWidth: 0,
  },
  tabInactive: {
    backgroundColor: "transparent",
  },
});
