# Zig User Map

This is the second attempt on creating a cool map where you can see the (rough) locations of all ziguanas out there!

**[Visit the map!](https://usermap.random-projects.net/)**

## Contribution

If you want to add yourself to the repo, make a PR that adds a file to the folder [`people`](people/). This file has to have the following format and should have `${your-nick}.json` as name:

```json
{
  "nick": "xq",
  "coordinates": [
    48.77844,
    9.18014
  ],
  "links": {
    "Website": "https://random-projects.net",
    "GitHub": "https://github.com/MasterQ32"
  }
}
```

Some tips:
- You can [create the file online](https://github.com/zig-community/user-map/new/master/people)
- You can find your location with either [OpenStreet Maps](https://www.openstreetmap.org/), [Google Maps](https://www.google.com/maps) or your mobile phone if GPS is enabled
- `links` is an object where each key will be displayed as a link with the string content as `href`.
- You decide how precise you want it to be. On your room, just the right street, the center of the city, center of the country. You decide!
