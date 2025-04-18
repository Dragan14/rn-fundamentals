import { StatusBar } from "expo-status-bar";
import { Stack } from "expo-router";
import { SafeAreaProvider } from "react-native-safe-area-context";
import { ThemeProvider, useTheme } from "@/context/ThemeContext";

function App() {
  const { theme } = useTheme();
  return (
    <SafeAreaProvider>
      <StatusBar backgroundColor={theme.colors.background} />
      <Stack
        screenOptions={{
          navigationBarColor: theme.colors.background,
          headerStyle: {
            backgroundColor: theme.colors.background,
          },
          headerTintColor: theme.colors.primary,
          headerTitleStyle: { color: theme.colors.onBackground },
        }}
      >
        <Stack.Screen
          name="index"
          options={{ title: "Home", headerShown: false }}
        />
        <Stack.Screen name="button" options={{ title: "Button" }} />
        <Stack.Screen name="textinput" options={{ title: "Text Input" }} />
        <Stack.Screen name="text" options={{ title: "Text" }} />
        <Stack.Screen
          name="segmentedcontrol"
          options={{ title: "Segmented Control" }}
        />
        <Stack.Screen name="switch" options={{ title: "Switch" }} />
        <Stack.Screen
          name="+not-found"
          options={{ title: "Not Found", headerShown: false }}
        />
      </Stack>
    </SafeAreaProvider>
  );
}

export default function RootLayout() {
  return (
    <ThemeProvider>
      <App />
    </ThemeProvider>
  );
}
