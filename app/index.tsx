import { ScrollView } from "react-native";
import { Link } from "expo-router";
import SafeAreaView from "@/components/SafeAreaView";
import Button from "@/components/Button";
import Text from "@/components/Text";

export default function Home() {
  return (
    <SafeAreaView>
      <ScrollView
        style={{
          paddingTop: 20,
          paddingHorizontal: 10,
        }}
        contentContainerStyle={{
          gap: 20,
        }}
      >
        <Text
          style={{
            fontSize: 20,
            fontWeight: "bold",
            textAlign: "center",
          }}
        >
          React Native Fundamental Components
        </Text>
        <Link href="/button" asChild>
          <Button
            style={{
              width: 350,
              marginHorizontal: "auto",
            }}
          >
            Button Component
          </Button>
        </Link>
        <Link href="/textinput" asChild>
          <Button
            style={{
              width: 350,
              marginHorizontal: "auto",
            }}
          >
            Text Input Component
          </Button>
        </Link>
        <Link href="/text" asChild>
          <Button
            style={{
              width: 350,
              marginHorizontal: "auto",
            }}
          >
            Text Component
          </Button>
        </Link>
        <Link href="/segmentedcontrol" asChild>
          <Button
            style={{
              width: 350,
              marginHorizontal: "auto",
            }}
          >
            Segmented Control Component
          </Button>
        </Link>
      </ScrollView>
    </SafeAreaView>
  );
}
