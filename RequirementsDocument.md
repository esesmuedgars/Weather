## Klarna iOS Developer Test Assignment

### Task

Create a simple single-view controller application which displays the weather for the users' location.

The assignment is broken down into two steps, where the second step is a continuation which is performed as a follow-up interview.

### Requirements

There is no big emphasis on visual design, but thought should be taken into account regarding overall architecture (ie. whether you're using Storyboards/Inteface Builder or not, whether you use MVC, MVVM, etc.).

Similarly, there are no requirements as to what architecture you should choose, but we recommend you choose the architecture you're most comfortable with.

Use of third-party libraries (e.g. Carthage/CocoaPods/Swift Package Manager) should be kept to a minimum, to make it easy for us to build and run your project – but if you include any, provide a readme with instructions to how to build and run it.

### Data specification

The weather forecast are available at [Dark Sky API](https://darksky.net/dev/docs#forecast-request). Values are encoded in JSON with the following schema:

```json
{
    "latitude": 59.337239,
    "longitude": 18.062381,
    "timezone": "Europe/Stockholm",
    "currently": {
        "time": 1537882620,
        "summary": "Clear",
        "icon": "clear-day",
        "precipIntensity": 0,
        "precipProbability": 0,
        "temperature": 40.46,
        "apparentTemperature": 33.75,
        "dewPoint": 29.59,
        "humidity": 0.65,
        "pressure": 1025.41,
        "windSpeed": 11.15,
        "windGust": 21.55,
        "windBearing": 295,
        "cloudCover": 0.03,
        "uvIndex": 0,
        "visibility": 8.32,
        "ozone": 321.6
    },
    "hourly": { },
    "daily": { },
    "flags": { },
    "offset": 2
}
```
***Note**: Some fields in the JSON might not exist, you might want to perform checks to avoid potential crashes.*

### Delivery

Once finished, deliver the result of the assignment either as project available on an open-source hosting provider such as GitHub or Bitbucket or as a zip file of the entire project.
