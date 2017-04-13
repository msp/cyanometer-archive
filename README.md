# Cyanometer Archive
Navigate the Cyanometer archive


## Local setup

- [Install Node](https://nodejs.org/en/download/)

Install the necessary node packages:

```
npm install
```

## Test / Develop:

In one terminal run the webpack dev server which defaults to the fake, embedded API (readonly):

```
npm run dev
```

Or choose an API (the Cyanometer API [source is here](https://github.com/msp/cyanometer))

```
# fake, embedded
npm run api
open http://localhost:4000

# local API
API_ENDPOINT=http://localhost:4000/api/locations/1/images/ npm run dev

# staging
API_ENDPOINT=https://cyanometer-staging.herokuapp.com/api/locations/1/images/ npm run dev
```

You can also run guard to do TDD

```
npm run guard
```

### Formatting

Elm is whitespace sensitive so I've been using [elm-format](https://atom.io/packages/elm-format) for consistency. Please do the same.



## Staging

```
API_ENDPOINT=https://cyanometer-staging.herokuapp.com/api/locations/1/images/ npm run deploy
```

Open [https://cyanometer-archive.firebaseapp.com](https://cyanometer-archive.firebaseapp.com)
