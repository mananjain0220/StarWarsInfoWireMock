# 🌌 StarWarsInfo — UI Testing with WireMock in Xcode

A demonstration project showcasing how to build **robust UI tests** using **WireMock** to mock local API calls for an iOS app written in Swift.

This app loads character data from the [Star Wars API (SWAPI)](https://swapi.dev/) and allows you to run all tests offline using mocked responses.

🧪 Built following the [Kodeco tutorial](https://www.kodeco.com/3462646-local-api-call-tutorial-with-wiremock-and-ui-tests-in-xcode).

---

## 📦 Features

- Mock network responses using [WireMock](https://wiremock.org/)
- Conditionally switch base URLs based on launch arguments
- Reliable, isolated UI tests with local data
- Coverage for empty states, errors, and loading indicators

---

## 🛠 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/StarWarsInfoWireMock.git
cd StarWarsInfoWireMock


## 2. Start the WireMock Server
Make sure Java is installed:
java -version

## 3 ▶️ Run the App (Mocked Mode)
Open the Xcode project

Go to Product > Scheme > Edit Scheme

Under Run > Arguments, add:
-runlocal

## 🧪 Run UI Tests

## 📁 Project Structure
StarWarsInfo/
├── Vendor/                      # WireMock JAR and mappings
│   ├── wiremock.jar
│   ├── __files/                 # JSON mock responses
│   └── mappings/               # Request → Response mapping rules
├── StarWarsInfoUITests/
│   └── UI test cases
├── StarWarsInfo/
│   ├── ViewControllers/
│   └── ViewModels/
└── README.md


## 📖 Based On
Kodeco Tutorial: Local API Call Testing with WireMock

## 🪐 License
This project is intended for educational and learning purposes. All original content © Razeware/Kodeco.
